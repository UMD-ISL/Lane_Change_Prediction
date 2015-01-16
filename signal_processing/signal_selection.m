%% Signal_Selection.m

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

function [num_selected_signal] = signal_selection(num_trips, num_data_columns)
%% Configuration and Initilization
ini = IniConfig();
ini.ReadFile('self_configuration.ini');

Driver_name = 'Dev';

Output_Path = strcat(ini.GetValues('Global Path Setting', 'OUTPUT_PATH'), ...
    '/', ini.GetValues(strcat(Driver_name, ' Dataset Path'), 'DATA_PATH'));

Figure_Output_Path = strcat(Output_Path, '/', ini.GetValues('Signal Selection', 'FIGURE_OUTPUT_PATH'));

for m = 1:num_trips
    load(strcat(Output_Path, '/Synchronized_Dataset/Video_', num2str(m), '_Synchronized_Data.mat'));
    folder_name = strcat(Figure_Output_Path, '/Video_', num2str(m));
    mkdir_if_not_exist(folder_name);
    
    time = Ten_Hz_signals_data(:,1);       % first column store the labeled time information
    target = Ten_Hz_signals_data(:, end);       % last column store the labeled target information
    selected_signal = [];
    selected_text = {};
    
    % denoise the spikes and choose the signal we want (with interpolate method)
    for j = 1:(num_data_columns - 1)      % read the text of each signal and do switch case job, ignore the last column (target)
        signal_type = cell2mat(Text_Index(j+1, 1));  % only use the following 'case' signals, use cell2mat function to translate 'cell' to 'mat'
        if ( strcmp(signal_type, 'Ti/Te') || strcmp(signal_type, 'Ti/Tt') )
            continue;
        end
        
        switch signal_type
            case 'HR'
                signal_data = Ten_Hz_signals_data(:, j+1);    % extract the j+1 column data, the first column is time
                selected_signal (:,1) = signal_data;
                selected_text{1,1} = signal_type;
                figure_handle = draw_graph(time, signal_type, signal_data, target, m);
                saveas(figure_handle, strcat(Figure_Output_Path, '/Video_', num2str(m), '/', signal_type, '_signal_plot'), 'fig');
                close(figure_handle);
                continue;
            case 'Te'
                signal_data = Ten_Hz_signals_data(:, j+1);    % extract the j+1 column data, the first column is time
                selected_signal (:,2) = signal_data;
                selected_text{2,1} = signal_type;
                figure_handle = draw_graph(time, signal_type, signal_data, target, m);
                saveas(figure_handle, strcat(Figure_Output_Path, '/Video_', num2str(m), '/', signal_type, '_signal_plot'), 'fig');
                close(figure_handle);
                continue;
            case 'Ti'
                signal_data = Ten_Hz_signals_data(:, j+1);    % extract the j+1 column data, the first column is time
                selected_signal (:,3) = signal_data;
                selected_text{2,1} = signal_type;
                figure_handle = draw_graph(time, signal_type, signal_data, target, m);
                saveas(figure_handle, strcat(Figure_Output_Path, '/Video_', num2str(m), '/', signal_type, '_signal_plot'), 'fig');
                close(figure_handle);
                continue;
            case 'Exp Vol'
                signal_data = Ten_Hz_signals_data(:, j+1);    % extract the j+1 column data, the first column is time
                selected_signal (:,4) = signal_data;
                selected_text{2,1} = signal_type;
                figure_handle = draw_graph(time, signal_type, signal_data, target, m);
                saveas(figure_handle, strcat(Figure_Output_Path, '/Video_', num2str(m), '/', signal_type, '_signal_plot'), 'fig');
                close(figure_handle);
                continue;
            case 'Insp Vol'
                signal_data = Ten_Hz_signals_data(:, j+1);    % extract the j+1 column data, the first column is time
                selected_signal (:,5) = signal_data;
                selected_text{2,1} = signal_type;
                figure_handle = draw_graph(time, signal_type, signal_data, target, m);
                saveas(figure_handle, strcat(Figure_Output_Path, '/Video_', num2str(m), '/', signal_type, '_signal_plot'), 'fig');
                close(figure_handle);
                continue;
            case 'qDEEL'
                signal_data = Ten_Hz_signals_data(:, j+1);    % extract the j+1 column data, the first column is time
                selected_signal (:,6) = signal_data;
                selected_text{2,1} = signal_type;
                figure_handle = draw_graph(time, signal_type, signal_data, target, m);
                saveas(figure_handle, strcat(Figure_Output_Path, '/Video_', num2str(m), '/', signal_type, '_signal_plot'), 'fig');
                close(figure_handle);
                continue;
            case 'GSR RAW'
                signal_data = Ten_Hz_signals_data(:, j+1);    % extract the j+1 column data, the first column is time
                selected_signal (:,7) = signal_data;
                selected_text{2,1} = signal_type;
                figure_handle = draw_graph(time, signal_type, signal_data, target, m);
                saveas(figure_handle, strcat(Figure_Output_Path, '/Video_', num2str(m), '/', signal_type, '_signal_plot'), 'fig');
                close(figure_handle);
                continue;
        end
    end
    [~, num_selected_signal] = size(selected_signal);
    selected_signal = [time, selected_signal, target];
    selected_text = [selected_text; {'Lane Change'}];
    Ten_Hz_signals_data = selected_signal;
    Text_Index = selected_text;
    mkdir_if_not_exist(strcat(Output_Path, './Singal_Selection_Output'));
    save(strcat(Output_Path, './Singal_Selection_Output/', 'Video_',num2str(m),'_Synchronized_Selected_Signal_Data.mat'), ...
        'Text_Index', 'Ten_Hz_signals_data', 'ECG_data', 'BELT_data');
end
