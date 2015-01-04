%% Synchronization_1.m

%% Description
%  File type:       Procedure
%
%  Summary:
%  This is the first file need to be excute for the whole project.
%  This script converts all .xlsx data into .mat format for further
%  processing and eliminate the nan data.
%
%  Input:
%  Driver's recorded raw signal data
%
% * Respiration signal                     RSP.xlsx
% * Galvanic skin response signal:         GSR.xlsx
% * Heart Rate signal:                     HR.xlsx
% * Vedio signal:                          OBD.xlsx
% * Galvanic skin response raw signal:     GSR_RAW.xlsx
% * Electrocardiography raw signal:        ECG_RAW.xlsx
% * Belt signal:                           Belt.xlsx
% * Acceleration signal:                   ACC.xlsx
%
%  Output:
%  save processed .mat files in './synchronization_1_Output/Video_',
%  num2str(m), '_Before_Denoised_Data.mat' format


%%
%  Examples: 
%  Provide sample usage code here.

%%
%  Algorithm:
%  There is no Algorithm implementation here.

%%
%  See also:
%
% * Nothing to refer here.

%%
%  Editor:       Yuan Ma
%  Date:         Oct.18.2014
%  Revision:     0.1
%  Partner:      Worked with Tianyu Wang, Yulong Li
%  Copyright:    Intelligent System Laboratory
%                University of Michigan Dearborn


%% Initialization and Configuration
clear all; clc;     % Clear environment, and start counting running time
ini = IniConfig();
ini.ReadFile('configuration.ini');

Data_Path = ini.GetValues('Dev Dataset Path', 'DATA_PATH');
home = ini.GetValues('Dev Dataset Path', 'HOME_PATH');
fd_list = dir(Data_Path);
num_folder = 0;

tic;                            % PROGRAM EFFICIENCY ESTIMATE
for i = 1:size(fd_list,1)
    stuct = fd_list(i,1);
    if (stuct.isdir == 1)
        num_folder = num_folder + 1;
    end
end
num_folder = num_folder - 2;    % ignore './' and '../'

synchronization_1_Output = strcat(home, '/synchronization_1_Output');
    mkdir_if_not_exist(synchronization_1_Output);
    
for m = 1:num_folder
    %% Processing each Signal data (Phase I)
    % search the data folder and list all the folders and ignore files.
    disp('Enter Signal Processing Phase I');        % DEBUG MESSAGE
    
    % Process RSP Data
    [Rsp_Data, Rsp_Txt, ~] = xlsread(strcat(Data_Path, '/', num2str(m), ...
        '/RSP.xlsx'));
    disp(Rsp_Txt(1, :));       % DEBUG info
    if (Rsp_Data(1,1) > 0.5) && (Rsp_Data(end,1) < 0.5)
        Reverse = find(Rsp_Data(:,1) < 0.5);
        Rsp_Data(Reverse,1) = Rsp_Data(Reverse,1) + 1;
    end

    % Process GSR Data
    [Gsr_Data, Gsr_Txt, ~] = xlsread(strcat(Data_Path, '/', num2str(m), ...
        '/GSR.xlsx'));
    disp(Gsr_Txt(1, :));       % DEBUG info
    if (Gsr_Data(1,1) > 0.5) && (Gsr_Data(end,1) < 0.5)
        Reverse = find(Gsr_Data(:,1) < 0.5);
        Gsr_Data(Reverse,1) = Gsr_Data(Reverse,1) + 1;
    end

    % Process ECG Data
    [Ecg_Data, Ecg_Txt, ~] = xlsread(strcat(Data_Path, '/', num2str(m), ...
        '/ECG.xlsx'));
    disp(Ecg_Txt(1, :));       % DEBUG info
    if (Ecg_Data(1,1) > 0.5) && (Ecg_Data(end,1) < 0.5)
        Reverse = find(Ecg_Data(:,1) < 0.5);
        Ecg_Data(Reverse,1) = Ecg_Data(Reverse,1) + 1;
    end

    % PROCESS OBD DATA ? not used ?
%     [Veh_Data,Veh_Txt,~] = xlsread(strcat(Data_Path, '/', num2str(m), ...
%         '/OBD.csv'));

    % PROCESS GSR_RAW DATA
    [GSR_RAW_Data, GSR_RAW_Txt] = xlsread(strcat(Data_Path, '/', num2str(m), ...
        '/GSR_RAW.xlsx'));
    disp(GSR_RAW_Txt(1, :));       % DEBUG info
    if (GSR_RAW_Data(1,1) > 0.5) && (GSR_RAW_Data(end,1) < 0.5)
        Reverse = find(GSR_RAW_Data(:,1)<0.5);
        GSR_RAW_Data(Reverse,1) = GSR_RAW_Data(Reverse,1) + 1;
    end

    % PROCESS ECG_RAW DATA
    [ECG_RAW_Data, ECG_RAW_Txt] = xlsread(strcat(Data_Path, '/', num2str(m), ...
        '/ECGraw.csv'));
    ECG_RAW_Txt(:,[1, 2, 3]) = ECG_RAW_Txt(:,[3, 1, 2]);
    disp(ECG_RAW_Txt(1, :));       % DEBUG info
    ECG_RAW_Data(:,[1, 2, 3]) = ECG_RAW_Data(:,[3, 1, 2]);
    if (ECG_RAW_Data(1, 1) > 0.5) && (ECG_RAW_Data(end, 1) < 0.5)
        Reverse = find(ECG_RAW_Data(:, 1)<0.5);
        ECG_RAW_Data(Reverse, 1) = ECG_RAW_Data(Reverse, 1) + 1;
    end

    % PROCESS BELT DATA
    [BELT_RAW_Data, BELT_RAW_Txt] = xlsread(strcat(Data_Path, '/', num2str(m), ...
        '/RSPraw.csv'));
    BELT_RAW_Txt(:,[1, 2]) = BELT_RAW_Txt(:,[2, 1]);
    disp(BELT_RAW_Txt(1, :));       % DEBUG info
    BELT_RAW_Data(:,[1, 2]) = BELT_RAW_Data(:,[2, 1]);
    if (BELT_RAW_Data(1, 1) > 0.5) && (BELT_RAW_Data(end, 1) < 0.5)
        Reverse = find(BELT_RAW_Data(:, 1) < 0.5);
        BELT_RAW_Data(Reverse, 1) = BELT_RAW_Data(Reverse, 1) + 1;
    end

    % PROCESS ACC DATA
%     [ACC_RAW_Data, ACC_RAW_Txt] = xlsread(strcat(Data_Path, '/', num2str(m), ...
%         '/Acc.xlsx'));
%     if (ACC_RAW_Data(1,1) > 0.5) && (ACC_RAW_Data(end,1) < 0.5)
%         Reverse = find(ACC_RAW_Data(:,1)<0.5);
%         ACC_RAW_Data(Reverse,1) = ACC_RAW_Data(Reverse,1) + 1;
%     end

    % save the mat raw data
    [target_Data, target_Txt, ~] = xlsread(strcat(Data_Path, '/', num2str(m), '/target.xls'));      
    target_Idx = target_Data;

    % TextIndex is a structure store the name of all signals, first column is
    % time
    Text_Index{1,1} = 'Time';
    k = 2;
    Text_Index{k,1} = Ecg_Txt{1,2};
    k = k+1;
    Text_Index{k,1} = Ecg_Txt{1,3};
    k = k+1;

    % Save Rsp data information into TextIndex
    for i = 2:length(Rsp_Txt(1,:))
        Text_Index{k,1} = Rsp_Txt{1,i};
        k = k + 1;
    end

    % Save Gsr data information into TextIndex
    for i = 2:length(Gsr_Txt(1,:))
        Text_Index{k,1} = Gsr_Txt{1,i};
        k = k+1;
    end

    % Save GSR RAW data information into TextIndex
    for i = 3:length(GSR_RAW_Txt(1,:))
        Text_Index{k,1} = GSR_RAW_Txt{1,i};
        k = k+1;
    end

    % Final column store the target Information
    Text_Index{k,1} = target_Txt{1,16};
    k = k+1;

    % Save the intermedia process result, NAME FORMAT is following below
    temp_file = strcat(synchronization_1_Output, '/Video_', num2str(m), '_temp_Data.mat');
    save(temp_file, ...   % save temp data
        'Rsp_Data','Gsr_Data','Ecg_Data','Text_Index', ...
        'GSR_RAW_Data','ECG_RAW_Data','BELT_RAW_Data', ...
        'target_Data','m');
%         'Rsp_Data','Gsr_Data','Ecg_Data','Veh_Data','Text_Index', ...
%         'GSR_RAW_Data','ECG_RAW_Data','BELT_RAW_Data','ACC_RAW_Data', ...
%         'target_Data','m');
    toc;

    %% Processing each Signal data (Phase II)
    % eliminate the nan value in the data
    
    % Clear all varibles but keep 'Data_Path' and 'synchronization_1_Output'
    clearvars -except Data_Path synchronization_1_Output temp_file;             
    
    % load the data generated in Phase I
    load(temp_file);   % load temp data
    delete(temp_file); % delete temp data
    
    disp('Enter Signal Processing Phase II');       % DEBUG MESSAGE
    tic;                                            % PROGRAM EFFICIENCY ESTIMATE
    
    % Pre-process each signal: ECG signal
%     Ecg_Data(:, 4:5) = [];
    [R,~] = find(isnan(Ecg_Data));          % find the NAN value position
    Ecg_Data(R,:) = [];

    % Pre-process GSR signal
    [R,~] = find(isnan(Gsr_Data));          % find the NAN value position
    Gsr_Data(R,:) = [];

    % Pre-process RSP signal
    [R,~] = find(isnan(Rsp_Data));          % find the NAN value position
    Rsp_Data(R,:) = [];

    % Pre-process ECG_Raw signal
    [R,~] = find(isnan(ECG_RAW_Data));      % find the NAN value position
    ECG_RAW_Data(R,:)=[];

    % Pre-process GSR_RAW signal
    [R,~] = find(isnan(GSR_RAW_Data));      % find the NAN value position
    GSR_RAW_Data(R,:)=[];

    % Pre-process Belt signal
    [R,~] = find(isnan(BELT_RAW_Data));     % find the NAN value position
    BELT_RAW_Data(R,:)=[];

    % Pre-process Acc signal
%     [R,~] = find(isnan(ACC_RAW_Data));      % find the NAN value position
%     ACC_RAW_Data(R,:)=[];

    % Time shifting process
    load(strcat(Data_Path, '/', 'Start_time_reference.mat'));

    GSR_start_Time      = Start_time_reference{1, m};
    ECG_start_Time      = Start_time_reference{2, m};
    RSP_start_Time      = Start_time_reference{3, m};
    OBD_start_Time      = Start_time_reference{4, m};
    ECG_RAW_start_Time  = Start_time_reference{5, m};
    GSR_RAW_start_Time  = Start_time_reference{6, m};
    BELT_RAW_start_Time = Start_time_reference{7, m};
%     ACC_RAW_start_Time  = Start_time_reference{8,m};

    Rsp_Data(:,1)       = Rsp_Data(1:end,1) - Rsp_Data(1,1);
    % delete date information, only reserve hour, minute, second
    % information
    Rsp_Data(:,1)       = Rsp_Data(:,1) + datenum(RSP_start_Time) ...
                            - floor(datenum(RSP_start_Time));
    Gsr_Data(:,1)       = Gsr_Data(1:end,1) - Gsr_Data(1,1);
    Gsr_Data(:,1)       = Gsr_Data(:,1) + datenum(GSR_start_Time) ...
                            - floor(datenum(GSR_start_Time));

    Ecg_Data(:, 1)       = Ecg_Data(1:end, 1) - Ecg_Data(1, 1);
    Ecg_Data(:, 1)       = Ecg_Data(:, 1) + datenum(ECG_start_Time) ...
                            - floor(datenum(ECG_start_Time));

    ECG_RAW_Data(:, 3)   = ECG_RAW_Data(1:end, 1) - ECG_RAW_Data(1, 1);
    ECG_RAW_Data(:, 3)   = ECG_RAW_Data(:, 1) + datenum(ECG_RAW_start_Time) ...
                            - floor(datenum(ECG_RAW_start_Time));

    GSR_RAW_Data(:,1)   = GSR_RAW_Data(1:end, 1) - GSR_RAW_Data(1, 1);
    GSR_RAW_Data(:,1)   = GSR_RAW_Data(:, 1) + datenum(GSR_RAW_start_Time) ...
                            - floor(datenum(GSR_RAW_start_Time));

    BELT_RAW_Data(:,2)  = BELT_RAW_Data(1:end, 1) - BELT_RAW_Data(1, 1);
    BELT_RAW_Data(:,2)  = BELT_RAW_Data(:, 1) + datenum(BELT_RAW_start_Time) ...
                            - floor(datenum(BELT_RAW_start_Time));
                        

%     ACC_RAW_Data(:,1)   = ACC_RAW_Data(1:end,1) - ACC_RAW_Data(1,1);
%     ACC_RAW_Data(:,1)   = ACC_RAW_Data(:,1) + datenum(ACC_RAW_start_Time) ...
%                             - floor(datenum(ACC_RAW_start_Time));

    % save ouput file, NAME FORMAT: 'Video_#_Before_denoised_data.mat'
    save(strcat(synchronization_1_Output, '/Video_', num2str(m), '_Before_Denoised_Data.mat'));
    
    toc;    % PROGRAM EFFICIENCY ESTIMATE
end         % end of program




