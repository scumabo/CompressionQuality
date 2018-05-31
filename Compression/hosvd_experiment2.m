function  hosvd_experiment2()
%compare svd and hosvd

 data_dir = '../data/testing/';
 
 
 %% hazelnuts %%
 dir = sprintf('%s/hazelnuts/', data_dir );
 precision = '*uint8';
 
 I1 = 512;
 I2 = 512;
 I3 = 512;
 t3 = batchReadVolume( dir, 'hnut512_uint.raw', I1,I2,I3, '*uint8' );
 
 id = 1;
 
 for i3 = 1:64:I3
     for i2 = 1:64:I2
         for i1 = 1:64:I1
             
             fprintf('### processing brick nr = %i...\n',id ); 
             
             i1_e = i1 + 63;
             i2_e = i2 + 63;
             i3_e = i3 + 63;
             
             %fprintf('(i1,i2,i3) = (%i,%i,%i) \n', i1, i2, i3);

             brick = t3(i1:i1_e, i2:i2_e, i3:i3_e);
             metrics(id, :) = compare_rank1( brick, id, dir, precision );
             
             id = id + 1;
         end
     end
 end


    
statsfile = sprintf('%s/stats/metrics_hnut_bricked', data_dir );
xlswrite(statsfile, metrics);


%% m2-subvolume 256-cubed

% tooth2_dir = sprintf('%s/m2_sub/', data_dir );
% precision = '*uint16';
%  








