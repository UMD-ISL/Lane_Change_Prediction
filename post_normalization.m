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
clear all; clc;
%# warning off;

%% define variables
root_path = './tempdata/';
outroot_origin = './tempdata/';
Total_Lane_Change = 31;     % Changable if having new data
Number_LC_Test=3;         % Changable

%%
% Architecture of neual network
hidden_nodes = 15;
learning_rates = 0.05;
Num_Signal_Selected = 7;
num_Trips = 5;                  % 5 trips in total (Kunqiao's data)
methods_fre={'welch'};          % ?
%# WhichSignal=1;

%%
% allocate memeories to be used
feature = [];
target  = [];
feature_Filter = 1:45;    % 9 signals * 5 features
all_Features = {};        % cell
step_Size = 1;            % move one point every window shift
num_total_Features = 5;

video1 = {}; video2 = {}; video3 = {}; video4 = {}; video5 = {};

time_before_LC      = 20; % time before lane change: 20 points
lane_change_size    = 20; % lange change size is 20 points
num_points_on_event = 20; % changable

skip = 1;                 % IMPORTANT FLAG, changable

middle = [];                    % ?
window_size_cal      = 20;      %
window_size_ECG_raw  = 256*2;   % window size of feature extracting for ECG raw data
window_size_BELT_raw = 26*2;    % window size of feature extracting for BELT raw data
num_of_Features      = 5;

%% Granger Causality Analysis

%%
for i = 1: num_Trips
    if (skip == 1)          % Don't want to regenerate train and test data
        break
    end
    disp(i)                 % DEBUG MESSAGE
    
    window_segment_cal   = {};
    window_segment_ECG   = {};
    window_segment_BELT  = {};
    
    %% calculate features of 10 Hz features
    Feature             = {};
    feature             = [];
    feature_vector_1    = [];
    
    % load 'synDataAll_trip_number.mat' data
    load(strcat(root_path,'synDataAll_',num2str(i),'.mat'));
    
    % Adding windows
    vedio_Length = size(dataAll_cal,1);     % number of data point in a video?
    
    % save value 1 point before
    cal_before = data_All_cal(window_size_cal-1,:);
    ECG_before = data_All_ECG(window_size_ECG_raw-1,:);
    BELT_before = dataAll_BELT(window_size_BELT_raw-1,:);
    
    % for every selected signal
    for k = 2:(Num_Signal_Selected + 1)
        % for data in every shifted window
        for j = 1:step_size:(vedio_Length-(window_size_cal-1))                               
            windowIndex = [j:(j+(window_size_cal-1))];
            Signal = dataAll_cal(windowIndex,k);
            feature(1,1) = Signal(end,1);
            feature(1,2) = max(Signal);
            feature(1,3) = min(Signal);
            feature(1,4) = mean(Signal);
            feature(1,5) = Signal(end,1)-Signal(end-1,1); % first order defference
            % feature vector combine 5 features above
            feature_vector_1(j,:) = feature;
        end
        Feature{k-1,1} = [data_All_cal((window_size_cal:end),1),feature_vector_1];
    end
    
    eval(strcat('L_cal',num2str(i),'=size(featvec1,1);'));
    save(strcat(root_path,'feature_cal_',num2str(i),'.mat'),'Feature', ...
        strcat('L_cal',num2str(i)),'cal_before');
   
   %% calculate ECG feature 256Hz
   feature_vector_1 = [];
   Feature          = [];
   feature          = [];
   LengthVideo = size(dataAll_ECG,1);
   
   for j = 1:stepsize:(LengthVideo-(window_size_ECG_raw-1))                               
       windowIndex = j:(j+(window_size_ECG_raw-1));
   
        Signal = data_All_ECG(windowIndex,2);
        feature(1,1) = Signal(end,1);
        feature(1,2) = max(Signal);
        feature(1,3) = min(Signal);
        feature(1,4) = mean(Signal);
        feature_vector_1(j,:)=feature; 
   end
   
   Feature = [dataAll_ECG((window_size_ECG_raw:end),1),feature_vector_1];
   eval(strcat('L_ECG',num2str(i),'=size(featvec1,1);'));
   save(strcat(rootIn,'feature_ECG_',num2str(i),'.mat'),'Feature', ...
       strcat('L_ECG',num2str(i)),'ECG_before');
   
   %% calculate BELT 25.6Hz
   feature_vector_1 = [];
   Feature          = [];
   feature          = [];
   LengthVideo = size(dataAll_BELT,1);
   
   for j = 1:stepsize:(LengthVideo-(window_size_BELT_raw-1))                               
       windowIndex = [j:(j+(window_size_BELT_raw-1))];
       Signal = dataAll_BELT(windowIndex,2);
       feature(1,1) = Signal(end,1);
       feature(1,2) = max(Signal);
       feature(1,3) = min(Signal);
       feature(1,4) = mean(Signal);
       feature_vector_1(j,:) = feature; 
   end
   
   Feature = [dataAll_BELT((window_size_BELT_raw:end),1),feature_vector_1];
   eval(strcat('L_BELT',num2str(i),'=size(featvec1,1);'));
   save(strcat(rootIn,'feature_BELT_',num2str(i),'.mat'),'Feature',strcat('L_BELT',num2str(i)),'BELT_before');
   
end
