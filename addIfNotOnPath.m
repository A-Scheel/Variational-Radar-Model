%ADDIFNOTONPATH Adds folder to path if it is not already on it
%
%   ADDIFNOTONPATH(folder) adds folder to the MATLAB path if it is not
%   already on the path
%
%   Author: Alexander Scheel (copied from thread on mathworks.com)

function addIfNotOnPath(folder)

% check if the folder is already on the path
pathCell = regexp(path, pathsep, 'split');
if ispc
    onPath = any(strcmpi(folder, pathCell));
else
    onPath = any(strcmp(folder, pathCell));
end

% add it if it is not on the path
if ~onPath
    addpath(folder);
end

end