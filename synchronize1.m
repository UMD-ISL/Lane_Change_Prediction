%% convert xlsx data into mat
clear;clc;
% CD the data folder
%addpath('C:\Users\Xipeng1990\Desktop\Synchronization')
%cd('./Data3');
Skip=0;
if Skip==0
[RspData,RspTxt,~]=xlsread('RSP.xlsx');
if RspData(1,1)>0.5 && RspData(end,1)<0.5
    Reverse=find(RspData(:,1)<0.5);
    RspData(Reverse,1)=RspData(Reverse,1)+1;
end
% PROCESS GSR DATA
[GsrData,GsrTxt,~]=xlsread('GSR.xlsx');
if GsrData(1,1)>0.5 && GsrData(end,1)<0.5
    Reverse=find(GsrData(:,1)<0.5);
    GsrData(Reverse,1)=GsrData(Reverse,1)+1;
end
% PROCESS ECG DATA
[EcgData,EcgTxt,~]=xlsread('HR.xlsx');
if EcgData(1,1)>0.5 && EcgData(end,1)<0.5
    Reverse=find(EcgData(:,1)<0.5);
    EcgData(Reverse,1)=EcgData(Reverse,1)+1;
end
% PROCESS OBD DATA
[VehData,VehTxt,~]=xlsread('OBD.xlsx');
% PROCESS GSR_RAW DATA
[GSR_RAWData,GSR_RAWTxt]=xlsread('GSR_RAW.xlsx');
if GSR_RAWData(1,1)>0.5 && GSR_RAWData(end,1)<0.5
    Reverse=find(GSR_RAWData(:,1)<0.5);
    GSR_RAWData(Reverse,1)=GSR_RAWData(Reverse,1)+1;
end
% PROCESS ECG_RAW DATA
[ECG_RAWData,ECG_RAWTxt]=xlsread('ECG_RAW.xlsx');
if ECG_RAWData(1,1)>0.5 && ECG_RAWData(end,1)<0.5
    Reverse=find(ECG_RAWData(:,1)<0.5);
    ECG_RAWData(Reverse,1)=ECG_RAWData(Reverse,1)+1;
end
% PROCESS BELT DATA
[BELT_RAWData,BELT_RAWTxt]=xlsread('Belt.xlsx');
if BELT_RAWData(1,1)>0.5 && BELT_RAWData(end,1)<0.5
    Reverse=find(BELT_RAWData(:,1)<0.5);
    BELT_RAWData(Reverse,1)=BELT_RAWData(Reverse,1)+1;
end
% PROCESS ACC DATA
[ACC_RAWData,ACC_RAWTxt]=xlsread('Acc.xlsx');
if ACC_RAWData(1,1)>0.5 && ACC_RAWData(end,1)<0.5
    Reverse=find(ACC_RAWData(:,1)<0.5);
    ACC_RAWData(Reverse,1)=ACC_RAWData(Reverse,1)+1;
end
% save the mat raw data
[targetData,targetTxt,~]=xlsread('target.xls');      
targetIdx=targetData;
% save the mat raw data
%save('RawDataAll');
% save the num data
%% ECG,RSP,GSR
TextIndex{1,1} = 'Time';
k=2;
TextIndex{k,1} = EcgTxt{1,2};%%
k=k+1;
TextIndex{k,1} = EcgTxt{1,3};%%
k=k+1;

for i=2:length(RspTxt(1,:))
    TextIndex{k,1} = RspTxt{1,i};
    k=k+1;
end

for i=2:length(GsrTxt(1,:))
    TextIndex{k,1} = GsrTxt{1,i};
    k=k+1;
end

% for i=2:length(ECG_RAWTxt(1,:))
%     TextIndex{k,1} = ECG_RAWTxt{1,i};
%     k=k+1;
% end

% for i=2:length(BELT_RAWTxt(1,:))
%     TextIndex{k,1} = BELT_RAWTxt{1,i};
%     k=k+1;
% end

for i=3:length(GSR_RAWTxt(1,:))
    TextIndex{k,1} = GSR_RAWTxt{1,i};
    k=k+1;
end

% for i=2:length(ACC_RAWTxt(1,:))
%     TextIndex{k,1} = ACC_RAWTxt{1,i};
%     k=k+1;
% end
TextIndex{k,1} = targetTxt{1,16};
k=k+1;

%%
save('NumberData','RspData','GsrData','EcgData','VehData','TextIndex','GSR_RAWData','ECG_RAWData','BELT_RAWData','ACC_RAWData','targetData');
end
%% Process the data, eliminate invalid data
clear;clc;
load('NumberData')
%% Pre-process ECG signal
EcgData(:,4:5) = [];
[R,~]=find(isnan(EcgData));
EcgData(R,:)=[];
% if EcgData(1,1)>0.5 && EcgData(end,1)<0.5
%     Reverse=find(EcgData(:,1)<0.5);
%     EcgData(Reverse,1)=EcgData(Reverse,1)+1;
% end
%% Pre-process GSR signal
[R,~]=find(isnan(GsrData));
GsrData(R,:)=[];
%% Pre-process RSP signal
[R,~]=find(isnan(RspData));
RspData(R,:)=[];
%% Pre-process ECG_Raw signal
[R,~]=find(isnan(ECG_RAWData));
ECG_RAWData(R,:)=[];
%% Pre-process GSR_RAW signal
GSR_RAWData(:,2)=GSR_RAWData(:,3);
GSR_RAWData(:,3) = [];
[R,~]=find(isnan(GSR_RAWData));
GSR_RAWData(R,:)=[];
%% Pre-process Belt signal
[R,~]=find(isnan(BELT_RAWData));
BELT_RAWData(R,:)=[];
%% Pre-process Acc signal
[R,~]=find(isnan(ACC_RAWData));
ACC_RAWData(R,:)=[];
%% Time shifting process

GSRstartTime = '22:41:22.000';      %% 18_15:15:17.000   20_15:29:15.000     21_18:17:46.000    25_14:34:37.000  04_10_22:52:00.000   06_17_17:24:18.000   06_16_22:41:22.000
ECGstartTime = '22:41:33.477';         %% 18_15:15:20.716    20_15:29:19.257   21_18:17:50.358   25_14:34:42.053  04_10_22:52:06:179  06_17_17:24:18.000   06_16_22:41:33.477
RSPstartTime = '22:41:35.476';         %% 18_15:15:30.203    20_15:29:30.703   21_18:18:04.593   25_14:34:37.546  04_10_22:52:14:492  06_17_17:24:27.375   06_16_22:41:35.476
OBDstartTime = '22:39:00';       %% 18_15:25:09      20_15:30:28               21_18:21:15       25_14:35:32      04_10_22:52:02      06_17_17:24:45       06_16_22:39:00
ECG_RAWstartTime = '22:41:22.004';       %% 18_15:15:17.000     20_15:29:15.004  21_18:17:46.004 25_14:34:37.004  04_10_22:52:00.004  06_17_17:24:18.004   06_16_22:41:22.004
GSR_RAWstartTime = '22:41:22.039';       %% 18_15:15:17.352     20_15:29:15.547  21_18:17:46.547 25_14:34:37.508  04_10_22:52:00.469  06_17_17:24:18.586   06_16_22:41:22.039
BELT_RAWstartTime = '22:41:22.039';       %% 18_15:15:17.039    20_15:29:15.039  21_18:17:46.039 25_14:34:37.039  04_10_22:52:00.039  06_17_17:24:18.039   06_16_22:41:22.039
ACC_RAWstartIime = '22:41:22.039';        %% 18_15:15:17.039    20_15:29:15.039  21_18:17:46.039 25_14:34:37.039  04_10_22:52:00.039  06_17_17:24:18.039   06_16_22:41:22.039
%
RspData(:,1)=[RspData(1:end,1) - RspData(1,1)];
RspData(:,1) = RspData(:,1) + datenum(RSPstartTime) - floor(datenum(RSPstartTime));
%
GsrData(:,1)=[GsrData(1:end,1) - GsrData(1,1)];
GsrData(:,1) = GsrData(:,1) + datenum(GSRstartTime) - floor(datenum(GSRstartTime));
%
EcgData(:,1)=[EcgData(1:end,1) - EcgData(1,1)];
EcgData(:,1) = EcgData(:,1) + datenum(ECGstartTime) - floor(datenum(ECGstartTime));

ECG_RAWData(:,1)=[ECG_RAWData(1:end,1) - ECG_RAWData(1,1)];
ECG_RAWData(:,1) = ECG_RAWData(:,1) + datenum(ECG_RAWstartTime) - floor(datenum(ECG_RAWstartTime));

GSR_RAWData(:,1)=[GSR_RAWData(1:end,1) - GSR_RAWData(1,1)];
GSR_RAWData(:,1) = GSR_RAWData(:,1) + datenum(GSR_RAWstartTime) - floor(datenum(GSR_RAWstartTime));

BELT_RAWData(:,1)=[BELT_RAWData(1:end,1) - BELT_RAWData(1,1)];
BELT_RAWData(:,1) = BELT_RAWData(:,1) + datenum(BELT_RAWstartTime) - floor(datenum(BELT_RAWstartTime));

ACC_RAWData(:,1)=[ACC_RAWData(1:end,1) - ACC_RAWData(1,1)];
ACC_RAWData(:,1) = ACC_RAWData(:,1) + datenum(ACC_RAWstartIime) - floor(datenum(ACC_RAWstartIime));
save('Before_denoise14_06_16.mat');





















