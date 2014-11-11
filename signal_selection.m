function [num_selected_signal] = signal_selection(num_trips, num_data_columns)
ini = IniConfig();
ini.ReadFile('configuration.ini');

Output_Path = ini.GetValues('Signal Selection', 'OUTPUT_PATH');
home = ini.GetValues('Path Setting', 'HOME_PATH');

for m = 1:num_trips
    load(strcat(home, '/Synchronized_Dataset/Video_', num2str(m), '_Synchronized_Data.mat'));
    folder_name = strcat(Output_Path, '/Video_', num2str(m));
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
                saveas(figure_handle, strcat(Output_Path, '/Video_', num2str(m), '/', signal_type, '_signal_plot'), 'fig');
                close(figure_handle);
                continue;
            case 'Te'
                signal_data = Ten_Hz_signals_data(:, j+1);    % extract the j+1 column data, the first column is time
                selected_signal (:,2) = signal_data;
                selected_text{2,1} = signal_type;
                figure_handle = draw_graph(time, signal_type, signal_data, target, m);
                saveas(figure_handle, strcat(Output_Path, '/Video_', num2str(m), '/', signal_type, '_signal_plot'), 'fig');
                close(figure_handle);
                continue;
            case 'Ti'
                signal_data = Ten_Hz_signals_data(:, j+1);    % extract the j+1 column data, the first column is time
                selected_signal (:,3) = signal_data;
                selected_text{2,1} = signal_type;
                figure_handle = draw_graph(time, signal_type, signal_data, target, m);
                saveas(figure_handle, strcat(Output_Path, '/Video_', num2str(m), '/', signal_type, '_signal_plot'), 'fig');
                close(figure_handle);
                continue;
            case 'Exp Vol'
                signal_data = Ten_Hz_signals_data(:, j+1);    % extract the j+1 column data, the first column is time
                selected_signal (:,4) = signal_data;
                selected_text{2,1} = signal_type;
                figure_handle = draw_graph(time, signal_type, signal_data, target, m);
                saveas(figure_handle, strcat(Output_Path, '/Video_', num2str(m), '/', signal_type, '_signal_plot'), 'fig');
                close(figure_handle);
                continue;
            case 'Insp Vol'
                signal_data = Ten_Hz_signals_data(:, j+1);    % extract the j+1 column data, the first column is time
                selected_signal (:,5) = signal_data;
                selected_text{2,1} = signal_type;
                figure_handle = draw_graph(time, signal_type, signal_data, target, m);
                saveas(figure_handle, strcat(Output_Path, '/Video_', num2str(m), '/', signal_type, '_signal_plot'), 'fig');
                close(figure_handle);
                continue;
            case 'qDEEL'
                signal_data = Ten_Hz_signals_data(:, j+1);    % extract the j+1 column data, the first column is time
                selected_signal (:,6) = signal_data;
                selected_text{2,1} = signal_type;
                figure_handle = draw_graph(time, signal_type, signal_data, target, m);
                saveas(figure_handle, strcat(Output_Path, '/Video_', num2str(m), '/', signal_type, '_signal_plot'), 'fig');
                close(figure_handle);
                continue;
            case 'GSR RAW'
                signal_data = Ten_Hz_signals_data(:, j+1);    % extract the j+1 column data, the first column is time
                selected_signal (:,7) = signal_data;
                selected_text{2,1} = signal_type;
                figure_handle = draw_graph(time, signal_type, signal_data, target, m);
                saveas(figure_handle, strcat(Output_Path, '/Video_', num2str(m), '/', signal_type, '_signal_plot'), 'fig');
                close(figure_handle);
                continue;
        end
    end
    [~, num_selected_signal] = size(selected_signal);
    selected_signal = [time, selected_signal, target];
    selected_text = [selected_text; {'Lane Change'}];
    Ten_Hz_signals_data = selected_signal;
    Text_Index = selected_text;
    mkdir_if_not_exist(strcat(home, './Singal_Selection_Output'));
    save(strcat(home, './Singal_Selection_Output/', 'Video_',num2str(m),'_Synchronized_Selected_Signal_Data.mat'), ...
        'Text_Index', 'Ten_Hz_signals_data', 'ECG_data', 'BELT_data');
end
