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
%                University of Michigan Dearborn

clc; clear all; close all;

ini = IniConfig();
ini.ReadFile('self_configuration.ini');

Driver_name = 'Dev';

Data_Path = strcat(ini.GetValues('Global Path Setting', 'DATA_PATH'), ...
    '/', ini.GetValues(strcat(Driver_name, ' Dataset Path'), 'DATA_PATH'));

Output_Path = strcat(ini.GetValues('Global Path Setting', 'OUTPUT_PATH'), ...
    '/', ini.GetValues(strcat(Driver_name, ' Dataset Path'), 'DATA_PATH'));

Video_signals = dir(strcat(Output_Path, '/synchronization_1_Output/*_Before_Denoised_Data.mat'));      % list all the .mat files
[num_trips, ~] = size(Video_signals);        % find how many trips here

load(strcat(Output_Path,'/Synchronized_Dataset/Video_1_Synchronized_Data.mat'));
[~, num_data_columns] = size(Ten_Hz_signals_data);

% modify some information of previous generated synchronized data
for i=1:num_trips
    load(strcat(Output_Path, '/Synchronized_Dataset/Video_', num2str(i), '_Synchronized_Data.mat'));
    Text_Index{20,:} = 'GSR RAW';        % rename 'GSR (...)' into GSR RAW ???
    save(strcat(Output_Path, '/Synchronized_Dataset/Video_', num2str(i), '_Synchronized_Data.mat'), 'Text_Index', 'Ten_Hz_signals_data', 'ECG_data', 'BELT_data');
end

%%
load(strcat(Output_Path, '/Synchronized_DataSet/statistics.mat'));
[num_selected_signal] = signal_selection(num_trips, num_data_columns);
save(strcat(Output_Path, '/Synchronized_DataSet/statistics.mat'),'num_selected_signal','num_lane_change','num_trips');