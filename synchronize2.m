clc;clear;
warning off
Signal=dir('Before_denoise/*.mat');
for j=1:size(Signal,1)
    
    temp = strcat('Before_denoise/Before_denoise', num2str(j),'.mat');
    load(temp);


    diff_EcgHR = diff(EcgData(:, 2));
    diff_EcgRR = diff(EcgData(:, 3));
    diff_EcgRaw = diff(ECG_RAWData(:, 2));
    EcgDataHR_New = EcgData(:, 1:2);
    EcgDataRR_New = EcgData(:, [1, 3]);
    ECG_RAWData_New = ECG_RAWData;
    
    % HR
    i = 1;
    while i < numel(diff_EcgHR)
        if    diff_EcgHR(i) > 30 ...
            | diff_EcgHR(i) < -30 ...
            | EcgDataHR_New(i + 1, 2) > 120 ...
            | EcgDataHR_New(i + 1, 2) < 50
            
            EcgDataHR_New(i + 1, :) = [NaN];
            if sign(diff_EcgHR(i)) ~= sign(diff_EcgHR(i + 1))
                if sign(diff_EcgHR(i + 1)) == -1 & EcgDataHR_New(i + 2, 2) < 50
                elseif sign(diff_EcgHR(i + 1)) == 1 & EcgDataHR_New(i + 2, 2) > 120
                else
                    i = i + 1;
                end
            end
            
        end
        i = i + 1;
    end
    
    % RR
    i = 1;
    while i < numel(diff_EcgRR)
        if    diff_EcgRR(i) > 0.3 ...
            | diff_EcgRR(i) < -0.3 ...
            | EcgDataRR_New(i + 1, 2) > 1 ...
            | EcgDataRR_New(i + 1, 2) < 0.5
            
            EcgDataRR_New(i + 1, :) = [NaN];
            if sign(diff_EcgRR(i)) ~= sign(diff_EcgRR(i + 1))
                if sign(diff_EcgRR(i + 1)) == -1 & EcgDataRR_New(i + 2, 2) < 50
                elseif sign(diff_EcgRR(i + 1)) == 1 & EcgDataRR_New(i + 2, 2) > 120
                else
                    i = i + 1;
                end
            end
            
        end
        i = i + 1;
    end
    
    % ECG_RAW
%     i = 1;
%     while i < numel(diff_EcgRaw)
%         if    diff_EcgRaw(i) > 50 ...
%             | diff_EcgRaw(i) < -150 ...
%             | ECG_RAWData_New(i + 1, 2) > 12000 ...
%             | ECG_RAWData_New(i + 1, 2) < -50
%             
%             ECG_RAWData_New(i + 1, :) = [NaN];
%             if sign(diff_EcgRaw(i)) ~= sign(diff_EcgRaw(i + 1))
%                 i = i + 1;
%             end
%             
%         end
%         i = i + 1;
%     end
    
    save(strcat('after_denoise\afterDenoise_', num2str(j), '.mat'),'EcgDataHR_New', 'diff_EcgHR', 'EcgDataRR_New', 'diff_EcgRR');
end
clc
clear
Signal=dir('Before_denoise/*.mat');
for m=1:size(Signal,1)
load(strcat('Before_denoise/Before_denoise',num2str(m),'.mat'));

% %% norm
% max_hr=max(EcgData(:,2));
% min_hr=min(EcgData(:,2));
% max_ECGRAW=max(ECG_RAWData(:,2));
% min_ECGRAW=min(ECG_RAWData(:,2));
% max_GSRRAW=max(GSR_RAWData(:,2));
% min_GSRRAW=min(GSR_RAWData(:,2));
% 
% EcgData(:,2)=(EcgData(:,2)-min_hr)/(max_hr-min_hr);
% ECG_RAWData(:,2)=(ECG_RAWData(:,2)-min_ECGRAW)/(max_ECGRAW-min_ECGRAW);
% GSR_RAWData(:,2)=(GSR_RAWData(:,2)-min_GSRRAW)/(max_GSRRAW-min_GSRRAW);
% difference1=diff(EcgData(:,2));
% difference2=diff(ECG_RAWData(:,2));
% difference3=diff(GSR_RAWData(:,2));
% %% denoise
% upper_outliers=find(difference1>0.3);
% EcgData(upper_outliers+1,:)=[];
% difference1=diff(EcgData(:,2));
% lower_outliers=find(difference1<-0.3);
% EcgData(lower_outliers-1,:)=[];
% 
% upper_outliers=find(difference2>0.3);
% ECG_RAWData(upper_outliers+1,:)=[];
% difference1=diff(ECG_RAWData(:,2));
% lower_outliers=find(difference1<-0.3);
% ECG_RAWData(lower_outliers-1,:)=[];
% 
% upper_outliers=find(difference3>0.3);
% GSR_RAWData(upper_outliers+1,:)=[];
% difference1=diff(GSR_RAWData(:,2));
% lower_outliers=find(difference1<-0.3);
% GSR_RAWData(lower_outliers-1,:)=[];
% 
% %% denorm
% EcgData(:,2)=EcgData(:,2)*(max_hr-min_hr)+min_hr;
% ECG_RAWData(:,2)=ECG_RAWData(:,2)*(max_ECGRAW-min_ECGRAW)+min_ECGRAW;
% GSR_RAWData(:,2)=GSR_RAWData(:,2)*(max_GSRRAW-min_GSRRAW)+min_GSRRAW;
% 
load(strcat('after_denoise/afterDenoise_',num2str(m),'.mat'));
EcgData(:,2)=EcgDataHR_New(:,2);
[R,~]=find(isnan(EcgData(:,2)));
EcgData(R,:)=[];
%% detrend for HR
waveletLevels = 6;
waveletType = 'db3';
baseline_HR=80;

[c,l] = wavedec(EcgData(:,2),waveletLevels,waveletType);
trend = wrcoef('a',c,l,waveletType,waveletLevels);
EcgData(:,2) = EcgData(:,2)-trend;
EcgData(:,2) = EcgData(:,2)+baseline_HR;

%% detrend for GSRRAW
baseline_GSRRAW=10;
trend = mean(GSR_RAWData(:,2));
GSR_RAWData(:,2)=GSR_RAWData(:,2)-trend;
GSR_RAWData(:,2)=GSR_RAWData(:,2)+baseline_GSRRAW;



%% process vehicle data
BaseTime = datenum(OBDstartTime) - floor(datenum(OBDstartTime));
VehData(:,1) = VehData(:,1)/3600/24 + BaseTime;
% [R,~]=find(isnan(VehData));
% VehData(R,:)=[];



startTime=max([ datenum(OBDstartTime) - floor(datenum(OBDstartTime));...
    datenum(GSRstartTime) - floor(datenum(GSRstartTime));...
    datenum(ECGstartTime) - floor(datenum(ECGstartTime));...
    datenum(RSPstartTime) - floor(datenum(RSPstartTime));...
    datenum(ECG_RAWstartTime) - floor(datenum(ECG_RAWstartTime));...
    datenum(GSR_RAWstartTime) - floor(datenum(GSR_RAWstartTime));...
    datenum(BELT_RAWstartTime) - floor(datenum(BELT_RAWstartTime));...
    ]);

stopTime = min([EcgData(end,1),GsrData(end,1),RspData(end,1),VehData(end,1),ECG_RAWData(end,1),GSR_RAWData(end,1),BELT_RAWData(end,1)]);
%% synchronisation : This part is used to synchronize the data
SampleRate = 10; % 10 Hz
TimeStep = (1/SampleRate)/24/3600;
% dataAll_cal = [];
% dataAll_ECG = [];
% dataAll_BELT = [];


tlength=abs((stopTime-startTime))*24*3600;  
%% Up-Sampling
[~,idx1]=min(abs(EcgData(:,1)-startTime)); 
[~,idx2]=min(abs(EcgData(:,1)-stopTime));  
v=EcgData(idx1:idx2,[2,3]);
t=(EcgData(idx1:idx2,1)-EcgData(idx1,1))*24*3600;
tq=0:0.1:tlength;
tq=tq';
vqecg=interp1(t,v,tq,'linear');

[noneUse1,idx1]=min(abs(GsrData(:,1)-startTime)); 
[noneUse2,idx2]=min(abs(GsrData(:,1)-stopTime));  
v=GsrData(idx1:idx2,2:end);
t=(GsrData(idx1:idx2,1)-GsrData(idx1,1))*24*3600;
tq=0:0.1:tlength;
tq=tq';
vqgsr=interp1(t,v,tq,'linear');

[noneUse1,idx1]=min(abs(RspData(:,1)-startTime)); 
[noneUse2,idx2]=min(abs(RspData(:,1)-stopTime));  
v=RspData(idx1:idx2,2:end);
t=(RspData(idx1:idx2,1)-RspData(idx1,1))*24*3600;
tq=0:0.1:tlength;
tq=tq';
vqrsp=interp1(t,v,tq,'linear');

%% ECG Down-Sampling
[noneUse1,idx1]=min(abs(ECG_RAWData(:,1)-startTime)); 
% [noneUse2,idx2]=min(abs(ECG_RAWData(:,1)-stopTime));  
vqecg_raw_time=(ECG_RAWData(idx1:end,1)-ECG_RAWData(idx1,1))*24*3600;
% LengthofDownS=ceil(((idx2-idx1+1)/256));
% for i=1:LengthofDownS
%     Label=0;
%     ave_small_win=[];
%     v=ECG_RAWData(idx1:idx2,2:end); 
%     if i==LengthofDownS
%         NumberLeft=ceil(((idx2-idx1+1)-(i-1)*256)/25);
%         for k=1:NumberLeft
%         boundary=min(((i-1)*256+k*25),size(v,1));
%         small_win=v(((i-1)*256+(k-1)*25+1:boundary),:);
%         ave_small_win(k,:)=mean(small_win);
%         
%         end
%         vqecg_raw((i-1)*10+1:((i-1)*10+NumberLeft),:) = ave_small_win;
%         Label=1;
%         break
%     end
%     if Label==1
%         break
%     end
%     window=v(((i-1)*256+1:(i*256)),:);
%    
%     for j=1:10
%         small_win=window(((j-1)*25+1:(j*25)),:);
%         ave_small_win(j,:)=mean(small_win);
%     end
%     vqecg_raw(((i-1)*10+1:(i*10)),:) = ave_small_win;
% end
vqecg_raw=ECG_RAWData(idx1:end,2:end); 
%% Belt signal down-sampling
[noneUse1,idx1]=min(abs(BELT_RAWData(:,1)-startTime)); 
% [noneUse2,idx2]=min(abs(BELT_RAWData(:,1)-stopTime));  
% v=BELT_RAWData(idx1:idx2,2);
% t=(BELT_RAWData(idx1:idx2,1)-BELT_RAWData(idx1,1))*24*3600;
% tq=0:1/256:tlength;
% tq=tq';
% belt=interp1(t,v,tq,'linear');
% 
% LengthofDownS=ceil((length(tq)/256));
% for i=1:LengthofDownS
%     Label=0;
%     ave_small_win=[];
%     v=belt;
%     if i==LengthofDownS
%         NumberLeft=ceil(((length(belt))-(i-1)*256)/25);
%         for k=1:NumberLeft
%         boundary=min(((i-1)*256+k*25),size(v,1));
%         small_win=v(((i-1)*256+(k-1)*25+1:boundary),:);
%         ave_small_win(k,:)=mean(small_win);
%         
%         end
%         vqbelt_raw((i-1)*10+1:((i-1)*10+NumberLeft),:) = ave_small_win;
%         Label=1;
%         break
%     end
%     if Label==1
%         break
%     end
%     window=v(((i-1)*256+1:(i*256)),:);
%    
%     for j=1:10
%         small_win=window(((j-1)*25+1:(j*25)),:);
%         ave_small_win(j,:)=mean(small_win);
%     end
%     vqbelt_raw(((i-1)*10+1:(i*10)),:) = ave_small_win;
% end
vqbelt_raw_time=(BELT_RAWData(idx1:end,1)-BELT_RAWData(idx1,1))*24*3600;
vqbelt_raw=BELT_RAWData(idx1:end,2:end); 
%% GSR_RAW signal down-sampling
[noneUse1,idx1]=min(abs(GSR_RAWData(:,1)-startTime)); 
[noneUse2,idx2]=min(abs(GSR_RAWData(:,1)-stopTime));  
v=GSR_RAWData(idx1:idx2,2);
t=(GSR_RAWData(idx1:idx2,1)-GSR_RAWData(idx1,1))*24*3600;
tq=0:0.1:tlength;
tq=tq';
vqgsr_raw=interp1(t,v,tq,'linear');
dataAll_cal = [tq,vqecg,vqrsp,vqgsr,vqgsr_raw];
dataAll_ECG = [vqecg_raw_time,vqecg_raw];
dataAll_BELT = [vqbelt_raw_time,vqbelt_raw];

%% ECG,RSP,GSR,OBD




%[targetData,targetTxt,~]=xlsread('target0318.xls');   %%
targetIdx=targetData;
  

   %targetIdx = [ % this is the target period
   % datenum('0:01:05'),datenum('0:01:40');...
    %datenum('0:01:56'),datenum('0:04:38');...
   % datenum('0:04:48'),datenum('0:05:17');...
   % datenum('0:06:05'),datenum('0:06:40');...
   % datenum('0:07:21'),datenum('0:08:38');...
    %datenum('0:10:45'),datenum('0:12:09');...
   % datenum('0:23:44'),datenum('0:24:05');];

targetIdx(:,1) = datenum(targetIdx(:,1))-floor(datenum(targetIdx(:,1)));
targetIdx(:,2) = datenum(targetIdx(:,2))-floor(datenum(targetIdx(:,2)));
baseline = datenum(OBDstartTime) - floor(datenum(OBDstartTime));
targetIdx(:,1) = targetIdx(:,1)+baseline;
targetIdx(:,2) = targetIdx(:,2)+baseline;
%%
Target =zeros(size(dataAll_cal(:,1)));

for i=1:length(targetIdx(:,1))
    index = find((dataAll_cal(:,1)>=(targetIdx(i,1)-startTime)*24*3600)&(dataAll_cal(:,1)<=(targetIdx(i,2)-startTime)*24*3600)&targetIdx(i,16)==1);       %%天宇 
    Target(index) = 1;     %%
    index = find((dataAll_cal(:,1)>=(targetIdx(i,1)-startTime)*24*3600)&(dataAll_cal(:,1)<=(targetIdx(i,2)-startTime)*24*3600)&targetIdx(i,16)==2);       %%天宇 
    Target(index) = 2;     %%
end

dataAll_cal = [dataAll_cal,Target];
save(strcat('synDataAll_new',num2str(m),'.mat'),'dataAll_cal','TextIndex','dataAll_ECG','dataAll_BELT');
end