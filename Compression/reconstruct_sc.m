function vol_reco = reconstruct_sc(dic, scoeff_thresholded, precision )
% reconstruct volume from wdec3 (considering precision)

Y = dic * scoeff_thresholded;

%fold back to volume

m = size(dic,1);
M = nthroot(m,3); 
tmp = size(scoeff_thresholded,2);
I = nthroot(tmp,3); 

npatch = 1;

vol_reco = zeros(I+M-1, I+M-1, I+M-1);
T=1;
for i3 = 1:T:I
    for i2 = 1:T:I
        for i1 = 1:T:I
            yp = Y(:, npatch);
            v = reshape(yp, M, M, M );
            
            p = vol_reco(i1:i1+M-1, i2:i2+M-1, i3:i3+M-1);
            v = v+p;
       
            vol_reco(i1:i1+M-1, i2:i2+M-1, i3:i3+M-1) = v;
            npatch = npatch + 1;
            
        end
    end
end


if( strcmp(precision,'*uint8') )
    vol_reco = uint8(double(vol_reco));
end
if( strcmp(precision,'*uint16') )
    vol_reco = uint16(double(vol_reco));
end

