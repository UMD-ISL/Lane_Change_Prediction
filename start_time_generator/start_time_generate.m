%% Initialization and Configuration
clear all; clc;     % Clear environment, and start counting running time
%%
[Data_Path, Output_Path] = loadGlobalPathSetting();
mkdir_if_not_exist(Output_Path);

%%
num_folder = getFolderNumber(Data_Path);
signal_number = 7;
Start_time_reference = cell(signal_number, num_folder);

%% read original signal data file and get signal start time
tic;
for m = 1:num_folder
        % 1: Signals.GSR
        GSR_filepath = strcat(Data_Path, '/', num2str(m),'/GSR.csv');
        GSR_start_Time = GSR_StartTime_Generator(GSR_filepath); 

        % 2: Signals.ECG
        ECG_filepath = strcat(Data_Path, '/', num2str(m),'/ECG.csv');
        ECG_start_Time = ECG_StartTime_Generator(ECG_filepath);

        % 3: Signals.RSP
        RSP_filepath = strcat(Data_Path, '/', num2str(m),'/RSP.csv');
        RSP_start_Time = RSP_StartTime_Generator(RSP_filepath);

        % 4: Signals.GSR_RAW
        GSR_RAW_filepath = strcat(Data_Path, '/', num2str(m),'/GSR_RAW.csv');
        GSR_RAW_start_Time = GSR_RAW_StartTime_Generator(GSR_RAW_filepath);
        GSR_RAW_start_Time = datenum(GSR_RAW_start_Time, 'HH:MM:SS.FFF');
        GSR_RAW_start_Time = addtodate(GSR_RAW_start_Time, 4, 'hour');
        GSR_RAW_start_Time = datestr(GSR_RAW_start_Time, 'HH:MM:SS.FFF');
        
        % 5: Signals.ECG_RAW
        ECG_RAW_filepath = strcat(Data_Path, '/', num2str(m),'/ECGraw.csv');
        ECG_RAW_start_Time = ECG_RAW_StartTime_Generator(ECG_RAW_filepath);
        
        % 6: Signals.BELT_RAW
        BELT_RAW_filepath = strcat(Data_Path, '/', num2str(m),'/RSPraw.csv');
        BELT_RAW_start_Time = BELT_RAW_StartTime_Generator(BELT_RAW_filepath);
        
        % 7: Signals.OBD
        OBD_filepath = strcat(Data_Path, '/', num2str(m),'/OBD.csv');
        OBD_start_Time = OBD_StartTime_Generator(OBD_filepath);

        
        % 1: Signals.GSR        2: Signals.ECG      3: Signals.RSP
        % 4: Signals.GSR_RAW    5: Signals.ECG_RAW  6: Signals.BELT_RAW
        % 7: Signals.OBD
        Start_time_reference(:, m) = {GSR_start_Time; ECG_start_Time; ...
                                 RSP_start_Time; GSR_RAW_start_Time; ...
                                 ECG_RAW_start_Time; BELT_RAW_start_Time; ...
                                 OBD_start_Time;
                            };
                        
        save(strcat(Output_Path, '/Start_time_reference.mat'), 'Start_time_reference');
        
end         % end of program


