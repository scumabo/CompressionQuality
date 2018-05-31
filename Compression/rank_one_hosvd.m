function snr_nums = rank_one_hosvd( t3, dir, precision )
%classical hosvd with tucker for different ranks


I1 = size(t3, 1);
I2 = size(t3, 2);
I3 = size(t3, 3);

reco_dir = sprintf('%s/reco/rank1hooi', dir);
R = double(uint8(I1/2)); %max num ranks
%disp(R);
snr_nums = zeros( R, 4 );

tdec = tucker_als( t3, [R R R], struct('init','eigs') );
core = tdec.core;
disp('started sorting...');
[ core_struct core_order ] = sort_core_coeffs( core, dir );
disp('sorting done...');

%tdec = parafac_als(t3, 512);
%lambdas = tdec.lambda;
    
U1 = tdec.U{1};
U2 = tdec.U{2};
U3 = tdec.U{3};

AA = tenzeros([I1 I2 I3]);
num_core_values = R*R*R;

% ssim constant
K = [0.01 0.03];
window = fspecial('gaussian', 11, 1.5);


for r = 1:10   
    % get indices for current core tensor
    pos = core_order(r);
    hot_core_value = core_struct.data( pos );
    i1 = core_struct.r1( pos );
    i2 = core_struct.r2( pos );
    i3 = core_struct.r3( pos );
    
    u1 =  U1(:,i1);
    u2 =  U2(:,i2);
    u3 =  U3(:,i3);
    
%     hot_core_value = lambdas( r );
%     u1 =  U1(:,r);
%     u2 =  U2(:,r);
%     u3 =  U3(:,r);

    tdec2 = ktensor( hot_core_value, {u1, u2, u3 });
        
    approx = tensor(tdec2);
    
    AA = AA + approx;
    
    
    snr_val = 0;
    mse_val = 0;
    ssim_val = 0;
    
    if( strcmp(precision,'*uint8') )
        approx_uint = uint8(double(AA));
        snr_val = calcSNR(t3, approx_uint);
        mse_val = calcMSE(t3, approx_uint);

        filename = sprintf('incr_rank1_hooi_%i.raw', r);
        batchWriteVolume( approx_uint, reco_dir, filename, precision );
        
        D = unfold_t3( approx_uint );
        C = unfold_t3( t3 );
        ssim_val = ssim(C, D, K, window, 255 );
       

    end
    if( strcmp(precision,'*uint16') )
        approx_uint = uint16(double(AA));
        snr_val = calcSNR(t3, approx_uint);
        mse_val = calcMSE(t3, approx_uint);
        filename = sprintf('incr_rank1_hooi_%i.raw', r);
        batchWriteVolume( approx_uint, reco_dir, filename, precision );
        
        D = unfold_t3( approx_uint );
        C = unfold_t3( t3 );
        ssim_val = ssim(C, D, K, window, 65535 );
    end

    
    %ncoeffs = ranks2ncoeffs(I1, I2, I3, r,r,r);
    snr_nums(r, 1) = r;
    snr_nums(r, 2) = snr_val;
    snr_nums(r, 3) = mse_val;
    snr_nums(r, 4) = ssim_val;

end



    
statsfile = sprintf('%s/stats/rank1_hosvd_snr', dir );
xlswrite(statsfile, snr_nums);


%% helper

function [t, t_order] = sort_core_coeffs( core, dir )
%sorts core tensor while maintaining indices

t.data = [];
t.r1 = [];
t.r2 = [];
t.r3 = [];

R = size(core,1);

tic;
counter = 1;
for j3 = 1:R
    for j2 = 1:R
        for j1 = 1:R   
            t.data( counter) = core( j1, j2, j3 );
            t.r1( counter) = j1;
            t.r2( counter) = j2;
            t.r3( counter) = j3;
            counter = counter + 1;
        end
    end
end
toc;

% statsfile = sprintf('%s/stats/core_coeffs', dir );
% tmp = [ t.data(:) t.r1(:) t.r2(:) t.r3(:)];
% 
% xlswrite( statsfile, tmp );

[t_sorted, t_order] = sort([t(:).data],'descend');

%statsfile = sprintf('%s/stats/core_coeffs_sorted', dir );
%xlswrite( statsfile, t_sorted' );
    



