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
%  Date:         Nov.11.2014
%  Revision:     0.1
%  Partner:      Worked with Yulong Li
%  Copyright:    Intelligent System Laboratory
%                University of Michigan Dearborn

%% Initialization
clear all; clc; close all;
ini = IniConfig();
ini.ReadFile('configuration.ini');

home = ini.GetValues('Path Setting', 'HOME_PATH');

% extract the varible 'num_lane_change', 'num_selected_signal', 'num_trips'
load(strcat(home, '/Synchronized_DataSet/statistics.mat'));
% get the number of signal selected
% get the lane change number

Post_normalization_Ouput = strcat(home, '/Post_normalization_Ouput');
mkdir_if_not_exist(Post_normalization_Ouput);

methods_fre     ={'welch'};         % ?      
feature_all     =[];                % malloc feature array
target          =[];                % malloc target array

%% feature calculation configuration
window_size_Ten_Hz_signals      = 10;
% window size for ECG raw data is 256 because the sampling rate is 256 Hz
window_size_ECG_raw             = 256;
% window size for BELT raw data is 26 because the sampling rate is 26 Hz
window_size_BELT_raw            = 26;
step_size                       = 1;

FLAG_Redo_Feature_Generation   = false; % the falg to see if need redo feature geneartion procedure

%% Retrive the number of Lane Change
tic;
for m = 1:num_trips
    disp(sprintf('Trip: (%d)', m));
    if true == FLAG_Redo_Feature_Generation
        break
    end
    
    %% PHASE: feature generation
    window_segment_cal  = {};   % use cell to store the cal_data in a window size
    window_segment_ECG  = {};	% use cell to store the ECG_data in a window size
    window_segment_BELT = {};	% use cell to store the BELT_data in a window size
    
    feature_pool    = {};       % feature_pool: Array type, store the calculated feature data
    feature         = [];
    feature_vector  = [];
    load(strcat(home, '/Synchronized_Dataset/Video_',num2str(m),'_Synchronized_Data.mat'));
    
    % Adding Windows
    num_Video_points    = size(Ten_Hz_signals_data, 1);
    % save value 1 point before the last point in the window
    cal_before          = Ten_Hz_signals_data(window_size_Ten_Hz_signals - 1,:);
    ECG_before          = ECG_data(window_size_ECG_raw - 1, :);
    BELT_before         = BELT_data(window_size_BELT_raw - 1, :);
    
    % store calculate before data? 10 Hz signal
    % calculate the feature generated from the 10Hz selected feature
    disp('Ten Hz Feature');
    for k = 2:(num_selected_signal + 1)
        disp('signal');
        % start from second column beacuse the first is 'time'
        % for each signal calculate the feature generated from five
        % different statistic attributes (origin, mean, max, min, and first
        % order difference
        for j = 1:step_size:(num_Video_points - (window_size_Ten_Hz_signals-1))                               
            window_index    = j:(j+(window_size_Ten_Hz_signals-1));
            signal_data     = Ten_Hz_signals_data(window_index, k);
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
        % each cell shows the all data from Videos of this signal
        % (column: time, origin data, max, min, mean, difference ...)
        feature_pool{k-1,1} = [Ten_Hz_signals_data((1 + window_size_Ten_Hz_signals - 1:end),1), feature_vector];
    end
    
    % execute 'Video_m_L_cal = size(feature_vector,1);' ?
    eval(strcat('Video_', num2str(m), '_Ten_Hz_signals_length', '=size(feature_vector,1);'));   
    save(strcat(Post_normalization_Ouput, '/', 'Video_',num2str(m), '_Ten_Hz_signals_feature.mat'), ...
        'feature_pool', strcat('Video_',num2str(m), '_Ten_Hz_signals_length'), 'cal_before');    

    %% Deal with ECG Raw data 256 Hz
    % this part needs a lot of computation need speed up, by modifying
    % step_size
    feature_vector  = [];
    feature_pool    = [];
    feature         = [];
    num_Video_points = size(ECG_data,1);
    
    disp('ECG 256 Hz Feature');
    for j = 1:step_size:( num_Video_points - (window_size_ECG_raw - 1) )
        window_index        = j:( j + (window_size_ECG_raw - 1) );
        signal              = ECG_data(window_index, 2);
        feature(1,1)        = signal(end, 1);   % the last point of window as one feature
        feature(1,2)        = max(signal);
        feature(1,3)        = min(signal);
        feature(1,4)        = mean(signal);
        % the fifth feature is added later
        feature_vector(j,:) = feature; 
    end
    
    feature_pool = [ECG_data((window_size_ECG_raw:end),1), feature_vector];
    eval(strcat('Video_',num2str(m), '_ECG_length', '=size(feature_vector,1);'));
    save(strcat(Post_normalization_Ouput, '/Video_',num2str(m),'_ECG_feature.mat'),...
        'feature_pool', strcat('Video_',num2str(m), '_ECG_length'), 'ECG_before');
    
    %% Deal with BELT raw data 26 Hz
    feature_vector   = [];
    feature_pool     = [];
    feature          = [];
    num_Video_points=size(BELT_data, 1);
    
    disp('BELT 26 Hz Feature');
    for j = 1:step_size:(num_Video_points - (window_size_BELT_raw-1))                               
        window_index        = j:( j + (window_size_BELT_raw - 1) );
        signal              = BELT_data(window_index, 2);
        feature(1,1)        = signal(end,1);
        feature(1,2)        = max(signal);
        feature(1,3)        = min(signal);
        feature(1,4)        = mean(signal);
        % the fifth feature is added later
        feature_vector(j,:) = feature; 
    end
   
   feature_pool = [BELT_data( (window_size_BELT_raw:end), 1), feature_vector];
   eval(strcat('Video_', num2str(m), '_BELT_length', '=size(feature_vector,1);'));
   save(strcat(Post_normalization_Ouput, '/Video_', num2str(m), '_BELT_feature', '.mat'), ...
       'feature_pool', strcat('Video_', num2str(m), '_BELT_length'), 'BELT_before');
end
toc;