function dct_coeff = decompose_dct( vol )
%applies a wavelet decomposition to an input volume


vol = double(vol);

dct_coeff = mirt_dctn(vol);

 disp('## initial DCT compression done...');
