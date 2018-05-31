function [ wdec_thresholded, shrink_idx ] = shrink_wt(wdec, sorted_coeffs, target_ncoeffs, start_idx )
%tests wt thresholding
% idea: find a wavelet decomposition with a given approximate number of
% non-zero coefficients

global MAX_VALID_NCOEFFS;

%set(0,'RecursionLimit',5000);

%% init
wdec_thresholded = wdec;
shrink_idx = MAX_VALID_NCOEFFS;  

if (~exist('start_idx', 'var'))
    start_idx = target_ncoeffs;
end

if ( target_ncoeffs <= MAX_VALID_NCOEFFS && target_ncoeffs > 0 )
    
    %%% remove coefficients with priorities:
    %%% high-frequency coefficients first, then lower-requency coefficients:
    %%% HHH-LHH-HLH-LLH-HHL-LHL-HLL-LLL..
    
    %%% wdec:LLL 'HLL','LHL','HHL','LLH','HLH','LHH','HHH'. ,i,., start to
    %%% threshold at highest K block of wedec
    
    if (target_ncoeffs < start_idx)
        start_idx = target_ncoeffs;
    end
    
    [wdec_thresholded, shrink_idx] = recursively_shrink_wdec( wdec, sorted_coeffs, target_ncoeffs, start_idx );
   
    eff_ncoeffs = nnz_wcoeffs(wdec_thresholded);
    fprintf('effective number of non-zero WT coefficients = %i\n', eff_ncoeffs );
    
else
    min_wc = sorted_coeffs(MAX_VALID_NCOEFFS+1);
    min_wc2 = sorted_coeffs(MAX_VALID_NCOEFFS);

    fprintf('\t max valid ncoeffs (%i) smaller than target ncoeff min_wc(%3.6f,%3.6f)\n', MAX_VALID_NCOEFFS, min_wc, min_wc2 );
end

return;

function [wdec_thresholded, idx] = recursively_shrink_wdec( wdec, sorted_coeffs, target_ncoeffs, idx )
%recursively shrinks/thresholds a current wdec3 with a givne threshold

% get threshold for given number of target ncoeffs
if (idx > 0)
    thresh = sorted_coeffs( idx );
else
    wdec_thresholded = wdec;
    return;
end

fprintf('\t\t recursively_shrink_wdec with idx = %i\n', idx );

wdec_thresholded = shrink_wdec( wdec, thresh, target_ncoeffs );

eff_ncoeffs = nnz_wcoeffs( wdec_thresholded );
fprintf('\t\t eff_coeffs = %i \n', eff_ncoeffs);
if ( eff_ncoeffs > target_ncoeffs )
    fprintf('\t\t eff_coeffs = %i > target_ncoeffs = %i \n', eff_ncoeffs, target_ncoeffs);
    
    new_thresh = thresh;
    
    %% FIXME: important this should be improved
    while ( new_thresh == thresh )
        nthresh_vals = sum( sorted_coeffs == thresh ); %length(find(b100==0))
        if ((idx - nthresh_vals) > 0)
            idx = idx - nthresh_vals;
        else
            idx = idx - 1;
        end
        if ( idx > 0)
            new_thresh = sorted_coeffs( idx );
        end
    end
    
    [wdec_thresholded, idx] = recursively_shrink_wdec( wdec, sorted_coeffs, target_ncoeffs, idx );

end


%%helper
function wdec_out = shrink_wdec( wdec_in, thresh, target_ncoeffs )
%thresholds a current wdec3 with a givne threshold
wdec_out = wdec_in;

fprintf('\t\t\t shrink_wdec with thresh = %3.6f\n', thresh);

nblocks = size(wdec_in.dec, 1); %counts the number of blocks containing wavelet coefficients
for block = nblocks:(-1):1
    % The data is converted into tensor and then back into double, this
    % speeds up the computations
    wdec_out.dec{block} = double(tenfun(@(x)((abs(x) >= thresh).*x), tensor(wdec_in.dec{block})));
  
    eff_ncoeffs = nnz_wcoeffs( wdec_out );
    if ( eff_ncoeffs <= target_ncoeffs )
        return;
    end
end

