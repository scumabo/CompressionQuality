function wdec = decompose_wt( vol )
%applies a wavelet decomposition to an input volume


vol = double(vol);
wname = 'bior4.4'; %'bior4.4'; %'coif5'; %'db5';% 'db1' = 'haar'; %'bior4.4', 'bior2.4'
I1 = size(vol, 1);
I2 = size(vol, 2);
I3 = size(vol, 3);

I_min = min(I1, min(I2, I3));

n_levels = wmaxlev(I_min,wname);
wdec = wavedec3( vol, n_levels, wname);

 disp('## initial WT compression done...');
