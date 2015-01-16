%% Synchronization_2.m

%% Description
%  File type:       Procedure
%
%  Summary:
%  This is the second file need to be excute for the whole project.
%  This script converts all .xlsx data into .mat format for further
%  processing

%%
%  Examples: 
%Provide sample usage code here

%%
%  Algorithm:
%  There is no algorithm implementation in this file.

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


%% Initialization and Configuration
clc; clear all;
ini = IniConfig();
ini.ReadFile('configuration.ini');

Data_Path = ini.GetValues('Dev Dataset Path', 'DATA_PATH');
home = ini.GetValues('Dev Dataset Path', 'HOME_PATH');

% make the folder where to save the output data
synchronization_1_Output = strcat(home, '/synchronization_1_Output');
Video_signals = dir(strcat(synchronization_1_Output, '/*_Before_Denoised_Data.mat'));      % list all the .mat files

synchronization_2_Output = strcat(home, '/synchronization_2_Output');
    mkdir_if_not_exist(synchronization_2_Output);
    
%% Combine signals from different Videos together
for m = 1:size(Video_signals, 1)
    signal_file = strcat(synchronization_1_Output, '/Video_' ,num2str(m), '_Before_Denoised_Data.mat');
    load(signal_file);  % load data in each signal file
    
    % help diff: diff Difference and approximate derivative.
    diff_Ecg_HR         = diff(Ecg_Data(:, 2));     % first version of HR data.
                                                    % second column of Ecg_Data is 'HR' data, only use the difference value
    diff_Ecg_RR         = diff(Ecg_Data(:, 3));     % fisrt version of RR data.
                                                    % third collumn of Ecg_Data is 'RR' data, only use th difference value
    diff_Ecg_Raw        = diff(ECG_RAW_Data(:, 2)); % first version of ECG raw data, only use the difference value
    Ecg_Data_HR_New     = Ecg_Data(:, 1:2);         % second version of HR data. Use original data.
    Ecg_Data_RR_New     = Ecg_Data(:, [1, 3]);      % second version of RR data. Use original data.
    ECG_RAW_Data_New    = ECG_RAW_Data;             % second version of ECG raw data. Use original data.
    
    % deal with HR signal
    i = 1;
    % helnumel function return the number of elements in an array
    while i < numel(diff_Ecg_HR)    
        if ( diff_Ecg_HR(i) > 30 ...                % if the diffrence is huge out of boundary of [-30, 30]
            || diff_Ecg_HR(i) < -30 ...
            || Ecg_Data_HR_New(i + 1, 2) > 120 ...  % or the value of next data is out of the boundary of [50, 120]
            || Ecg_Data_HR_New(i + 1, 2) < 50) 
            % then do following
            % if the data meet one of condition above, make this dat to
            % NaN, means this can't be used.
            Ecg_Data_HR_New(i + 1, :) = NaN;    
            if sign(diff_Ecg_HR(i)) ~= sign(diff_Ecg_HR(i + 1)) % if signal is not the same symbol
                if ( ( -1 == sign(diff_Ecg_HR(i + 1)) ) ...
                        && ( Ecg_Data_HR_New(i + 2, 2) < 50 ) ...
                    || ( 1 == sign(diff_Ecg_HR(i + 1)) ) ...
                        && ( Ecg_Data_HR_New(i + 2, 2) > 120 ) )
                    % do nothing here
                else
                    % skip the next data point
                    i = i + 1;
                end
            end 
        end
        i = i + 1;
    end
    
    % deal with RR signal
    i = 1;
    while i < numel(diff_Ecg_RR)
        if ( diff_Ecg_RR(i) > 0.3 ...               % if the diffrence is huge out of boundary [-0.3, 0.3]
            || diff_Ecg_RR(i) < -0.3 ...
            || Ecg_Data_RR_New(i + 1, 2) > 1 ...    % or the value of next data is out of the boundary of [0.5, 1]
            || Ecg_Data_RR_New(i + 1, 2) < 0.5)
            % then do following
            % if the data meet one of condition above, make this dat to
            % NaN, means this can't be used.
            Ecg_Data_RR_New(i + 1, :) = NaN;
            if sign(diff_Ecg_RR(i)) ~= sign(diff_Ecg_RR(i + 1))
                if ( ( sign(diff_Ecg_RR(i + 1)) == -1) ...
                        && ( Ecg_Data_RR_New(i + 2, 2) < 50 ) ...
                    || ( sign(diff_Ecg_RR(i + 1)) == 1 ) ...
                        && ( Ecg_Data_RR_New(i + 2, 2) > 120 ) )
                    % do nothing here
                else
                    % skip the next data point
                    i = i + 1;
                end
            end
        end
        i = i + 1;
    end
    
    % deal with ECG_RAW data
    i = 1;
    while i < numel(diff_Ecg_Raw)
        if ( diff_Ecg_Raw(i) > 50 ...                   % if the diffrence is huge out of boundary [-150, 50]
            || diff_Ecg_Raw(i) < -150 ...
            || ECG_RAW_Data_New(i + 1, 2) > 12000 ...   % or the value of next data is out of the boundary of [-50, 12000]
            || ECG_RAW_Data_New(i + 1, 2) < -50)
            % then do following
            % if the data meet one of condition above, make this dat to
            % NaN, means this can't be used.
            ECG_RAW_Data_New(i + 1, :) = NaN;
            if sign(diff_Ecg_Raw(i)) ~= sign(diff_Ecg_Raw(i + 1))   % if the signal symbol of two data points are different.
                % skip the next data point
                i = i + 1;
            end  
        end
        i = i + 1;
    end
    
    % save the processed data
    save(strcat(synchronization_2_Output, '/Video_', num2str(m), '_After_Denoised_Data.mat'),'Ecg_Data_HR_New', 'diff_Ecg_HR', 'Ecg_Data_RR_New', 'diff_Ecg_RR');
end