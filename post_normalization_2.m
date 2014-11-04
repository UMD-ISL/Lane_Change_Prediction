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
%  Author:       Yuan Ma
%  Date:         Oct.17.2014
%  Revision:     0.1
%  Partner:      Worked with Tianyu Wang, Yulong Li
%  Copyright:    Intelligent System Laboratory
%                University of Michigan Dearborn

%% Combine five Videos together

ini = IniConfig();
ini.ReadFile('configuration.ini');
Data_Path = ini.GetValues('Path Setting', 'DATA_PATH');
home = ini.GetValues('Path Setting', 'HOME_PATH');

total_feature = 5;

window_size_Ten_Hz_signals      = 20;
% window size for ECG raw data is 256 because the sampling rate is 256 Hz
window_size_ECG_raw             = 256 * 2;
% window size for BELT raw data is 26 because the sampling rate is 26 Hz
window_size_BELT_raw            = 26 * 2;

load(strcat(home, '\Synchronized_Dataset\statistics.mat'));
% get the number of signal selected
% get the lane change number

num_signal_attributes   = 5;

for m = 1:num_trips
    load(strcat(home, '\Post_normalization_Ouput\Video_', num2str(m), ...
        '_Ten_Hz_signals_feature.mat'));
    % dynamic generate varibles using eval function
    % the value of feature_pool will change everytime the data is loaded
    eval(strcat('Ten_Hz_signals_feature_', num2str(m), ' = feature_pool;'));  

    load(strcat(home, '\Post_normalization_Ouput\Video_1_ECG_feature.mat'));
    eval(strcat('ECG_feature_', num2str(m), ' = feature_pool;'));

    load(strcat(home, '\Post_normalization_Ouput\Video_1_BELT_feature.mat'));
    eval(strcat('BELT_feature_', num2str(m), ' = feature_pool;'));
    
end

% this part can be modified (just find the max and min signal in all data)
% !!!
%% Normalization all together
for i = 1:num_selected_signal % mean, max, min ...
    Ten_Hz_signals_feature_all{i} = [Ten_Hz_signals_feature_1{i,1}; Ten_Hz_signals_feature_2{i,1}; ...
                          Ten_Hz_signals_feature_3{i,1}; Ten_Hz_signals_feature_4{i,1}; ...
                          Ten_Hz_signals_feature_5{i,1}];
    
    Normalized_Data = Ten_Hz_signals_feature_all{i};       % temp variables
    for j = 2:(num_signal_attributes + 1)
        % normalize data into [0,1]
        Normalized_Data(:,j) = (Normalized_Data(:,j) - min(Normalized_Data(:,j))) ...
            ./ (max(Normalized_Data(:,j)) - min(Normalized_Data(:,j)));   
    end
    Ten_Hz_signals_feature_all{i} = Normalized_Data;
end

%% Not use ECG and BELT data right now
% feature_All_ECG = [  feature_ECG_1; feature_ECG_2; feature_ECG_3;...
%                 feature_ECG_4; feature_ECG_5];
% for j = 2:num_signal_attributes + 1
%    feature_All_ECG(:,j) = (feature_All_ECG(:,j) - min(feature_All_ECG(:,j))) ...
%        ./(max(feature_All_ECG(:,j)) - min(feature_All_ECG(:,j)));
% end  
% 
% feature_All_BELT = [ feature_BELT_1; feature_BELT_2; feature_BELT_3;
%                 feature_BELT_4; feature_BELT_5];              
% for j = 2:num_signal_attributes + 1
%     feature_All_BELT(:,j) = (feature_All_BELT(:,j) - min(feature_All_BELT(:,j))) ...
%     ./(max(feature_All_BELT(:,j))-min(feature_All_BELT(:,j)));
% end

%%  Seperate each Video
offset = 0;
for j = 1:num_selected_signal
     Video = Ten_Hz_signals_feature_all{j};
    for m = 1:num_trips
        % signal_length = Video_m__Ten_Hz_signals_length;
        eval(strcat('signal_length = Video_', num2str(m), '_Ten_Hz_signals_length;'));
        % seperate the video according to the the length of each signal
        % Video_cal_m(j) = [zeros(window_size_cal - 1, num_signal_attributes + 1); Video( (offset + 1 : offset + signal_length), : )];
        eval(strcat('Video_Ten_Hz_signals_feature_', num2str(m), '{j}  = [zeros(window_size_Ten_Hz_signals - 1, num_signal_attributes + 1); Video( (offset + 1 : offset + signal_length), : )];'));
        offset = offset + signal_length;
    end
    offset = 0;
end

%% add target information here
for m = 1:num_trips
    load(strcat(home,'\Synchronized_Dataset\Video_' ,num2str(m), '_Synchronized_Data.mat'));
    for i = 1:num_selected_signal
        % add the target information to the end column
        eval(strcat('Video_Ten_Hz_signals_feature_', num2str(m), '{i} = [ Video_Ten_Hz_signals_feature_', num2str(m), '{i}, Ten_Hz_signals_data(:,end)];'));
    end
    eval(strcat('Video_ECG_feature_', num2str(m), ' = [zeros(window_size_ECG_raw - 1, num_signal_attributes); ECG_feature_', num2str(m), '];'));
    eval(strcat('Video_BELT_feature_', num2str(m), ' = [zeros(window_size_BELT_raw - 1, num_signal_attributes); BELT_feature_', num2str(m), '];'));
end

%% Time Matching (generalize for ECG signals)
size_array = [];
for m = 1:num_trips
    eval(strcat('size_array = [size_array; size(Video_ECG_feature_', num2str(m), ', 1)];'));
end

[~, maxIndex] = max(size_array); % find the video index which has longest ECG signal length
% max_Video_ECG_feature = Video_ECG_feature_num2str(maxIndex);
eval(strcat('max_Video_ECG_feature = Video_ECG_feature_', num2str(maxIndex), ';'));
% max_Video_Ten_Hz_signals_feature = Video_Ten_Hz_signals_feature_num2str(maxIndex);
eval(strcat('max_Video_Ten_Hz_signals_feature = Video_Ten_Hz_signals_feature_', num2str(maxIndex), '{1};'))

% time consuming job, and also have problem (maybe)
Lookup_Table = [];      % why use lookup table here?
Time_sequence = max_Video_Ten_Hz_signals_feature(:,1);
for m = window_size_Ten_Hz_signals:size(max_Video_Ten_Hz_signals_feature,1)
    Match_From = Time_sequence(m);
    %find the index which is closet to 10Hz data Match_From
    [~, Match_to_ECG] = min(abs(max_Video_ECG_feature(:,1) - Match_From));
    Lookup_Table = [Lookup_Table; [m, Match_to_ECG]];
end

for m = 1:num_trips
    eval(strcat('index = find(Lookup_Table(:,1) == size(Video_Ten_Hz_signals_feature_', num2str(m), '{1},1));'));
    eval(strcat('Vedio_', num2str(m), '_new_ECG_feature = Video_ECG_feature_', num2str(m), '(Lookup_Table(1:index, 2),2:5);'));
    eval(strcat('Vedio_', num2str(m), '_new_ECG_feature = [zeros(window_size_Ten_Hz_signals - 1, size(Vedio_', num2str(m), '_new_ECG_feature, 2)); Vedio_', num2str(m), '_new_ECG_feature ];'));
    eval(strcat('Video_Ten_Hz_signals_feature_', num2str(m), ' = [ Video_Ten_Hz_signals_feature_', num2str(m), ', Vedio_', num2str(m), '_new_ECG_feature];'));
end

%% Generalization for Belt signal
size_array = [];
for m = 1:num_trips
    eval(strcat('size_array = [size_array; size(Video_BELT_feature_', num2str(m), ', 1)];'));
end

[~, maxIndex] = max(size_array); % find the video index which has longest BELT signal length
% max_Video_BELT_feature = Video_ECG_feature_num2str(maxIndex);
eval(strcat('max_Video_BELT_feature = Video_BELT_feature_', num2str(maxIndex), ';'));
% max_Video_Ten_Hz_signals_feature = Video_Ten_Hz_signals_feature_num2str(maxIndex);
eval(strcat('max_Video_Ten_Hz_signals_feature = Video_Ten_Hz_signals_feature_', num2str(maxIndex), '{1};'))

% time consuming job, and also have problem (maybe)
Lookup_Table = [];      % why use lookup table here?
Time_sequence = max_Video_Ten_Hz_signals_feature(:,1);
for m = window_size_Ten_Hz_signals:size(max_Video_Ten_Hz_signals_feature, 1)
    Match_From = Time_sequence(m);
    %find the index which is closet to 10Hz data Match_From
    [~, Match_to_BELT] = min(abs(max_Video_BELT_feature(:,1) - Match_From));
    Lookup_Table = [Lookup_Table; [m, Match_to_BELT]];
end

for m = 1:num_trips
    eval(strcat('index = find(Lookup_Table(:,1) == size(Video_Ten_Hz_signals_feature_', num2str(m), '{1},1));'));
    eval(strcat('Vedio_', num2str(m), '_new_BELT_feature = Video_BELT_feature_', num2str(m), '(Lookup_Table(1:index, 2),2:5);'));
    eval(strcat('Vedio_', num2str(m), '_new_BELT_feature = [zeros(window_size_Ten_Hz_signals - 1, size(Vedio_', num2str(m), '_new_BELT_feature, 2)); Vedio_', num2str(m), '_new_BELT_feature ];'));
    eval(strcat('Video_Ten_Hz_signals_feature_', num2str(m), ' = [ Video_Ten_Hz_signals_feature_', num2str(m), ', Vedio_', num2str(m), '_new_BELT_feature];'));
end

%% Calculate the x(t)-x(t-stepsize)
for m = 1:num_trips
    for j = 1:2
      eval(strcat('signal = Video_Ten_Hz_signals_feature_',num2str(m),'{1, num_selected_signal + j};')); 
      signal(:,5) = [0;diff(signal(:,1))];
      signal(20,5) = 0;
      eval(strcat('Video_Ten_Hz_signals_feature_',num2str(m),'{1, num_selected_signal + j} = signal;'))
    end
end


%% Deal with ECG feature
% normalization
ECG_feature_all = [];
for m = 1:num_trips
    eval(strcat('ECG_feature_all = [ECG_feature_all; Video_Ten_Hz_signals_feature_', num2str(m), '(:8)];'));
    for j=1:num_signal_attributes
       ECG_feature_all(:,j) = (ECG_feature_all(:,j)-min(ECG_feature_all(:,j)))./(max(ECG_feature_all(:,j))-min(ECG_feature_all(:,j)));
    end
end

offset = 0;
for j = m:num_selected_signal
     Video = ECG_feature_all{j};
    for m = 1:num_trips
        % signal_length = Video_m__Ten_Hz_signals_length;
        eval(strcat('signal_length = Video_', num2str(m), '_Ten_Hz_signals_length;'));
        % seperate the video according to the the length of each signal
        % Video_cal_m(j) = [zeros(window_size_cal - 1, num_signal_attributes + 1); Video( (offset + 1 : offset + signal_length), : )];
        eval(strcat('Video_ECG_feature_', num2str(m), '{j}  = [zeros(window_size_Ten_Hz_signals - 1, num_signal_attributes + 1); Video( (offset + 1 : offset + signal_length), : )];'));
        offset = offset + signal_length;
    end
    offset = 0;
end

%% Deal with BELT feature
BELT_feature_all = [];
for j=1:num_signal_attributes
    eval(strcat('BELT_feature_all = [BELT_feature_all; Video_Ten_Hz_signals_feature_', num2str(m), '(:9)];'));
    featureAll_BELT(:,j)=(featureAll_BELT(:,j)-min(featureAll_BELT(:,j)))./(max(featureAll_BELT(:,j))-min(featureAll_BELT(:,j)));
end

% L1=size(Video1{1,1},1);
% L2=size(Video2{1,1},1);
% L3=size(Video3{1,1},1);
% L4=size(Video4{1,1},1);
% L5=size(Video5{1,1},1);
% Video=[];
% Video=featureAll_ECG;
% Video_ECG_1=Video((1:L1),:);
% Video_ECG_2=Video((L1+1:L2+L1),:);
% Video_ECG_3=Video((L1+L2+1:L2+L1+L3),:);
% Video_ECG_4=Video((L1+L2+L3+1:L2+L1+L3+L4),:);
% Video_ECG_5=Video((L1+L2+L3+L4+1:L2+L1+L3+L4+L5),:);
% 
% Video1{1,8}=Video_ECG_1;
% Video2{1,8}=Video_ECG_2;
% Video3{1,8}=Video_ECG_3;
% Video4{1,8}=Video_ECG_4;
% Video5{1,8}=Video_ECG_5;
% 
% Video=[];
% Video=featureAll_BELT;
% Video_BELT_1=Video((1:L1),:);
% Video_BELT_2=Video((L1+1:L2+L1),:);
% Video_BELT_3=Video((L1+L2+1:L2+L1+L3),:);
% Video_BELT_4=Video((L1+L2+L3+1:L2+L1+L3+L4),:);
% Video_BELT_5=Video((L1+L2+L3+L4+1:L2+L1+L3+L4+L5),:);
% Video1{1,9}=Video_BELT_1;
% Video2{1,9}=Video_BELT_2;
% Video3{1,9}=Video_BELT_3;
% Video4{1,9}=Video_BELT_4;
% Video5{1,9}=Video_BELT_5;
% for m=1:NumberofTrips
%     for j=8:9
%         eval(strcat('Video=','Video',num2str(m),'{1,j};'));
%         Video=[zeros(size(Video,1),1),Video,zeros(size(Video,1),1)];
%         eval(strcat('Video',num2str(m),'{1,j}=Video;'));
%     end
% end
% save(strcat(Outroot_origin,'\DataSet\Video_final.mat'),'Video1','Video2','Video3','Video4','Video5');
% Extract Lane-Change period
% load(strcat(Outroot_origin,'\DataSet\Video_final.mat'));
% for j=1:NumberofTrips
% 
% eval(strcat('dataAll_cell=Video',num2str(j),';'));
% dataAll=dataAll_cell{1};
% targetindex1=find(dataAll(:,end)==1);
% targetindex2=find(dataAll(:,end)==2);
% ID1=[];
% ID2=[];
% for m=1:length(targetindex1)-1
%     if(m==1)
%     ID1=targetindex1(1);
%     end
%     if(targetindex1(m+1)>targetindex1(m)+2)
%     ID1=[ID1,targetindex1(m+1)];
%     end
% end
% for m=1:length(targetindex2)-1
%     if(m==1)
%     ID2=targetindex2(1);
%     end
%     if(targetindex2(m+1)>targetindex2(m)+2)
%     ID2=[ID2,targetindex2(m+1)];
%     end
% end
% LaneChangeOldInd=ID1/10;
% NolangechangeInd=ID2/10;
% NoLane=NolangechangeInd*10+1-time_before_LC;
% LaneBefore=LaneChangeOldInd*10+1-time_before_LC;% at this time
% [x1,y1]=size(LaneBefore);
% [x2,y2]=size(NoLane);
% NumberofSignalSelected=9;
% for m=1:NumberofSignalSelected
%     eval(strcat('invoker=Video',num2str(j),'{1,i};'));
%     for index=1:y1
%         pointIndex=LaneBefore(index);
%         middle=[middle;invoker((pointIndex:(pointIndex+lanechangesize-1)),2:6)];
%     end
%     eval(strcat('Video',num2str(j),'{2,i}=middle;'));
%     middle=[];
% end
% 
% for m=1:NumberofSignalSelected
%     eval(strcat('invoker=Video',num2str(j),'{1,i};'));
%     eval(strcat('middle=Video',num2str(j),'{2,i};'));
%     for index=1:y2
%         pointIndex=NoLane(index); 
%         middle=[middle;invoker((pointIndex:(pointIndex+lanechangesize-1)),2:6)];
%     end
%     eval(strcat('Video',num2str(j),'{2,i}=middle;'));
%     middle=[];
% end
% end
% feature=[Video1{2,WhichSignal};Video2{2,WhichSignal};Video3{2,WhichSignal};Video4{2,WhichSignal};Video5{2,WhichSignal}];
% K1=size(Video1{2,WhichSignal},1);
% K2=size(Video2{2,WhichSignal},1);
% K3=size(Video3{2,WhichSignal},1);
% K4=size(Video4{2,WhichSignal},1);
% K5=size(Video5{2,WhichSignal},1);
% Target=[ones(1,K1/3),zeros(1,K1*2/3),ones(1,K2/3),zeros(1,K2*2/3),ones(1,K3/3),zeros(1,K3*2/3),ones(1,K4/3),zeros(1,K4*2/3),ones(1,K5/3),zeros(1,K5*2/3)]';
% save(strcat(rootIn,'\DataSet\Video.mat'),'Video1','Video2','Video3','Video4','Video5');


