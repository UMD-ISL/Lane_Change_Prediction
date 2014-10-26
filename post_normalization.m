%% Post_normalization

%% Description
%%
%  File type:    Executable file

%%
%  Summary:
%  5 Features:
%
% * raw data 
% * max value
% * min value
% * mean value
% * first order difference

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
%  Date:         Oct.17.2014
%  Revision:     0.1
%  Partner:      Worked with Tianyu Wang, Yulong Li
%  Copyright:    Intelligent System Laboratory
%                University of Michigan Dearborn

%% Initialization
clear all; clc; close all;
ini = IniConfig();
ini.ReadFile('configuration.ini');

home = ini.GetValues('Path Setting', 'HOME_PATH');
Data_Path = ini.GetValues('Path Setting', 'DATA_PATH');
% extract the varible 'num_lane_change', 'num_selected_signal', 'num_trips'
load(strcat(home, '/Synchronized_DataSet/statistics.mat'));

methods_fre     ={'welch'};         % ?      
feature_all     =[];                % malloc feature array
target          =[];                % malloc target array

feature_filter      = 1:45;      % total 45 features (9 signals * 5 attributes)
Invalid_feature     = [];
feature_filter      = setdiff(feature_filter,Invalid_feature);
feature_All         = {};
% video1={}; video2={}; video3={}; video4={}; video5={};
middle=[];  %?

%% Architecture and parameters of neural network (NN)
test_size               = 3;
hidden_nodes            = 15;
learning_rate           = 0.05;
step_size               = 1;
num_signal_attributes   = 5;

%% data descprition
time_before_lane_change = 20;
lane_change_size        = 20;
num_points_per_event    = 20;

%% feature calcuation configuration
window_size_cal         = 20;
window_size_ECG_raw     = 256 * 2;      % window size for ECG raw data is 256 because the sampling rate is 256 Hz
window_size_BELT_raw    = 26 * 2;       % window size for BELT raw data is 26 because the sampling rate is 26 Hz

FLAG_Redo_Feature_Generation   = false; % the falg to see if need redo feature geneartion procedure
%% Retrive the number of Lane Change

for m = 1:num_trips
    if true == FLAG_Redo_Feature_Generation
        break
    end
    
    %% PHASE: feature generation
    window_segment_cal  = {};            % use cell to store the cal_data in a window size
    window_segment_ECG  = {};            % use cell to store the ECG_data in a window size
    window_segment_BELT = {};            % use cell to store the BELT_data in a window size
    
    Feature     = {};
    feature     = [];
    featvec1    = [];
    load(strcat(home, '/Synchronized_Dataset/Vedio_',num2str(m),'_Synchronized_Data.mat'));
    
    % Adding Windows
    num_video_points    = size(data_All_cal,1);
    cal_before          = data_All_cal(window_size_cal - 1,:);     % save value 1 point before the last point in the window
    ECG_before          = data_All_ECG(window_size_ECG_raw - 1,:);
    BELT_before         = data_All_BELT(window_size_BELT_raw - 1,:);
    
    for k = 2:(num_selected_signal + 1)
        for j = 1:step_size:(num_video_points - (window_size_cal-1))                               
            windowIndex=[j:(j+(window_size_cal-1))];
            Signal=dataAll_cal(windowIndex,k);
            feature(1,1)=Signal(end,1);
            feature(1,2)=max(Signal);
            feature(1,3)=min(Signal);
            feature(1,4)=mean(Signal);
            feature(1,5)=Signal(end,1)-Signal(end-1,1);
            featvec1(j,:)=feature;    
        end
        Feature{k-1,1}=[dataAll_cal((window_size_cal:end),1),featvec1];
   end
       
  eval(strcat('L_cal',num2str(m),'=size(featvec1,1);'));
  save(strcat(rootIn,'\DataSet\feature_cal_',num2str(m),'.mat'),'Feature',strcat('L_cal',num2str(m)),'cal_before');    
   
   featvec1=[];
   Feature=[];
   feature=[];
    num_video_points=size(dataAll_ECG,1);
   for j=1:step_size:(num_video_points-(window_size_ECG_raw-1))                               
       windowIndex=[j:(j+(window_size_ECG_raw-1))];
   
        Signal=dataAll_ECG(windowIndex,2);
        feature(1,1)=Signal(end,1);
        feature(1,2)=max(Signal);
        feature(1,3)=min(Signal);
        feature(1,4)=mean(Signal);
        featvec1(j,:)=feature; 
    end
   Feature=[dataAll_ECG((window_size_ECG_raw:end),1),featvec1];
   eval(strcat('L_ECG',num2str(m),'=size(featvec1,1);'));
   save(strcat(rootIn,'\DataSet\feature_ECG_',num2str(m),'.mat'),'Feature',strcat('L_ECG',num2str(m)),'ECG_before');
   
   featvec1=[];
   Feature=[];
   feature=[];
   
    num_video_points=size(dataAll_BELT,1);
   for j=1:step_size:(num_video_points-(window_size_BELT_raw-1))                               
       windowIndex=[j:(j+(window_size_BELT_raw-1))];
       Signal=dataAll_BELT(windowIndex,2);
        feature(1,1)=Signal(end,1);
        feature(1,2)=max(Signal);
        feature(1,3)=min(Signal);
        feature(1,4)=mean(Signal);
        featvec1(j,:)=feature; 
   end
   Feature=[dataAll_BELT((window_size_BELT_raw:end),1),featvec1];
   eval(strcat('L_BELT',num2str(m),'=size(featvec1,1);'));
   save(strcat(rootIn,'\DataSet\feature_BELT_',num2str(m),'.mat'),'Feature',strcat('L_BELT',num2str(m)),'BELT_before');
end
    
% Combine five videos together
load(strcat(rootIn,'\DataSet\feature_cal_1.mat'));
feature_cal_1=Feature;
load(strcat(rootIn,'\DataSet\feature_ECG_1.mat'));
feature_ECG_1=Feature;
load(strcat(rootIn,'\DataSet\feature_BELT_1.mat'));
feature_BELT_1=Feature;

load(strcat(rootIn,'\DataSet\feature_cal_2.mat'));
feature_cal_2=Feature;
load(strcat(rootIn,'\DataSet\feature_ECG_2.mat'));
feature_ECG_2=Feature;
load(strcat(rootIn,'\DataSet\feature_BELT_2.mat'));
feature_BELT_2=Feature;

load(strcat(rootIn,'\DataSet\feature_cal_3.mat'));
feature_cal_3=Feature;
load(strcat(rootIn,'\DataSet\feature_ECG_3.mat'));
feature_ECG_3=Feature;
load(strcat(rootIn,'\DataSet\feature_BELT_3.mat'));
feature_BELT_3=Feature;

load(strcat(rootIn,'\DataSet\feature_cal_4.mat'));
feature_cal_4=Feature;
load(strcat(rootIn,'\DataSet\feature_ECG_4.mat'));
feature_ECG_4=Feature;
load(strcat(rootIn,'\DataSet\feature_BELT_4.mat'));
feature_BELT_4=Feature;

load(strcat(rootIn,'\DataSet\feature_cal_5.mat'));
feature_cal_5=Feature;
load(strcat(rootIn,'\DataSet\feature_ECG_5.mat'));
feature_ECG_5=Feature;
load(strcat(rootIn,'\DataSet\feature_BELT_5.mat'));
feature_BELT_5=Feature;

% Normalization all together
for m=1:NumberofSignalSelected
    featureAll_cal{m}=[feature_cal_1{m,1};feature_cal_2{m,1};feature_cal_3{m,1};feature_cal_4{m,1};feature_cal_5{m,1}];
    Media=featureAll_cal{m};
    for j=2:num_signal_attributes+1
        Media(:,j)=(Media(:,j)-min(Media(:,j)))./(max(Media(:,j))-min(Media(:,j)));
    end
    featureAll_cal{m}=Media;
end

featureAll_ECG=[feature_ECG_1;feature_ECG_2;feature_ECG_3;feature_ECG_4;feature_ECG_5];
    for j=2:Totalfeature+1
       featureAll_ECG(:,j)=(featureAll_ECG(:,j)-min(featureAll_ECG(:,j)))./(max(featureAll_ECG(:,j))-min(featureAll_ECG(:,j)));
    end
    
 
featureAll_BELT=[feature_BELT_1;feature_BELT_2;feature_BELT_3;feature_BELT_4;feature_BELT_5];
for j=2:Totalfeature+1
       featureAll_BELT(:,j)=(featureAll_BELT(:,j)-min(featureAll_BELT(:,j)))./(max(featureAll_BELT(:,j))-min(featureAll_BELT(:,j)));
end

% Seperate each video
for j=1:NumberofSignalSelected
    video=featureAll_cal{j};
    video_cal_1{j}=[zeros(window_size_cal-1,num_signal_attributes+1);video((1:L_cal1),:)];
    video_cal_2{j}=[zeros(window_size_cal-1,num_signal_attributes+1);video((L_cal1+1:L_cal2+L_cal1),:)];
    video_cal_3{j}=[zeros(window_size_cal-1,num_signal_attributes+1);video((L_cal1+L_cal2+1:L_cal2+L_cal1+L_cal3),:)];
    video_cal_4{j}=[zeros(window_size_cal-1,num_signal_attributes+1);video((L_cal1+L_cal2+L_cal3+1:L_cal2+L_cal1+L_cal3+L_cal4),:)];
    video_cal_5{j}=[zeros(window_size_cal-1,num_signal_attributes+1);video((L_cal1+L_cal2+L_cal3+L_cal4+1:L_cal2+L_cal1+L_cal3+L_cal4+L_cal5),:)];
end
for m=1:NumberofTrips
load(strcat(rootIn,'\DataSet\synDataAll_',num2str(m)));
eval(strcat('dataAll_cal_',num2str(m),'=dataAll_cal;'));
end
for m=1:NumberofSignalSelected
    video_cal_1{m}=[video_cal_1{m},dataAll_cal_1(:,end)];
    video_cal_2{m}=[video_cal_2{m},dataAll_cal_2(:,end)];
    video_cal_3{m}=[video_cal_3{m},dataAll_cal_3(:,end)];
    video_cal_4{m}=[video_cal_4{m},dataAll_cal_4(:,end)];
    video_cal_5{m}=[video_cal_5{m},dataAll_cal_5(:,end)];
end

video=[];
video=featureAll_ECG;
video_ECG_1=[zeros(window_size_ECG_raw-1,Totalfeature+1);video((1:L_ECG1),:)];
video_ECG_2=[zeros(window_size_ECG_raw-1,Totalfeature+1);video((L_ECG1+1:L_ECG2+L_ECG1),:)];
video_ECG_3=[zeros(window_size_ECG_raw-1,Totalfeature+1);video((L_ECG1+L_ECG2+1:L_ECG2+L_ECG1+L_ECG3),:)];
video_ECG_4=[zeros(window_size_ECG_raw-1,Totalfeature+1);video((L_ECG1+L_ECG2+L_ECG3+1:L_ECG2+L_ECG1+L_ECG3+L_ECG4),:)];
video_ECG_5=[zeros(window_size_ECG_raw-1,Totalfeature+1);video((L_ECG1+L_ECG2+L_ECG3+L_ECG4+1:L_ECG2+L_ECG1+L_ECG3+L_ECG4+L_ECG5),:)];

video=[];
video=featureAll_BELT;
video_BELT_1=[zeros(window_size_BELT_raw-1,Totalfeature+1);video((1:L_BELT1),:)];
video_BELT_2=[zeros(window_size_BELT_raw-1,Totalfeature+1);video((L_BELT1+1:L_BELT2+L_BELT1),:)];
video_BELT_3=[zeros(window_size_BELT_raw-1,Totalfeature+1);video((L_BELT1+L_BELT2+1:L_BELT2+L_BELT1+L_BELT3),:)];
video_BELT_4=[zeros(window_size_BELT_raw-1,Totalfeature+1);video((L_BELT1+L_BELT2+L_BELT3+1:L_BELT2+L_BELT1+L_BELT3+L_BELT4),:)];
video_BELT_5=[zeros(window_size_BELT_raw-1,Totalfeature+1);video((L_BELT1+L_BELT2+L_BELT3+L_BELT4+1:L_BELT2+L_BELT1+L_BELT3+L_BELT4+L_BELT5),:)];

video_ECG_1=[zeros(window_size_ECG_raw-1,num_signal_attributes);feature_ECG_1];
video_ECG_2=[zeros(window_size_ECG_raw-1,num_signal_attributes);feature_ECG_2];
video_ECG_3=[zeros(window_size_ECG_raw-1,num_signal_attributes);feature_ECG_3];
video_ECG_4=[zeros(window_size_ECG_raw-1,num_signal_attributes);feature_ECG_4];
video_ECG_5=[zeros(window_size_ECG_raw-1,num_signal_attributes);feature_ECG_5];


video_BELT_1=[zeros(window_size_BELT_raw-1,num_signal_attributes);feature_BELT_1];
video_BELT_2=[zeros(window_size_BELT_raw-1,num_signal_attributes);feature_BELT_2];
video_BELT_3=[zeros(window_size_BELT_raw-1,num_signal_attributes);feature_BELT_3];
video_BELT_4=[zeros(window_size_BELT_raw-1,num_signal_attributes);feature_BELT_4];
video_BELT_5=[zeros(window_size_BELT_raw-1,num_signal_attributes);feature_BELT_5];

% Time Matching(generalize for ECG signals)
[~,maxIndex]=max([size(video_ECG_1,1);size(video_ECG_2,1);size(video_ECG_3,1);size(video_ECG_4,1);size(video_ECG_5,1)]);
eval(strcat('max_video_ECG=video_ECG_',num2str(maxIndex),';'));
eval(strcat('max_video=video_cal_',num2str(maxIndex),'{1};'))
LookUpTable=[];
for m=window_size_cal:size(max_video,1)
    Time_sequence=max_video(:,1);
    MatchFrom=Time_sequence(m);
    [~,MatchTo_ECG]=min(abs(max_video_ECG(:,1)-MatchFrom));
    LookUpTable=[LookUpTable;[m,MatchTo_ECG]];
end

Index1=find(LookUpTable(:,1)==size(video_cal_1{1},1));
NEW_ECG1=video_ECG_1(LookUpTable(1:Index1,2),2:5);
NEW_ECG1=[zeros(window_size_cal-1,size(NEW_ECG1,2));NEW_ECG1];

Index2=find(LookUpTable(:,1)==size(video_cal_2{1},1));
NEW_ECG2=video_ECG_2(LookUpTable(1:Index2,2),2:5);
NEW_ECG2=[zeros(window_size_cal-1,size(NEW_ECG2,2));NEW_ECG2];

Index3=find(LookUpTable(:,1)==size(video_cal_3{1},1));
NEW_ECG3=video_ECG_3(LookUpTable(1:Index3,2),2:5);
NEW_ECG3=[zeros(window_size_cal-1,size(NEW_ECG3,2));NEW_ECG3];

Index4=find(LookUpTable(:,1)==size(video_cal_4{1},1));
NEW_ECG4=video_ECG_4(LookUpTable(1:Index4,2),2:5);
NEW_ECG4=[zeros(window_size_cal-1,size(NEW_ECG4,2));NEW_ECG4];

Index5=find(LookUpTable(:,1)==size(video_cal_5{1},1));
NEW_ECG5=video_ECG_5(LookUpTable(1:Index5,2),2:5);
NEW_ECG5=[zeros(window_size_cal-1,size(NEW_ECG5,2));NEW_ECG5];

video_cal_1=[video_cal_1,NEW_ECG1];
video_cal_2=[video_cal_2,NEW_ECG2];
video_cal_3=[video_cal_3,NEW_ECG3];
video_cal_4=[video_cal_4,NEW_ECG4];
video_cal_5=[video_cal_5,NEW_ECG5];

% Generalization for Belt signal
[~,maxIndex]=max([size(video_BELT_1,1);size(video_BELT_2,1);size(video_BELT_3,1);size(video_BELT_4,1);size(video_BELT_5,1)]);
eval(strcat('max_video_BELT=video_BELT_',num2str(maxIndex),';'));
eval(strcat('max_video=video_cal_',num2str(maxIndex),'{1};'))
LookUpTable=[];
for m=window_size_cal:size(max_video,1)
    Time_sequence=max_video(:,1);
    MatchFrom=Time_sequence(m);
    [~,MatchTo_BELT]=min(abs(max_video_BELT(:,1)-MatchFrom));
    LookUpTable=[LookUpTable;[m,MatchTo_BELT]];
end
Index1=find(LookUpTable(:,1)==size(video_cal_1{1},1));
NEW_BELT1=video_BELT_1(LookUpTable(1:Index1,2),2:5);
NEW_BELT1=[zeros(window_size_cal-1,size(NEW_BELT1,2));NEW_BELT1];

Index2=find(LookUpTable(:,1)==size(video_cal_2{1},1));
NEW_BELT2=video_ECG_2(LookUpTable(1:Index2,2),2:5);
NEW_BELT2=[zeros(window_size_cal-1,size(NEW_BELT2,2));NEW_BELT2];

Index3=find(LookUpTable(:,1)==size(video_cal_3{1},1));
NEW_BELT3=video_BELT_3(LookUpTable(1:Index3,2),2:5);
NEW_BELT3=[zeros(window_size_cal-1,size(NEW_BELT3,2));NEW_BELT3];

Index4=find(LookUpTable(:,1)==size(video_cal_4{1},1));
NEW_BELT4=video_BELT_4(LookUpTable(1:Index4,2),2:5);
NEW_BELT4=[zeros(window_size_cal-1,size(NEW_BELT4,2));NEW_BELT4];

Index5=find(LookUpTable(:,1)==size(video_cal_5{1},1));
NEW_BELT5=video_BELT_5(LookUpTable(1:Index5,2),2:5);
NEW_BELT5=[zeros(window_size_cal-1,size(NEW_BELT5,2));NEW_BELT5];

video1=[video_cal_1,NEW_BELT1];
video2=[video_cal_2,NEW_BELT2];
video3=[video_cal_3,NEW_BELT3];
video4=[video_cal_4,NEW_BELT4];
video5=[video_cal_5,NEW_BELT5];

% Calculate the x(t)-x(t-stepsize)
for m=1:NumberofTrips
    for j=1:2
      eval(strcat('signal=video',num2str(m),'{1,NumberofSignalSelected+j};')); 
      signal(:,5)=[0;diff(signal(:,1))];
      signal(20,5)=0;
      eval(strcat('video',num2str(m),'{1,NumberofSignalSelected+j}=signal;'))
    end
end

featureAll_ECG=[video1{:,8};video2{:,8};video3{:,8};video4{:,8};video5{:,8}];
    for j=1:num_signal_attributes
       featureAll_ECG(:,j)=(featureAll_ECG(:,j)-min(featureAll_ECG(:,j)))./(max(featureAll_ECG(:,j))-min(featureAll_ECG(:,j)));
    end

 
featureAll_BELT=[video1{:,9};video2{:,9};video3{:,9};video4{:,9};video5{:,9}];
for j=1:num_signal_attributes
       featureAll_BELT(:,j)=(featureAll_BELT(:,j)-min(featureAll_BELT(:,j)))./(max(featureAll_BELT(:,j))-min(featureAll_BELT(:,j)));
end

L1=size(video1{1,1},1);
L2=size(video2{1,1},1);
L3=size(video3{1,1},1);
L4=size(video4{1,1},1);
L5=size(video5{1,1},1);
video=[];
video=featureAll_ECG;
video_ECG_1=video((1:L1),:);
video_ECG_2=video((L1+1:L2+L1),:);
video_ECG_3=video((L1+L2+1:L2+L1+L3),:);
video_ECG_4=video((L1+L2+L3+1:L2+L1+L3+L4),:);
video_ECG_5=video((L1+L2+L3+L4+1:L2+L1+L3+L4+L5),:);

video1{1,8}=video_ECG_1;
video2{1,8}=video_ECG_2;
video3{1,8}=video_ECG_3;
video4{1,8}=video_ECG_4;
video5{1,8}=video_ECG_5;

video=[];
video=featureAll_BELT;
video_BELT_1=video((1:L1),:);
video_BELT_2=video((L1+1:L2+L1),:);
video_BELT_3=video((L1+L2+1:L2+L1+L3),:);
video_BELT_4=video((L1+L2+L3+1:L2+L1+L3+L4),:);
video_BELT_5=video((L1+L2+L3+L4+1:L2+L1+L3+L4+L5),:);
video1{1,9}=video_BELT_1;
video2{1,9}=video_BELT_2;
video3{1,9}=video_BELT_3;
video4{1,9}=video_BELT_4;
video5{1,9}=video_BELT_5;
for m=1:NumberofTrips
    for j=8:9
        eval(strcat('video=','video',num2str(m),'{1,j};'));
        video=[zeros(size(video,1),1),video,zeros(size(video,1),1)];
        eval(strcat('video',num2str(m),'{1,j}=video;'));
    end
end
save(strcat(Outroot_origin,'\DataSet\video_final.mat'),'video1','video2','video3','video4','video5');
% Extract Lane-Change period
load(strcat(Outroot_origin,'\DataSet\video_final.mat'));
for j=1:NumberofTrips

eval(strcat('dataAll_cell=video',num2str(j),';'));
dataAll=dataAll_cell{1};
targetindex1=find(dataAll(:,end)==1);
targetindex2=find(dataAll(:,end)==2);
ID1=[];
ID2=[];
for m=1:length(targetindex1)-1
    if(m==1)
    ID1=targetindex1(1);
    end
    if(targetindex1(m+1)>targetindex1(m)+2)
    ID1=[ID1,targetindex1(m+1)];
    end
end
for m=1:length(targetindex2)-1
    if(m==1)
    ID2=targetindex2(1);
    end
    if(targetindex2(m+1)>targetindex2(m)+2)
    ID2=[ID2,targetindex2(m+1)];
    end
end
LaneChangeOldInd=ID1/10;
NolangechangeInd=ID2/10;
NoLane=NolangechangeInd*10+1-time_before_LC;
LaneBefore=LaneChangeOldInd*10+1-time_before_LC;% at this time
[x1,y1]=size(LaneBefore);
[x2,y2]=size(NoLane);
NumberofSignalSelected=9;
for m=1:NumberofSignalSelected
    eval(strcat('invoker=video',num2str(j),'{1,i};'));
    for index=1:y1
        pointIndex=LaneBefore(index);
        middle=[middle;invoker((pointIndex:(pointIndex+lanechangesize-1)),2:6)];
    end
    eval(strcat('video',num2str(j),'{2,i}=middle;'));
    middle=[];
end

for m=1:NumberofSignalSelected
    eval(strcat('invoker=video',num2str(j),'{1,i};'));
    eval(strcat('middle=video',num2str(j),'{2,i};'));
    for index=1:y2
        pointIndex=NoLane(index); 
        middle=[middle;invoker((pointIndex:(pointIndex+lanechangesize-1)),2:6)];
    end
    eval(strcat('video',num2str(j),'{2,i}=middle;'));
    middle=[];
end
end
feature=[video1{2,WhichSignal};video2{2,WhichSignal};video3{2,WhichSignal};video4{2,WhichSignal};video5{2,WhichSignal}];
K1=size(video1{2,WhichSignal},1);
K2=size(video2{2,WhichSignal},1);
K3=size(video3{2,WhichSignal},1);
K4=size(video4{2,WhichSignal},1);
K5=size(video5{2,WhichSignal},1);
Target=[ones(1,K1/3),zeros(1,K1*2/3),ones(1,K2/3),zeros(1,K2*2/3),ones(1,K3/3),zeros(1,K3*2/3),ones(1,K4/3),zeros(1,K4*2/3),ones(1,K5/3),zeros(1,K5*2/3)]';
save(strcat(rootIn,'\DataSet\video.mat'),'video1','video2','video3','video4','video5');
