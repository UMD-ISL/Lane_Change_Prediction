%% Synchronization_1

%% Description
%%
%  File type:    Executable file

%%
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

%% Initialization
clear all; clc; tic;
%# warning off;

% CD the data folder
% addpath('C:\Users\Xipeng1990\Desktop\Synchronization')
% cd('./Data3');

Data_directory = '../Lane_Change_original_data/';
fd_list = dir(Data_directory);
num_folder = 0;

% search the data folder and list all the folders and ignore files.
for i = 1:size(fd_list,1)
    stuct = fd_list(i,1);
    if (stuct.isdir == 1)
        num_folder = num_folder + 1;
    end
end
num_folder = num_folder - 2;    % ignore './' and '../'

% Process RSP Data
for m = 1:num_folder
    [RspData,RspTxt,~] = xlsread(strcat(Data_directory, num2str(m), ...
        '/RSP.xlsx'));
    if (RspData(1,1) > 0.5) && (RspData(end,1) < 0.5)
        Reverse = find(RspData(:,1) < 0.5);
        RspData(Reverse,1) = RspData(Reverse,1) + 1;
    end
end

% Process GSR Data
[GsrData,GsrTxt,~] = xlsread(strcat(Data_directory, num2str(m), ...
    '/GSR.xlsx'));
if (GsrData(1,1) > 0.5) && (GsrData(end,1) < 0.5)
    Reverse = find(GsrData(:,1) < 0.5);
    GsrData(Reverse,1) = GsrData(Reverse,1) + 1;
end

% Process ECG Data
[EcgData,EcgTxt,~] = xlsread(strcat(Data_directory, num2str(m), ...
    '/HR.xlsx'));
if (EcgData(1,1) > 0.5) && (EcgData(end,1) < 0.5)
    Reverse = find(EcgData(:,1) < 0.5);
    EcgData(Reverse,1) = EcgData(Reverse,1) + 1;
end

% PROCESS OBD DATA
[VehData,VehTxt,~] = xlsread(strcat(Data_directory, num2str(m), ...
    '/OBD.xlsx'));

% PROCESS GSR_RAW DATA
[GSR_RAWData,GSR_RAWTxt] = xlsread(strcat(Data_directory, num2str(m), ...
    '/GSR_RAW.xlsx'));
if (GSR_RAWData(1,1) > 0.5) && (GSR_RAWData(end,1) < 0.5)
    Reverse = find(GSR_RAWData(:,1)<0.5);
    GSR_RAWData(Reverse,1) = GSR_RAWData(Reverse,1) + 1;
end

% PROCESS ECG_RAW DATA
[ECG_RAWData,ECG_RAWTxt] = xlsread(strcat(Data_directory, num2str(m), ...
    '/ECG_RAW.xlsx'));
if (ECG_RAWData(1,1) > 0.5) && (ECG_RAWData(end,1) < 0.5)
    Reverse = find(ECG_RAWData(:,1)<0.5);
    ECG_RAWData(Reverse,1) = ECG_RAWData(Reverse,1) + 1;
end

% PROCESS BELT DATA
[BELT_RAWData,BELT_RAWTxt] = xlsread(strcat(Data_directory, num2str(m), ...
    '/Belt.xlsx'));
if (BELT_RAWData(1,1) > 0.5) && (BELT_RAWData(end,1) < 0.5)
    Reverse = find(BELT_RAWData(:,1) < 0.5);
    BELT_RAWData(Reverse,1) = BELT_RAWData(Reverse,1) + 1;
end

% PROCESS ACC DATA
[ACC_RAWData,ACC_RAWTxt] = xlsread(strcat(Data_directory, num2str(m), ...
    '/Acc.xlsx'));
if (ACC_RAWData(1,1) > 0.5) && (ACC_RAWData(end,1) < 0.5)
    Reverse = find(ACC_RAWData(:,1)<0.5);
    ACC_RAWData(Reverse,1) = ACC_RAWData(Reverse,1) + 1;
end

toc; % end of program


