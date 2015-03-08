function [ output_args ] = test_RT2_L1( netTrained, netConfig )

    k = [];

    load(strcat(home, '\DataSet\video1.mat'));         %   38200-39300 3LC
    load(strcat(home, '\DataSet\video2.mat'));         %   3000 - 9000 8LC
    load(strcat(home, '\DataSet\video3.mat'));         %   900  - 3800 7LC
    load(strcat(home, '\DataSet\video4.mat'));         %   4000 - 8500 9LC
    load(strcat(home, '\DataSet\video5.mat'));         %   11000-19000 6LC
    load(strcat(home, '\DataSet\video6.mat'));         %   4000  -7500 6LC


    rt_input(:, 1     :  1100) = train_video1(:, 38201 : 39300);
    rt_input(:, 1101  :  7100) = train_video2(:, 3001  :  9000);
    rt_input(:, 7101  : 10000) = train_video3(:, 901   :  3800);
    rt_input(:, 10001 : 14500) = train_video4(:, 4001  :  8500);
    rt_input(:, 14501 : 22500) = train_video5(:, 11001 : 19000);

    rt_target(:, 1     :  1100) = ground_video1(:, 38201 : 39300);
    rt_target(:, 1101  :  7100) = ground_video2(:, 3001  :  9000);
    rt_target(:, 7101  : 10000) = ground_video3(:, 901   :  3800);
    rt_target(:, 10001 : 14500) = ground_video4(:, 4001  :  8500);
    rt_target(:, 14501 : 22500) = ground_video5(:, 11001 : 19000);


    NN1_OutputTrain = sim(netTrained, rt_input);
    NN1_OutputTest = sim(netTrained, train_video6);


    pointNum = 20;

    for i = 21 : 1100
        NN2_TrainingInput(1 : pointNum, i-20) = NN1_OutputTrain(1, i-pointNum+1 : i)';
        NN2_TrainingTarget(1, i-20) = rt_target(1, i);
    end

    for i = 1121 : 7100
        NN2_TrainingInput(1 : pointNum, i-40) = NN1_OutputTrain(1, i-pointNum+1 : i)';
        NN2_TrainingTarget(1, i-40) = rt_target(1, i);
    end

    for i = 7121 : 10000
        NN2_TrainingInput(1 : pointNum, i-60) = NN1_OutputTrain(1, i-pointNum+1 : i)';
        NN2_TrainingTarget(1, i-60) = rt_target(1, i);
    end

    for i = 10021 : 14500
        NN2_TrainingInput(1 : pointNum, i-80) = NN1_OutputTrain(1, i-pointNum+1 : i)';
        NN2_TrainingTarget(1, i-80) = rt_target(1, i);
    end

    for i = 14521 : 22500
        NN2_TrainingInput(1 : pointNum, i-100) = NN1_OutputTrain(1, i-pointNum+1 : i)';
        NN2_TrainingTarget(1, i-100) = rt_target(1, i);
    end


    for i = 21 : 1100
        NN2_TrainingInput(1 : pointNum, i-20) = NN1_OutputTrain(1, i-pointNum+1 : i)';
        NN2_TrainingTarget(1, i-20) = rt_target(1, i);
    end


    for i = 4001 : 7500
        NN2_TestingInput(1 : pointNum, i-4000) = NN1_OutputTest(1, i-pointNum+1 : i)';
        NN2_TestingTarget(1, i-4000) = ground_video6(1, i);
    end



    j = 1;

    for i = 1 : 22400

        if NN2_TrainingTarget(1, i) == 1

            NN2_TrainingInput2(:, j) = NN2_TrainingInput(:, i);
            NN2_TrainingTarget2(1, j) = NN2_TrainingTarget(1, i);
            j = j + 1;

        end

    end


    NN2_TrainingInput2(:, 694  : 1193) = NN2_TrainingInput(:, 5001  : 5500 );
    NN2_TrainingInput2(:, 1194 : 1693) = NN2_TrainingInput(:, 16001 : 16500);
    NN2_TrainingInput2(:, 1694 : 2193) = NN2_TrainingInput(:, 18001 : 18500);
    NN2_TrainingTarget2(1, 694 : 2193) = 0;


    disp('Start training for 2nd layer...'); tic;
    [netTrained, accuracy_train] = train(NN2_TrainingInput2, NN2_TrainingTarget2, NN2_TestingInput, NN2_TestingTarget, netConfig, k);
    disp('Finish training for 2nd layer...'); toc;   

    disp('Start testing for 2nd layer...'  ); tic;
    [ true_positive, false_negative, false_positive, true_negative, accuracy_test ] = test(netTrained, NN2_TestingInput, NN2_TestingTarget);
    disp('Finish testing for 2nd layer...'  ); tic;



end

