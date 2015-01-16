function fileCell = csvReader(fileName)

fileCell = {};
fid = fopen(fileName, 'r');
tline = fgetl(fid);
rowCnt = 0;
while ischar(tline)
    tline = cleanUp(tline);
    rowCnt = rowCnt+1;
    pst = strfind(tline, ',');
    colCnt = 0;
    for i=pst
        colCnt = colCnt+1;
        if colCnt==1
            thisCell = tline(1:pst(colCnt)-1);
        else
            thisCell = tline(pst(colCnt-1)+1:pst(colCnt)-1);
        end
        if ~isempty(thisCell) && thisCell(1)=='"'
            thisCell = thisCell(2:end-1);
        end
        fileCell{rowCnt, colCnt} = thisCell;
    end
    if length(tline)>pst(end)
        colCnt = colCnt+1;
        thisCell = tline(pst(end)+1:end);
        if ~isempty(thisCell) && thisCell(1)=='"'
            thisCell = thisCell(2:end-1);
        end
        fileCell{rowCnt, colCnt} = thisCell;
    end
    tline = fgetl(fid);
end

end

function tline = cleanUp(tline)

pst = strfind(tline, ', ');
while ~isempty(pst)
    tline(pst+1) = '';
    pst = strfind(tline, ', ');
end
pst = strfind(tline, ' ,');
while ~isempty(pst)
    tline(pst) = '';
    pst = strfind(tline, ' ,');
end

end