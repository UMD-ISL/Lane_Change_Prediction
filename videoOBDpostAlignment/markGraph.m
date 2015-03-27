function markGraph(finalCurve)
[m n]=size(finalCurve(:,:,1));
for i=1:n
    x(i)=i;
    y(i)=finalCurve(1,i,1);
end

%# higlight points of interest
idx1=(51382<=x & x<=52995);
idx2=(x>=62367&x<=62585);
idx3=(x>=72840&x<=72880);
idx4=(x>=79184&x<=79315);
idx5=(x>=81958&x<=82622);
idx6=(x>=83177&x<=83761);
idx7=(x>=90362&x<=91136);
idx8=(x>=111178&x<=111908);
idx9=(x>=116564&x<=117338);
idx10=(x>=119405&x<=1119765);
idx11=(x>=123020&x<=123980);
plot(x,y);
hold on, plot(x(idx1), y(idx1), 'red')
hold on, plot(x(idx2), y(idx2), 'red')
hold on, plot(x(idx3), y(idx3), 'red')
hold on, plot(x(idx4), y(idx4), 'red')
hold on, plot(x(idx5), y(idx5), 'red')
hold on, plot(x(idx6), y(idx6), 'red')
hold on, plot(x(idx7), y(idx7), 'red')
hold on, plot(x(idx8), y(idx8), 'red')
hold on, plot(x(idx9), y(idx9), 'red')
hold on, plot(x(idx10), y(idx10), 'red')
hold on, plot(x(idx11), y(idx11), 'red')
hold off