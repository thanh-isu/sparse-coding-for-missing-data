function generate_samples()
% Generate a reference sparse dictionary A of size mxp, and n sparse codes.
% Model: y = Ax + e
% y of size m, A: mxp and x: p
% Generate n such y's

n = 256; m = 256;
k = 6; % code sparsity

% Generate dictionary
if exist('data/dict.mat', 'file')
    load data/dict.mat
else
    At = generate_dictionary(n, m);
    coherence = incoherent(At);
    disp(['The dictionary has coherence is ' num2str(coherence)])
    save 'data/dict.mat' At
end

% load Experiments/aaai/sim1/A.mat
% Ar = A;

% Given A, we generate data by the model: y = A*x + e
p = 1e5;

Yt = zeros(n, p);
% noise data are created by adding up noise to Y
Y2 = zeros(n, p);
Xt = zeros(m, p);

std_noise = 0.1; % ~1/sqrt(n)
rng('default')
for i = 1:p
    % Draw uniformly the support of signal
%     rng(20171120 + i);
    support = randperm(m, k);
    % Generate sparse code
    x = zeros(m, 1); x(support) = randsample([-1; 1], k, true); %randn(k, 1);
    y = At*full(x);
    Xt(:, i) = x; Yt(:, i) = y;
    
    % Additive noise, 
    e = std_noise * randn(n, 1);
    Y2(:, i) = y + e;
end

save('data/no_noise_k6.mat', 'Yt', 'Xt', 'At');

% Yt = Y2;
% save('data/2_noise.mat', 'Ytrain', 'Xt', 'Ar');

clear Y2 Yt Xt;
end