function [Data_Path, Output_Path] = loadGlobalPathSetting()

    ini = IniConfig();
    ini.ReadFile('configuration.ini');

    Data_Path = strcat(ini.GetValues('Global Path Setting', 'DATA_PATH'), ...
    '/', ini.GetValues('Driver Dataset Path', 'DATA_PATH'));

    Output_Path = strcat(ini.GetValues('Global Path Setting', 'OUTPUT_PATH'), ...
    '/', ini.GetValues('Driver Dataset Path', 'DATA_PATH'));

end