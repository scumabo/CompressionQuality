function [VGS, par, vgs_map] = vgs_index(imo, imd, para)% 
%==========================================================================
% Multi-scale Visual Gradient Similarity (VGS) for digital images
%--------------------------------------------------------------------------
%Input: 
%(1) imo: the reference image 
%(2) imd: the test image
%(3) fields of structure 'para':  type,mask, range, T,r,fb, S1,S2
%    para.type: the used VGS type, VGS1(para.type=1),VGS2(para.type=2), and the default one is VGS2.
%    para.mask: the used gradient masks, it can be Prewitt masks(para.mask=1), 
%                Roberts masks(para.mask=2),or Sobel masks(para.mask=3). 
%    para.range:  The  dynamic range of pixel values ([0, para.range]). Assume the image 
%    is  8-bit grayscale, then para.range=255.
%    para.T:    the normalized threshold of noticeable gradient magnitude.
%    para.r:   the exponent of the  power law for subjective intensity to image gradient,
%    para.fb:  the base frequency(in units of cycles/degree). Let Dis be the viewing distance 
%                 in units of image pixels,then we can compute the viewing
%                 resolution (in units of pixels/degree) by V=Dis*tan(pi/180), then fb=V/32;
%    para.S1:   the used finest scale number 
%    para.S2:   the used coarsest scale number 
%Note the default parameter values are for LCD or CRT display.
%For display type of printing, set para.T=0.035 and para.r=0.85.
%---------------------------------------------------------------------------
%Output:
%(1) VGS: Scalar,the final pooled single quality value.
%(2) par: par=[Qs;mu;Lamd];
%        (a)Qs(=par(1,:)):  the  single quality for  each  scale, i.e., single scale VGS;
%        (b)mu(=par(2,:)):  quality uniformity factor for  each  scale;
%        (c)Lamd(=par(3,:)): perceptual contrast projection coefficient of the test image to the
%           reference image for  each  scale;
%(3) vgs_map: a pyramid. vgs_map{s} is a 2-D vector, the point-wise VGS map  after contrast
%    registration for scale s.
%--------------------------------------------------------------------------
%Date: Sep.,2011.
%Version��1.0
%Author: Jieying Zhu
%--------------------------------------------------------------------------

if (nargin < 2 || nargin > 3)
   error('No match in input argument number!');
   return;
end

Dim=ndims(imo); 
if( Dim~=ndims(imd)||Dim>3 )
   error('Dimension error in input image data!');
   return;
end
%
if (size(imo) ~= size(imd))
    error('The sizes of input images are not  equal!');
    return;
end
%
if (nargin<3 | ~isstruct(para))
    %default settings
    type=2; mask=1; tau=2;
    T=0.025;    rr=0.55;
    fb=1;       S1=1; Rg=255;
    S2=6+ceil(log2(fb/tau));%
else
    if (isfield(para, 'type'))
        type = para.type;
    else
        type = 2;
    end
    if (isfield(para, 'mask'))
        mask = para.mask;
    else
        mask = 1;
    end

    if mask==2
        tau = 1.2;
    else
        tau = 2;
    end
    
    if (isfield(para, 'range'))
        Rg = para.range;
    else
        Rg = 255;
    end

    if (isfield(para, 'T'))
        T = para.T;
    else
        T = 0.025;
    end

    if (isfield(para, 'r'))
        rr = para.r;
    else
        rr = 0.55;
    end

    if (isfield(para, 'fb'))
        fb = para.fb;
    else
        fb = 1;
    end

    if (isfield(para, 'S1'))
        S1 = para.S1;
    else
        S1 = 1;
    end
    if (isfield(para, 'S2'))
        S2 = para.S2;
    else
        S2 = 6+ceil(log2(fb/tau));%
    end
    %
end

if( type<1||type>2)
   error('Invalid input VGS type!');
   return;
end
if fb<=0
 error('The base frequency (fb) can not be zero or negatives!');
 return;
end
%
[D1,D2] = size(imo);
if (S1<1||S1>S2)
    error('Invalid input scale number of S1 (or S2)!');
    return;
elseif( min(D1,D2)<2^(S2+1))
    error('The coarsest scale number is too large!');
    return;
end
%gradient masks
if mask==1
    eps=3;
    fltv=[-1,-1,-1;0,0,0;1,1,1]; flth=fltv';%Prewitt gradient filters
elseif mask==2
    eps=1.2;
    fltv=[0,1;-1,0]; flth=[-1,0;0,1]; %Roberts gradient filters
elseif mask==3%
    eps=4;
    fltv=[-1,-2,-1;0,0,0;1,2,1]; flth=fltv';%Sobel  gradient filters
else
    error('Invalid gradient mask number!');
    return;
end
%--------------------------------------------------------------------------------------------   
%main body
%---------------------------------
%For color image, here supply VGS only to its gray-scale version. 
if (Dim==3)
     imo=rgb2gray(imo); 
     imd=rgb2gray(imd); 
end  
imo = double(imo); imd = double(imd);
% visual detection threshold of gradient magnitude.
T0=eps*T*Rg;%
flts=ones(2,2)/4;%low-pass filter. 
%
for s=1:S2 %scales
    %Low-pass pyramid generation, downsampling by two along each row and each column.
    if s==1
        imo_pyr{s} = imo;
        imd_pyr{s} = imd;
    else
        imflt1 = imfilter(imo_pyr{s-1},flts,'symmetric','same');
        imflt2 = imfilter(imd_pyr{s-1},flts,'symmetric','same');
        imo_pyr{s} = downsample(downsample(imflt1, 2)', 2)';
        imd_pyr{s} = downsample(downsample(imflt2, 2)', 2)';
    end
    [Qs(s) mu(s) Lamd(s) vgs_map{s}] = VGS_sscale( imo_pyr{s},imd_pyr{s},flth,fltv, T0,rr);
end
par=[Qs;mu;Lamd];
%
%inter-scale weights
if type==1
   Ws=ones(1,S2-S1+1);
else% type==2
   for i=1:S2
     p(i)=2^(5-i);
   end
   p=p(S1:S2);%selected scales
   Ws=csf_M(p*fb/tau);% 
end
 %inter-scale pooling
 Ws=Ws/sum(Ws);
 VGS=sum(Qs(S1:S2).*Ws);
%-----------------------------------------------------------------------
function [Qs mu Lamd vgs_map] = VGS_sscale( imo, imd, flth,fltv, T0,rr )
%--------------------------------------------------------------------------
%This function is to compute single-scale comparisons. 
% an infinite small non-zero number to avoid the dividend  being zero.
det=(0.00001)^2; %
%compute gradient of scale s.
imo_d1 = filter2(flth,imo,'valid');%
imd_d1 = filter2(flth,imd,'valid');%
%
imo_d2= filter2(fltv,imo,'valid');%
imd_d2 = filter2(fltv,imd,'valid');%
%
Mo=(imo_d1.^2+imo_d2.^2).^0.5; % gradient magnitudes
Md=(imd_d1.^2+imd_d2.^2).^0.5; % gradient magnitudes
M12=imo_d1.*imd_d1+imo_d2.*imd_d2;

% figure
% s1 = subplot(2,4,1);  imshow(imo_d1,[]);
% s2 = subplot(2,4,5);  imshow(imd_d1,[]);
% s3 = subplot(2,4,2);  imshow(imo_d2,[]);
% s4 = subplot(2,4,6);  imshow(imd_d2,[]);
% s5 = subplot(2,4,3);  imshow(Mo,[]);
% s6 = subplot(2,4,7);  imshow(Md,[]);
% s7 = subplot(2,4,8);  imshow(M12,[]);


%point-wise gradient direction similarity 
SA=M12./(Mo.*Md+det);% 
Sgn=sign(SA);
SA=(SA.^2).*Sgn;
%index of  removed points 
indx=(Mo<T0 & Md<T0);
Mo(indx)=0; Md(indx)=0;
% change to peceptual gradient magnitude
Mo=Mo.^rr; Md=Md.^rr;
%global contrast registration
Md_Mo=Md.*Mo;
Mo2=Mo.^2;
Lamd=(sum(Md_Mo(:))+det)/( sum(Mo2(:)) +det);%lambda
Mol=Mo*Lamd;
%point-wise gradient magnitude similarity
SM=(min(Mol,Md))./(max(Mol,Md)+det);%
vgs_map=SM.*SA;
%intra-scale pooling-----------------------------------------------
if sum(~indx(:))% 
    q=vgs_map(~indx);
    Qs=mean(q);
    qmse=mean(q.^2)-Qs^2;
    mu=1-qmse^0.5;%
    Qs=Qs*mu*Lamd;
else %~indx are all zeros, thus the selected point set is a Null set.
    %for natural images, nearly no such case happens.
    Qs=1;
    mu=1;
    Lamd=1;
end
%--------------------------------------------------------------

%----------------------------------------------------------------
function [z]=csf_M(f)
% Code for the contrast sensitivity function modified from the one given by Mannos and Sakrison.
z=2.6*(0.0192+0.228*f).*exp(-(0.228*f).^1.1);%having a peak at 4 cycles/degree.
%_________________________________________________________________
 





