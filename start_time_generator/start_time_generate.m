%% Initialization and Configuration
clear all; clc;     % Clear environment, and start counting running time

%%
ini = IniConfig();
ini.ReadFile('configuration.ini');
Driver_name = 'Dev';

home = ini.GetValues('Global Path Setting', 'HOME_PATH');

Data_Path = strcat(ini.GetValues('Global Path Setting', 'DATA_PATH'), ...
    '/', ini.GetValues(strcat(Driver_name, ' Dataset Path'), 'DATA_PATH'));

Output_Path = strcat(ini.GetValues('Global Path Setting', 'OUTPUT_PATH'), ...
    '/', ini.GetValues(strcat(Driver_name, ' Dataset Path'), 'DATA_PATH'));

mkdir_if_not_exist(Output_Path);

%%
fd_list = dir(Data_Path);
num_folder = 0;                 % variable that count number of folders

tic;                            % PROGRAM EFFICIENCY ESTIMATE
for i = 1:size(fd_list,1)
    stuct = fd_list(i,1);
    if (stuct.isdir == 1)
        num_folder = num_folder + 1;
    end
end
num_folder = num_folder - 2;    % ignore './' and '../'

enumeration Signals;

signal_number = 7;
Start_time_reference = cell(signal_number, num_folder);

%% read original signal data file and get signal start time
parfor m = 1:num_folder
   % 1: Signals.GSR
    GSR_filepath = strcat(Data_Path, '/', num2str(m),'/GSR.csv');
    GSR_start_Time = GSR_StartTime_Generator(GSR_filepath);
    disp('Get GSR signal time reference');   
    
    % 2: Signals.ECG
    ECG_filepath = strcat(Data_Path, '/', num2str(m),'/ECG.csv');
    ECG_start_Time = ECG_StartTime_Generator(ECG_filepath);
    disp('Get ECG signal time reference');
    
    % 3: Signals.RSP
    RSP_filepath = strcat(Data_Path, '/', num2str(m),'/RSP.csv');
    RSP_start_Time = RSP_StartTime_Generator(RSP_filepath);
    disp('Get RSP signal time reference');
    
    % 4: Signals.OBD
    OBD_filepath = strcat(Data_Path, '/', num2str(m),'/OBD.csv');
    OBD_start_Time = OBD_StartTime_Generator(OBD_filepath);
    disp('Get OBD signal time reference');
    
    % 5: Signals.ECG_RAW
    ECG_RAW_filepath = strcat(Data_Path, '/', num2str(m),'/ECGraw.csv');
    ECG_RAW_start_Time = ECG_RAW_StartTime_Generator(ECG_RAW_filepath);
    disp('Get ECG_RAW signal time reference');
    
    % 6: Signals.GSR_RAW      
    GSR_RAW_filepath = strcat(Data_Path, '/', num2str(m),'/GSR_RAW.xlsx');
    GSR_RAW_start_Time = GSR_RAW_StartTime_Generator(GSR_RAW_filepath);
    disp('Get GSR_RAW signal time reference');
    
    % 7: Signals.BELT_RAW
    BELT_RAW_filepath = strcat(Data_Path, '/', num2str(m),'/RSPraw.csv');
    try
        BELT_RAW_start_Time = BELT_RAW_StartTime_Generator(BELT_RAW_filepath);
        disp('Get BELT_RAW signal time reference');
    catch
        BELT_RAW_start_Time = RSP_start_Time;
        continue;
    end
    
    % 1: Signals.GSR    2: Signals.ECG      3: Signals.RSP
    % 4: Signals.OBD    5: Signals.ECG_RAW  6: Signals.GSR_RAW
    % 7: Signals.BELT_RAW
    Start_time_reference(:, m) = {GSR_start_Time; ECG_start_Time; ...
                            RSP_start_Time; OBD_start_Time; ...
                            ECG_RAW_start_Time; GSR_RAW_start_Time; ...
                            BELT_RAW_start_Time
                        };
end         % end of program

save(strcat(Output_Path, '/Start_time_reference.mat'), 'Start_time_reference');
