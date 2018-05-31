function sorted_coeffs = sort_dctcoeffs( dct_coeffs )
% sort the wavelet coefficients of an existing 3d wcoeff decomposition

global MAX_NCOEFFS;
global MAX_VALID_NCOEFFS;

%% (1) move all coefficients to one array (for threshold estimation)
dct_array = reshape(dct_coeffs,[1 numel(dct_coeffs)]);

%% (2) consider absolute coefficient values for thresholding
abs_coeffs = abs(dct_array);


%% (3) continue only with positive wavelet coefficients. do sorting
%%% and remain only non-zero coefficients
sorted_coeffs = sort(abs_coeffs, 'descend');

%% set global variables
MAX_NCOEFFS = size( sorted_coeffs, 2 );
MAX_VALID_NCOEFFS = nnz(sorted_coeffs);


