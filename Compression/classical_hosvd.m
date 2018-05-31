function rmse_nums = classical_hosvd( t3, dir, precision )
%classical hosvd with tucker for different ranks


I1 = size(t3, 1);
I2 = size(t3, 2);
I3 = size(t3, 3);

reco_dir = sprintf('%s/reco', dir);
num_ranks = I1;
rmse_nums = zeros( num_ranks, 2 );

for r = 2:1:num_ranks
    
    tdec = tucker_als( t3, [r r r], struct('init','eigs') );
    
    approx = tensor(tdec);
    approx_uint8 = uint8(double(approx));

    %filename = sprintf('ta_ranks_%i_%i_%i.raw', r, r, r);
    %batchWriteVolume( approx_uint8, reco_dir, filename, precision );
    
    err = 0;
    if( strcmp(precision,'*uint8') )
        approx_uint = uint8(double(approx));
        err = sqrt(calcMSE(t3, approx_uint));
    end
    if( strcmp(precision,'*uint16') )
        approx_uint = uint16(double(approx));
        err = sqrt(calcMSE(t3, approx_uint));
    end
    
    ncoeffs = ranks2ncoeffs(I1, I2, I3, r,r,r);
    rmse_nums(r, 1) = ncoeffs;
    rmse_nums(r, 2) = err;
end



    
statsfile = sprintf('%s/stats/hosvd_errors', dir );
xlswrite(statsfile, rmse_nums);


