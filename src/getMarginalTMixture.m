%GETMARGINALTMIXTURE   Get marginal Student's t mixture
%
%   marg = GETMARGINALTMIXTURE(model, margIdcs) outputs the marginal
%   density marg from the joint density model. The vector margIdcs 
%   specifies which entries are part of the marginal density.
%
%   Example
%       load(['model', filesep, 'variationalRadarModel.mat']);
%       marg = getMarginalTMixture(jointPredictiveDensity, [2 3])
%
%   This example loads the radar model and computes the marginal
%   distribution over the dimensions 2 and 3, i.e. the x- and y-coordinates
%   of the measurements.
%
%   Author: Alexander Scheel

function marg = getMarginalTMixture(model, margIdcs)

% get the number of components in the mixture
nComponents = numel(model.rho);

% get the dimension of the marginal density
dimMarg = numel(margIdcs);

% the mixture coefficients and degrees of freedom stay the same
marg.rho = model.rho;
marg.nu = model.nu;

% reduce the mean vectors
marg.gamma = model.gamma(margIdcs,:);

% initialize precision matrices
marg.Htilde = zeros(dimMarg, dimMarg, nComponents);

% iterate over precision matrices and compute marginal preceision matrices
for i = 1:nComponents
    % make the precision matrices a covariance matrix
    sigma = inv(model.Htilde(:,:,i));
    
    % select the necessary components
    sigmaPart = sigma(margIdcs,margIdcs);
    
    % make it a precision matrix again
    marg.Htilde(:,:,i) = inv(sigmaPart);
end

end