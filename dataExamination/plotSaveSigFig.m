function plotSaveSigFig(sigParams, sig, targetData, vidIndex, ...
            dataExaminationOutput)
    for j = 2:size(sigParams, 2)
        hfig = draw_graph(sig.data(:, 1), sigParams{1, j}, ...
            sig.data(:, j), targetData, vidIndex);
            if strfind(sigParams{1, j}, '/')
                newParams = strrep(sigParams{1, j}, '/', '_');
            else
                newParams = sigParams{1, j};
            end
            savefile = strcat(dataExaminationOutput, '/Video_', ...
                            num2str(vidIndex), '_', newParams);
            savefig(hfig, savefile);
    end
end