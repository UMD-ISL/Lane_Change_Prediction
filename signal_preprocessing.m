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

clc; clear all; close all;

Video_signals = dir('./synchronization_1_Output/*_Before_Denoised_Data.mat');      % list all the .mat files
[num_trips, ~] = size(Video_signals);        % find how many trips here
load('./Synchronized_Dataset/Video_1_Synchronized_Data.mat');
[~, num_data_columns] = size(Ten_Hz_signals_data);

% modify some information of previous generated synchronized data
for i=1:num_trips
    load(strcat('./Synchronized_Dataset/Video_', num2str(i), '_Synchronized_Data.mat'));
    Text_Index{20,:} = 'GSR RAW';        % rename 'GSR (...)' into GSR RAW ???
    save(strcat('./Synchronized_Dataset/Video_', num2str(i), '_Synchronized_Data.mat'), 'Text_Index', 'Ten_Hz_signals_data', 'ECG_data', 'BELT_data');
end

load('Synchronized_DataSet/statistics.mat');
[num_selected_signal] = signal_selection(num_trips, num_data_columns);
save('Synchronized_DataSet/statistics.mat','num_selected_signal','num_lane_change','num_trips');