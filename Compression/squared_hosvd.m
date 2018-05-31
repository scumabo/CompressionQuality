function snr_nums = squared_hosvd( t3, dir, precision )
%computes the hosvd only with one squared svd

reco_dir = sprintf('%s/reco/svd', dir);


A = unfold_t3( t3 );

[U,S,V] = svd(double(A));

[I1, I2] = size(A);

num_sigm = I2;
snr_nums = zeros( num_sigm, 4 );

AA = zeros(I1, I2);

J1 = size(t3,1);
J2 = size(t3,2);
J3 = size(t3,3);

% ssim constant
K = [0.01 0.03];
window = fspecial('gaussian', 11, 1.5);
for r = 1:10
    
    UU = U(:,r);
    VV = V(:,r);
    SS = S(r, r);
   
    XX = UU*SS*VV';
        
    AA = AA + XX;
    
    snr_val = 0;
    mse_val = 0;
    ssim_val = 0;
    if( strcmp(precision,'*uint8') )
        mse_val = calcMSE(A, uint8(AA));
        snr_val = calcSNR(A, uint8(AA));
        ssim_val = ssim(A, uint8(AA), K, window, 255 );
        filename = sprintf('incr_svd_%i.raw', r);
        AAA = fold_t3( uint8(AA), J1, J2, J3);
        batchWriteVolume( AAA, reco_dir, filename, precision );
   end
    if( strcmp(precision,'*uint16') )
        mse_val = calcMSE(A, uint16(AA));
        snr_val = calcSNR(A, uint16(AA));
        ssim_val = ssim(A, uint16(AA), K, window, 65535 );
        filename = sprintf('incr_svd_%i.raw', r);
        AAA = fold_t3( uint16(AA), J1, J2, J3);
        batchWriteVolume( AAA, reco_dir, filename, precision );
    end
    
    %ncoeffs = col *( I1 + I2 + 1 );
    snr_nums(r, 1) = r; %ncoeffs;
    snr_nums(r, 2) = snr_val;
    snr_nums(r, 3) = mse_val;
    snr_nums(r, 4) = ssim_val;

end

statsfile = sprintf('%s/stats/svd_snr', dir );
xlswrite(statsfile, snr_nums);


%% for debugging or checking visual results %%
% B = double(double(A)-AA);
% 
% minv = min(min(B));
% maxv = max(max(B));
% msg = sprintf('min-max values of B = [%.6f,%.6f]', minv, maxv);
% disp(msg);
% 
% 
% figure
% 
% sa = subplot(1,3,1); title(sa, 'original'); imshow( A, []); colormap(gray); freezeColors;
% saa = subplot(1,3,2); title(saa, 'approximation'); imshow( AA,[] );  colormap(gray); freezeColors;
% sb = subplot(1,3,3); title(sb, 'difference'); imshow( B,[]); colormap( cool ); 


