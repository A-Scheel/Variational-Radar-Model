%PLOT2DSTUDENTTMIXTURE Contour plot of a two-dimensional Student's t
%                      mixture
%
%   fig = PLOT2DSTUDENTTMIXTURE(model) creates a contour plot of the
%   two-dimensional Student'S t mixture model. It outputs the figure handle
%   fig.
%
%   fig = PLOT2DSTUDENTTMIXTURE(model, settings) allows to additional
%   specify some plot parameters through the argument settings. It is a
%   struct that may contain the following fields (default values and the
%   format are given in brackets):
%
%   settings.title (default value: '') - Title of the figure
%   settings.axis (default value: [-1 1 -1 1]) - Axis limits as [xmin,
%                                                 xmax, ymin, ymax]
%   settings.daspect (default value: [1 1 1]) - Data aspect ratio of the
%                                               axis
%   settings.minContourValue (default value: 0.1) - Value of the smallest
%                                                   contour in the plot
%
%   Author: Alexander Scheel

function fig = plot2DStudentTMixture(model, settings)

%% settings handling
% create the settings variable if it has not been passed
if nargin <= 1
    settings = [];
end

% default settings
defaultSettings.title = '';
defaultSettings.axis = [-1 1 -1 1];
defaultSettings.daspect = [1 1 1];
defaultSettings.minContourValue = 0.1;

% replace missing settings by the default values
fields = fieldnames(defaultSettings);
for i = 1:numel(fields)
    if ~isfield(settings, fields{i})
        settings.(fields{i}) = defaultSettings.(fields{i});
    end
end

%% create the figure
% create figure
fig = figure('name', settings.title);
grid on;
box on;
hold on;
ax = gca;
axis(settings.axis);
title(settings.title);
daspect(settings.daspect);

% create meshgrid for contour plot
gridSpacingA = (settings.axis(2) - settings.axis(1))/500;
gridSpacingB = (settings.axis(4) - settings.axis(3))/500;
[a, b] = meshgrid(settings.axis(1):gridSpacingA:settings.axis(2), ...
                  settings.axis(3):gridSpacingB:settings.axis(4));
meshPoints = [a(:), b(:)]';

% compute the density values for the mesh points
p = studentTMixturePDF(model, meshPoints);

% define the levels of the contour plot in dependence on the maximum
% density value
pMax = max(p);
if settings.minContourValue > pMax
    warning(['The minimum contour value is above the maximum density value.', ...
       ' Choosing backup settings instead.'])
    levels = linspace(pMax*0.1, pMax, 8);
else
    levels = linspace(settings.minContourValue, pMax, 8);
end

% create a contour plot
contour(ax, a, b, reshape(p, size(a)), levels);

% draw color bar
cb = colorbar;
set(get(cb, 'label'), 'string', 'Density Value')
end