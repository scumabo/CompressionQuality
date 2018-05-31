function tdec = decompose_ta( vol, R1, R2, R3 )
%initial tensor decomposition to half of the initial ranks


I1 = size(vol, 1);
I2 = size(vol, 2);
I3 = size(vol, 3);



 tdec = tucker_als( tensor(vol),[R1 R2 R3], struct('init','eigs'));
 
 disp('## initial TA compression done...');
