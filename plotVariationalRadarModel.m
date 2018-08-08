%PLOTVARIATIONALRADARMODEL Script for plotting the variational radar model
%
%   PLOTVARIATIONALRADARMODEL plots the variational model in six different
%   perspectives. It generates the marginal density over the location of
%   measurements, four densities that are conditioned on different aspect
%   angles, and a conditional density that shows the Doppler errors.
%
%   Author: Alexander Scheel

clear all;
close all;

% add the source folder to the MATLAB path
[currPath, ~, ~] = fileparts(mfilename('fullpath'));
addIfNotOnPath([currPath, filesep, 'src']);

%% load the variational radar model
% Loading the variational radar model creates the variable
% jointPredicitveDensity which contains the predictive Student's t mixture
% for the joint density of transformed measurements and aspect angle.
%
% The mixture is stored as a struct with the following fields
% jointPredictiveDensity.roh - mixing coefficients
% jointPredictiveDensity.gamma - 4x50 matrix where the i-th column contains
%                                the mean vector of the i-th Student's t
%                                density
% jointPredictiveDensity.nu - vector of degrees of freedom for each
%                             component
% jointPredictiveDensity.Htilde - 4x4x50 matrix where the i-th slice
%                                 contains the precision matrix of the i-th
%                                 component
%
% The density is four-dimensional with the order
% 1: x' - x-coordinate of the measurement in normalized object coordinates
% 2: z'_x - x-coordinate of the measurement in normalized object coordinates
% 3: z'_y - y-coordinate of the measurement in normalized object coordinates
% 4: z'_d - Doppler error
disp('Loading the model ...')
load(['model', filesep, 'variationalRadarModel.mat'])

%% plot of the marginal density p(z'_x, z'_y)
disp('Plotting marginal density p(z''_x, z''_y) ...')

% get the marginal density for indices 2 and 3 (z'_x and z'_y)
margDensity = getMarginalTMixture(jointPredictiveDensity, [2, 3]);

% figure settings
figSettings = [];
figSettings.title = 'Marginal Density p(z''_x, z''_y)';
figSettings.axis = [-0.5, 1 -1, 1];
figSettings.daspect = [1/5, 1/2, 1];
% create a contour plot
plot2DStudentTMixture(margDensity, figSettings);

%% plot conditioanl densities p(z'_x, z'_y | x')
disp('Plotting conditional densities p(z''_x, z''_y | x'') ...')

% get the marginal density p(z'_x, z'_y, x') first (i.e. marginalize over
% Doppler)
margWoDoppler = getMarginalTMixture(jointPredictiveDensity, [1, 2, 3]);

% get and plot the conditional density for x' = -3;
condDensity = getConditionalTMixture(margWoDoppler, 1, -3);
figSettings = [];
figSettings.title = 'Conditional Density p(z''_x, z''_y | x'' = -3)';
figSettings.axis = [-0.5, 1 -1, 1];
figSettings.daspect = [1/5, 1/2, 1];
figSettings.minContourValue = 0.4;
plot2DStudentTMixture(condDensity, figSettings);

% get and plot the conditional density for x' = -pi/2;
condDensity = getConditionalTMixture(margWoDoppler, 1, -pi/2);
figSettings = [];
figSettings.title = 'Conditional Density p(z''_x, z''_y | x'' = -\pi/2)';
figSettings.axis = [-0.5, 1 -1, 1];
figSettings.daspect = [1/5, 1/2, 1];
figSettings.minContourValue = 0.4;
plot2DStudentTMixture(condDensity, figSettings);

% get and plot the conditional density for x' = -pi/2;
condDensity = getConditionalTMixture(margWoDoppler, 1, -pi/4);
figSettings = [];
figSettings.title = 'Conditional Density p(z''_x, z''_y | x'' = -\pi/4)';
figSettings.axis = [-0.5, 1 -1, 1];
figSettings.daspect = [1/5, 1/2, 1];
figSettings.minContourValue = 0.4;
plot2DStudentTMixture(condDensity, figSettings);

% get and plot the conditional density for x' = -pi/2;
condDensity = getConditionalTMixture(margWoDoppler, 1, 0);
figSettings = [];
figSettings.title = 'Conditional Density p(z''_x, z''_y | x'' = 0)';
figSettings.axis = [-0.5, 1 -1, 1];
figSettings.daspect = [1/5, 1/2, 1];
figSettings.minContourValue = 0.4;
plot2DStudentTMixture(condDensity, figSettings);

%% plot conditioanl densities p(z'_x, z'_d | z'_y = -0.5, x' = -\pi/2)
disp('Plotting conditional density p(z''_x, z''_d | z''_y = -0.5, x'' = -\pi/2) ...')

condDensity = getConditionalTMixture(jointPredictiveDensity, [1, 3], [-pi/2, -0.5]);
figSettings = [];
figSettings.title = 'Conditional Density p(z''_x, z''_d | z''_y = -0.5, x'' = \pi/2)';
figSettings.axis = [-0.5, 1 -1.5, 1.5];
figSettings.daspect = [1/5, 1/2, 1];
plot2DStudentTMixture(condDensity, figSettings);