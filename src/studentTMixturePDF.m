%STUDENTTMIXTUREPDF   Computes the pdf values for given samples and a
%                     student's t mixture model
%   
%   p = STUDENTTMIXTUREPDF(model, data) outputs pdf values for the
%   Student's t mixture that is defined in model. The points for which the
%   density values are computed are given in data as a matrix. The matrix
%   dimensions are 'Dimension of the model' x 'Number of data points'.
%
%   [p, pComp] = STUDENTTMIXTUREPDF(model, data) additionally outputs the
%   density value of each component individually in pComp.
%
% Author: Alexander Scheel

function [p, pComp] = studentTMixturePDF(model, data)

% get dimension of data and get the number of data points
[D, nData] = size(data);

% get number of components
nComp = numel(model.rho);

% pre-compute the determinants
if D > 1
    d = zeros(1,1,nComp);
    for i = 1:nComp
        d(i) = det(model.Htilde(:,:,i));
    end
else
    d = model.Htilde;
end

% get the nus
nu = permute(model.nu, [1,3,2]);

% compute the gamma factor
gammaFactor = exp(gammaln(nu/2 + D/2) - gammaln(nu/2));

% compute the determinant factor
detFactor = sqrt(d) ./ (nu * pi).^(D/2);

% compute the delta
mu = permute(model.gamma, [1,3,2]);
delta = bsxfun(@minus, data, mu);
HtildeTimesDelta = zeros(D,nData,nComp);
for i = 1:D
    HtildeTimesDelta(i,:,:) =  sum(bsxfun(@times, permute(model.Htilde(i,:,:), [2, 1, 3]), delta),1);
end
delta2 = sum(delta .* HtildeTimesDelta,1);

% compute the delta factor
deltaFactor = bsxfun(@power, (1 + bsxfun(@rdivide, delta2, nu)), (-nu/2-D/2));

% get the mixing coefficients
mix = permute(model.rho, [1,3,2]);

% get the overall pdf value
pComp = bsxfun(@times, gammaFactor .* detFactor, deltaFactor);
p = sum(bsxfun(@times, pComp, mix),3);

end