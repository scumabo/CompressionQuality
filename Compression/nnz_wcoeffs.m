function [number] = nnz_wcoeffs(wdec)
%returns number of nonzero coefficients for a multilevel wt %decomposition


nblocks = size(wdec.dec, 1);

number = 0;
for block=1:nblocks
    coeffs0 = wdec.dec{block};
    nvalidcoeffs =  nnz(tensor(coeffs0));
    %nvalidcoeffs2 =  nnz(double(coeffs0));
    number = number + nvalidcoeffs;
end