function [Y1, Y2] = gen_incomp_samples(rho)
%GENERATE_INCOMPLETE Summary of this function goes here
%   Detailed explanation goes here

load data/no_noise_k6.mat

[n, p] = size(Yt);
% Save p1 fully observed samples for initialization
p1 = 10e3; %floor(0.1*p);
P1 = randperm(p, p1);
Y1 = Yt(:, P1);

% Partition P2 contains samples sub-sampled with probability rho
P2 = 1:p;
P2(P1) = [];

p2 = length(P2);
Y2 = Yt(:, randperm(p, p2));

unf_rands = rand(n, p2); % simulate coin tossing with uniform dsn
Gamma = (unf_rands < rho);
Y2(~Gamma) = 0;

% save the data to disk
str = sprintf('data/no_noise_k6_rho%.2f.mat', rho);
save(str, 'Y1', 'Y2', 'At', 'Gamma');
    
end

