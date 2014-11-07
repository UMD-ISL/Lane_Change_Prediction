%% signal_preprocessing.m

%% Description
%  File type:       Procedure
%
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
%               University of Michigan Dearborn

clear all; clc; close all;
ini = IniConfig();
ini.ReadFile('configuration.ini');

home = ini.GetValues('Path Setting', 'HOME_PATH');
Data_Path = ini.GetValues('Path Setting', 'DATA_PATH');

%% Experiment setting
% get num_lane_change by loading 'statistic.mat'
load(strcat(home, '/Synchronized_DataSet/statistics.mat'));
% num_lane_change
num_points_per_event    = 20;
hiddenNodes             = 15;
learning_rate           = 0.1;      % MODIFY IT
train_test_ratio        = 1/3;
feature_filter          = 1:45;     % nine signal * 5 features
num_features            = length(feature_filter);

EventPool       = [];
NoEventPool     = [];

result          = cell(1,20);
NofFeature      = length(FeatureFilter);
IndexofLC       = [];
Feature         = [];

true_positive   = 0;
true_negative   = 0;
false_positive  = 0;
false_negative  = 0;

%%
load(strcat(Inroot,'video.mat'));
for i=1:size(video1,2)
    Feature=[Feature,video1{2,i}];
end
train319=Feature(:,FeatureFilter)';

[~,c]=size(train319);
NumberofEvent=c/NumberofPoints_on_event*ratio;
for j=1:NumberofEvent
    EventPool=[EventPool,{train319(:,(((j-1)*NumberofPoints_on_event+1)):(j*NumberofPoints_on_event))}];
end
%
for j=1:(NumberofEvent*2)
    NoEventPool=[NoEventPool,{train319(:,(((NumberofEvent+j-1)*NumberofPoints_on_event)+1):((NumberofEvent+j)*NumberofPoints_on_event))}];
end
% %%
Feature=[];
for i=1:size(video2,2)
    Feature=[Feature,video2{2,i}];
end
train321=Feature(:,FeatureFilter)';

[~,c]=size(train321);
NumberofEvent=c/NumberofPoints_on_event*ratio;
for j=1:NumberofEvent
    EventPool=[EventPool,{train321(:,(((j-1)*NumberofPoints_on_event+1)):j*NumberofPoints_on_event)}];
end

for j=1:(NumberofEvent*2)
    NoEventPool=[NoEventPool,{train321(:,(((NumberofEvent+j-1)*NumberofPoints_on_event)+1):(NumberofEvent+j)*NumberofPoints_on_event)}];
end
% %%
Feature=[];
for i=1:size(video3,2)
    Feature=[Feature,video3{2,i}];
end
train318=Feature(:,FeatureFilter)';
[~,c]=size(train318);
NumberofEvent=c/NumberofPoints_on_event*ratio;
for j=1:NumberofEvent
    EventPool=[EventPool,{train318(:,(((j-1)*NumberofPoints_on_event+1)):j*NumberofPoints_on_event)}];
end

for j=1:(NumberofEvent*2)
    NoEventPool=[NoEventPool,{train318(:,(((NumberofEvent+j-1)*NumberofPoints_on_event)+1):(NumberofEvent+j)*NumberofPoints_on_event)}];
end
% %%
Feature=[];
for i=1:size(video4,2)
    Feature=[Feature,video4{2,i}];
end
train320=Feature(:,FeatureFilter)';
%
[~,c]=size(train320);
NumberofEvent=c/NumberofPoints_on_event*ratio;
for j=1:NumberofEvent
    EventPool=[EventPool,{train320(:,(((j-1)*NumberofPoints_on_event+1)):j*NumberofPoints_on_event)}];
end

for j=1:(NumberofEvent*2)
    NoEventPool=[NoEventPool,{train320(:,(((NumberofEvent+j-1)*NumberofPoints_on_event)+1):(NumberofEvent+j)*NumberofPoints_on_event)}];
end
% %%
Feature=[];
for i=1:size(video5,2)
    Feature=[Feature,video5{2,i}];
end
train325=Feature(:,FeatureFilter)';

%
[~,c]=size(train325);
NumberofEvent=c/NumberofPoints_on_event*ratio;
for j=1:NumberofEvent
    EventPool=[EventPool,{train325(:,(((j-1)*NumberofPoints_on_event+1)):j*NumberofPoints_on_event)}];
end

for j=1:(NumberofEvent*2)
    NoEventPool=[NoEventPool,{train325(:,(((NumberofEvent+j-1)*NumberofPoints_on_event)+1):(NumberofEvent+j)*NumberofPoints_on_event)}];
end











load('Index_test_10_folder.mat');
for k=1:10
    k
    for mmm=1:length(hiddenNodes)
        for nnn=1:length(learnRates)
            netConfig.hidNodes=hiddenNodes(mmm);
            netConfig.lr = learnRates(nnn);
            netConfig.goal = 1e-10;
            netConfig.outNodes = 2;
            netConfig.epochs = 1000;
            % 10 test version
%             RandomSequence=randperm(TotalLaneChange);
%             IndexofLC=RandomSequence(1:NumberLCTest)
%             
%             FF=1:TotalLaneChange;
%             Except=setdiff(FF,IndexofLC);
%             
%             
%             IndexofNLC=RandomSequence(1:(NumberLCTest*2))
%             NFF=1:(TotalLaneChange*2);
%             NExcept=setdiff(NFF,IndexofNLC);
%             
%             
%             testingInput=[EventPool{:,IndexofLC},NoEventPool{:,IndexofNLC}];
%             Targetground=[ones(1,size(testingInput,2)*ratio),zeros(1,size(testingInput,2)*(1-ratio))];
%             trainingInput=[EventPool{:,Except},NoEventPool{:,NExcept}];
%             trainingground=[ones(1,(size(trainingInput,2)*ratio)),zeros(1,(size(trainingInput,2)*(1-ratio)))];
%             refertrain=1-trainingground;
%             trainingTarget=[trainingground;refertrain];
%             refertest=1-Targetground;
%             testingTarget=[Targetground;refertest];
            
              %test version temporary
            
            IndexofLC=IndexLC(k,:);
            FF=1:TotalLaneChange;
            Except=setdiff(FF,IndexofLC);
            IndexofNLC=IndexNLC(k,:);
            NFF=1:(TotalLaneChange*2);
            NExcept=setdiff(NFF,IndexofNLC);
            testingInput=[EventPool{:,IndexofLC},NoEventPool{:,IndexofNLC}];
            Targetground=[ones(1,size(testingInput,2)*ratio),zeros(1,size(testingInput,2)*(1-ratio))];
            trainingInput=[EventPool{:,Except},NoEventPool{:,NExcept}];
            trainingground=[ones(1,(size(trainingInput,2)*ratio)),zeros(1,(size(trainingInput,2)*(1-ratio)))];
%             refertrain=1-trainingground;
%             trainingTarget=[trainingground;refertrain];
%             refertest=1-Targetground;
%             testingTarget=[Targetground;refertest];
			 
  
%% training NN  
			speed_nn = NNBuilder2(trainingInput, trainingground, testingInput, Targetground, netConfig);
            [netTrained, tr] = speed_nn.trainNN(speed_nn.net);
            save(strcat(Outroot_origin,'TrainedNN\','trainedNN',num2str(k),'.mat'),'netTrained');
                        trainingOutput = sim(netTrained, trainingInput);
			flag_size=size(trainingOutput);
			flag_length=flag_size(1,2);
			i_tr=1;
            OutputflagTr=[];  
			for i_tr=1:flag_length                                       %if training output is over 0.5 regard as class 1
			                                                            %if training output is less than 0.5 regard as class 0
			    if(trainingOutput(1,i_tr)>=0.5)
				   OutputflagTr(i_tr)=1;
				   
				 else
				 OutputflagTr(i_tr)=0;
				 end
				   
			end
			
			
            trainingErrorAll=(OutputflagTr-trainingground);
            trainingError = trainingErrorAll(abs(trainingErrorAll)>0.1);            %error which is class 1 predict as class 0
			                                                                                        %class 0 predict as class 1
         
%% testing NN
            testingOutput = sim(netTrained, testingInput);
			
				flag_size=size(testingOutput);
			flag_length=flag_size(1,2);
			i_ts=1; 
            OutputflagTs=[];
			for i_ts=1:flag_length                                       %if training output is over 0.5 regard as class 1
			                                                            %if training output is less than 0.5 regard as class 0
			      if(testingOutput(1,i_ts)>=0.5)
				   OutputflagTs(i_ts)=1;
				   
				 else
				 OutputflagTs(i_ts)=0;
				 end
				   
			end
			
            testingErrorAll =(OutputflagTs-Targetground);
            testingError = testingErrorAll(abs(testingErrorAll)>0.1);
            
      %      disp(['day: ' num2str(days(lll)) ' hn: ' num2str(hiddenNodes(mmm)) ...
       %      ' lr: ' num2str(learnRates(nnn))]);
      %      trainingCnt = size(trainingInput,2);
       %     trCnt = size(trainingError,2);
      %      disp(['training: ' num2str(trainingCnt) ' error: ' num2str(trCnt) ...
       %       ' rate: ' num2str(trCnt/trainingCnt)])
     %       testingCnt = size(testingInput,2);
     %        teCnt = size(testingError,2);
    %        disp(['testing: ' num2str(testingCnt) ' error: ' num2str(teCnt) ...
     %     ' rate: ' num2str(teCnt/testingCnt)]);
      %      disp('---------------------------------------------------------------');
      %      save(filePath);
        end
		
		
    end
        
figure1=figure;plot(OutputflagTs,'.');hold on;plot(Targetground,'r');title('testing Result');
% figure(2);plot(OutputflagTr,'.');hold on;plot(trainingTarget(1,:),'r');title('training Result');
% figure(3);plot(testingOutput(1,:));hold on;plot(testingOutput(2,:),'r');title('testing output');
% figure(4);plot(trainingOutput(1,:));hold on;plot(trainingOutput(2,:),'r');title('training output');
ratio_train=1-size(trainingError,2)/size(trainingErrorAll,2)
ratio_test=1-size(testingError,2)/size(testingErrorAll,2)
% plotroc(Targetground,OutputflagTs);
% [auc,~]=roc_auc(OutputflagTs,Targetground,1,0);
% auc
NumberLCTest=size(IndexofLC,2);
Result=zeros(2*NumberLCTest,2*NumberLCTest);
Result(1:2,1)=[ratio_train;ratio_test];
Result(1:3,2)=IndexofLC';
Result(:,3)=IndexofNLC';
result{1,k}=Result;
saveas(figure1,strcat(Outroot_origin,'Figure\','test_',num2str(k)),'fig');
close(figure1);
%% plot confusion matrix
Total_length=size(OutputflagTs,2);
one_third=OutputflagTs(1,1:Total_length*ratio);
two_third=OutputflagTs(1,(Total_length*ratio+1):end);
LC_LC=LC_LC+size(find(one_third==1),2);
LC_NLC=LC_NLC+size(find(one_third==0),2);
NLC_LC=NLC_LC+size(find(two_third==1),2);
NLC_NLC=NLC_NLC+size(find(two_third==0),2);

end




save(strcat(Outroot_origin,'result.mat'),'result','LC_LC','LC_NLC','NLC_LC','NLC_NLC');

% for i=1:TestTimes
%     eachresult=result{1,i};
%     testingresult(i,1)=eachresult(2,1);
%     testingresultPP(i,1)=eachresult(3,1);
% end
% meantestingresult=mean(testingresult);
% meantestingresultPP=mean(testingresultPP);
% finalresult=[meantestingresult,meantestingresultPP];
% save(strcat(Outroot_origin,'AverageResult.mat'),'finalresult');
% event=length(OutputflagTs)/20;
% Outevent=[];
% eve_id=1;
% idid=1;
% for idid=1:event
%     vote=sum(OutputflagTs(eve_id:eve_id+19));
%     if(vote>10)
%         Outevent=[Outevent,ones(1,20)];
%     
%     else
%         Outevent=[Outevent,zeros(1,20)];
%     
%     end
%      eve_id=eve_id+20;
% end
% 
%  testingErrorAll =(Outevent-testingTarget(1,:));
%   testingError = testingErrorAll(abs(testingErrorAll)>0.1);
% 
%  post_processing_ratio_test=1-size(testingError,2)/size(testingErrorAll,2);
%  if post_processing_ratio_test <= ratio_test
%      post_processing_ratio_test=ratio_test;
%  end
%  post_processing_ratio_test
% figure2=figure;plot(Outevent,'.');hold on;plot(testingTarget(1,:),'r');title('final period Result');
% Result=zeros(NumberLCTest,NumberLCTest);
% Result(1:3,1)=[ratio_train;ratio_test;post_processing_ratio_test];
% Result(:,2)=IndexofLC';
% result{1,k}=Result;
% saveas(figure1,strcat(Outroot_origin,'test_',num2str(k)),'fig');
% saveas(figure2,strcat(Outroot_origin,'test-PP_',num2str(k)),'fig');
% close(figure1);
% close(figure2);
%error analysis  when class is 1 and when class is 0
% OutputflagTs,testingTarget(1,:)
% OutputflagTr,testingTarget(1,:)
%testing errro
% testingErrorAll =(OutputflagTs-testingTarget(1,:));
% class1ts=find(testingTarget(1,:)==1);
% class0ts=find(testingTarget(1,:)==0);
% i=0;j=0;
% ts0=zeros(1,20);ts1=zeros(1,20);
% tr0=zeros(1,20);tr1=zeros(1,20);
% 
% for i=1:20
%     i=i-1;
%     for j=1:20:length(class0ts)
%         index0=class0ts(i+j);
%         if (testingErrorAll(index0)~=0)
%             ts0(i+1)=ts0(i+1)+1;
%         end
%     end
% end
% count0ts{k}=ts0;
% for i=1:20
%     i=i-1;
%     for j=1:20:length(class1ts)
%         index1=class1ts(i+j);
%         if (testingErrorAll(index1)~=0)
%             ts1(i+1)=ts1(i+1)+1;
%         end
%     end
% end
% count1ts{k}=ts1;
% 
%  trainingErrorAll=(OutputflagTr-trainingTarget(1,:));
% class1tr=find(trainingTarget(1,:)==1);
% class0tr=find(trainingTarget(1,:)==0);
% i=0;j=0;
% % count0tr={[zeros(1,20)],[zeros(1,20)],[zeros(1,20)]};
% % count1tr={[zeros(1,20)],[zeros(1,20)],[zeros(1,20)]};
% 
% for i=1:20
%     i=i-1;
%     for j=1:20:length(class0tr)
%         index0=class0tr(i+j);
%         if (trainingErrorAll(index0)~=0)
%             tr0(i+1)=tr0(i+1)+1;
%         end
%     end
% end
% count0tr{k}=tr0;
% 
% for i=1:20
%     i=i-1;
%     for j=1:20:length(class1tr)
%         index1=class1tr(i+j);
%         if (trainingErrorAll(index1)~=0)
%             tr1(i+1)=tr1(i+1)+1;
%         end
%     end
% end
% count1tr{k}=tr1;
% 
% end
