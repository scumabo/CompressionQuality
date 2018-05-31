function A = unfold_t3( T3 )
%unfolds a tensor3 into a squared matrix 

I1 = size(T3, 1);
I2 = size(T3, 2);
I3 = size(T3, 3);


J3 = uint8(sqrt(I3));

if ( (J3*J3) < I3 )
    J3 = J3+1;
end

J1 = I1*double(J3);
J2 = I2*double(J3);


A = zeros( J1, J2 );

i3 = 1;

for j1 = 1:I1:J1
    for j2 = 1:I2:J2
        
        if (i3 <= I3)
            
            j1_e = j1 + I1-1;
            j2_e = j2 + I2-1;
            
            tmp = double(T3(:,:,i3));
            
            A(j1:j1_e, j2:j2_e) = tmp;
            
            
            i3 = i3 + 1;
        end
        
    end
end
