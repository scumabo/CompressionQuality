function vol_reco = truncate_ta( tdec, K1, K2, K3, precision )
%compression of ta for n number of coefficients

global DATA_DIR;

core = tdec.core;
U1 = tdec.U{1};
U2 = tdec.U{2};
U3 = tdec.U{3};

I1 = size(U1,1);
I2 = size(U2,1);
I3 = size(U3,1);
R1 = size(U1,2);
R2 = size(U2,2);
R3 = size(U3,2);

if ( K1 > R1 || K2 > R2 || K3 > R3 )
    fprintf('the truncated ranks must be smaller than the initial ranks, the ranks are (R1,R2,R3) =< (K1,K2,K3) = (%i,%i,%i) < (%i,%i,%i)', R1, R2, R3, K1, K2, K3);
    return;
end

 core_trunc = core(1:K1,1:K2,1:K3);
 
 U1_trunc =  U1(:,1:K1);
 U2_trunc =  U2(:,1:K2);
 U3_trunc =  U3(:,1:K3);
 
 % FIXME: check size of R... if R=1, reconstruct as ktensor
 
 tdec2 = ttensor(core_trunc, U1_trunc, U2_trunc, U3_trunc);
 
 approx = tensor(tdec2);
 
 if( strcmp(precision,'*uint8') )
     vol_reco = uint8(double(approx));
 end
 if( strcmp(precision,'*uint16') )
     vol_reco = uint16(double(approx));
 end
 

%filename = sprintf('truncated_tucker_%i.raw', DATA_DIR, r);
%batchWriteVolume( approx_uint, reco_dir, filename, precision );

 
