function sorted_coeffs = sort_scoeffs( scoeffs )
% sort the wavelet coefficients of an existing 3d wcoeff decomposition

global MAX_NCOEFFS;
global MAX_VALID_NCOEFFS;

%% (1) consider absolute coefficient values for thresholding
abs_coeffs = abs(scoeffs);

N = size(scoeffs, 2);
M = size(scoeffs,1);

P = N*M;

b = reshape( abs_coeffs, [1 P]);

c = b(b > 0); %note: otherwise some really small coefficients remain

%% (2) continue only with positive coefficients. do sorting
sorted_coeffs = sort(c, 2, 'descend'); %sort values, in second col.

%% set global variables
MAX_NCOEFFS = size( sorted_coeffs, 2 );
MAX_VALID_NCOEFFS = nnz(sorted_coeffs);


%% FIXME: sorting should remain original indices. permutations...


