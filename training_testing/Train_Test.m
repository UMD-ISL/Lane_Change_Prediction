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

true_positive           = 0;
true_negative           = 0;
false_positive          = 0;
false_negative          = 0;

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
    disp(sprintf('Folder: (%d)', k));
    for mmm = 1:length(hidden_nodes)
        for nnn = 1:length(learning_rate)
            netConfig.hidNodes  = hidden_nodes(mmm);
            netConfig.lr        = learning_rate(nnn);
            netConfig.goal      = 1e-10;
            netConfig.outNodes  = 2;
            netConfig.epochs    = 1000;     % 1000 epochs
            
            %test version temporary
            index_of_lane_change  = IndexLC(k, :);
            FF                    = 1:num_lane_change;
            Except                = setdiff(FF, index_of_lane_change);

            index_of_no_lane_change            = IndexNLC(k,:);
            NFF                   = 1:(num_lane_change * 2);
            NExcept               = setdiff(NFF, index_of_no_lane_change);

            testing_input          = [event_pool{:, index_of_lane_change}, no_event_pool{:,index_of_no_lane_change}];
            testing_ground         = [ones(1, round(size(testing_input, 2) * true_false_ratio)), zeros(1, round(size(testing_input, 2) * (1 - true_false_ratio)))];
            training_input         = [event_pool{:, Except}, no_event_pool{:, NExcept}];
            training_ground        = [ones(1, round(size(training_input,2) * true_false_ratio)), zeros(1, round(size(training_input,2) * (1-true_false_ratio)))];

            disp('Start training...'); tic;
            %% training NN
            speed_nn = NNBuilder2(training_input, training_ground, testing_input, testing_ground, netConfig);
            [netTrained, tr] = speed_nn.trainNN(speed_nn.net);
            
            save(strcat(TrainedNN_Output, '/trainedNN',num2str(k),'.mat'), 'netTrained');
            trainingOutput = sim(netTrained, training_input);
			
            flag_size      = size(trainingOutput);
            flag_length    = flag_size(1, 2);
            OutputflagTr   = [];
            % if training output is over 0.5 regard as class 1, otherwise regard as class 0
            for i_tr = 1:flag_length                                                                                       
              if(trainingOutput(1,i_tr) >= 0.5)
				        OutputflagTr(i_tr) = 1;
				      else
				        OutputflagTr(i_tr) = 0;
				      end
				    end

            trainingErrorAll  = (OutputflagTr - training_ground);
            trainingError     = trainingErrorAll(abs(trainingErrorAll) > 0.1);            % error which is class 1 predict as class 0
			     disp('Finish training...'); toc;                                         % class 0 predict as class 1
         
            %% testing NN
            disp('Start testing...'); tic;
            testingOutput     = sim(netTrained, testing_input);
            flag_size         = size(testingOutput);
            flag_length       = flag_size(1,2);
            i_ts              = 1; 
            OutputflagTs      = [];
            for i_ts          = 1:flag_length                     % if training output is over 0.5 regard as class 1
			                                                      % if training output is less than 0.5 regard as class 0
            if(testingOutput(1,i_ts) >= 0.5)
				      OutputflagTs(i_ts) = 1;
		        else
				      OutputflagTs(i_ts) = 0;
				    end
				  end

          testingErrorAll   = (OutputflagTs - testing_ground);
          testingError      = testingErrorAll(abs(testingErrorAll) > 0.1);
          disp('Finish testing...'); toc;
        end
    end

    figure1=figure;
    plot(OutputflagTs,'.');
    hold on;
    plot(testing_ground,'r');
    title('testing Result');
    % figure(2);plot(OutputflagTr,'.');hold on;plot(trainingTarget(1,:),'r');title('training Result');
    % figure(3);plot(testingOutput(1,:));hold on;plot(testingOutput(2,:),'r');title('testing output');
    % figure(4);plot(trainingOutput(1,:));hold on;plot(trainingOutput(2,:),'r');title('training output');
    accuracy_train = 1 - size(trainingError,2) / size(trainingErrorAll, 2)
    accuracy_test  = 1 - size(testingError,2) / size(testingErrorAll, 2)
    % plotroc(testing_ground,OutputflagTs);
    % [auc,~]=roc_auc(OutputflagTs,testing_ground,1,0);
    % auc
    NumberLCTest    = size(index_of_lane_change, 2);
    Result          = zeros(2 * NumberLCTest, 2 * NumberLCTest);
    Result(1:2,1)   = [accuracy_train; accuracy_test];
    Result(1:3,2)   = index_of_lane_change';
    Result(:,3)     = index_of_no_lane_change';
    result{1,k}     = Result;
    % saveas(figure1,strcat(Outroot_origin,'Figure\','test_',num2str(k)),'fig');
    % close(figure1);
    %% plot confusion matrix
    Total_length    = size(OutputflagTs,2);
    one_third       = OutputflagTs(1, 1:Total_length * true_false_ratio);
    two_third       = OutputflagTs(1, (Total_length * true_false_ratio + 1):end);
    true_positive   = true_positive + size(find(1 == one_third), 2);
    false_negative  = true_negative + size(find(0 == one_third), 2);
    false_positive  = false_positive + size(find(1 == two_third), 2);
    true_negative   = false_negative + size(find(0 == two_third), 2);
end

save(strcat(TrainedNN_Output, '/result.mat'),'result','true_positive', ...
    'false_negative', 'false_positive', 'true_negative');