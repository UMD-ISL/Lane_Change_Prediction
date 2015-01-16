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
%  Date:         Nov.11.2014
%  Revision:     0.1
%  Partner:      Worked with Tianyu Wang, Yulong Li
%  Copyright:    Intelligent System Laboratory
%                University of Michigan Dearborn

%% Extract Lane-Change period
clc; clear all; close all;
ini = IniConfig();
ini.ReadFile('configuration.ini');
home = ini.GetValues('Path Setting', 'HOME_PATH');

load(strcat(home, '\Synchronized_Dataset\statistics.mat'));
load(strcat(home,'\Synchronized_Dataset\Video_Ten_Hz_signals_feature_Final.mat'));

time_before_Lane_Change = 20;
lane_change_size          = 20;

for m = 1:num_trips
    eval(strcat('data_all_cell = Video_Ten_Hz_signals_feature_', num2str(m), ';'));
    % only use first signal's target column
    data_all = data_all_cell{1};
    lane_change_target_index = find(1 == data_all(:,end));
    no_lane_change_target_index = find(2 == data_all(:,end));
    lane_change_event_ID    =[];
    no_lane_change_event_ID =[];
    
    for k = 1:(length(lane_change_target_index) - 1)
        if(1 == k)
            lane_change_event_ID = lane_change_target_index(1);  % the first lane change ID is ID
        end
        if( lane_change_target_index(k + 1) > (lane_change_target_index(k) + 2) )
            % use the index of first lane change event data as the lane
            % change event ID
            lane_change_event_ID = [lane_change_event_ID, lane_change_target_index(k + 1)];
        end
    end
    
    for k = 1:(length(no_lane_change_target_index) - 1)
        if(1 == k)
            no_lane_change_event_ID = no_lane_change_target_index(1);
        end
        if(no_lane_change_target_index(k + 1) > (no_lane_change_target_index(k) + 2) )
            no_lane_change_event_ID = [no_lane_change_event_ID, no_lane_change_target_index(k + 1)];
        end
    end
    
    % what is this part talking about?
    LaneChangeOldInd    = lane_change_event_ID/10;
    NolangechangeInd    = no_lane_change_event_ID/10;
    NoLane              = NolangechangeInd * 10 + 1 - time_before_Lane_Change;
    LaneBefore          = LaneChangeOldInd * 10 + 1 - time_before_Lane_Change;
    [x1,y1]             = size(LaneBefore);
    [x2,y2]             = size(NoLane);
    
    % extract lane change points and save them as a cell in second row, and
    % save this matrix as 'Video_m_events_feature'
    num_selected_signals = 9;   % not 7 any more (7 + 2)
    eval(strcat('Video_',num2str(m),'_events_feature = Video_Ten_Hz_signals_feature_', num2str(m), ';'));
    for i = 1:num_selected_signals
        eval(strcat('invoker = Video_Ten_Hz_signals_feature_',num2str(m),'{1,i};'));
        middle=[];
        for index = 1 : y1
            pointIndex = LaneBefore(index);
            middle = [middle; invoker((pointIndex:(pointIndex + lane_change_size - 1)), 2:6)];
        end
        
        for index = 1 : y2
            pointIndex = NoLane(index);
            % add no lane change points after it
            middle = [middle; invoker((pointIndex:(pointIndex + lane_change_size - 1)), 2:6)];
        end
        eval(strcat('Video_',num2str(m),'_events_feature{2,i} = middle;'));
    end
end

Post_normalization_3_Output = strcat(home, '/Post_normalization_3_Output');
    mkdir_if_not_exist(Post_normalization_3_Output);
save(strcat(Post_normalization_3_Output, '/Videos_events_feature.mat'), ...
    'Video_1_events_feature', 'Video_2_events_feature', ...
    'Video_3_events_feature', 'Video_4_events_feature', ...
    'Video_5_events_feature')
