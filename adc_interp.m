% Make normalized ADC map

sizeX = 80;
sizeY = 80;
x = 1:sizeX; % each 1 unit is a voxel, or 2 mm
y = 1:sizeY; 
[X,Y] = meshgrid(x,y);

ADC = zeros(sizeX, sizeY);
% TODO: "simulate necrosis"? 
% I'm just going to make some noise for now
ADC = randi([10, 20], sizeX, sizeY) ./ 100;
ADC = ADC + ((X - sizeX/2).^2 + (Y - sizeY/2).^2 <= 10^2);
ADC = ADC - min(ADC(:));
ADC = ADC ./ max(ADC(:)); % this and line above is normalization to account for adding tumor on top of noise
%ADC = imgaussfilt(ADC, 1);

subplot(2,2,1)
imagesc(x,y,ADC)
impixelinfo;
colorbar
axis('on', 'image');
title("Normalized ADC Map", 'FontSize', 15)

% Now, convert to NTC map
theta = 100; % placeholder value
% 2mm voxels, 1mm slice (2x2x1)
% 0.7405 cells in one voxel (from Nature Protocols paper) - number from
% spheres in a cube



NTC = ADC .* theta;
subplot(2,2,2)
imagesc(x,y,NTC)
impixelinfo;
colorbar
axis('on', 'image');
title("NTC Map", 'FontSize', 15)
%breast_mask = roipoly
%breastboundary = [];
%load("breastboundary.mat","breastboundary");
%drawpolygon(breastboundary);
%plot(breastboundary)

% % % Now, mask tumor on NTC map, and breast
tumor = NTC >= (0.9*theta);
subplot(2,2,3)
imagesc(x,y,tumor)
impixelinfo;
colorbar
axis('on', 'image');
title("Tumor Mask", 'FontSize', 15)

% Now, interpolate/scale up
x2 = 1:40;
y2 = 1:40; 
[X2,Y2] = meshgrid(x2,y2);
NTC2 = custom_upsample(x, y, NTC, x2, x2, 'cubic');

subplot(2,2,4)
imagesc(x2,y2,NTC2)
impixelinfo;
colorbar
axis('on', 'image');
title("Interpolated NTC Map", 'FontSize', 15)

% now need to run 2d diffusion-proliferation
% params: 
% - D: 5e-4
% - k: 0.05
% - 


% Now, need to compare before and after result
% - Concordance correlation coefficient
%    - https://en.wikipedia.org/wiki/Concordance_correlation_coefficient
% - Mean-squared, mean absolute error, etc.



%%%%
% x is a list like 1:80
% TODO: address issue of 
function new_map = custom_upsample(x, y, map, new_x, new_y, method)
    % Step to use for interp2. For example, if x is 1:80, and we now want
    % 1:160, then we need 1:0.5:80, so step_x is 0.5 or 80/160
    step_x = length(x) / length(new_x);
    step_y = length(y) / length(new_y);

    x_interp = x(1):step_x:x(length(x));
    y_interp = y(1):step_y:y(length(y));
    [X,Y] = meshgrid(x, y);
    [X2,Y2] = meshgrid(x_interp, y_interp);

    new_map = interp2(X, Y, map, X, Y, method);
end