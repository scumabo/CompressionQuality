function vol_reco = reconstruct_wt( wdec_thresholded, precision )
% reconstruct volume from wdec3 (considering precision)

approx = tensor( waverec3( wdec_thresholded ) );

if( strcmp(precision,'*uint8') )
    vol_reco = uint8(double(approx));
end
if( strcmp(precision,'*uint16') )
    vol_reco = uint16(double(approx));
end

