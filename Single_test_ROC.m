function Single_test_ROC(Inroot,Outroot_origin,NumberofPoints_on_event,TotalLaneChange,hiddenNodes,learnRates,FeatureFilter,NumberLCTest)
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
          
IndexofLC=[];
FF=1:TotalLaneChange;
Except=setdiff(FF,IndexofLC);
IndexofNLC=[];
NFF=1:(TotalLaneChange*2);
NExcept=setdiff(NFF,IndexofNLC);
testingInput=[EventPool{:,IndexofLC},NoEventPool{:,IndexofNLC}];
Targetground=[ones(1,size(testingInput,2)*ratio),zeros(1,size(testingInput,2)*(1-ratio))];
trainingInput=[EventPool{:,Except},NoEventPool{:,NExcept}];
trainingground=[ones(1,(size(trainingInput,2)*ratio)),zeros(1,(size(trainingInput,2)*(1-ratio)))];
figure1=figure;
plotroc(trainingground,trainingInput(1,:),'HR ori',trainingground,trainingInput(2,:),'HR MAX',...
    trainingground,trainingInput(3,:),'HR MIN',trainingground,trainingInput(4,:),'HR mean',...
    trainingground,trainingInput(5,:),'HR diff');
saveas(figure1,strcat('figure_ROC/','HR_ROC.fig'));
close(figure1);

figure1=figure;
plotroc(trainingground,trainingInput(6,:),'Te ori',trainingground,trainingInput(7,:),'Te MAX',...
    trainingground,trainingInput(8,:),'Te MIN',trainingground,trainingInput(9,:),'Te mean',...
    trainingground,trainingInput(10,:),'Te diff');
saveas(figure1,strcat('figure_ROC/','Te_ROC.fig'));
close(figure1);

figure1=figure;
plotroc(trainingground,trainingInput(11,:),'Ti ori',trainingground,trainingInput(12,:),'Ti MAX',...
    trainingground,trainingInput(13,:),'Ti MIN',trainingground,trainingInput(14,:),'Ti mean',...
    trainingground,trainingInput(15,:),'Ti diff');
saveas(figure1,strcat('figure_ROC/','Ti_ROC.fig'));
close(figure1);

figure1=figure;
plotroc(trainingground,trainingInput(16,:),'Exp Vol ori',trainingground,trainingInput(17,:),'Exp Vol MAX',...
    trainingground,trainingInput(18,:),'Exp Vol MIN',trainingground,trainingInput(19,:),'Exp Vol mean',...
    trainingground,trainingInput(20,:),'Exp Vol diff');
saveas(figure1,strcat('figure_ROC/','Exp Vol_ROC.fig'));
close(figure1);

figure1=figure;
plotroc(trainingground,trainingInput(21,:),'Insp Vol ori',trainingground,trainingInput(22,:),'Insp Vol MAX',...
    trainingground,trainingInput(23,:),'Insp Vol MIN',trainingground,trainingInput(24,:),'Insp Vol mean',...
    trainingground,trainingInput(25,:),'Insp Vol diff');
saveas(figure1,strcat('figure_ROC/','Insp Vol_ROC.fig'));
close(figure1);

figure1=figure;
plotroc(trainingground,trainingInput(26,:),'qDEEL ori',trainingground,trainingInput(27,:),'qDEEL MAX',...
    trainingground,trainingInput(28,:),'qDEEL MIN',trainingground,trainingInput(29,:),'qDEEL mean',...
    trainingground,trainingInput(30,:),'qDEEL diff');
saveas(figure1,strcat('figure_ROC/','qDEEL_ROC.fig'));
close(figure1);

figure1=figure;
plotroc(trainingground,trainingInput(31,:),'GSR2 ori',trainingground,trainingInput(32,:),'GSR2 MAX',...
    trainingground,trainingInput(33,:),'GSR2 MIN',trainingground,trainingInput(34,:),'GSR2 mean',...
    trainingground,trainingInput(35,:),'GSR2 diff');
saveas(figure1,strcat('figure_ROC/','GSR2_ROC.fig'));
close(figure1);




figure1=figure;
plotroc(trainingground,trainingInput(36,:),'ECG ori',trainingground,trainingInput(37,:),'ECG MAX',...
    trainingground,trainingInput(38,:),'ECG MIN',trainingground,trainingInput(39,:),'ECG mean',...
    trainingground,trainingInput(40,:),'ECG diff');
saveas(figure1,strcat('figure_ROC/','ECG_ROC.fig'));
close(figure1);

figure1=figure;
plotroc(trainingground,trainingInput(41,:),'BELT ori',trainingground,trainingInput(42,:),'BELT MAX',...
    trainingground,trainingInput(43,:),'BELT MIN',trainingground,trainingInput(44,:),'BELT mean',...
    trainingground,trainingInput(45,:),'BELT diff');
saveas(figure1,strcat('figure_ROC/','BELT_ROC.fig'));
close(figure1);

for i=1:45
[auc(i),~]=roc_auc(trainingInput(i,:),trainingground,1,0);
end
save('figure_ROC/auc.mat','auc')





