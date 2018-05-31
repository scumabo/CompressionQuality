function iqa_comparison()
%compares differend IQA methods on 3D volume data (object space)

%% FIXME: something not working with precision '*uint16'

% definitions of compression methods applied
global DO_TA;
global DO_WT;
global DO_DCT;
global DO_SA;
global DO_SC;

global NCOLS_METRICS;
global NUM_RATIOS;
global DATA_DIR;

% definitions of IQA metrics applied
global DO_PSNR;
global DO_SNR;
global DO_PSNR_HVS;
global DO_VSNR;
global DO_SSIM;
global DO_MSSSIM;
global DO_IWSSIM;
global DO_FSIM;
global DO_RAND;
global DO_VGS;
global DO_VQA;
global DO_RMSE;

% definitions of datasets evaluated
global DO_HNUT_64;
global DO_TEST4ROI;
global DO_CHAM_64;
global DO_FLOWER_64;
global DO_SPONGE_64;
global DO_BONE1;
global DO_M2_256;
global DO_BONOBO;
global DO_BUCKY64;
global DO_NEGHIP;
global DO_ROIS;
global DO_ML;
global DO_BONSAI;
global DO_ENGINE;
global DO_HNUT512;
global DO_OSIRIX_MRI;
global DO_GAUSSIAN_SPHERE;
global DO_MANDELBROT;
global DO_3DWAVES;
global DO_MANIX128;
global DO_ENGINE128;
global DO_CARP128;
global DO_GMM;
global DO_VOLVIS_TOOTH;
global DO_HYDROGEN;
global DO_HNUT128;
global PREP_DATA;

%% init
DO_TA = true;
DO_WT = true;
DO_DCT = true;
DO_SA = false;
DO_SC = false;

PREP_DATA = false;
DO_VQA = true;

NCOLS_METRICS = 40;
NUM_RATIOS = 10;

DO_SNR = true;
DO_PSNR = true;
DO_PSNR_HVS = false;
DO_VSNR = false;
DO_SSIM = true;
DO_MSSSIM = false;
DO_IWSSIM = false;
DO_FSIM = false;
DO_VGS = false;
DO_RMSE = false;

DO_RAND = false;

DO_HNUT_64 = false;
DO_TEST4ROI = false;
DO_CHAM_64 = false;
DO_NEGHIP = false;
DO_BUCKY64 = false;
DO_ROIS = false;
DO_ML = false;
DO_BONE1 = false;
DO_BONSAI = false;
DO_ENGINE = false;
DO_HNUT512 = false;
DO_OSIRIX_MRI = false;
DO_BONOBO = false;
DO_M2_256 = false;
DO_MANDELBROT = false;
DO_GAUSSIAN_SPHERE = false;
DO_3DWAVES = false;
DO_MANIX128 = true;
DO_ENGINE128 = false;
DO_CARP128 = false;
DO_GMM = false;
DO_VOLVIS_TOOTH = false;
DO_HYDROGEN = false;
DO_HNUT128 = false;

DATA_DIR = '/cise/research/vis/homes/susuter/data';
DATA_DIR = '/cise/research/vis/shared/datasets';
DATA_DIR = '/blank0/data';

row_idx = 1;
I  = 64;

%% downsampled hnut
if ( DO_HNUT128  )
    
    descr = 'hnut128';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 506;
    t3 = batchReadVolume( dir, filename, 128,128,128, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
    if ( DO_VQA )
        [ a, b, c] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
    end
    row_idx = row_idx + NUM_RATIOS;
end

%% downsampled volvis tooth
if (DO_HYDROGEN  )
    
    descr = 'hydrogen';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 505;
    t3 = batchReadVolume( dir, filename, 128,128,128, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
    if ( DO_VQA )
        [ a, b, c] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
    end
    row_idx = row_idx + NUM_RATIOS;
end

%% downsampled volvis tooth
if ( DO_VOLVIS_TOOTH )
    
    descr = 'tooth128';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 504;
    t3 = batchReadVolume( dir, filename, 128,128,81, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
    if ( DO_VQA )
        [ a, b, c] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
    end
    row_idx = row_idx + NUM_RATIOS;
end

%% downsampled carp
if ( DO_CARP128 )
    
    descr = 'carp1';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 504;
    t3 = batchReadVolume( dir, filename, 128,128,128, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
    if ( DO_VQA )
        [ a, b, c] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
    end
    row_idx = row_idx + NUM_RATIOS;
end


%% downsampled engine
if ( DO_ENGINE128 )
    
    descr = 'engine2';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 504;
    t3 = batchReadVolume( dir, filename, 128,128,64, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
    if ( DO_VQA )
        [ a, b, c] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
    end
    row_idx = row_idx + NUM_RATIOS;
end

%% downsampled manix
if ( DO_MANIX128 )
    
    descr = 'manix128';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 500;
    t3 = batchReadVolume( dir, filename, 128,128,115, precision,0 );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
    if ( DO_VQA )
        [ a, b, c] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
    end
    row_idx = row_idx + NUM_RATIOS;
end


%% gmm1-gmm3 (MI paper)
if ( DO_GMM )
    
    descr = 'gmm3';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 501;
    t3 = batchReadVolume( dir, filename, I,I,I, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
    if ( DO_VQA )
        [ a, b, c] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
    end
    row_idx = row_idx + NUM_RATIOS;
end

if ( DO_ROIS )
    
    descr = 'trabeculae_roi2';
    filenameorig = sprintf('%s.raw', descr);
    dir = sprintf('%s/rois-64cubed/%s', DATA_DIR, descr );
    precision = '*uint8';
    id = 50;
    
    t3 = batchReadVolume( dir, filenameorig, I,I,I, precision );
    %showVolume(t3, '');
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
    if ( DO_VQA )
        [ a, b, c] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
         end
        if ( DO_WT )
%            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
            metrics_wt(:, :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
    end
    
    row_idx = row_idx + NUM_RATIOS;
end


%% mandelbrot
if ( DO_MANDELBROT )
    
    descr = 'mandelbrot';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 100;
    J = 128;
    t3 = batchReadVolume( dir, filename, J,J,J, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
    if ( DO_VQA )
        [ a, b, c] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
    end
    row_idx = row_idx + NUM_RATIOS;
end

%% gaussian sphere
if ( DO_GAUSSIAN_SPHERE )
    
    descr = 'gaussian_sphere';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 110;
    t3 = batchReadVolume( dir, filename, I,I,I, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
    if ( DO_VQA )
        [ a, b, c] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
    end
    row_idx = row_idx + NUM_RATIOS;
end

%% 3dwaves
if ( DO_3DWAVES )
    
    descr = '3dwaves_stapled2';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 120;
    t3 = batchReadVolume( dir, filename, I,I,I, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
    if ( DO_VQA )
        [ a, b, c, d] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
        if ( DO_SC )
            metrics_sc(row_idx:(row_idx+NUM_RATIOS-1), :) = d;
        end
   end
    row_idx = row_idx + NUM_RATIOS;
end

%% marchnerlobb
if ( DO_ML )
    
    descr = 'marschnerlobb';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 40;
    t3 = batchReadVolume( dir, filename, 40,40,40, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
    if ( DO_VQA )
        [ a, b, c] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
    end
    row_idx = row_idx + NUM_RATIOS;
end


%% neghip
if ( DO_NEGHIP )
    
    descr = 'neghip';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 10;
   
    t3 = batchReadVolume( dir, filename, I, I, I, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
    if ( DO_VQA )
        [ a, b, c] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
    end
    row_idx = row_idx + NUM_RATIOS;
end

%% bucky ball 64-cubed
if ( DO_BUCKY64 )
    
    descr = 'bucky64';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 11;
    
    t3 = batchReadVolume( dir, filename, I, I, I, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
    if (DO_VQA)
        [ a, b] = evaluate_volume( t3, precision, id, descr );
        
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
    end
    row_idx = row_idx + NUM_RATIOS;
end

%% hazelnuts %%

if ( DO_HNUT_64 )
    
    descr = 'hnut';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    precision = '*uint8';
    id = 1;
    
    t3 = batchReadVolume( dir, 'hnut_64x64x64.raw', 64,64,64, precision );
    %showVolume(t3, '');
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
    if ( true )
        [ a, b] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
    end
    row_idx = row_idx + NUM_RATIOS;
end

%% test-4-roi

if ( DO_TEST4ROI )
    
    dir = sprintf('%s/testdata_uct/', DATA_DIR );
    precision = '*uint16';
    id = 2;
    
    t3 = batchReadVolume( dir, 'test-4-roi.raw', 64,64,64, precision );
    [ a, b] = evaluate_volume( t3, precision, id );
    if ( DO_TA )
        metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
    end
    if ( DO_WT )
        metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
    end
    
    row_idx = row_idx + NUM_RATIOS;
end


%% chameleon

if ( DO_CHAM_64 )
    dir = sprintf('%s/chameleon/', DATA_DIR );
    precision = '*uint16';
    id = 3;
    
    t3 = batchReadVolume( dir, '64-cubed.raw', 64,64,64, precision );
    [ a, b] = evaluate_volume( t3, precision, id );
    if ( DO_TA )
        metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
    end
    if ( DO_WT )
        metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
    end
    
    row_idx = row_idx + NUM_RATIOS;
end


%% flower

if ( DO_FLOWER_64 )
    dir = sprintf('%s/flower/', DATA_DIR );
    precision = '*uint8';
    id = 4;
    
    t3 = batchReadVolume( dir, '64-cubed.raw', 64,64,64, precision );
    [ a, b] = evaluate_volume( t3, precision, id );
    
    if ( DO_TA )
        metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
    end
    if ( DO_WT )
        metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
    end
    
    row_idx = row_idx + NUM_RATIOS;
   
end

%% sponge

if ( DO_SPONGE_64 )
    dir = sprintf('%s/sponge/', DATA_DIR );
    precision = '*uint16';
    id = 5;
    
    t3 = batchReadVolume( dir, '64-cubed.raw', 64,64,64, precision );
    [ a, b] = evaluate_volume( t3, precision, id );
    
    if ( DO_TA )
        metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
    end
    if ( DO_WT )
        metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
    end
    
    row_idx = row_idx + NUM_RATIOS;
   
end

%% bone trabeculae
if ( DO_BONE1 )
    
    descr = 'zollikerberg_thoracic';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 6;
    t3 = batchReadVolume( dir, filename, 750,600,500, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
end
%% bone engine
if ( DO_ENGINE )
    
    descr = 'engine';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 7;
    t3 = batchReadVolume( dir, filename, 256,256,128, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    if ( DO_VQA )
        [ a, b, c] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
    end
    row_idx = row_idx + NUM_RATIOS;
    
end
%% bone bonsai
if ( DO_BONSAI )
    
    descr = 'bonsai';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 8;
    t3 = batchReadVolume( dir, filename, 256,256,128, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
     if ( DO_VQA )
        [ a, b, c] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
    end
    row_idx = row_idx + NUM_RATIOS;
   
end

%% bone hnut 512
if ( DO_HNUT512 )
    
    descr = 'hnut512';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 11;
    t3 = batchReadVolume( dir, filename, 512,512,512, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
end

%% bone osirix mri2
if ( DO_OSIRIX_MRI )
    
    descr = 'osirix_mri2';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    filename = sprintf('%s.raw', descr);
    precision = '*uint8';
    id = 12;
    t3 = batchReadVolume( dir, filename, 290,450,114, precision );
    
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
end

%% m2-subvolume 256-cubed

if ( DO_M2_256 )
    descr = 'm2_256';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    precision = '*uint16';
    id = 9;
    
    filename = sprintf('%s.raw', descr);
    t3 = batchReadVolume( dir, filename, 256,256,256, precision );
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
     if ( DO_VQA )
        [ a, b, c] = evaluate_volume( t3, precision, id, descr );
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
    end
    row_idx = row_idx + NUM_RATIOS;

end

%% bonobo-roi121 256-cubed (same as in STAR)

if ( DO_BONOBO )
    descr = 'bonobo_roi121';
    dir = sprintf('%s/%s/', DATA_DIR, descr );
    precision = '*uint16';
    id = 30;
    
    filename = sprintf('%s.raw', descr);
    
    t3 = batchReadVolume( dir, filename, 256,256,256, precision );
    if (PREP_DATA)
        prepare_data( t3, precision, descr );
    end
    
    if (DO_VQA)
        
        [ a, b, c] = evaluate_volume( t3, precision, id, descr );
        
        if ( DO_TA )
            metrics_ta(row_idx:(row_idx+NUM_RATIOS-1), :) = a;
        end
        if ( DO_WT )
            metrics_wt(row_idx:(row_idx+NUM_RATIOS-1), :) = b;
        end
        if ( DO_DCT )
            metrics_dct(row_idx:(row_idx+NUM_RATIOS-1), :) = c;
        end
        
        row_idx = row_idx + NUM_RATIOS;
    end
    
end

%% print statistics to file

if (DO_VQA)
    DATA_DIR = '/cise/research/vis/homes/susuter/data';    
    out_dir = '2014_VQA_DVR_stats';
    
    if (DO_TA)
        statsfile = sprintf('%s/%s/metrics_ta.csv', DATA_DIR, out_dir);
        csvwrite( statsfile, metrics_ta );
    end
    
    if (DO_WT)
        statsfile = sprintf('%s/%s/metrics_wt.csv', DATA_DIR, out_dir );
        csvwrite(statsfile, metrics_wt);
    end

    if (DO_SC)
        statsfile = sprintf('%s/%s/metrics_sc.csv', DATA_DIR, out_dir );
        csvwrite(statsfile, metrics_sc);
    end
    
    if (DO_DCT)
        statsfile = sprintf('%s/%s/metrics_dct.csv', DATA_DIR, out_dir );
        csvwrite(statsfile, metrics_dct);
    end
end



