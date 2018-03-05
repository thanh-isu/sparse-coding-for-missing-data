function [] = run_simulation()
% 
% Running mode: mode 'trunc', 'arora', 'thres', 'trainlets'

% Load the data (Ar, Ytrain, Xt) and change the parameter accordingly
params.rho = 0.2;
fname = sprintf("data/no_noise_k6_rho%.2f.mat", params.rho);
load(fname);

% load isolated side information (same across rho)
% load data/side_info.mat

params.reg = 0; % reg for noise/noiseless regime
params.complete = 1; % 1 - complete data, 2 - overcomplete

% Run the experiment varying p, 10 values
p = size(Y2, 2);
varied_p = (5:5:30)*1e3; %(5:5:25)
numb_p = size(varied_p, 2);

% Number of trials for each p
num_mcmc = 10;

prob_success = zeros(numb_p, 1);
mean_error = zeros(numb_p, 1);
detailed_error = zeros(numb_p, num_mcmc);
run_time = zeros(numb_p, 1);

% Set parameters for initialization procedure
params.dict_size = size(At);
params.iterations = 3e3; % Number of iterations of the initialization algorithm
% 'trunc', 'thres', 'trainlets' and 'arora' mode normal SC initialization with IHT
params.mode = 'sparfa'; % sparfa vs arora

% Load params
params = params_config(params);

fname = sprintf('output/%s_noiseless_k6_%.2f.mat', params.mode, params.rho);

for i = 1:numb_p
    % Fix number of samples, shuffle the data set and get pi of them
    pi = varied_p(i);
    
    % Storing variables
    success_count = 0;
    error = 0;
    per_trial_time = 0;
    for t = 1:num_mcmc
        % Partition data for the sampling in spectral initialization
        params.Y1 = Y1;
        sample_set = randperm(p, pi);
        params.Gamma = Gamma(:, sample_set);
        params.Y2 = Y2(:, sample_set);
        timer = tic;
        [numb_atom_rec, A0] = spectral_init_algorithm(params);
        
        if numb_atom_rec ~= size(A0, 2)
            continue;
        end

        % Given the initial to the main algorithm
        params.A0 = A0;%At + (1/8)*randn(size(At));
        
        % [~, mA0] = dict_recovery_check(At, A0);
        % init_error = norm(mA0 - At, 'fro');
        
        A = descent_algorithm(params);
        
        % Running time is measure right after learning
        per_trial_time = per_trial_time + toc(timer);
        
        % Check the success
        [match, A] = dict_recovery_check(At, A);
        per_trial_error = norm(A - At, 'fro');
        
        if size(match, 1) == size(At, 1) && per_trial_error < params.reconst_err_thres ...
%                 && numb_atom_rec == size(At, 2)
            success_count = success_count + 1;
        end
        
        % record the results
        error = error + per_trial_error;
        detailed_error(i, t) = per_trial_error;
        
        % figure; imagesc(A);
        if rem(t, 5) == 0
            fprintf('%d th simulation and %d runs: sucess %d \n', i, t, success_count);
        end
    end
    
    % summarize and save the results
    prob_success(i) = success_count/num_mcmc;
    mean_error(i) = error/num_mcmc;
    run_time(i) = per_trial_time/num_mcmc;
    disp(mean_error');
end

save(fname, 'varied_p', 'prob_success', 'mean_error', 'run_time', 'detailed_error');
% txt files with ascii for tikz plots
save(sprintf('output/time_noiseless_%s_k6_rho%.2f.txt', params.mode, params.rho), 'run_time', '-ascii', '-double'); 
save(sprintf('output/psucc_noiseless_%s_k6_rho%.2f.txt', params.mode, params.rho), 'prob_success', '-ascii', '-double');
save(sprintf('output/error_noiseless_%s_k6_rho%.2f.txt', params.mode, params.rho), 'mean_error', '-ascii', '-double');

end

