function [Y, Dksvd,lambda,err] = decompose_sc( vol )
%learns a dictionary with sparse coding as done in gobbetti et al. 2012

% see 
% GOBBETTI E., IGLESIAS GUITIÁN J. A., MARTON F.:
% Covra: A compression-domain output-sensitive volume rendering
% architecture based on a sparse representation of voxel blocks.
% Computer Graphics Forum 31, 3pt4 (2012)
% params from gobbetti et al.: 
% 25 iterations
% fixed dictionary size K=1024
% block size M = 6
% sparsity S = 8
% tolerance E = 0.015 (for brick skipping)
% gobbetti et al. used coreset of 1.4%, which has shown good psnr results
% to approx. the full solution
% corset size: C = 64Mvox
% NOTE: we do not perform the importance sampling with the coreset since we
% don't work on large data, just general notion of compression models
% should be tested.

vol = double(vol);
I1 = size(vol, 1);
I2 = size(vol, 2);
I3 = size(vol, 3);


%%  (1) fill patches into data matrix y
% divide input volume (brick) into blocks of size M=8,4 = 4^3 or 8^3
% set those blocks as vectors/patches into data matrix y
% deviate from gobbetti due to our input brick size 64^3

M=4;
m = M*M*M;
Y = zeros(m,(I1*I2*I3)/(m));

npatch = 1;
T=1;
for i3 = 1:T:(I3-M+1)
    for i2 = 1:T:(I2-M+1)
        for i1 = 1:T:(I1-M+1)
            block = vol(i1:i1+M-1, i2:i2+M-1, i3:i3+M-1);
            Y(:,npatch) = reshape(block, m,1); %reshape takes column-vise vectors
            npatch = npatch + 1;
        end
    end
end

%figure, imshow(Y, []);

% gobbetti et al. use ORMP via Choleski Decomposition for sparse coding

%% (2) learn dictionary D

% the first dictionary element (DC) is kept fixed to d1 = (1/sqrt(M*M*M))
% -> check if done in rubinstein.

% D * lambda = Y, min D, lambda


%params 
S = 6; %sparsity
K = 200; % dictionary size

params.data = Y;
params.Tdata = S;
params.dictsize = K;
params.iternum = 25;
params.memusage = 'high';

% ksvd training

[Dksvd,lambda,err] = ksvd(params,'');


% show results %

figure; plot(err); title('K-SVD error convergence');
xlabel('Iteration'); ylabel('RMSE');

fprintf('  Dictionary size: %d x %d', m, K);

%[dist,ratio] = dictdist(Dksvd,D);
%fprintf('  Ratio of recovered atoms: %.2f%%\n', ratio*100);




disp('## initial dictionary learning done...');


