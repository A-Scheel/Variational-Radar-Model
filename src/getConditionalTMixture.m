%GETCONDITIONALTMIXTURE Get conditional Student's t mixture
%
%   cond = GETCONDITIONALTMIXTURE(model, condIdcs, condVals) computes the
%   Student's t mixture density that results from conditioning the
%   Student's t mixture density model on part of the random variable. The
%   indices of the vector components that we condition on are specified in
%   condIdcs and their values in condVals.
%
%   The procedure is derived from the equations for a conditional Student's
%   t distribution in [1] and extending them to a mixture density through
%            p(x, z)   \sum_i( w_i * p_i(x,z) )   
%   p(x|z) = ------- = ------------------------ = 
%              p(z)    \sum_j( w_j *  p_j(z) )
%
%                          w_i * p_i(z)
%          = \sum_i( ----------------------- * p_i(x|z) )
%                    \sum_j( w_j *  p_j(z) )
%
%   [1] Roth, M.: "On the Multivariate t Distribution". Linköpinbg, Sweden,
%       2013
%
%   Example
%       load(['model', filesep, 'variationalRadarModel.mat']);
%       cond = getConditionalTMixture(jointPredictiveDensity, ...
%                [1, 3], [-pi/2, -0.5])
%
%   The example computes the conditional density, when conditioning on an
%   aspect angle of -pi/2 and a y-position of -0.5.
%
%   Author: Alexander Scheel

function cond = getConditionalTMixture(model, condIdcs, condVals)

%% preliminary checks and conversions
% get the number of components
nComponents = numel(model.rho);

% bring condIdcs in the correct format
if ismatrix(condIdcs) || ~any(size(condIdcs) == 1)
    if size(condIdcs,1) < size(condIdcs,2)
        condIdcs = condIdcs';        
    end
else
    error('The condIdcs vector needs to be a column or row vector!')
end

% bring condIdcs in the correct format
if ismatrix(condVals) || ~any(size(condVals) == 1)
    if size(condVals,1) < size(condVals,2)
        condVals = condVals';        
    end
else
    error('The condIdcs vector needs to be a column or row vector!')
end

% get the dimension of the joint density
dimJoint = size(model.gamma,1);

%% rearrange the density
% The density is rearranged such that the values that the mixture is
% conditioned on are at the end. Thus, the euqations of [1] are applicable.

% find the remaining indices 
remainingIdcs = find(~any(bsxfun(@eq, 1:dimJoint, condIdcs),1));

% get the number of remaining indices (there must be at least one remaining
% index)
nRemaining = numel(remainingIdcs);
if isempty(remainingIdcs)
    error('There must be at least one remaining variable for computing the conditional density!');
end

% construct a sort vector that puts the remaining indices first
sortVec = [remainingIdcs'; condIdcs];

% rearrange dimensions
newGamma = model.gamma(sortVec,:);
newHTilde = model.Htilde(sortVec,sortVec,:);

%% compute the parameters of the conditional density
% compute the difference between the conditioned value and the mean
delta = bsxfun(@minus, condVals, newGamma(nRemaining+1:end,:));

% compute the mean vectors and precision matrices of the conditional
% density following [1]
condGamma = zeros(nRemaining,nComponents);
condHTilde = zeros(nRemaining,nRemaining,nComponents);
for i = 1:nComponents
    % convert the precision matrices to covariance matrices
    newSigma = inv(newHTilde(:,:,i));
    
    % split the covariance matrix
    sigma11 = newSigma(1:nRemaining,1:nRemaining);
    sigma12 = newSigma(1:nRemaining,nRemaining+1:end);
    sigma22 = newSigma(nRemaining+1:end,nRemaining+1:end);
    
    % compute the new mean vector
    condGamma(:,i) = newGamma(1:nRemaining,i) + sigma12 * (sigma22 \ delta(:,i));
    
    % compute the new covariance matrix
    condSigma = (model.nu(i) + delta(:,i)' * (sigma22 \ delta(:,i))) / ...
                (model.nu(i) + dimJoint - nRemaining) * ...
                (sigma11 - sigma12 * (sigma22 \ sigma12'));
    condHTilde(:,:,i) = inv(condSigma);
end

% get the marginal density of the value that is conditioned on and evaluate
% it
margDensity = getMarginalTMixture(model, condIdcs);
[p, pComp] = studentTMixturePDF(margDensity, condVals);
pComp = permute(pComp, [1, 3, 2]);

% assemble the conditional density and compute the new weights
cond.rho = model.rho .* pComp / p;
cond.gamma = condGamma;
cond.Htilde = condHTilde;
cond.nu = model.nu + dimJoint - nRemaining;

end

