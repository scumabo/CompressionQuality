function vol_reco = reconstruct_dct( dct_thresholded, precision )
% reconstruct volume from wdec3 (considering precision)

vol_reco = mirt_idctn( dct_thresholded );

if( strcmp(precision,'*uint8') )
    vol_reco = uint8(double(vol_reco));
end
if( strcmp(precision,'*uint16') )
    vol_reco = uint16(double(vol_reco));
end

