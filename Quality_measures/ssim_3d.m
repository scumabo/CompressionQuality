function [mssim, ssim_map, mcs, cs_map] = ssim_3d(vol1, vol2, L)
% extension of the 2d SSIM used for images to an SSIM for 3d volumes

% exension of SSIM to 3D. used ssim.m as developed by the following
% authors as template
% 
% Z. Wang, A. C. Bovik, H. R. Sheikh, and E. P. Simoncelli, "Image
% quality assessment: From error visibility to structural similarity,"
% IEEE Transactios on Image Processing, vol. 13, no. 4, pp. 600-612,
% Apr. 2004.
%
% http://www.ece.uwaterloo.ca/~z70wang/research/ssim/


global MAX_VAL;
MAX_VAL=255; %FIXME

%% init
if (nargin < 2 || nargin > 5)
   mssim = -Inf;
   ssim_map = -Inf;
   return;
end

if (size(vol1) ~= size(vol2))
   mssim = -Inf;
   ssim_map = -Inf;
   return;
end

M = size( vol1, 1 );
N = size( vol1, 2 );
I3 = size( vol1, 3 );


if (nargin == 2)
   if ((M < 11) || (N < 11) || (I3 < 11))
	   mssim = -Inf;
	   ssim_map = -Inf;
      return
   end
end

if (~exist('MAX_VAL'))
   L = 255;
end

if (nargin == 3)
   if ((M < 11) || (N < 11) || (I3 < 11))
	   mssim = -Inf;
	   ssim_map = -Inf;
      return
   end
end

h = fspecial3('gaussian',[11 11 11]);

K(1) = 0.01;					% default settings
K(2) = 0.03;					%

vol1 = double(vol1);
vol2 = double(vol2);

C1 = (K(1)*(MAX_VAL))^2;
C2 = (K(2)*(MAX_VAL))^2;

%% compute SSIM
% currently done without downsampling since the intention is to do this on
% subblocks of the volumes, which are of smaller size anyways

mu1 = convn( vol1, h, 'valid' );
mu2 = convn( vol2, h, 'valid' );

mu1_sq = mu1.*mu1;
mu2_sq = mu2.*mu2;
mu1_mu2 = mu1.*mu2;

sigma1_sq = convn( vol1.*vol1, h, 'valid' ) - mu1_sq;
sigma2_sq = convn( vol2.*vol2, h, 'valid' ) - mu2_sq;

sigma12 = convn( vol1.*vol2, h, 'valid' ) - mu1_mu2;

if (C1 > 0 && C2 > 0)
   ssim_map = ((2*mu1_mu2 + C1).*(2*sigma12 + C2))./((mu1_sq + mu2_sq + C1).*(sigma1_sq + sigma2_sq + C2));
   cs_map = (2*sigma12 + C2)./(sigma1_sq + sigma2_sq + C2);
else
    disp('todo');
%    numerator1 = 2*mu1_mu2 + C1;
%    numerator2 = 2*sigma12 + C2;
% 	denominator1 = mu1_sq + mu2_sq + C1;
%    denominator2 = sigma1_sq + sigma2_sq + C2;
%    ssim_map = ones(size(mu1));
%    index = (denominator1.*denominator2 > 0);
%    ssim_map(index) = (numerator1(index).*numerator2(index))./(denominator1(index).*denominator2(index));
%    index = (denominator1 ~= 0) & (denominator2 == 0);
%    ssim_map(index) = numerator1(index)./denominator1(index);
end

%% pooling
mssim = mean3(ssim_map);
mcs = mean3(cs_map);

return

%% helpfer functions

function val = mean3(A)
%mean for 3d volume

I1 = size(A, 1);
val = 0;
for k = 1:I1
     val = val + mean2(double(A(k, :, :)));
end
val = val /I1;

