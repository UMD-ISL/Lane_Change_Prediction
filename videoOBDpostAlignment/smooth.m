function output=smooth(record,windowSize)
if nargin==1
    windowSize=30;
end
output=medfilt1(record,windowSize);