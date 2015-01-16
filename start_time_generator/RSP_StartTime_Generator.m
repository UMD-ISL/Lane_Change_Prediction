function RSP_start_Time = RSP_StartTime_Generator(RSP_filepath)
    % read RSP.csv file  # 3
    [Data, Header, ~]   =  xlsread(RSP_filepath);  % have some problem here
    Header = Header(1,:);
    % find the column number of Timestamp
    [~, index]  = ismember('Timestamp', Header);
    RSP_start_Time      = datestr(Data(1,index), 'HH:MM:SS.FFF');
end

