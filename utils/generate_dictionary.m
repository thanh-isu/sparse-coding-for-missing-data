function [A] = generate_dictionary(n, m)
%GEN_TREE_BASED_DICTIONARY Generate random, overcomplete (demoractic) dictionary
% 
% INPUT: - dictionary size (n, m)
%        - sparsity r
% OUPUT: A - dictionary

% D - dictionary to be generated
A = zeros(n, m);
for j = 1 : m
    % Generate Rademacher/Gaussian distribution
    % d = randsample([-1, 1], n, true);
    d = randn(n, 1);
    A(:, j) = d;
end
A = normc(A);

end

