function psnr  = calcPSNR(A, B, max_value)
% computes the peak-signal-to-noise (psnr) ratio for a volume a and b
% psnr is generally used as a measure of quality for lossy compression
% psnr is returned in decibel and computed with the formula:
% psnr = 20 * log_10 (max/RMSE), where 'max' is the maximal intensity
% value of the possible input values of A and B, for a 8bit volume 'max' is
% 255, and RMSE is the root mean squarred error between A and B. 
% dim of A and B must match and are: m x n x l


%Testing
% adapted EXAMPLE 3 from PSNR.m (by John T. McCarthy)
% EXAMPLE 3:         
%            load clown
%            A = ind2gray(X,map); % Convert to intensity image in [0,1]
%            AA = uint8(255*A);   % Change to integers in [0,255]
%            BB = 0.95*AA;        % Make BB close to AA.
%            AAA = tensor(AA);
%            BBB = tensor(BB);
%            calcPSNR(AAA, BBB, 255);   % ---> "PSNR = 33.56 dB" 



% A and B are of type tensor
%if dim(A) not equal to dim(B) -> error
if(size(A) ~= size(B))
    error('the dimensions of the two volumes compared must be equal');
end

%TODO
%if (A==B)
%   error('Volumes are identical: PSNR has infinite value')
%end

psnr = 20 * log10(max_value/sqrt(calcMSE(A, B)));
psnr = abs(psnr);

%disp(sprintf('PSNR = %5.2f dB',psnr));
