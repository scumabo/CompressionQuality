function metrics = compare_ssim(vol1, vol2, precision, id )
%compare 2D unfolded ssim and 3D ssim

%% FIXME: set values directly do metrics files

%% init
%global L; % FIXME: update code with global L value (precision?)
global NCOLS_METRICS;
global DO_PSNR;
global DO_PSNR_HVS;
global DO_VSNR;
global DO_SSIM;
global DO_MSSSIM;
global DO_IWSSIM;
global DO_FSIM;
global DO_RAND;
global DO_VGS;
global DO_RMSE;
global DO_SNR;

global MAX_VAL;

I1 = size(vol1,1);
I2 = size(vol1,2);
I3 = size(vol1,3);

L = 256;

if (nargin == 2)
    precision = getPrecision();
end
if( strcmp(precision,'*uint8') )
    L = 256;
end
if( strcmp(precision,'*uint16') )
    L = 65536;
end

MAX_VAL = L-1;

K = [0.01 0.03];
window = fspecial('gaussian', 11, 1.5);


%% prepare data
va = unfold_t3( vol1 );
vb = unfold_t3( vol2 );

%compare SSIM for a reference volume with a random volume
randvol = rand(I1,I2,I3);
randvol = randvol * MAX_VAL;
vr = unfold_t3( randvol );

%% compute IQAs
metrics = zeros( 1, NCOLS_METRICS );
% metrics( 1->id, 
%           ... 2->psnr_3d, 3->iw_psnr_2d, 4->vsnr_2d, 5->psnr_hvs1_2d, 6->psnr_hvs2_2d, 
%           ... 7->ssim_2d, 8->ssim_3d, 9->msssim_2d, 10->mssim_3d, 11->iwssim_2d, 
%           ... 12->fsim_2d, 13->vgs_2d, 14-> RMSE_3d, 15-SNR
%           ... same order for rand volume starting from index 22 )

metrics(1, 1) = id;

disp('## started comparing IQAs ...');


if( DO_SNR )
    
    disp('SNR 3D...');
    
    snr3d = calcSNR(vol1, vol2 );
    metrics(1, 15) = snr3d;
    
end

if( DO_PSNR )
    
    disp('PSNR 3D...');
    
    psnr3d = calcPSNR(vol1, vol2, MAX_VAL );
    metrics(1, 2) = psnr3d;
    
    if ( DO_RAND )
        
        psnr3d = calcPSNR(vol1, randvol, MAX_VAL );
        metrics(1, 22) = psnr3d;
        
    end
    
end

if ( DO_VSNR )
    
    disp('VSNR 2D...');
    
    vsnr_val_2d = vsnr(va, vb); %% FIXME: could not make it run
    metrics(1, 4) = vsnr_val_2d; %update for 3d
    
    if ( DO_RAND )
        
        vsnr_val_2d = vsnr(va, vr); %% FIXME: could not make it run
        metrics(1, 24) = vsnr_val_2d; %update for 3d
        
    end

end

if ( DO_PSNR_HVS )
    
    disp('PSNR HVS 2D...');
 
    [p_hvs_m_2d, p_hvs_2d] = psnrhvsm(va, vb);
    metrics(1, 5) = p_hvs_m_2d; %update for 3d
    metrics(1, 6) = p_hvs_2d; %update for 3d
    
    if ( DO_RAND )
        
        [p_hvs_m_2d, p_hvs_2d] = psnrhvsm(va, vr);
        metrics(1, 25) = p_hvs_m_2d; %update for 3d
        metrics(1, 26) = p_hvs_2d; %update for 3d
   
    end
end


if ( DO_SSIM )
    
    disp('SSIM 2D...');
    
    %mssim2d = ssim( va, vb, K, window, L );% with downsampling
    %mssim2d = ssim_index_new( va, vb, K, window );
   
    disp('SSIM 3D...');
        
    mssim3d = ssim_3d( vol1, vol2, MAX_VAL );
    %metrics(1, 7) = mssim2d;
    metrics(1, 8) = mssim3d;
    
    
    if ( DO_RAND )
        mssim2d = ssim_index_new( va, vr, K, window );
        mssim3d = ssim_3d( vol1, randvol, MAX_VAL );
        metrics(1, 27) = mssim2d;
        metrics(1, 28) = mssim3d;
        
    end
    
end

if ( DO_MSSSIM )
    
    disp('MSSSIM 2D...');
    
    overall_ms_ssim_2d = msssim( va, vb, L );
        
    disp('MSSSIM 3D...');
    
    overall_ms_ssim_3d = msssim_3d( vol1, vol2, L );
        
    metrics(1, 9) = overall_ms_ssim_2d;
    metrics(1, 10) = overall_ms_ssim_3d;
    
    if ( DO_RAND )
        
        overall_ms_ssim_2d = msssim( va, vr, L );
        overall_ms_ssim_3d = msssim_3d( vol1, randvol, L );
        metrics(1, 29) = overall_ms_ssim_2d;
        metrics(1, 30) = overall_ms_ssim_3d;
        
    end
end


if ( DO_IWSSIM )
    
    disp('IWSSIM 2D...');
    
    [iwssim2d, iwmse2d, iwpsnr2d]= iwssim(va, vb);% FIXME, iw_flag, Nsc, K, L, weight, win, blk_size, parent, sigma_nsq);
        
    metrics(1, 3) = iwpsnr2d; %update for 3d
    metrics(1, 11) = iwssim2d; %update for 3d
    
    if ( DO_RAND )
        
        [iwssim2d, iwmse2d, iwpsnr2d]= iwssim(va, vr);% FIXME, iw_flag, Nsc, K, L, weight, win, blk_size, parent, sigma_nsq);
        metrics(1, 23) = iwpsnr2d; %update for 3d
        metrics(1, 31) = iwssim2d; %update for 3d
        
    end
end

if ( DO_FSIM )
    
    disp('FSIM 2D...');

    [fsim_val, fsim_c] = fsim(va, vb);
    
    metrics(1, 12) = fsim_val; %update for 3d
    
    if ( DO_RAND )
        
        [fsim_val, fsim_c] = fsim(va, vr);
        metrics(1, 32) = fsim_val; %update for 3d
        
    end
end


if ( DO_VGS )
    
    disp('VGS 2D...');
    
    para.fb=1.12;
    para.T=0.03;
    para.r=0.5;
    para.mask=1;
    %For parameter values not given, default settings for them are used.
    [vgs_val1, par1, vgs_map1] = vgs_index( va, vb, para );
    metrics(1, 13) = vgs_val1; %update for 3d
    %figure, imshow(vgs_map{1},[-1,1]);% VGS map of the first scale
    
    para.T=0.2;
    para.r=0.8;
    [vgs_val2, par2, vgs_map2] = vgs_3d( vol1, vol2, para );
    metrics(1, 14) = vgs_val2; %update for 3d
   
    vgs_val1
    vgs_val2
    %FIXME: why vgs_val2 goes out of range? images look fine
    close all;
   
end

if( DO_RMSE )
    
    disp('RMSE 3D...');
    
    rmseval = normalized_rmse(vol1, vol2, MAX_VAL );
    metrics(1, 14) = (1-rmseval);
    
    rmse_val = calcMSE(vol1, vol2);
    rmse_val = rmse_val/MAX_VAL;
    metrics(1, 15) = (1-rmse_val);

end


%% debug SUS
%fprintf('(vol1,vol2):PSNR 3D = %6.4f; \t3D-SSIM = %6.4f, 2D-SSIM = %6.4f, 3D-MS-SSIM = %6.4f, 2D-MS-SSIM = %6.4f\n', psnr3d, mssim3d, mssim2d, overall_ms_ssim_3d, overall_ms_ssim_2d);
%fprintf('(vol1,vol2):\t3D-IWMSE = %6.4f, 2D-IWMSE = %6.4f, 3D-IWPSNR = %6.4f, 2D-IWPSNR = %6.4f, 3D-IWSSIM = %6.4f, 2D-IWSSIM = %6.4f\n\n', 0,iwmse2d, 0,iwpsnr2d, 0,iwssim2d);

