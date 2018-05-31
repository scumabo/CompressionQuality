function [ scoeffs_thresholded, shrink_idx ] = shrink_sc( scoeffs, sorted_coeffs, target_ncoeffs, start_idx )
%threshold sparse coefficients

global MAX_VALID_NCOEFFS;

%% init
shrink_idx = MAX_VALID_NCOEFFS;  
scoeffs_thresholded = scoeffs;


if (~exist('start_idx', 'var'))
    start_idx = target_ncoeffs;
end

if ( target_ncoeffs <= MAX_VALID_NCOEFFS && target_ncoeffs > 0 )
        
     if (target_ncoeffs < start_idx)
        start_idx = target_ncoeffs;
    end
    
    
    % get threshold for given number of target ncoeffs
    if (start_idx > 0)
        thresh = sorted_coeffs( start_idx );
    else
        scoeffs_thresholded = scoeffs;
        return;
    end
        
    scoeffs_thresholded = double(tenfun(@(x)((abs(x) >= thresh).*x), tensor(scoeffs)));
    
    eff_ncoeffs = nnz(scoeffs_thresholded);
    
    fprintf('effective number of non-zero DCT coefficients = %i\n', eff_ncoeffs );
else
    min_wc = sorted_coeffs(MAX_VALID_NCOEFFS+1);
    min_wc2 = sorted_coeffs(MAX_VALID_NCOEFFS);
    
    fprintf('\t max valid ncoeffs (%i) smaller than target ncoeff min_wc(%3.6f,%3.6f)\n', MAX_VALID_NCOEFFS, min_wc, min_wc2 );
end

return;


