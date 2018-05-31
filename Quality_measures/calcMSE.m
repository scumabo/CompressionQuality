function mse  = calcMSE(A, B)
%computes mean squarred error (mse) for the volumes A and B
% MSE = 
% 1/(m*n*l) * sum(i1[0 m-1])sum(i2[0 n-1])sum(i3[0 l-1]) ||A(i1,i2,i3) - B(i1,i2,i3)||^2

m = size(A, 1);
n = size(A, 2);
sum_err2 = 0;

AA = double(A);
BB = double(B);
err2 = (AA-BB).^2;


%% 2D
if (ndims(A) == 2)
    for k = 1:m
        sum_err2 = sum_err2 + mean((err2(k, :)));
    end

    mse = sum_err2/m;
end


%% 3D
if (ndims(A) ==3)
    for k = 1:m
        for l = 1:n
            sum_err2 = sum_err2 + mean(double(err2(k, l, :)));
        end
    end
    mse = sum_err2 /(m*n);
end
