function ncoeffs = ranks2ncoeffs( vol, R1, R2, R3)
%computes the number of coefficients given for a certain rank-(R1,R2,R3) TA


%I1 = size(vol, 1);
%I2 = size(vol, 2);
%I3 = size(vol, 3);

%ncoeffs = I1*R1 + I2*R2 + I3*R3 + R1*R2*R3;
ncoeffs = R1*R2*R3;

