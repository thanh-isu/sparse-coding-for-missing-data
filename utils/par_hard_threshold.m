function [parX] = par_hard_threshold(X, k)
%PA_HARD_THRESHOLD Summary of this function goes here
%   Detailed explanation goes here

% Parallel version of hard_threshold function to speed up the algorithm
W = 256;
divX = partition_matrix(X, W);

parfor i = 1:length(divX)
    parX{i} = hard_threshold(divX{i}, k);
end

parX = cell2mat(parX);

end

function [divY] = partition_matrix(Y, W)
% W - number of devided work
N = size(Y, 2);

% Load per workers
L = floor(N/W); % each load should be 128 or 256 columns

for i = 1:W
    divY{i} = Y(:, 1+(i-1)*L : i*L);
end

if W*L < N
    divY{W+1} = Y(:, 1+W*L : N);
    divY{W+1} = Y(:, 1+W*L : N);
end
end
