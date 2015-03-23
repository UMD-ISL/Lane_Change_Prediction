function OutputDataset = shuffleDataset(inputDataset)
    OutputDataset = inputDataset(randperm(size(inputDataset,1)),:);
end