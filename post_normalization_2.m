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

%% Combine five Videos together
clc; clear all; close all;
ini = IniConfig();
ini.ReadFile('configuration.ini');
home = ini.GetValues('Path Setting', 'HOME_PATH');

total_feature = 5;

window_size_Ten_Hz_signals      = 10;
% window size for ECG raw data is 256 because the sampling rate is 256 Hz
window_size_ECG_raw             = 256;
% window size for BELT raw data is 26 because the sampling rate is 26 Hz
window_size_BELT_raw            = 26;

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

    load(strcat(home, '\Post_normalization_Ouput\Video_', num2str(m), ...
        '_ECG_feature.mat'));
    eval(strcat('ECG_feature_', num2str(m), ' = feature_pool;'));

    load(strcat(home, '\Post_normalization_Ouput\Video_', num2str(m), ... 
        '_BELT_feature.mat'));
    eval(strcat('BELT_feature_', num2str(m), ' = feature_pool;'));
    
end

% this part can be modified (just find the max and min signal in all data)
% !!!
%% Normalization all together
for i = 1:num_selected_signal % mean, max, min ...
    temp = [];
    for m = 1:num_trips
        eval(strcat('temp = [temp; Ten_Hz_signals_feature_', num2str(m), '{i,1}];'));
    end  
    
    Normalized_Data = temp;       % temp variables
    for j = 2:(num_signal_attributes + 1)
        % normalize data into [0,1]
        Normalized_Data(:,j) = (Normalized_Data(:,j) - min(Normalized_Data(:,j))) ...
            ./ (max(Normalized_Data(:,j)) - min(Normalized_Data(:,j)));   
    end
    % Ten_Hz_signals_feature_all: 7 signals, each signal has 6 columns
    % (time + 5 features)
    Ten_Hz_signals_feature_all{i} = Normalized_Data;
end
clearvars temp;

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
        % Ten_Hz_signals_feature_all: 7 signals, each signal has 7 columns (time + 5 features + target)
        eval(strcat('Video_Ten_Hz_signals_feature_', num2str(m), '{i} = [ Video_Ten_Hz_signals_feature_', num2str(m), '{i}, Ten_Hz_signals_data(:,end)];'));
    end
    eval(strcat('Video_ECG_feature_', num2str(m), ' = [zeros(window_size_ECG_raw - 1, num_signal_attributes); ECG_feature_', num2str(m), '];'));
    eval(strcat('Video_BELT_feature_', num2str(m), ' = [zeros(window_size_BELT_raw - 1, num_signal_attributes); BELT_feature_', num2str(m), '];'));
end

%% Time Matching (generalize for ECG signals)
% map the time of ECG and Belt signals into 10Hz data time
size_array = [];
    eval(strcat('size_array = [size_array; size(Video_ECG_feature_', num2str(m), ', 1)];'));
for m = 1:num_trips
end

[~, max_index] = max(size_array); % find the video index which has longest ECG signal length
% max_Video_ECG_feature = Video_ECG_feature_num2str(maxIndex);
eval(strcat('max_length_Video_ECG_feature = Video_ECG_feature_', num2str(max_index), ';'));
% max_Video_Ten_Hz_signals_feature = Video_Ten_Hz_signals_feature_num2str(maxIndex);
% extract the time column
eval(strcat('max_length_Video_Ten_Hz_signals_feature = Video_Ten_Hz_signals_feature_', num2str(max_index), '{1};'))

% time consuming job, and also have problem (maybe)
Lookup_Table = [];      % why use lookup table here?
Time_sequence = max_length_Video_Ten_Hz_signals_feature(:,1);
for j = window_size_Ten_Hz_signals:size(max_length_Video_Ten_Hz_signals_feature,1)
    Match_From = Time_sequence(j);
    %find the index which is closet to 10Hz data Match_From
    [~, Match_to_ECG] = min(abs(max_length_Video_ECG_feature(:,1) - Match_From));
    Lookup_Table = [Lookup_Table; [j, Match_to_ECG]];
end

for m = 1:num_trips
    % find the last point coresponding index
    eval(strcat('index = find(Lookup_Table(:,1) == size(Video_Ten_Hz_signals_feature_', num2str(m), '{1},1));'));
    % save ECG feature data and the new time index into a new variable 
    eval(strcat('Vedio_', num2str(m), '_new_ECG_feature = Video_ECG_feature_', num2str(m), '(Lookup_Table(1:index, 2),2:5);'));
    % add the number of window size 0 points at the begining
    eval(strcat('Vedio_', num2str(m), '_new_ECG_feature = [zeros(window_size_Ten_Hz_signals - 1, size(Vedio_', num2str(m), '_new_ECG_feature, 2)); Vedio_', num2str(m), '_new_ECG_feature ];'));
    % add new_ECG_feature into Ten_Hz_Signals_feature
    eval(strcat('Video_Ten_Hz_signals_feature_', num2str(m), ' = [ Video_Ten_Hz_signals_feature_', num2str(m), ', Vedio_', num2str(m), '_new_ECG_feature];'));
end

%% Generalization for Belt signal
size_array = [];
for m = 1:num_trips
    eval(strcat('size_array = [size_array; size(Video_BELT_feature_', num2str(m), ', 1)];'));
end

[~, max_index] = max(size_array); % find the video index which has longest BELT signal length
% max_Video_BELT_feature = Video_ECG_feature_num2str(maxIndex);
eval(strcat('max_Video_BELT_feature = Video_BELT_feature_', num2str(max_index), ';'));
% max_Video_Ten_Hz_signals_feature = Video_Ten_Hz_signals_feature_num2str(maxIndex);
% extract the time column
eval(strcat('max_Video_Ten_Hz_signals_feature = Video_Ten_Hz_signals_feature_', num2str(max_index), '{1};'))

% time consuming job, and also have problem (maybe)
Lookup_Table = [];      % why use lookup table here?
Time_sequence = max_Video_Ten_Hz_signals_feature(:,1);
for j = window_size_Ten_Hz_signals:size(max_Video_Ten_Hz_signals_feature, 1)
    Match_From = Time_sequence(j);
    %find the index which is closet to 10Hz data Match_From
    [~, Match_to_BELT] = min(abs(max_Video_BELT_feature(:,1) - Match_From));
    Lookup_Table = [Lookup_Table; [j, Match_to_BELT]];
end

for m = 1:num_trips
    % find the last point coresponding index
    eval(strcat('index = find(Lookup_Table(:,1) == size(Video_Ten_Hz_signals_feature_', num2str(m), '{1},1));'));
    % save ECG feature data and the new time index into a new variable 
    eval(strcat('Vedio_', num2str(m), '_new_BELT_feature = Video_BELT_feature_', num2str(m), '(Lookup_Table(1:index, 2),2:5);'));
    % add the number of window size 0 points at the begining
    eval(strcat('Vedio_', num2str(m), '_new_BELT_feature = [zeros(window_size_Ten_Hz_signals - 1, size(Vedio_', num2str(m), '_new_BELT_feature, 2)); Vedio_', num2str(m), '_new_BELT_feature ];'));
    % add new_ECG_feature into Ten_Hz_Signals_feature
    eval(strcat('Video_Ten_Hz_signals_feature_', num2str(m), ' = [ Video_Ten_Hz_signals_feature_', num2str(m), ', Vedio_', num2str(m), '_new_BELT_feature];'));
end

%% Calculate the x(t) - x(t-stepsize) of ECG and BELT Signal and add them into feature
for m = 1:num_trips
    for j = 1:2 %(+1 means ECG signal, and +2 means BELT signal)
      eval(strcat('signal = Video_Ten_Hz_signals_feature_',num2str(m),'{1, num_selected_signal + j};'));
      % why it is 5 ?
      [~, column] = size(signal);
      signal(:, column + 1)   = [0; diff(signal(:,1))];
      signal(window_size_Ten_Hz_signals, column + 1) = 0;
      eval(strcat('Video_Ten_Hz_signals_feature_',num2str(m),'{1, num_selected_signal + j} = signal;'))
    end
end
clearvars column;

%% Deal with ECG feature
%normalization
ECG_feature_all = [];
for m = 1:num_trips
    % now Video_Ten_Hz_signals_feature_m have 9 columns (7 + 2 signals, 8 is the ECG signal feature)
    eval(strcat('ECG_feature_all = [ECG_feature_all; Video_Ten_Hz_signals_feature_', num2str(m), '{:, 8}];'));  % this 8 should be modified
end

for j = 1:num_signal_attributes % until here ECG signal have 5 features
       ECG_feature_all(:,j) = (ECG_feature_all(:,j) - min(ECG_feature_all(:,j))) ...    % here has a problem !!!
           ./(max(ECG_feature_all(:,j)) - min(ECG_feature_all(:,j)));
end

offset = 0;
for j = m:num_selected_signal
    Video = ECG_feature_all;
    for m = 1:num_trips
        % signal_length = Video_m__Ten_Hz_signals_length;
        eval(strcat('signal_length = Video_', num2str(m), '_Ten_Hz_signals_length;'));
        % seperate the video according to the the length of each signal
        % Video_cal_m(j) = [zeros(window_size_cal - 1, num_signal_attributes + 1); Video( (offset + 1 : offset + signal_length), : )];
        eval(strcat('Video_ECG_feature_', num2str(m), ' = [Video( (offset + 1 : offset + signal_length), : )];'));
        eval(strcat('Video_Ten_Hz_signals_feature_', num2str(m), '{1, 8} = Video_ECG_feature_', num2str(m), ';'));
        offset = offset + signal_length;
    end
    offset = 0;
end

%% Deal with BELT feature
BELT_feature_all = [];
for j=1:num_signal_attributes
    eval(strcat('BELT_feature_all = [BELT_feature_all; Video_Ten_Hz_signals_feature_', num2str(m), '{:, 9}];'));
    BELT_feature_all(:,j)=(BELT_feature_all(:,j) - min(BELT_feature_all(:,j))) ...
        ./ (max(BELT_feature_all(:,j)) - min(BELT_feature_all(:,j)));
end

offset = 0;
for j = m:num_selected_signal
    Video = BELT_feature_all;
    for m = 1:num_trips
        % signal_length = Video_m__Ten_Hz_signals_length;
        eval(strcat('signal_length = Video_', num2str(m), '_Ten_Hz_signals_length;'));
        % seperate the video according to the the length of each signal
        % Video_cal_m(j) = [zeros(window_size_cal - 1, num_signal_attributes + 1); Video( (offset + 1 : offset + signal_length), : )];
%         eval(strcat('Video_BELT_feature_', num2str(m), ' = [Video( (offset + 1 : offset + signal_length), : )];'));
        eval(strcat('Video_Ten_Hz_signals_feature_', num2str(m), '{1, 9} = Video_BELT_feature_', num2str(m), ';'));
        offset = offset + signal_length;
    end
    offset = 0;
end

for m = 1:num_trips
    for j = 8:9
        eval(strcat('temp = ', 'Video_Ten_Hz_signals_feature_', num2str(m), '{1,j};'));
        % add two empty column at the begin and the end
        temp = [zeros(size(temp,1),1), temp, zeros(size(temp,1),1)];
        eval(strcat('Video_Ten_Hz_signals_feature_',num2str(m),'{1,j} = temp;'));
    end
end

save(strcat(home,'\Synchronized_Dataset\Video_Ten_Hz_signals_feature_Final.mat'), ...
    'Video_Ten_Hz_signals_feature_1', ...
    'Video_Ten_Hz_signals_feature_2', ...
    'Video_Ten_Hz_signals_feature_3', ...
    'Video_Ten_Hz_signals_feature_4', ...
    'Video_Ten_Hz_signals_feature_5');


