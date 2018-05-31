function snr  = calcSNR(A, B )
% computes the signal-to-noise (psnr) ratio for a volume a and b



% A and B are of type tensor
%if dim(A) not equal to dim(B) -> error
if(size(A) ~= size(B))
    error('the dimensions of the two volumes compared must be equal');
end

%TODO
%if (A==B)
%   error('Volumes are identical: PSNR has infinite value')
%end

sqrd_mean = calc_squared_mean( A );
mse = calcMSE( A, B );
snr = 10 * log10(sqrd_mean/mse);
snr = abs(snr);

%disp(sprintf('SNR = %5.2f dB',snr));

% from xie
% function ser = snr(recVol,origVol)
% % The program determines the SER between two volumes.
% errVol = recVol - origVol;
% error = sum(errVol(:).^2);
% ser = 10*log10(sum(origVol(:).^2)/error);
% end





%% helper functions %%
function mse = calc_squared_mean( A )
%computes squared mean value of an input data



m = size(A, 1);
n = size(A, 2);

AA = double(A);
srd_A = AA.^2;
sum_vals = 0;


%% 2D
if (ndims(A) == 2)
    for k = 1:m
        sum_vals = sum_vals + mean((srd_A(k, :)));
    end

    mse = sum_vals/m;
end

%% 3D
if (ndims(A) ==3)
    for k = 1:m
        for l = 1:n
            sum_vals = sum_vals + mean(double(srd_A(k, l, :)));
        end
    end
    mse = sum_vals /(m*n);
end
