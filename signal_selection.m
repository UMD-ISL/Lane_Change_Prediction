function signal_selection(, num_trips, lane_change_labels)
ini = IniConfig();
ini.ReadFile('configuration.ini');

%Data_directory = '../Lane_Change_original_data/';
Output_Path = ini.GetValues('Signal Selection', 'OUTPUT_PATH');
home = ini.GetValues('Path Setting', 'HOME_PATH');

time_axis = data_All_cal(:,1)

for m = 1:num_trips
    mkdir(Output_Path, strcat('figure_', num2str(m)))   % make a folder to store generated images of each vedio
    load(stract(home, '/Synchronized_Dataset/Vedio_', num2str(m), '_Synchronized_Data.mat');
    
    selected_signal = [];
    selected_text = [];
    
    %% denoise the spikes and choose the signal we want (with interpolate method)
    for j = 1:(lane_change_labels - 1)      % read the text of each signal and do switch case job
        signal_text = cell2mat(Text_Index(j+1,1));  % only use the following 'case' signals, use cell2mat function to translate 'cell' to 'mat'
        
        switch signal_text
            case 'HR'
                data = data_All_cal(:, j+1);    % extract the j+1 column data, the first column is time
                selected_signal_text(:, 1) = 'HR';
                figure_1 = draw_graph(time_axis, selected_signal_text)
        end
    end
