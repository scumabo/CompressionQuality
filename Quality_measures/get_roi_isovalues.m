function [ roi, isovalues ] = get_roi_isovalues( roi_idx )
%gets a roi with given most relevant isosurfaces


roi_list = {'hnut_roi1', 'hnut_roi2', ...
    'flower_roi1', 'flower_roi2', 'flower_roi3', 'flower_roi4', 'flower_roi5', ...
    'shell1_roi1', 'shell1_roi2', ...
    'trabeculae_roi1', 'trabeculae_roi2', 'trabeculae_roi3', ...
    'neghip', 'bucky64', ...
    'hnut', ...
    'frog_roi1', 'frog_roi2', 'frog_roi3' };

%eight most significant isovalues for given rois
isoval_list = [ 134 135 33 136 103 67 137 21; ... % 1: hnut_roi1
    133 134 69 135 49 136 86 33; ... % 2: hnut_roi2
    103 104 105 43 106 61 107 33; ...% 3: flower_roi1:
    146 147 148 24 149 88 13 117; ...% 4: flower_roi2:
    112 113 114 65 115 53 116 30; ...% 5: flower_roi3:
    180 75 181 111 182 20 56 183; ...% 6: flower_roi4:
    163 164 82 165 126 56 18 166; ...% 7: flower_roi5:
    50 100 150 200 -1 -1 -1 -1; ... % 8: shell1_roi1
    50 100 150 200 -1 -1 -1 -1; ... % 9: shell1_roi2
    50 100 150 200 -1 -1 -1 -1; ... % 10: trabeculae_roi1
    96 131 202 69 160 244 216 180; ... % 11: trabeculae_roi2
    95 213 73 214 122 146 165 215; ... % 12: trabeculae_roi3
    154 93 205 60 236 36 124 23; ... % 13: neghip
    30 50 80 100 -1 -1 -1 -1; ... % 14: bucky
    164 85 165 56 166 19 142 100; ... % 15: hnut 64 cubed
    109 170 60 205 135 39 223 5; ...% 16: frog_roi1:
    100 135 180 62 232 211 31 241; ...% 17: frog_roi2:
    100 138 186 64 237 208 224 43; ...   %  18: frog_roi3:
    ]; %end isoval_list

% shell1_roi1: 105 146 64 168 213 238 40 245
% shell1_roi2: 74 223 52 159 237 94 212 149
% trabeculae_roi1: 131 99 157 73 239 197 53 217


nrois = size(roi_list, 2);

if ( roi_idx > nrois )
    error('index for roi out of bound');
end

roi = char(roi_list( roi_idx ));
isovalues = isoval_list(roi_idx, :);
