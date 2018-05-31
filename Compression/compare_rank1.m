function metrics = compare_rank1( t3, id, dir, precision )
% compare rank-1 reconstructions of different approaches


%% compute svd rank 1 approximation
unfolding = unfold_t3( t3 );
unfolding_approx = rank1_svd( unfolding, precision );

%% compute hooi rank 1 approximation
hooi_approx = rank1_hooi( t3, precision );

%% writing results to raw files
filename = sprintf('reco/rank1hooi/rank1_hooi_1_%i.raw', id );
batchWriteVolume( hooi_approx, dir, filename, precision );
I1 = size(t3, 1);
I2 = size(t3, 2);
I3 = size(t3, 3);
unfolding_approx_t3 = fold_t3( unfolding_approx, I1, I2, I3 );
filename = sprintf('reco/svd/svd_1_%i.raw', id );
batchWriteVolume( unfolding_approx_t3, dir, filename, precision );

%% measuring accuracies of approximations
metrics = zeros( 1, 7 );

% metrics for SVD approach
snr_val1 = calcSNR(unfolding, unfolding_approx);
rmse_val1 = sqrt(calcMSE(unfolding, unfolding_approx));
ssim_val1 = calcSSIM( unfolding, unfolding_approx, precision );

% metrics for HOOI approach
snr_val2 = calcSNR(t3, hooi_approx);
rmse_val2 = sqrt(calcMSE(t3, hooi_approx));

C = unfold_t3( t3 );
D = unfold_t3( hooi_approx );
ssim_val2 = calcSSIM( C, D, precision );


if( strcmp(precision,'*uint8') )
    rmse_val2 = rmse_val2 / 255;
    rmse_val1 = rmse_val1 / 255;
end

if( strcmp(precision,'*uint16') )
    rmse_val1 = rmse_val1 / 65535;
    rmse_val2 = rmse_val2 / 65535;
end


metrics(1, 1) = id;
metrics(1, 2) = snr_val1;
metrics(1, 3) = rmse_val1;
metrics(1, 4) = ssim_val1;
metrics(1, 5) = snr_val2;
metrics(1, 6) = rmse_val2;
metrics(1, 7) = ssim_val2;

%disp(metrics);

%% helper hooi rank-1
function approx_t3 = rank1_hooi( t3, precision )
%perform rank one reco for hooi

I1 = size(t3, 1);
R = double(uint8(I1/2)); %max num ranks

tdec = tucker_als( t3, [R R R], struct('init','eigs') );
core = tdec.core;
U1 = tdec.U{1};
U2 = tdec.U{2};
U3 = tdec.U{3};

tdec2 = ktensor( core(1,1,1), {U1(:,1), U2(:,1), U3(:,1) });

if( strcmp(precision,'*uint8') )
    approx_t3 = uint8(double(tensor(tdec2)));
end

if( strcmp(precision,'*uint16') )
    approx_t3 = uint16(double(tensor(tdec2)));
end




%% helper svd rank-1
function A_approx = rank1_svd( A, precision )
%perform rank one reco for svd

[U,S,V] = svd(double(A));

UU = U(:,1);
VV = V(:,1);
SS = S(1,1);

AA = UU*SS*VV';

if( strcmp(precision,'*uint8') )
    A_approx = uint8(AA);
end

if( strcmp(precision,'*uint16') )
    A_approx = uint16(AA);
end



%% helper cal ssim
function ssim_val = calcSSIM( A, B, precision )
%calculate SSIM for two images

% ssim constant
K = [0.01 0.03];
window = fspecial('gaussian', 11, 1.5);

ssim_val = 0;
if( strcmp(precision,'*uint8') )
    ssim_val = ssim(A, B, K, window, 255 );
end

if( strcmp(precision,'*uint16') )
    ssim_val = ssim(A, B, K, window, 65535 );
end