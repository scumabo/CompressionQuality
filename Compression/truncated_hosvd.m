function rmse_nums = truncated_hosvd( t3, dir, precision )
%classical hosvd with tucker for different ranks


I1 = size(t3, 1);
I2 = size(t3, 2);
I3 = size(t3, 3);

reco_dir = sprintf('%s/reco/truncated_tucker', dir);
R = I1/2; %max num ranks
rmse_nums = zeros( R, 2 );

tdec = tucker_als( t3, [R R R], struct('init','eigs') );

core = tdec.core;
U1 = tdec.U{1};
U2 = tdec.U{2};
U3 = tdec.U{3};


for r = 2:R
    
    core_trunc = core(1:r,1:r,1:r);
    
    U1_trunc =  U1(:,1:r);
    U2_trunc =  U2(:,1:r);
    U3_trunc =  U3(:,1:r);
    
    tdec2 = ttensor(core_trunc, U1_trunc, U2_trunc, U3_trunc);
        
    approx = tensor(tdec2);
    err = 0;
    
    if( strcmp(precision,'*uint8') )
        approx_uint = uint8(double(approx));
        err = sqrt(calcMSE(t3, approx_uint));
        filename = sprintf('truncated_tucker_%i.raw', r);
        batchWriteVolume( approx_uint, reco_dir, filename, precision );
    end
    if( strcmp(precision,'*uint16') )
        approx_uint = uint16(double(approx));
        err = sqrt(calcMSE(t3, approx_uint));
        filename = sprintf('truncated_tucker_%i.raw', r);
        batchWriteVolume( approx_uint, reco_dir, filename, precision );
    end
    
    ncoeffs = ranks2ncoeffs(I1, I2, I3, r,r,r);
    rmse_nums(r, 1) = ncoeffs;
    rmse_nums(r, 2) = err;
end


core_val = core(1,1,1);

U1_trunc =  U1(:,1);
U2_trunc =  U2(:,1);
U3_trunc =  U3(:,1);

tdec2 = ktensor(core_val, U1_trunc, U2_trunc, U3_trunc);

approx = tensor(tdec2);
filename = sprintf('truncated_tucker_%i.raw', 1);
batchWriteVolume( approx, reco_dir, filename, precision );

    
statsfile = sprintf('%s/stats/truncated_hosvd_errors', dir );
xlswrite(statsfile, rmse_nums);


