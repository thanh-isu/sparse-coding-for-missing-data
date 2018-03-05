function [A] = descent_algorithm(params)
%NEURAL_SPARSE_CODING Summary of this function goes here
%   Detailed explanation goes here


A0 = params.A0;
[~, m] = size(A0);

% Number of samples, using incomplete samples only
Y = params.Y2;
p = size(Y, 2);

% Dictionary and sparse code
A = A0;
% X = zeros(m, p);

% Sparsity parameters
k = params.k;

% Number of iterations
T = 50;
% Maximum coefficients
C = 1;

% Alternating algorithm with learning rate
eta = m/k; % at leat Omega(k/k)
bias_adj = 1;

if ~strcmp(params.mode, 'arora')
    bias_adj = 1/params.rho;
    eta = eta/params.rho;
    % T = round(T/params.rho);
end

for i = 1:T
    % Simple thresholding encoding rule
    X = A'*Y;
    % 03/04: adjustment or no bias adjustment after thresholding work
    % better. try keep k largest to see what happens
    % X = bias_adj * X .* (abs(X) >= C/2); 
    X = bias_adj * par_hard_threshold(X, k);
    
    % Noisy gradient
    Y_hat = A*X;
    if strcmp(params.mode, 'arora')
        residual = Y - Y_hat;
    else
        residual = Y - Y_hat .* params.Gamma;
    end
    % residual = Y - Y_hat .* (Y ~= 0);
    % norm(residual, 'fro');
    
    % Update the dictionary with noisy gradient
    g = 1/p*residual*sign(X)';
    A = A + eta*g;
    A = normc(A);
end

end