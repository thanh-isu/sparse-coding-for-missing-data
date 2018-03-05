function [] = display_results(mode)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if mode == 1
    sparfa = load('output/sparfa_noiseless_k6_1.00.mat');
    arora = load('output/sparfa_noiseless_k6_0.80.mat');
    sparfa2 = load('output/sparfa_noiseless_k6_0.60.mat');
    sparfa3 = load('output/sparfa_noiseless_k6_0.40.mat');
    varied_p = sparfa.varied_p;
else
    sparfa = load('Experiments/aaai/output/thres_noise.mat');
    trunc_dsc = load('Experiments/aaai/output/trunc_noise.mat');
    % Trainlets initalize with 0
    trainlet_dsc = load('Experiments/aaai/output/trainlets_noise_rd.mat');
    % Trainlets initialized with I
    trainlet_dscI = load('Experiments/aaai/output/trainlets_noise_rd.mat');
    arora = load('Experiments/aaai/output/arora_noise.mat');
    varied_p = sparfa.varied_p;
end


% Probability of success
prob_sparfa = sparfa.prob_success;
prob_arora = arora.prob_success;
prob_sparfa2 = sparfa2.prob_success;
prob_sparfa3 = sparfa3.prob_success;
title = 'Probability of success';
result = [varied_p', prob_sparfa, prob_arora, prob_sparfa2, prob_sparfa3];
save('output/prob_success_sparfa_k6.txt', 'result', '-ascii', '-double')
% plot_curve(varied_p, prob_trunc, prob_sparfa, prob_arora, prob_trlets1, prob_trlets2, title);

% Error

error_sparfa = sparfa.mean_error;
error_arora = arora.mean_error;
error_sparfa2 = sparfa2.mean_error;
error_sparfa3 = sparfa3.mean_error;
title = 'Avg. eror over 100 runs';
result = [varied_p', error_sparfa, error_arora, error_sparfa2, error_sparfa3];
save('output/error_sparfa_k6.txt', 'result', '-ascii', '-double')
% plot_curve(varied_p, error_sparfa, error_thres, error_arora, error_trlets1, error_trlets2, title);

% Probability of success
time_sparfa = sparfa.run_time;
time_arora = arora.run_time;
time_sparfa2 = sparfa2.run_time;
title = 'Avg. running time over 100 runs';
result = [varied_p', time_sparfa, time_arora, time_sparfa2];
save('output/run_time_sparfa_k6.txt', 'result', '-ascii', '-double')
% plot_curve(varied_p, time_sparfa, time_thres, time_arora, time_trlets1, time_trlets2, title);


end

function plot_curve(xAxis, methodA, methodB, methodC, methodD, methodE, title)
figure; plot(xAxis, methodA, '--rs', 'MarkerSize', 10);
hold on;
plot(xAxis, methodB, '--bd', 'MarkerSize', 10);
plot(xAxis, methodC, '--kv', 'MarkerSize', 10);
plot(xAxis, methodD, '--g^', 'MarkerSize', 10);
%plot(xAxis, methodE, '--go', 'MarkerSize', 10);

xlabel('Number of samples', 'FontSize', 12)
ylabel(title, 'FontSize', 12)
set(gca, 'FontSize', 15)
grid on; grid minor;
legend( 'Ours', 'Arora+HT', 'Arora', 'Trainlets1', 'Location', 'Best')

end