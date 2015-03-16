function plotFig()
    figure('color', 'w');
    h(1) = subplot(5, 1, 1);
    plot(rand(1,20));
    
    h(2) = subplot(5, 1, 2);
    plot(rand(1,20));
    
    h(3) = subplot(5, 1, 3);
    plot(rand(1,20));
    
    h(4) = subplot(5, 1, 4);
    plot(rand(1,20));
    
    h(5) = subplot(5, 1, 5);
    plot(rand(1,20));


    set(h, 'box', 'off');
    set(h(1:4),'xcolor','w');
    linkaxes(h');
end