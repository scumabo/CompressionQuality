function [VGS, par, vgs_map] = vgs_3d( vol1, vol2, para)
%visual gradient similarity 3d
%==========================================================================
% Multi-scale Visual Gradient Similarity (VGS) for digital images
% extended to 3D from original version, 2013 Dec, Suter
%--------------------------------------------------------------------------
%Input: 
%(1) vol1: the reference volume (ground truth) 
%(2) vol2: the test image
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

Dim=ndims(vol1); 
if( Dim~=ndims(vol2)||Dim>3 )
   error('Dimension error in input image data!');
   return;
end
%
if (size(vol1) ~= size(vol2))
    error('The sizes of input images are not  equal!');
    return;
end
vol1 = double(vol1);
vol2 = double(vol2);

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
[D1, D2, D3] = size(vol1);

%% FIXME: do an automatic thing
S2 = 3;
if (S1<1||S1>S2)
    error('Invalid input scale number of S1 (or S2)!');
    return;
elseif( min(D3, min(D1,D2)) < 2^(S2+1) )
    error('The coarsest scale number is too large!');
    return;
end
%gradient masks FIXME: check 3d for prewitt and roberts,
if mask==1
    eps=3;
    %fltv=[-1,-1,-1;0,0,0;1,1,1]; flth=fltv';%Prewitt gradient filters
    g1flt(:,:,1)=[-1,-1,-1;-1,-1,-1;-1,-1,-1]; %3D Prewitt gradient filters
    g1flt(:,:,2)=[0,0,0;0,0,0;0,0,0]; %3D Prewitt gradient filters
    g1flt(:,:,3)=[1,1,1;1,1,1;1,1,1]; %3D Prewitt gradient filters
    g2flt = -g1flt;
    g3flt = permute(g1flt, [1 3 2]);
    g4flt = -g3flt;
    g5flt = permute(g1flt, [3 2 1]);
    g6flt = -g5flt;

      
elseif mask==2
    eps=1.2;
    %fltv=[0,1;-1,0]; flth=[-1,0;0,1]; %Roberts gradient filters
    g1flt(:,:,1)=[0,1;-1,0];  %3D Roberts gradient filters
    g1flt(:,:,2)=[0,0;0,0];  %3D Roberts gradient filters
    g1flt(:,:,3)=[-1,0;0,1];  %3D Roberts gradient filters
    g2flt = -g1flt;
    g3flt = permute(g1flt, [1 3 2]);
    g4flt = -g3flt;
    g5flt = permute(g1flt, [3 2 1]);
    g6flt = -g5flt;
elseif mask==3%
    eps=4;
    %fltv=[-1,-2,-1;0,0,0;1,2,1]; flth=fltv';%Sobel  gradient filters
    g1flt(:,:,1)=[1,2,1;2,4,2;1,2,1]; %3D Sobel  gradient filters
    g1flt(:,:,2)=[0,0,0;0,0,0;0,0,0]; %3D Sobel  gradient filters
    g1flt(:,:,3)=[-1,-2,-1;-2,-4,-2;-1,-2,-1]; %3D Sobel  gradient filters
    g2flt = -g1flt;
    g3flt = permute(g1flt, [1 3 2]);
    g4flt = -g3flt;
    g5flt = permute(g1flt, [3 2 1]);
    g6flt = -g5flt;

else
    error('Invalid gradient mask number!');
    return;
end
%--------------------------------------------------------------------------------------------   
%main body
%---------------------------------

% visual detection threshold of gradient magnitude.
T0=eps*T*Rg;%
%FIXME: adjust to 3D flts=ones(2,2)/4;%low-pass filter. 
flts=ones(2,2,2)/8;%low-pass filter. 
%
for s=1:S2 %scales
    %Low-pass pyramid generation, downsampling by two along each row and each column.
    if s==1
        vol1_pyr{s} = vol1;
        vol2_pyr{s} = vol2;
    else
        vflt1 = convn( vol1_pyr{s-1},flts, 'same' );
        vflt2 = convn( vol2_pyr{s-1},flts, 'same' );
        [I1, I2, I3] = size(vflt1);
        vol1_pyr{s} = vflt1(1:2:I1,1:2:I2,1:2:I3); %FIXME extend to 3d
        vol2_pyr{s} = vflt2(1:2:I1,1:2:I2,1:2:I3);
    end
    [Qs(s) mu(s) Lamd(s) vgs_map{s}] = VGS_sscale( vol1_pyr{s},vol2_pyr{s},g1flt, g2flt, g3flt, g4flt, g5flt, g6flt, T0,rr);
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
function [Qs mu Lamd vgs_map] = VGS_sscale( vol1, vol2, g1flt, g2flt, g3flt, g4flt, g5flt, g6flt, T0,rr )
%--------------------------------------------------------------------------
%This function is to compute single-scale comparisons. 
% an infinite small non-zero number to avoid the dividend  being zero.
det=(0.00001)^2; %
%compute gradient of scale s.
% FIXME: check if this is correct what i am doing
vol1_d1 = convn(vol1, g1flt,'same');%
vol2_d1 = convn(vol2,g1flt, 'same');%
%
vol1_d2 = convn(vol1, g2flt,'same');%
vol2_d2 = convn(vol2, g2flt,'same');%
%
vol1_d3 = convn(vol1, g3flt,'same');%
vol2_d3 = convn(vol2, g3flt,'same');%
%
vol1_d4 = convn(vol1, g4flt,'same');%
vol2_d4 = convn(vol2, g4flt,'same');%
%
vol1_d5 = convn(vol1, g5flt,'same');%
vol2_d5 = convn(vol2, g5flt,'same');%
%
vol1_d6 = convn(vol1, g6flt,'same');%
vol2_d6 = convn(vol2, g6flt,'same');%
%
M1=(vol1_d1.^2 + vol1_d2.^2 + vol1_d3.^2 + vol1_d4.^2 + vol1_d5.^2 + vol1_d6.^2 ).^0.5; % gradient magnitudes
M2=(vol2_d1.^2 + vol2_d2.^2 + vol2_d3.^2+ vol2_d4.^2 + vol2_d5.^2 + vol2_d6.^2 ).^0.5; % gradient magnitudes
M12=vol1_d1.*vol2_d1+vol1_d2.*vol2_d2+vol1_d3.*vol2_d3+vol1_d4.*vol2_d4+vol1_d5.*vol2_d5+vol1_d6.*vol1_d6;


slice = size(vol1,1)*3/4;

scrsz = get(0,'ScreenSize');
fig = figure('Position',[1000 5 scrsz(3)*2/3 scrsz(4)/2]);

load('cb_PiYG','mycmap');
%set(fig,'Colormap',mycmap);

ncols = 10;
nrows = 2;
row1_start = 1;
row2_start = ncols+1;
subplot( nrows, ncols, row1_start );  imshow(vol1_d1(:,:,slice),[] ); 
subplot( nrows, ncols, row2_start );  imshow(vol2_d1(:,:,slice),[] );
subplot( nrows, ncols, row1_start + 1 );  imshow(vol1_d2(:,:,slice),[] );
subplot( nrows, ncols, row2_start + 1 );  imshow(vol2_d2(:,:,slice),[] );

subplot( nrows, ncols, row1_start + 2 );  imshow(vol1_d3(:,:,slice),[] );
subplot( nrows, ncols, row2_start + 2 );  imshow(vol2_d3(:,:,slice),[] );
subplot( nrows, ncols, row1_start + 3 );  imshow(vol1_d4(:,:,slice),[] );
subplot( nrows, ncols, row2_start + 3 );  imshow(vol2_d4(:,:,slice),[] );

subplot( nrows, ncols, row1_start + 4 );  imshow(vol1_d5(:,:,slice),[] );
subplot( nrows, ncols, row2_start + 4 );  imshow(vol2_d5(:,:,slice),[] );
subplot( nrows, ncols, row1_start + 5 );  imshow(vol1_d6(:,:,slice),[] );
subplot( nrows, ncols, row2_start + 5 );  imshow(vol2_d6(:,:,slice),[] );

s7 = subplot( nrows, ncols, row1_start + 6 );  imshow(M1(:,:,slice),[] ); title(s7, 'M1');
s17 = subplot( nrows, ncols, row2_start + 6 );  imshow(M2(:,:,slice),[] ); title(s17, 'M2');
s18 = subplot( nrows, ncols, row2_start + 7 );  imshow(M12(:,:,slice),[] ); title(s18, 'M12');

%point-wise gradient direction similarity 
SA=M12./(M1.*M2+det);% 
Sgn=sign(SA);
SA=(SA.^2).*Sgn;


%index of  removed points 
indx=(M1<T0 & M2<T0);
M1(indx)=0; M2(indx)=0;
% change to peceptual gradient magnitude
M1=M1.^rr; M2=M2.^rr;
%global contrast registration
M2_M1=M2.*M1;
M1_2=M1.^2;
Lamd=(sum(M2_M1(:))+det)/( sum(M1_2(:)) +det);%lambda
M1_l=M1*Lamd;
%point-wise gradient magnitude similarity
SM=(min(M1_l,M2))./(max(M1_l,M2)+det);%
vgs_map=SM.*SA;

 s19 = subplot( nrows, ncols, row2_start + 8 );  imshow(M1_l(:,:,slice),[0 255] ); title(s19, 'M1L');
 s8 = subplot( nrows, ncols, row1_start + 7);  imshow(SA(:,:,slice),[] ); title(s8, 'SA');
 s20 = subplot( nrows, ncols, row2_start + 9 );  imshow(indx(:,:,slice),[] ); title(s20, 'indx');
 s9 = subplot( nrows, ncols, row1_start + 8 ); imshow(SM(:,:,slice),[] ); title(s9, 'SM');
 %s10 = subplot( nrows, ncols, row1_start + 9 ); imshow(vgs_map(:,:,slice),[0 255] ); title(s10, 'vgs_map');
 s10 = subplot( nrows, ncols, row1_start + 9 ); imshow(Sgn(:,:,slice),[] ); title(s10, 'sign'); colormap( jet ); 


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
 





