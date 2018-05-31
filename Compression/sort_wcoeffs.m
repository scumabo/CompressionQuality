function sorted_coeffs = sort_wcoeffs( wdec )
% sort the wavelet coefficients of an existing 3d wcoeff decomposition

global MAX_NCOEFFS;
global MAX_VALID_NCOEFFS;

%% (1) move all coefficients to one array (for threshold estimation)
nblocks = size(wdec.dec, 1); %counts the number of blocks containing wavelet coefficients 
num_wcs = 0; % total number of wavelet coefficients
for block = 1:nblocks
    num_wcs = num_wcs + numel(wdec.dec{block});
end

all_coeffs = zeros(1,num_wcs);
start_idx = 1;
for block = nblocks:(-1):1
    block_size = numel(wdec.dec{block});
    all_coeffs(start_idx:start_idx+block_size-1) = reshape(wdec.dec{block},[1 block_size]);
    start_idx = start_idx + block_size;
end

%% (2) consider absolute coefficient values for thresholding
abs_coeffs = abs(all_coeffs);


%% (3) continue only with positive wavelet coefficients. do sorting
%%% and remain only non-zero coefficients
sorted_coeffs = sort(abs_coeffs, 'descend');
%cut_coeffs = sorted_coeffs(sorted_coeffs > 0.0001); %note: otherwise some really small coefficients remain

%% set global variables
MAX_NCOEFFS = size( sorted_coeffs, 2 );
MAX_VALID_NCOEFFS = nnz(sorted_coeffs);



%% FIXME: TODO
%% (4) take logarithmic values of wcs (for binning)
%ncut_coeffs = size(cut_coeffs,2); %debug
%cut_log_coeffs = log(cut_coeffs);
%figure, hist(cut_log_coeffs, 150);

%% (5) do some binning and estimate a global threshold (come close to the
%%% number of coefficients needed

%%  increase the threshold and remove coefficients with priorities:
%%% high-frequency coefficients first, then lower-requency coefficients:  
%%% HHH-LHH-HLH-LLH-HHL-LHL-HLL-LLL..

%%% wdec:LLL 'HLL','LHL','HHL','LLH','HLH','LHH','HHH'. ,i,., start to
%%% threshold at highest K block of wedec

