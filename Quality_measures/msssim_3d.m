function overall_mssim = msssim_3d(vol1, vol2, L, level)
% extensions of wang et al., 2003, multiscale SSIM to 3D (volume input)

% Multi-scale Structural Similarity Index (MS-SSIM)
% Z. Wang, E. P. Simoncelli and A. C. Bovik, "Multi-scale structural similarity
% for image quality assessment," Invited Paper, IEEE Asilomar Conference on
% Signals, Systems and Computers, Nov. 2003


global MAX_VAL;

%% FIXME
% kernel size of input
% levels and input size...

%% init
M = size( vol1, 1 );
N = size( vol1, 2 );
I3 = size( vol1, 3 );


if (nargin < 2 || nargin > 7)
   overall_mssim = -Inf;
   return;
end

if (~exist('MAX_VAL'))
   error('MAX_VAL not defined');
end

if (~exist('K'))
   K = [0.01 0.03];
end

if (~exist('win'))
   window = fspecial3('gaussian',[11 11 11]);
end

if (~exist('level'))
    if ( (M <= 356) || (N <= 356) || (I3 <= 356))
        level = 5;
    end
    if ( (M <= 88) || (N <= 88) || (I3 <= 88))
        level = 3;
    end  
end

if (~exist('weight'))
    if  ( level == 5 )
        weight = [0.0448 0.2856 0.3001 0.2363 0.1333];
    end
    if (level == 3)
        weight = [ 0.2856 0.3001 0.2363];
    end
end

if (~exist('method'))
   method = 'product';
end

if (size(vol1) ~= size(vol2))
   overall_mssim = -Inf;
   return;
end

if ((M < 11) || (N < 11) || (I3 < 11))
   overall_mssim = -Inf;
   return
end

if (length(K) ~= 2)
   overall_mssim = -Inf;
   return;
end

if (K(1) < 0 || K(2) < 0)
   overall_mssim = -Inf;
   return;
end
  
J1 = size(window, 1);
J2 = size(window, 2);
J3 = size(window, 3);

if ((J1*J2*J3)<4 || (J1>M) || (J2>N) || (J3>I3))
   overall_mssim = -Inf;
   return;
end
   
if (level < 1)
   overall_mssim = -Inf;
   return
end


min_img_width = min(min(M, N),I3)/(2^(level-1));
max_win_width = max(max(J1,J2), J3);
if (min_img_width < max_win_width)
   overall_mssim = -Inf;
   return;
end

if (length(weight) ~= level || sum(weight) == 0)
   overall_mssim = -Inf;
   return;
end

if ( ~strcmp(method, 'wtd_sum') && ~strcmp(method, 'product'))
   overall_mssim = -Inf;
   return;
end

%% multiscale computations

downsample_filter = ones([2 2 2])./4;
v1 = double(vol1);
v2 = double(vol2);

for l = 1:level
   [mssim_array(l), ssim_map_array{l}, mcs_array(l), cs_map_array{l}] = ssim_3d(v1, v2, MAX_VAL);

   f_v1 = convn( v1, downsample_filter, 'same' );
   f_v2 = convn( v2, downsample_filter, 'same' );

   clear v1; clear v2;
   v1 = f_v1(1:2:end, 1:2:end, 1:2:end);
   v2 = f_v2(1:2:end, 1:2:end, 1:2:end);
end

%% combining results

if (strcmp(method, 'product'))
   overall_mssim = prod(mcs_array(1:level-1).^weight(1:level-1))*(mssim_array(level).^weight(level));
else
   weight = weight./sum(weight);
   overall_mssim = sum(mcs_array(1:level-1).*weight(1:level-1)) + mssim_array(level).*weight(level);
end

