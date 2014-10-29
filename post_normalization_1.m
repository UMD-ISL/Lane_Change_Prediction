%% Post_normalization

%% Description
%%
%  File type:    Executable file

%%
%  Summary:
%  5 Features:
%
% * raw data 
% * max value
% * min value
% * mean value
% * first order difference

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
%  Date:         Oct.17.2014
%  Revision:     0.1
%  Partner:      Worked with Tianyu Wang, Yulong Li
%  Copyright:    Intelligent System Laboratory
%                University of Michigan Dearborn

%% Initialization
clear all; clc; close all;
ini = IniConfig();
ini.ReadFile('configuration.ini');

home = ini.GetValues('Path Setting', 'HOME_PATH');
Data_Path = ini.GetValues('Path Setting', 'DATA_PATH');
% extract the varible 'num_lane_change', 'num_selected_signal', 'num_trips'
load(strcat(home, '/Synchronized_DataSet/statistics.mat'));

Post_normalization_Ouput = strcat(home, '/Post_normalization_Ouput');
mkdir_if_not_exist(Post_normalization_Ouput);

methods_fre     ={'welch'};         % ?      
feature_all     =[];                % malloc feature array
target          =[];                % malloc target array

feature_filter      = 1:45;      % total 45 features (9 signals * 5 attributes)
Invalid_feature     = [];
feature_filter      = setdiff(feature_filter,Invalid_feature);
feature_All         = {};
% video1={}; video2={}; video3={}; video4={}; video5={};
middle=[];  %?

%% Architecture and parameters of neural network (NN)
test_size               = 3;
hidden_nodes            = 15;
learning_rate           = 0.05;
step_size               = 1;
num_signal_attributes   = 5;

%% data descprition
time_before_lane_change = 20;
lane_change_size        = 20;
num_points_per_event    = 20;

%% feature calcuation configuration
window_size_cal         = 20;
window_size_ECG_raw     = 256 * 2;      % window size for ECG raw data is 256 because the sampling rate is 256 Hz
window_size_BELT_raw    = 26 * 2;       % window size for BELT raw data is 26 because the sampling rate is 26 Hz

FLAG_Redo_Feature_Generation   = false; % the falg to see if need redo feature geneartion procedure
%% Retrive the number of Lane Change

tic;
for m = 1:num_trips
    if true == FLAG_Redo_Feature_Generation
        break
    end
    
    %% PHASE: feature generation
    window_segment_cal  = {};            % use cell to store the cal_data in a window size
    window_segment_ECG  = {};            % use cell to store the ECG_data in a window size
    window_segment_BELT = {};            % use cell to store the BELT_data in a window size
    
    feature_pool    = {};
    feature         = [];
    feature_vector  = [];
    load(strcat(home, '/Synchronized_Dataset/Vedio_',num2str(m),'_Synchronized_Data.mat'));
    
    % Adding Windows
    num_video_points    = size(data_All_cal,1);
    cal_before          = data_All_cal(window_size_cal - 1,:);     % save value 1 point before the last point in the window
    ECG_before          = data_All_ECG(window_size_ECG_raw - 1,:);
    BELT_before         = data_All_BELT(window_size_BELT_raw - 1,:);
    
    % store calculate before data? 10 Hz signal
    calculate the feature generated from the 10Hz selected feature
    for k = 2:(num_selected_signal + 1)
        % start from second column beacuse the first is 'time'
        % for each signal calculate the feature generated from five
        % different statistic attributes (origin, mean, max, min, and first
        % order difference
        for j = 1:step_size:(num_video_points - (window_size_cal-1))                               
            window_index    = j:(j+(window_size_cal-1));
            signal_data     = data_All_cal(window_index, k);
            % first feature is the last data
            feature(1, 1)   = signal_data(end,1);
            % second feature is the max data value among the window size
            feature(1, 2)   = max(signal_data);
            % third feature is the min data value among the window size
            feature(1, 3)   = min(signal_data);
            % forth feature is the mean data value among the window size
            feature(1, 4)   = mean(signal_data);
            % fifth feature is the differnce value between the last and one
            % point before the last point
            feature(1, 5)   = signal_data(end,1) - signal_data(end-1,1);    
            feature_vector(j, :)    = feature;    
        end
        % the row of feature_pool shows how many signals
        % each cell shows the all data from vedios of this signal
        % (column: time, origin data, max, min, mean, difference ...)
        feature_pool{k-1,1} = [data_All_cal((window_size_cal:end),1), feature_vector];
    end
    
    eval(strcat('Vedio_',num2str(m), '_L_cal', '=size(feature_vector,1);'));    % execute 'Vedio_m_L_cal = size(feature_vector,1);' ?
    save(strcat(Post_normalization_Ouput, '/', 'Vedio_',num2str(m), '_L_cal_feature.mat'), ...
        'feature_pool', strcat('Vedio_',num2str(m), '_L_cal'), 'cal_before');    

    %% Deal with ECG Raw data 256 Hz
    % this part needs a lot of computation need speed up, by modifying
    % step_size
    feature_vector  = [];
    feature_pool    = [];
    feature         = [];
    num_video_points = size(data_All_ECG,1);
    
    for j = 1:step_size:( num_video_points - (window_size_ECG_raw - 1) )                               
        window_index        = j:( j + (window_size_ECG_raw - 1) );
        signal              = data_All_ECG(window_index, 2);
        feature(1,1)        = signal(end,1);
        feature(1,2)        = max(signal);
        feature(1,3)        = min(signal);
        feature(1,4)        = mean(signal);
        feature_vector(j,:) = feature; 
    end
    
    feature_pool = [data_All_ECG((window_size_ECG_raw:end),1), feature_vector];
    eval(strcat('Vedio_',num2str(m), '_L_ECG', '=size(feature_vector,1);'));
    save(strcat(Post_normalization_Ouput, '/Vedio_',num2str(m),'_ECG_feature.mat'),...
        'feature_pool', strcat('Vedio_',num2str(m), '_L_ECG'), 'ECG_before');
    
    %% Deal with BELT raw data 26 Hz
    feature_vector   = [];
    feature_pool     = [];
    feature          = [];
    num_video_points=size(data_All_BELT,1);
    
    for j = 1:step_size:(num_video_points - (window_size_BELT_raw-1))                               
        window_index        = j:( j + (window_size_BELT_raw - 1) );
        signal              = data_All_BELT(window_index, 2);
        feature(1,1)        = signal(end,1);
        feature(1,2)        = max(signal);
        feature(1,3)        = min(signal);
        feature(1,4)        = mean(signal);
        feature_vector(j,:) = feature; 
    end
   
   Feature = [data_All_BELT( (window_size_BELT_raw:end), 1), feature_vector];
   eval(strcat('Vedio_', num2str(m), '_L_BELT', '=size(feature_vector,1);'));
   save(strcat(Post_normalization_Ouput, '/Vedio_', num2str(m), '_BELT_feature', '.mat'), ...
       'feature_pool', strcat('Vedio_', num2str(m), '_L_BELT'), 'BELT_before');
end
toc;