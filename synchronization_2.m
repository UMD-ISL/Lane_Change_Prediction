%% Synchronization_2.m

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


%% Initialization and Configuration
clc; clear all;
% warning off;
vedio_signals = dir('./synchronization_1_Output/*_Before_Denoised_Data.mat');      % list all the .mat files

% Combine signals from different vedios together
for m = 1:size(vedio_signals, 1)
    signal_file = strcat('./synchronization_1_Output/Vedio_' ,num2str(m), '_Before_Denoised_Data.mat');
    load(signal_file);  % load data in each signal file
    
    diff_Ecg_HR         = diff(Ecg_Data(:, 2));     % second column of Ecg_Data is 'HR' data
    diff_Ecg_RR         = diff(Ecg_Data(:, 3));     % third collumn of Ecg_Data is 'RR' data
    diff_Ecg_Raw         = diff(ECG_RAW_Data(:, 2)); %
    Ecg_Data_HR_New     = Ecg_Data(:, 1:2);         % new HR signal?
    Ecg_Data_RR_New     = Ecg_Data(:, [1, 3]);
    ECG_RAW_Data_New    = ECG_RAW_Data;
    
    % HR
    i = 1;
    while i < numel(diff_Ecg_HR)    % numel function return the number of elements in an array
        if ( diff_Ecg_HR(i) > 30 ...
            || diff_Ecg_HR(i) < -30 ...
            || Ecg_Data_HR_New(i + 1, 2) > 120 ...
            || Ecg_Data_HR_New(i + 1, 2) < 50) 
            % then do following
            Ecg_Data_HR_New(i + 1, :) = NaN;    
            if sign(diff_Ecg_HR(i)) ~= sign(diff_Ecg_HR(i + 1)) % if signal is not the same symbol
                if ( ( sign(diff_Ecg_HR(i + 1)) == -1 ) ...
                        && ( Ecg_Data_HR_New(i + 2, 2) < 50 ) ...
                    || ( sign(diff_Ecg_HR(i + 1)) == 1 ) ...
                        && ( Ecg_Data_HR_New(i + 2, 2) > 120 ) )
                    % do nothing here
                else
                    i = i + 1;
                end
            end 
        end
        i = i + 1;
    end
    
    % RR
    i = 1;
    while i < numel(diff_Ecg_RR)
        if ( diff_Ecg_RR(i) > 0.3 ...
            || diff_Ecg_RR(i) < -0.3 ...
            || Ecg_Data_RR_New(i + 1, 2) > 1 ...
            || Ecg_Data_RR_New(i + 1, 2) < 0.5)
            % then do following
            Ecg_Data_RR_New(i + 1, :) = NaN;
            if sign(diff_Ecg_RR(i)) ~= sign(diff_Ecg_RR(i + 1))
                if ( ( sign(diff_Ecg_RR(i + 1)) == -1) ...
                        && ( Ecg_Data_RR_New(i + 2, 2) < 50 ) ...
                    || ( sign(diff_Ecg_RR(i + 1)) == 1 ) ...
                        && ( Ecg_Data_RR_New(i + 2, 2) > 120 ) )
                    % do nothing here
                else
                    i = i + 1;
                end
            end
        end
        i = i + 1;
    end
    
    % ECG_RAW
    i = 1;
    while i < numel(diff_Ecg_Raw)
        if ( diff_Ecg_Raw(i) > 50 ...
            || diff_Ecg_Raw(i) < -150 ...
            || ECG_RAW_Data_New(i + 1, 2) > 12000 ...
            || ECG_RAW_Data_New(i + 1, 2) < -50)
            % then do following
            ECG_RAW_Data_New(i + 1, :) = NaN;
            if sign(diff_Ecg_Raw(i)) ~= sign(diff_Ecg_Raw(i + 1))
                i = i + 1;
            end  
        end
        i = i + 1;
    end
    
    save(strcat('./synchronization_2_Output/Vedio_', num2str(m), '_After_Denoised_Data.mat'),'Ecg_Data_HR_New', 'diff_Ecg_HR', 'Ecg_Data_RR_New', 'diff_Ecg_RR');
end

%%
clc; clear all;
NumLC=0;
Signal=dir('Before_denoise/*.mat');
for m=1:size(Signal,1)
load(strcat('Before_denoise/Before_denoise',num2str(m),'.mat'));
       
end