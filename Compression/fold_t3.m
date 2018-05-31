function T3 = fold_t3( A, I1, I2, I3 )
%folds a squared matrix into tensor of size 


T3 = tenzeros( [I1 I2 I3]);

[J1, J2] = size(A);

i3 = 1;

for j1 = 1:I1:J1
    for j2 = 1:I2:J2
        
        if (i3 <= I3)
            
            j1_e = j1 + I1-1;
            j2_e = j2 + I2-1;
            
            tmp = tensor(A(j1:j1_e, j2:j2_e));
            
            T3(:,:,i3) = tmp;
            
            i3 = i3 + 1;
        end
        
    end
end

