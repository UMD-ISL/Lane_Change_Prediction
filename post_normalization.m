clear; clc;
warning off;
%% Granger Causality Analysis
%% define variables
rootIn='N:\tianyu\code1\';
Outroot_origin='N:\tianyu\code1\';
TotalLaneChange=31;%% Need to verify
NumberLCTest=3;
hiddenNodes=[15];
learnRates=[0.05];
NumberofSignalSelected=7;
NumberofTrips=5;
methods_fre={'welch'}; 
% WhichSignal=1;         
feature=[];
Target=[];
FeatureFilter=[1:45];
featureAll={};
stepsize=1;
Totalfeature=5;
video1={};
video2={};
video3={};
video4={};
video5={};
TbeforeLC=20;
lanechangesize=20;
NumberofPoints_on_event=20;%% Need to verify
skip=1; %%Need to verify!!
middle=[];
window_size_cal=20;
window_size_ECG_raw=256*2;
window_size_BELT_raw=26*2;
NumberofFeatures=5;

for i=1:NumberofTrips
    if skip==1
        break
    end
    i
    windowSegment_cal={};
    windowSegment_ECG={};
    windowSegment_BELT={};
    Feature={};
    feature=[];
    featvec1=[];
    load(strcat(rootIn,'synDataAll_',num2str(i),'.mat'));
    
    %% Adding Windows
    LengthVideo=size(dataAll_cal,1);
    cal_before=dataAll_cal(window_size_cal-1,:);%save value 1 point before
    ECG_before=dataAll_ECG(window_size_ECG_raw-1,:);
    BELT_before=dataAll_BELT(window_size_BELT_raw-1,:);
   for k=2:NumberofSignalSelected+1
   for j=1:stepsize:(LengthVideo-(window_size_cal-1))                               
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
       
  eval(strcat('L_cal',num2str(i),'=size(featvec1,1);'));
  save(strcat(rootIn,'feature_cal_',num2str(i),'.mat'),'Feature',strcat('L_cal',num2str(i)),'cal_before');    
   
   featvec1=[];
   Feature=[];
   feature=[];
    LengthVideo=size(dataAll_ECG,1);
   for j=1:stepsize:(LengthVideo-(window_size_ECG_raw-1))                               
       windowIndex=[j:(j+(window_size_ECG_raw-1))];
   
        Signal=dataAll_ECG(windowIndex,2);
        feature(1,1)=Signal(end,1);
        feature(1,2)=max(Signal);
        feature(1,3)=min(Signal);
        feature(1,4)=mean(Signal);
        featvec1(j,:)=feature; 
    end
   Feature=[dataAll_ECG((window_size_ECG_raw:end),1),featvec1];
   eval(strcat('L_ECG',num2str(i),'=size(featvec1,1);'));
   save(strcat(rootIn,'feature_ECG_',num2str(i),'.mat'),'Feature',strcat('L_ECG',num2str(i)),'ECG_before');
   
   featvec1=[];
   Feature=[];
    feature=[];
    LengthVideo=size(dataAll_BELT,1);
   for j=1:stepsize:(LengthVideo-(window_size_BELT_raw-1))                               
       windowIndex=[j:(j+(window_size_BELT_raw-1))];
       Signal=dataAll_BELT(windowIndex,2);
        feature(1,1)=Signal(end,1);
        feature(1,2)=max(Signal);
        feature(1,3)=min(Signal);
        feature(1,4)=mean(Signal);
        featvec1(j,:)=feature; 
   end
   Feature=[dataAll_BELT((window_size_BELT_raw:end),1),featvec1];
   eval(strcat('L_BELT',num2str(i),'=size(featvec1,1);'));
   save(strcat(rootIn,'feature_BELT_',num2str(i),'.mat'),'Feature',strcat('L_BELT',num2str(i)),'BELT_before');
end
    
%% Combine five videos together
load(strcat(rootIn,'feature_cal_1.mat'));
feature_cal_1=Feature;
load(strcat(rootIn,'feature_ECG_1.mat'));
feature_ECG_1=Feature;
load(strcat(rootIn,'feature_BELT_1.mat'));
feature_BELT_1=Feature;

load(strcat(rootIn,'feature_cal_2.mat'));
feature_cal_2=Feature;
load(strcat(rootIn,'feature_ECG_2.mat'));
feature_ECG_2=Feature;
load(strcat(rootIn,'feature_BELT_2.mat'));
feature_BELT_2=Feature;

load(strcat(rootIn,'feature_cal_3.mat'));
feature_cal_3=Feature;
load(strcat(rootIn,'feature_ECG_3.mat'));
feature_ECG_3=Feature;
load(strcat(rootIn,'feature_BELT_3.mat'));
feature_BELT_3=Feature;

load(strcat(rootIn,'feature_cal_4.mat'));
feature_cal_4=Feature;
load(strcat(rootIn,'feature_ECG_4.mat'));
feature_ECG_4=Feature;
load(strcat(rootIn,'feature_BELT_4.mat'));
feature_BELT_4=Feature;

load(strcat(rootIn,'feature_cal_5.mat'));
feature_cal_5=Feature;
load(strcat(rootIn,'feature_ECG_5.mat'));
feature_ECG_5=Feature;
load(strcat(rootIn,'feature_BELT_5.mat'));
feature_BELT_5=Feature;

%% Normalization all together
for i=1:NumberofSignalSelected
    featureAll_cal{i}=[feature_cal_1{i,1};feature_cal_2{i,1};feature_cal_3{i,1};feature_cal_4{i,1};feature_cal_5{i,1}];
    Media=featureAll_cal{i};
    for j=2:Totalfeature+1
        Media(:,j)=(Media(:,j)-min(Media(:,j)))./(max(Media(:,j))-min(Media(:,j)));
    end
    featureAll_cal{i}=Media;
end

% featureAll_ECG=[feature_ECG_1;feature_ECG_2;feature_ECG_3;feature_ECG_4;feature_ECG_5];
%     for j=2:Totalfeature+1
%        featureAll_ECG(:,j)=(featureAll_ECG(:,j)-min(featureAll_ECG(:,j)))./(max(featureAll_ECG(:,j))-min(featureAll_ECG(:,j)));
%     end
% 
%  
% featureAll_BELT=[feature_BELT_1;feature_BELT_2;feature_BELT_3;feature_BELT_4;feature_BELT_5];
% for j=2:Totalfeature+1
%        featureAll_BELT(:,j)=(featureAll_BELT(:,j)-min(featureAll_BELT(:,j)))./(max(featureAll_BELT(:,j))-min(featureAll_BELT(:,j)));
% end

%% Seperate each video
for j=1:NumberofSignalSelected
    video=featureAll_cal{j};
    video_cal_1{j}=[zeros(window_size_cal-1,Totalfeature+1);video((1:L_cal1),:)];
    video_cal_2{j}=[zeros(window_size_cal-1,Totalfeature+1);video((L_cal1+1:L_cal2+L_cal1),:)];
    video_cal_3{j}=[zeros(window_size_cal-1,Totalfeature+1);video((L_cal1+L_cal2+1:L_cal2+L_cal1+L_cal3),:)];
    video_cal_4{j}=[zeros(window_size_cal-1,Totalfeature+1);video((L_cal1+L_cal2+L_cal3+1:L_cal2+L_cal1+L_cal3+L_cal4),:)];
    video_cal_5{j}=[zeros(window_size_cal-1,Totalfeature+1);video((L_cal1+L_cal2+L_cal3+L_cal4+1:L_cal2+L_cal1+L_cal3+L_cal4+L_cal5),:)];
end
for i=1:NumberofTrips
load(strcat(rootIn,'synDataAll_',num2str(i)));
eval(strcat('dataAll_cal_',num2str(i),'=dataAll_cal;'));
end
for i=1:NumberofSignalSelected
    video_cal_1{i}=[video_cal_1{i},dataAll_cal_1(:,end)];
    video_cal_2{i}=[video_cal_2{i},dataAll_cal_2(:,end)];
    video_cal_3{i}=[video_cal_3{i},dataAll_cal_3(:,end)];
    video_cal_4{i}=[video_cal_4{i},dataAll_cal_4(:,end)];
    video_cal_5{i}=[video_cal_5{i},dataAll_cal_5(:,end)];
end

% video=[];
% video=featureAll_ECG;
% video_ECG_1=[zeros(window_size_ECG_raw-1,Totalfeature+1);video((1:L_ECG1),:)];
% video_ECG_2=[zeros(window_size_ECG_raw-1,Totalfeature+1);video((L_ECG1+1:L_ECG2+L_ECG1),:)];
% video_ECG_3=[zeros(window_size_ECG_raw-1,Totalfeature+1);video((L_ECG1+L_ECG2+1:L_ECG2+L_ECG1+L_ECG3),:)];
% video_ECG_4=[zeros(window_size_ECG_raw-1,Totalfeature+1);video((L_ECG1+L_ECG2+L_ECG3+1:L_ECG2+L_ECG1+L_ECG3+L_ECG4),:)];
% video_ECG_5=[zeros(window_size_ECG_raw-1,Totalfeature+1);video((L_ECG1+L_ECG2+L_ECG3+L_ECG4+1:L_ECG2+L_ECG1+L_ECG3+L_ECG4+L_ECG5),:)];
% 
% video=[];
% video=featureAll_BELT;
% video_BELT_1=[zeros(window_size_BELT_raw-1,Totalfeature+1);video((1:L_BELT1),:)];
% video_BELT_2=[zeros(window_size_BELT_raw-1,Totalfeature+1);video((L_BELT1+1:L_BELT2+L_BELT1),:)];
% video_BELT_3=[zeros(window_size_BELT_raw-1,Totalfeature+1);video((L_BELT1+L_BELT2+1:L_BELT2+L_BELT1+L_BELT3),:)];
% video_BELT_4=[zeros(window_size_BELT_raw-1,Totalfeature+1);video((L_BELT1+L_BELT2+L_BELT3+1:L_BELT2+L_BELT1+L_BELT3+L_BELT4),:)];
% video_BELT_5=[zeros(window_size_BELT_raw-1,Totalfeature+1);video((L_BELT1+L_BELT2+L_BELT3+L_BELT4+1:L_BELT2+L_BELT1+L_BELT3+L_BELT4+L_BELT5),:)];

video_ECG_1=[zeros(window_size_ECG_raw-1,Totalfeature);feature_ECG_1];
video_ECG_2=[zeros(window_size_ECG_raw-1,Totalfeature);feature_ECG_2];
video_ECG_3=[zeros(window_size_ECG_raw-1,Totalfeature);feature_ECG_3];
video_ECG_4=[zeros(window_size_ECG_raw-1,Totalfeature);feature_ECG_4];
video_ECG_5=[zeros(window_size_ECG_raw-1,Totalfeature);feature_ECG_5];


video_BELT_1=[zeros(window_size_BELT_raw-1,Totalfeature);feature_BELT_1];
video_BELT_2=[zeros(window_size_BELT_raw-1,Totalfeature);feature_BELT_2];
video_BELT_3=[zeros(window_size_BELT_raw-1,Totalfeature);feature_BELT_3];
video_BELT_4=[zeros(window_size_BELT_raw-1,Totalfeature);feature_BELT_4];
video_BELT_5=[zeros(window_size_BELT_raw-1,Totalfeature);feature_BELT_5];

%% Time Matching(generalize for ECG signals)
[~,maxIndex]=max([size(video_ECG_1,1);size(video_ECG_2,1);size(video_ECG_3,1);size(video_ECG_4,1);size(video_ECG_5,1)]);
eval(strcat('max_video_ECG=video_ECG_',num2str(maxIndex),';'));
eval(strcat('max_video=video_cal_',num2str(maxIndex),'{1};'))
LookUpTable=[];
for i=window_size_cal:size(max_video,1)
    Time_sequence=max_video(:,1);
    MatchFrom=Time_sequence(i);
    [~,MatchTo_ECG]=min(abs(max_video_ECG(:,1)-MatchFrom));
    LookUpTable=[LookUpTable;[i,MatchTo_ECG]];
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

%% Generalization for Belt signal
[~,maxIndex]=max([size(video_BELT_1,1);size(video_BELT_2,1);size(video_BELT_3,1);size(video_BELT_4,1);size(video_BELT_5,1)]);
eval(strcat('max_video_BELT=video_BELT_',num2str(maxIndex),';'));
eval(strcat('max_video=video_cal_',num2str(maxIndex),'{1};'))
LookUpTable=[];
for i=window_size_cal:size(max_video,1)
    Time_sequence=max_video(:,1);
    MatchFrom=Time_sequence(i);
    [~,MatchTo_BELT]=min(abs(max_video_BELT(:,1)-MatchFrom));
    LookUpTable=[LookUpTable;[i,MatchTo_BELT]];
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

%% Calculate the x(t)-x(t-stepsize)
for i=1:NumberofTrips
    for j=1:2
      eval(strcat('signal=video',num2str(i),'{1,NumberofSignalSelected+j};')); 
      signal(:,5)=[0;diff(signal(:,1))];
      signal(20,5)=0;
      eval(strcat('video',num2str(i),'{1,NumberofSignalSelected+j}=signal;'))
    end
end

featureAll_ECG=[video1{:,8};video2{:,8};video3{:,8};video4{:,8};video5{:,8}];
    for j=1:Totalfeature
       featureAll_ECG(:,j)=(featureAll_ECG(:,j)-min(featureAll_ECG(:,j)))./(max(featureAll_ECG(:,j))-min(featureAll_ECG(:,j)));
    end

 
featureAll_BELT=[video1{:,9};video2{:,9};video3{:,9};video4{:,9};video5{:,9}];
for j=1:Totalfeature
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
for i=1:NumberofTrips
    for j=8:9
        eval(strcat('video=','video',num2str(i),'{1,j};'));
        video=[zeros(size(video,1),1),video,zeros(size(video,1),1)];
        eval(strcat('video',num2str(i),'{1,j}=video;'));
    end
end
save(strcat(Outroot_origin,'video_final.mat'),'video1','video2','video3','video4','video5');
%% Extract Lane-Change period 
load(strcat(Outroot_origin,'video_final.mat'));
for j=1:NumberofTrips

eval(strcat('dataAll_cell=video',num2str(j),';'));
dataAll=dataAll_cell{1};
targetindex1=find(dataAll(:,end)==1);
targetindex2=find(dataAll(:,end)==2);
ID1=[];
ID2=[];
for i=1:length(targetindex1)-1
    if(i==1)
    ID1=targetindex1(1);
    end
    if(targetindex1(i+1)>targetindex1(i)+2)
    ID1=[ID1,targetindex1(i+1)];
    end
end
for i=1:length(targetindex2)-1
    if(i==1)
    ID2=targetindex2(1);
    end
    if(targetindex2(i+1)>targetindex2(i)+2)
    ID2=[ID2,targetindex2(i+1)];
    end
end
LaneChangeOldInd=ID1/10;
NolangechangeInd=ID2/10;
NoLane=NolangechangeInd*10+1-TbeforeLC;
LaneBefore=LaneChangeOldInd*10+1-TbeforeLC;% at this time
[x1,y1]=size(LaneBefore);
[x2,y2]=size(NoLane);
NumberofSignalSelected=9;
for i=1:NumberofSignalSelected
    eval(strcat('invoker=video',num2str(j),'{1,i};'));
    for index=1:y1
        pointIndex=LaneBefore(index);
        middle=[middle;invoker((pointIndex:(pointIndex+lanechangesize-1)),2:6)];
    end
    eval(strcat('video',num2str(j),'{2,i}=middle;'));
    middle=[];
end

for i=1:NumberofSignalSelected
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
% feature=[video1{2,WhichSignal};video2{2,WhichSignal};video3{2,WhichSignal};video4{2,WhichSignal};video5{2,WhichSignal}];
% K1=size(video1{2,WhichSignal},1);
% K2=size(video2{2,WhichSignal},1);
% K3=size(video3{2,WhichSignal},1);
% K4=size(video4{2,WhichSignal},1);
% K5=size(video5{2,WhichSignal},1);
% Target=[ones(1,K1/3),zeros(1,K1*2/3),ones(1,K2/3),zeros(1,K2*2/3),ones(1,K3/3),zeros(1,K3*2/3),ones(1,K4/3),zeros(1,K4*2/3),ones(1,K5/3),zeros(1,K5*2/3)]';
save(strcat(rootIn,'video.mat'),'video1','video2','video3','video4','video5');

test(rootIn,Outroot_origin,NumberofPoints_on_event,TotalLaneChange,hiddenNodes,learnRates,FeatureFilter,NumberLCTest)




% [~,signalsnum]=size(feature);
% pvalue=[];
% Final_Pvalue=cell(1,NumberofFeatures);
% for i=1:signalsnum
% %     [pVal]=granger_cause(Target,features(:,i),0.05,6);
%     [pVal]=granger_cause_ARMA(Target,feature(:,i),0.05,6);
%     pvalue=[pvalue,pVal];
% end

