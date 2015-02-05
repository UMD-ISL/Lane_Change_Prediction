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
% * Galvanic skin response signal:         GSR.csv
% * Heart Rate signal:                     ECG.csv
% * Respiration signal:                    RSP.csv
% * Vedio signal:                          OBD.csv
% * Electrocardiography raw signal:        ECG_RAW.csv
% * Galvanic skin response raw signal:     GSR_RAW.xlsx
% * Respiration signal raw signal:         RSPraw.xlsx
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

[Data_Path, Output_Path] = loadGlobalPathSetting();

fd_list = dir(Data_Path);
num_folder = 0;

for i = 1:size(fd_list,1)
    stuct = fd_list(i,1);
    if (stuct.isdir == 1)
        num_folder = num_folder + 1;
    end
end
num_folder = num_folder - 2;    % ignore './' and '../'

synchronization_1_Output = createOutputFolder(Output_Path, 'synchronization_1_Output');

for videoIndex = 1:num_folder
    %% Processing each Signal data (Phase I)
   
    inputData = readPhysiSignalDataFiles(Data_Path, videoIndex);
    
    inputData = checkDataTimestampError(inputData);
    
    inputData = readLabelResultFile(inputData, Data_Path, videoIndex);

    inputData = createHeaderInfo(inputData);
    
    % Save the intermedia process result, NAME FORMAT is following below
    temp_file = strcat(synchronization_1_Output, '/Video_', num2str(videoIndex), '_temp_Data.mat');
    save(temp_file, ...   % save temp data
        'Rsp_Data', 'Gsr_Data', 'Ecg_Data', 'Text_Index', ...
        'GSR_RAW_Data', 'ECG_RAW_Data', 'BELT_RAW_Data', ...
        'target_Data', 'm');


    %% Processing each Signal data (Phase II)
    % eliminate the nan value in the data
    eliminateNanData(temp_file, Output_Path, synchronization_1_Output);
    
    timeShiftingProcess(temp_file, Output_Path);
    
    % save ouput file, NAME FORMAT: 'Video_#_Before_denoised_data.mat'
    % Too Lazy !!! you should find what data you want store, what is
    % redundant!!!
    load(temp_file);    % update processed data
    save(strcat(synchronization_1_Output, '/Video_', num2str(videoIndex), '_Before_Denoised_Data.mat'));
    delete(temp_file); % delete temp data
    
end         % end of program




