%% Initialization and Configuration
clear all; clc;     % Clear environment, and start counting running time

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

%%
tic;
parfor m = 1:num_folder
    disp('Enter into a new folder');
    % read GSR.csv file  # 1
    [Data, Header, ~]   =  xlsread(strcat(Data_Path, '/', num2str(m),'/GSR.csv'));
    % find the column number of Timestamp
    [~, index]  = ismember('Timestamp', Header);
    % convert double format to string format
    GSR_start_Time      = datestr(Data(1,index), 'HH:MM:SS.FFF');
    % 1: Signals.GSR
    Start_time_reference{1, m} = GSR_start_Time;
    disp('Get GSR signal time reference');
    
    % read ECG.csv file  # 2
    [Data, Header, ~]   =  xlsread(strcat(Data_Path, '/', num2str(m),'/ECG.csv'));
    % find the column number of Timestamp
    [~, index]  = ismember('Timestamp', Header);
    ECG_start_Time      = datestr(Data(1,index), 'HH:MM:SS.FFF');
    % 2: Signals.ECG
    Start_time_reference{2, m} = ECG_start_Time;
    disp('Get ECG signal time reference');
    
    % read RSP.csv file  # 3
    [Data, Header, ~]   =  xlsread(strcat(Data_Path, '/', num2str(m),'/RSP.csv'));  % have some problem here
    Header = Header(1,:);
    % find the column number of Timestamp
    [~, index]  = ismember('Timestamp', Header);
    RSP_start_Time      = datestr(Data(1,index), 'HH:MM:SS.FFF');
    % 3: Signals.RSP
    Start_time_reference{3, m} = RSP_start_Time;
    disp('Get RSP signal time reference');
    
    % read OBD.csv file  # 4
    [Data, Header, ~]   =  xlsread(strcat(Data_Path, '/', num2str(m),'/OBD.csv'));
    timeformat          = '[0-9]+:[0-9]+:[0-9]+ (PM|AM)';
    reg_time            = regexp(Header{3,1}, timeformat, 'match');
    OBD_start_Time      = datestr(cell2mat(reg_time), 'HH:MM:SS.FFF');
    % 4: Signals.OBD
    Start_time_reference{4, m} = OBD_start_Time;
    disp('Get OBD signal time reference');
    
    % read ECGraw.csv file # 5
    [Data, Header, ~]   = xlsread(strcat(Data_Path, '/', num2str(m),'/ECGraw.csv'));
    % find the column number of Timestamp
    [~, index] = ismember('Timestamp', Header);
    % convert double format to string format
    ECG_RAW_start_Time      = datestr(Data(1,index), 'HH:MM:SS.FFF');
    % 5: Signals.ECG_RAW
    Start_time_reference{5, m} = ECG_RAW_start_Time;
    disp('Get ECG_RAW signal time reference');
    
    % read GSRRaw.csv file # 6
    [Data, Header, ~]   =  xlsread(strcat(Data_Path, '/', num2str(m),'/GSR_RAW.xlsx'));
    [~, index]  = ismember('Time', Header);
    % convert double format to string format
    Data(1,index) = addtodate(Data(1,index), 4, 'hour');
    GSR_RAW_start_Time  = datestr(Data(1,index), 'HH:MM:SS.FFF');
    % 6: Signals.GSR_RAW
    Start_time_reference{6, m} = GSR_RAW_start_Time;
    disp('Get GSR_RAW signal time reference');
    
    % read Belt.csv file # 7
    try
        [Data, Header, ~]   =  xlsread(strcat(Data_Path, '/', num2str(m),'/RSPraw.csv'));
        [~, index]  = ismember('Timestamp', Header);
        % convert double format to string format
        BELT_RAW_start_Time  = datestr(Data(1,index), 'HH:MM:SS.FFF');
        % 7: Signals.BELT_RAW
        Start_time_reference{7, m} = BELT_RAW_start_Time;
        disp('Get BELT_RAW signal time reference');
    catch
        continue;
    end
end         % end of program
toc;

save(strcat(Output_Path, '/Start_time_reference.mat'), 'Start_time_reference');