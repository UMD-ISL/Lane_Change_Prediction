%% signal_preprocessing.m

%% Description
%  File type:       Procedure
%
%  Summary:
%  This is the first file need to be excute for the whole project.
%  This script converts all .xlsx data into .mat format for further
%  processing

%%
%  Examples: 
%Provide sample usage code here

%%
%  Algorithm:
%df
%dsf

%%
%  See also:
% * ITEM1
% * ITEM2

%%
%  Author:       Yuan Ma
%  Date:         Oct.18.2014
%  Revision:     0.1
%  Partner:      Worked with Tianyu Wang, Yulong Li
%  Copyright:    Intelligent System Laboratory
%               University of Michigan Dearborn

clear all; clc; close all;
ini = IniConfig();
ini.ReadFile('configuration.ini');

home = ini.GetValues('Path Setting', 'HOME_PATH');
Data_Path = ini.GetValues('Path Setting', 'DATA_PATH');

%% Experiment setting
% get num_lane_change by loading 'statistic.mat'
load(strcat(home, '/Synchronized_Dataset/statistics.mat'));
% num_lane_change
num_points_per_event    = 20;
% what is the number of layers here ?
hidden_nodes            = 15;       % hidden node number in each layer
learning_rate           = [0.05];      % MODIFY IT, also can add more learning rate
true_false_ratio        = 1/3;      
feature_filter          = 1:45;     % nine signal * 5 features

event_pool               = [];
no_event_pool             = [];

result                  = cell(1,20);     % why (1, 20) ?
num_features            = length(feature_filter);
index_of_lane_change    = [];
feature_vector          = [];


load(strcat(home, '/Post_normalization_3_Output/Videos_events_feature.mat'));

% the second is the number of signals
for m = 1: num_trips
  eval(strcat('temp = Video_', num2str(m), '_events_feature;'));
  feature_vector = [];
  % for each signal
  for i = 1:size(temp, 2)   % size(temp, 2) == 9
    feature_vector = [feature_vector, temp{2,i}];
  end

  train_temp = feature_vector(:, feature_filter)';
  eval(strcat('Video_', num2str(m), '_train_samples = train_temp;'));
  [~, c]      = size(train_temp);
  num_events  = c / num_points_per_event * true_false_ratio;

  % lane change event
  for j = 1:num_events
      event_pool = [event_pool, {train_temp(:, (((j - 1) * num_points_per_event + 1 )) : (j * num_points_per_event))}];
  end

  % no lane change event
  for j = 1:(num_events * 2)
      no_event_pool = [no_event_pool, {train_temp(:, (((num_events + j - 1) ...
        * num_points_per_event) + 1) : ((num_events + j) * num_points_per_event))}];
  end
end

%% use this mat to do the training
load(strcat(home, '/index_test_10_folder.mat'));
% load IndexLC and IndexNLC

TrainedNN_Output = strcat(home, '/TrainedNN_Output');
mkdir_if_not_exist(TrainedNN_Output);


for k = 1:10
    disp(sprintf('Fold: (%d)', k));
    for mmm = 1:length(hidden_nodes)
        for nnn = 1:length(learning_rate)
            netConfig.hidNodes  = hidden_nodes(mmm);
            netConfig.lr        = learning_rate(nnn);
            netConfig.goal      = 1e-10;
            netConfig.outNodes  = 2;
            netConfig.epochs    = 1000;     % 1000 epochs

            %test version temporary
            index_of_lane_change    = IndexLC(k, :);
            FF                      = 1:num_lane_change;
            Except                  = setdiff(FF, index_of_lane_change);

            index_of_no_lane_change = IndexNLC(k,:);
            NFF                     = 1:(num_lane_change * 2);
            NExcept                 = setdiff(NFF, index_of_no_lane_change);

            testing_input           = [event_pool{:, index_of_lane_change}, no_event_pool{:,index_of_no_lane_change}];
            testing_ground          = [ones(1, round(size(testing_input, 2) * true_false_ratio)), zeros(1, round(size(testing_input, 2) * (1 - true_false_ratio)))];
            training_input          = [event_pool{:, Except}, no_event_pool{:, NExcept}];
            training_ground         = [ones(1, round(size(training_input,2) * true_false_ratio)), zeros(1, round(size(training_input,2) * (1-true_false_ratio)))];

            disp('Start training...'); tic;

            [netTrained, accuracy_train] = train(training_input, training_ground, testing_input, testing_ground, netConfig, k);

            disp('Finish training...'); toc;                                         % class 0 predict as class 1
            disp('Start testing...'  ); tic;

            [ true_positive, false_negative, false_positive, true_negative, accuracy_test ] = test(netTrained, testing_input, testing_ground);

            disp('Finish testing...'); toc;
        end
    end
end





save(strcat(TrainedNN_Output, '/result.mat'), 'accuracy_train', 'accuracy_test', 'true_positive', ...
    'false_negative', 'false_positive', 'true_negative');