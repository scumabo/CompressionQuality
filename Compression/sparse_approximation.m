function vol_reco = sparse_approximation( vol, ncoeffs, precision, do_haar )
%sparse approximation by xie xu and reza entezari

n = ncoeffs;
x = double( vol );
[Nx, Ny, Nz] = size(x);
N = Nx * Ny * Nz;

% solver parameters
delta = 1e-8; % error tolerance
mu = 1e-2; % smoothness paramater. Usually smaller value results in more accurate recovery but leads to long time
DC = 6; % DC area to keep. Usaully smaller value lead to more accurate. Suggest to use 4, 5 or 6.
opts = [];
opts.Verbose = 10;


% Base Freq
[Yi, Xi, Zi] = meshgrid(1:floor(Nx/DC), 1:floor(Ny/DC), 1:floor(Nz/DC));
Ibase = sub2ind([Nx Ny Nz], Xi(:), Yi(:), Zi(:));
no_base_freq = length(Ibase);
[Yi, Xi, Zi] = meshgrid(1:Nx, 1:Ny, 1:Nz);
Iall = sub2ind([Nx Ny Nz], Xi(:), Yi(:), Zi(:));
Irest = setdiff(Iall, Ibase);
JJ = randperm(N - no_base_freq);


if( do_haar )
    
    wavelet = @(x) haar3_linear(x, Nx, Ny, Nz);
    invWavelet = @(x) ihaar3_linear(x, Nx, Ny, Nz);
    opts.U = wavelet; % forward transform, analysis operator
    opts.Ut = invWavelet; % inverse transform, synthesis operator
    
else 
    %surfacelets
    %% note: this code is optimized for 64-cubed data!
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    Pyr_mode = 2;% effect the downsample factor
    
    Level_64 = [-1 3 3; 3 -1 3; 3 3 -1]; % 3 * 64 directions
    Level_16 = [-1 2 2; 2 -1 2; 2 2 -1]; % 3 * 16 directions
    Level_4 =  [-1 1 1; 1 -1 1; 1 1 -1]; % 3 * 4 directions
    Level_1 =  [-1 0 0; 0 -1 0; 0 0 -1]; % 3 directions (i.e. the hourglass decomposition)
    
    % A parameter for the surfacelet filter
    bo = 8;
    
    Lev_array = {Level_16,Level_4};% indicating # of levels
    
    X0 = zeros(size(x));
    
    [Y, Recinfo,Pyr_mode_surf, Lev_array_surf, dec_flts_surf, rec_flts_surf, msize_surf, beta_surf, lambda_surf] = Surfdec_returnMore(X0, Pyr_mode, Lev_array, 'ritf', 'bo', bo); % this code is simply use to create a structure holder, the real values of Xn or Y is not important.
    
    num_coeff= int64(numel_cell(Y));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    invSurfacelet = @(x) surfRec_linear(x, Nx, Ny, Nz, Y, Recinfo);
    surfacelet = @(x) surfDec_linear(x, Nx, Ny, Nz, Pyr_mode, Lev_array,bo,num_coeff);
    opts.U = surfacelet; % forward transform
    opts.Ut = invSurfacelet; % inverse transform
    
end



J = [Ibase(:)' Irest(JJ(1:( n - no_base_freq)))'];

A = partialDCT3(Nx, Ny, Nz, n, J);
y = A * x(:);

AA = @(x) A*x;
AAt =@(x) A'*x;


%% non-linear optimization
tic;
[xRec,niter,resid,outData] = NESTA( AA, AAt, y, mu, delta, opts);
toc;

vol_reco = reshape(xRec,Nx, Ny, Nz);

if( strcmp(precision,'*uint8') )
    vol_reco = uint8(double(vol_reco));
end
if( strcmp(precision,'*uint16') )
    vol_reco = uint16(double(vol_reco));
end


