%% Synchronization_1

%% Description
%%
%  File type:    Executable file

%%
%  Summary:
%  convert xlsx data into mat

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
clear all; clc;
%# warning off;

% CD the data folder
% addpath('C:\Users\Xipeng1990\Desktop\Synchronization')
% cd('./Data3');

Data_directory = '../Lane Change original data';
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

% Process Rsp Data
for m = 1:num_folder
    [RspData,RspTxt,~] = xlsread(strcat(Data_directory, num2str(m), ...
        '/RSP.xlsx'));
    if (RspData(1,1) > 0.5) && (RspData(end,1) < 0.5)
        Reverse = find(RspData(:,1) < 0.5);
        RspData(Reverse,1) = RspData(Reverse,1) + 1;
    end
end

% Process Gsr Data
[GsrData,GsrTxt,~] = xlsread(strcat(Data_directory, num2str(m), ...
    '/GSR.xlsx'));
if (GsrData(1,1) > 0.5) && (GsrData(end,1) < 0.5)
    Reverse = find(GsrData(:,1) < 0.5);
    GsrData(Reverse,1) = GsrData(Reverse,1) + 1;
end





