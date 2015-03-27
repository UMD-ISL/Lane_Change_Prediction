function a=sumDiff(diff)
[m n l]=size(diff);
a=0;
for i=1:l
    for j=1:m
        for k=1:n
            a=a+diff(j,k,i);
        end
    end
end
        