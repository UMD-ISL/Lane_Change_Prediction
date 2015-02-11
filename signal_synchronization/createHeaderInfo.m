function inputData = createHeaderInfo(inputData)

    inputData.Text_Index = [inputData.Gsr_Txt, inputData.Ecg_Txt, ...
                            inputData.Rsp_Txt, inputData.GSR_RAW_Txt, ...
                            inputData.ECG_RAW_Txt, inputData.BELT_RAW_Txt, ...
                            inputData.target_Txt(1, 16)
                            % need modification here according to new label
                            % result
                            ];
                
end