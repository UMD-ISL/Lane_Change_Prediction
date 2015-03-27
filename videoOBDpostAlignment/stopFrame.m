function stop_frame=stopFrame(finalCurve)
[row col]=size(finalCurve);
windowSize=30;
threshold=0.02e-6;
frames=[];
stop_frame=[];
for count=1:col-windowSize+1
    temp=finalCurve(count:count+windowSize-1);
%     stop_frame=[stop_frame var(temp)];
    if var(temp)<threshold
        frames=[frames count];
    end
end
[row col]=size(frames);
for t=1:col-1
    if abs(frames(t+1)-frames(t))>100
        stop_frame=[stop_frame frames(t)];
    end
end