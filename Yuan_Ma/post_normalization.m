%% Post_normalization

%% Description
%%
%  File type:    Executable file
%
%  Summary:
%
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
root_path = 'N:\tianyu\code1\';
outroot_origin = 'N:\tianyu\code1\';
Total_Lane_Change = 31;     % Changable if having new data
Number_LC_Test=3;         % Changable

%%
% Architecture of neual network
hidden_nodes = 15;
learning_rates = 0.05;
Num_Signal_Selected = 7;
Num_Trips = 5;
methods_fre={'welch'};          %% ?
%# WhichSignal=1;

%%
% allocate memeories to be used
feature=[];
target=[];
feature_Filter = 1:45;  % 9 signals * 5 features
all_Features={};        % cell
step_Size=1;            % move one point every window shift
num_total_Features = 5;

video1 = {}; video2 = {}; video3 = {}; video4 = {}; video5 = {};

time_before_LC = 20;      % time before lane change: 20 points
lane_change_size = 20;    % lange change size is 20 points
num_points_on_event = 20; % changable

skip = 1;                 % IMPORTANT FLAG, changable

middle = [];
window_size_cal = 20;           %
window_size_ECG_raw = 256*2;    % window size of feature extracting for ECG raw data
window_size_BELT_raw = 26*2;    % window size of feature extracting for BELT raw data
num_of_Features = 5;

%% Granger Causality Analysis

%%






