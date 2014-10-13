function Single_test(Inroot,Outroot_origin,NumberofPoints_on_event,TotalLaneChange,hiddenNodes,learnRates,FeatureFilter,NumberLCTest)
% Intelligent System Lab
%UM-Dearborn 
% Kunqiao Li
% Using Neural Network to predict the lane change
% feature use physiological signals
EventPool=[];
NoEventPool=[];
result=cell(1,20);
NofFeature=length(FeatureFilter);
IndexofLC=[];
ratio=1/3;
Feature=[];
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
%%
LChistogram1  = zeros(1, 21);
NLChistogram1 = zeros(1, 21);
folder = zeros(2, 180, 10);

% LChistogram2  = zeros(1, 20);
% NLChistogram2 = zeros(1, 20);
% 
% LChistogram3  = zeros(1, 19);
% NLChistogram3 = zeros(1, 19);
% 
% LChistogram4  = zeros(1, 18);
% NLChistogram4 = zeros(1, 18);
% 
% LChistogram5  = zeros(1, 17);
% NLChistogram5 = zeros(1, 17);
% 
% LChistogram6  = zeros(1, 16);
% NLChistogram6 = zeros(1, 16);
%%
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
% 			speed_nn = NNBuilder2(trainingInput, trainingground, testingInput, Targetground, netConfig);
%             [netTrained, tr] = speed_nn.trainNN(speed_nn.net);
%             save(strcat(Outroot_origin,'TrainedNN\','trainedNN',num2str(k),'.mat'),'netTrained');
            load(strcat('C:\Users\Emosdead\Desktop\TrainedNN\','trainedNN',num2str(k),'.mat'));
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
    folder(2,:,k) = OutputflagTs;
    folder(1,1:60,k)=1;
%     save(strcat(Outroot_origin,'folder', k, '.mat'),'folder');
    % figure(2);plot(OutputflagTr,'.');hold on;plot(trainingTarget(1,:),'r');title('training Result');
    % figure(3);plot(testingOutput(1,:));hold on;plot(testingOutput(2,:),'r');title('testing output');
    % figure(4);plot(trainingOutput(1,:));hold on;plot(trainingOutput(2,:),'r');title('training output');
    ratio_train=1-size(trainingError,2)/size(trainingErrorAll,2)
    ratio_test=1-size(testingError,2)/size(testingErrorAll,2)

    NumberLCTest=size(IndexofLC,2);
    Result=zeros(2*NumberLCTest,2*NumberLCTest);
    Result(1:2,1)=[ratio_train;ratio_test];
    Result(1:3,2)=IndexofLC';
    Result(:,3)=IndexofNLC';
    result{1,k}=Result;
    saveas(figure1,strcat(Outroot_origin,'Figure\','test_',num2str(k)),'fig');
    close(figure1);

    for i = 0 : 20 : 59
        countLC = 0;
        for j = 1 : 20
            if OutputflagTs(i + j) == 1
                countLC = countLC + 1;
            end
        end
        LChistogram1(countLC + 1) = LChistogram1(countLC + 1) + 1;
        
%         countLC = 0;
%         for j = 1 : 19
%             if OutputflagTs(i + j) == 1
%                 countLC = countLC + 1;
%             end
%         end
%         LChistogram2(countLC + 1) = LChistogram2(countLC + 1) + 1;
%         
%         countLC = 0;
%         for j = 1 : 18
%             if OutputflagTs(i + j) == 1
%                 countLC = countLC + 1;
%             end
%         end
%         LChistogram3(countLC + 1) = LChistogram3(countLC + 1) + 1;
%         
%         countLC = 0;
%         for j = 1 : 17
%             if OutputflagTs(i + j) == 1
%                 countLC = countLC + 1;
%             end
%         end
%         LChistogram4(countLC + 1) = LChistogram4(countLC + 1) + 1;
%         
%         countLC = 0;
%         for j = 1 : 16
%             if OutputflagTs(i + j) == 1
%                 countLC = countLC + 1;
%             end
%         end
%         LChistogram5(countLC + 1) = LChistogram5(countLC + 1) + 1;
%         
%         countLC = 0;
%         for j = 1 : 15
%             if OutputflagTs(i + j) == 1
%                 countLC = countLC + 1;
%             end
%         end
%         LChistogram6(countLC + 1) = LChistogram6(countLC + 1) + 1;
    end

    for i = 60 : 20 : 179
        countNLC = 0;
        for j = 1 : 20
            if OutputflagTs(i + j) == 1
                countNLC = countNLC + 1;
            end
        end
        NLChistogram1(countNLC + 1) = NLChistogram1(countNLC + 1) + 1;
        
%         countNLC = 0;
%         for j = 1 : 19
%             if OutputflagTs(i + j) == 1
%                 countNLC = countNLC + 1;
%             end
%         end
%         NLChistogram2(countNLC + 1) = NLChistogram2(countNLC + 1) + 1;
%         
%         countNLC = 0;
%         for j = 1 : 18
%             if OutputflagTs(i + j) == 1
%                 countNLC = countNLC + 1;
%             end
%         end
%         NLChistogram3(countNLC + 1) = NLChistogram3(countNLC + 1) + 1;
%         
%         countNLC = 0;
%         for j = 1 : 17
%             if OutputflagTs(i + j) == 1
%                 countNLC = countNLC + 1;
%             end
%         end
%         NLChistogram4(countNLC + 1) = NLChistogram4(countNLC + 1) + 1;
%         
%         countNLC = 0;
%         for j = 1 : 16
%             if OutputflagTs(i + j) == 1
%                 countNLC = countNLC + 1;
%             end
%         end
%         NLChistogram5(countNLC + 1) = NLChistogram5(countNLC + 1) + 1;
%         
%         countNLC = 0;
%         for j = 1 : 15
%             if OutputflagTs(i + j) == 1
%                 countNLC = countNLC + 1;
%             end
%         end
%         NLChistogram6(countNLC + 1) = NLChistogram6(countNLC + 1) + 1;
    end

end

figure, bar(0:20, LChistogram1);
axis([0 21 0 30]);
figure, bar(0:20, NLChistogram1);
axis([0 21 0 60]);

% figure, bar(0:19, LChistogram2);
% axis([0 20 0 30]);
% figure, bar(0:19, NLChistogram2);
% axis([0 20 0 60]);
% 
% figure, bar(0:18, LChistogram3);
% axis([0 19 0 30]);
% figure, bar(0:18, NLChistogram3);
% axis([0 19 0 60]);
% 
% figure, bar(0:17, LChistogram4);
% axis([0 18 0 30]);
% figure, bar(0:17, NLChistogram4);
% axis([0 18 0 60]);
% 
% figure, bar(0:16, LChistogram5);
% axis([0 17 0 30]);
% figure, bar(0:16, NLChistogram5);
% axis([0 17 0 60]);
% 
% figure, bar(0:15, LChistogram6);
% axis([0 16 0 30]);
% figure, bar(0:15, NLChistogram6);
% axis([0 16 0 60]);


save(strcat(Outroot_origin,'result.mat'),'result');
save(strcat(Outroot_origin,'folder.mat'),'folder');

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
