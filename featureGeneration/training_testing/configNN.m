function netConfig = configNN()
%% Experiment setting
netConfig.hidNodes  = 15;
netConfig.lr        = 0.05;
netConfig.goal      = 1e-10;
netConfig.outNodes  = 2;
netConfig.epochs    = 100000000;
end