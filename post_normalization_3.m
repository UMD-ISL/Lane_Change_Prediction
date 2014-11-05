%% Post_normalization_2

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

%% Extract Lane-Change period
clc; clear all; close all;
ini = IniConfig();
ini.ReadFile('configuration.ini');
Data_Path = ini.GetValues('Path Setting', 'DATA_PATH');
home = ini.GetValues('Path Setting', 'HOME_PATH');

load(strcat(home, '\Synchronized_Dataset\statistics.mat'));
load(strcat(home,'\Synchronized_Dataset\Video_Ten_Hz_signals_feature_Final.mat'));

time_before_Lane_Change = 20;


for m = 1:num_trips
    eval(strcat('data_all_cell = Video_Ten_Hz_signals_feature_', num2str(m), ';'));
    data_all = data_all_cell{1};
    lane_change_target_index = find(1 == data_all(:,end));
    no_lane_change_target_index = find(2 == data_all(:,end));
    lane_change_event_ID    =[];
    no_lane_change_event_ID =[];
    
    for m = 1:(length(lane_change_target_index) - 1)
        if(1 == m)
            lane_change_event_ID = lane_change_target_index(1);  % the first lane change ID is ID
        end
        if( lane_change_target_index(m+1) > (lane_change_target_index(m) + 2) )
            % use the index of first lane change event data as the lane
            % change event ID
            lane_change_event_ID = [lane_change_event_ID, lane_change_target_index(m+1)];
        end
    end
    
    for m = 1:(length(no_lane_change_target_index) - 1)
        if(1 == m)
            no_lane_change_event_ID = no_lane_change_target_index(1);
        end
        if(no_lane_change_target_index(m+1) > no_lane_change_target_index(m)+2)
            no_lane_change_event_ID = [no_lane_change_event_ID, no_lane_change_target_index(m+1)];
        end
    end
    
    LaneChangeOldInd = lane_change_event_ID/10;
    NolangechangeInd = no_lane_change_event_ID/10;
    NoLane = NolangechangeInd * 10 + 1 - time_before_Lane_Change;
    LaneBefore = LaneChangeOldInd * 10 + 1 - time_before_Lane_Change; % at this time
    [x1,y1]=size(LaneBefore);
    [x2,y2]=size(NoLane);
    
    num_selected_signals = 9;   % not 7 any more (7 + 2)
%     for m=1:num_selected_signals
%         eval(strcat('invoker=Video',num2str(m),'{1,i};'));
%         for index=1:y1
%             pointIndex=LaneBefore(index);
%             middle=[middle;invoker((pointIndex:(pointIndex+lanechangesize-1)),2:6)];
%         end
%         eval(strcat('Video',num2str(m),'{2,i}=middle;'));
%         middle=[];
%     end
% 
%     for m=1:NumberofSignalSelected
%         eval(strcat('invoker=Video',num2str(m),'{1,i};'));
%         eval(strcat('middle=Video',num2str(m),'{2,i};'));
%         for index=1:y2
%             pointIndex=NoLane(index); 
%             middle=[middle;invoker((pointIndex:(pointIndex+lanechangesize-1)),2:6)];
%         end
%         eval(strcat('Video',num2str(m),'{2,i}=middle;'));
%         middle=[];
%     end
end

% feature=[Video1{2,WhichSignal};Video2{2,WhichSignal};Video3{2,WhichSignal};Video4{2,WhichSignal};Video5{2,WhichSignal}];
% K1=size(Video1{2,WhichSignal},1);
% K2=size(Video2{2,WhichSignal},1);
% K3=size(Video3{2,WhichSignal},1);
% K4=size(Video4{2,WhichSignal},1);
% K5=size(Video5{2,WhichSignal},1);
% Target=[ones(1,K1/3),zeros(1,K1*2/3),ones(1,K2/3),zeros(1,K2*2/3),ones(1,K3/3),zeros(1,K3*2/3),ones(1,K4/3),zeros(1,K4*2/3),ones(1,K5/3),zeros(1,K5*2/3)]';
% save(strcat(rootIn,'\DataSet\Video.mat'),'Video1','Video2','Video3','Video4','Video5');