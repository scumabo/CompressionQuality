function  hosvd_experiment()
%compare svd and hosvd

 data_dir = '../data/testing/';
 
 
 %% hazelnuts %%
 dir = sprintf('%s/hazelnuts/', data_dir );
 precision = '*uint8';
 id = 1;

 t3 = batchReadVolume( dir, 'hnut_64x64x64.raw', 64,64,64, '*uint8' ); 
% 
% rmse_nums_v1 = classical_hosvd( t3, dir, precision );
% 
% rmse_nums_v2 = truncated_hosvd( t3, dir, precision );
% 
%  squared_hosvd( t3, dir, precision );
%  
%  rank_one_hosvd( t3, dir, precision );
metrics(id, :) = compare_rank1( t3, id, dir, precision );

 

%% test-4-roi

 dir = sprintf('%s/tooth/', data_dir );
 precision = '*uint16';
 id = 2;

 t3 = batchReadVolume( dir, 'test-4-roi.raw', 64,64,64, precision ); 
% 
% %showVolume(t3, '');
% 
% classical_hosvd( t3, dir, precision );
% 
% truncated_hosvd( t3, dir, precision );
% 
%  squared_hosvd( t3, dir, precision );
%  
%  rank_one_hosvd( t3, dir, precision );

metrics(id, :) = compare_rank1( t3, id, dir, precision );


%% chameleon

 dir = sprintf('%s/chameleon/', data_dir );
 precision = '*uint16';
 id = 3;

 t3 = batchReadVolume( dir, '64-cubed.raw', 64,64,64, precision ); 
% 
% %showVolume(t3, '');
% 
% classical_hosvd( t3, dir, precision );
% 
% truncated_hosvd( t3, dir, precision );
% 
% squared_hosvd( t3, dir, precision );
% rank_one_hosvd( t3, dir, precision );
metrics(id, :) = compare_rank1( t3, id, dir, precision );


%% flower
 
 dir = sprintf('%s/flower/', data_dir );
 precision = '*uint8';
 id = 4;

 t3 = batchReadVolume( dir, '64-cubed.raw', 64,64,64, precision ); 
% 
% %showVolume(t3, '');
% 
% classical_hosvd( t3, dir, precision );
% 
% truncated_hosvd( t3, dir, precision );
% 
%squared_hosvd( t3, dir, precision );

%rank_one_hosvd( t3, dir, precision );

metrics(id, :) = compare_rank1( t3, id, dir, precision );


%% sponge

dir = sprintf('%s/sponge/', data_dir );
precision = '*uint16';
id = 5;

t3 = batchReadVolume( dir, '64-cubed.raw', 64,64,64, precision ); 


%classical_hosvd( t3, dir, precision );

%truncated_hosvd( t3, dir, precision );

%squared_hosvd( t3, dir, precision );

%rank_one_hosvd( t3, dir, precision );

metrics(id, :) = compare_rank1( t3, id, dir, precision );


%% m2-subvolume 256-cubed

% tooth2_dir = sprintf('%s/m2_sub/', data_dir );
% precision = '*uint16';
%  
% t3 = batchReadVolume( tooth2_dir, 'm2_256x256x256.raw', 256,256,256, precision ); 
% 
% %classical_hosvd( t3, tooth2_dir, precision );
% 
% truncated_hosvd( t3, tooth2_dir, precision );
% 
% squared_hosvd( t3, tooth2_dir, precision );


    
statsfile = sprintf('%s/stats/metrics', data_dir );
xlswrite(statsfile, metrics);






