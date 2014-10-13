function figure1=draw_graph(data,TextIndex,feature_index,ColumeofLanechange)
C=feature_index;
figure1=figure;
plot(data(:,C));
hold on
A=find(data(:,ColumeofLanechange)==1);
B=find(data(:,ColumeofLanechange)==2);
for i=1:length(A)-1
    if(i==1)
    ID_pre=A(1);
    ID_post=[];
    end
    if(A(i+1)>A(i)+2)
    ID_pre=[ID_pre,A(i+1)];
    ID_post=[ID_post,A(i)];
    end
    
end
for i=1:length(B)-1
    if(i==1)
    ID2_pre=B(1);
    ID2_post=[];
    end
    if(B(i+1)>B(i)+2)
    ID2_pre=[ID2_pre,B(i+1)];
    ID2_post=[ID2_post,B(i)];
    end
    
end
ID_post=[ID_post,A(end)];
ID2_post=[ID2_post,B(end)];

Length=length(ID_pre);
for j=1:Length
    D=ID_pre(1,j);
    B=ID_post(1,j);
    plot(D:B,data(D:B,C),'r','LineWidth',2)
end
Length=length(ID2_pre);
for j=1:Length
    D=ID2_pre(1,j);
    B=ID2_post(1,j);
    plot(D:B,data(D:B,C),'g','LineWidth',2)
end

% Create title
title([TextIndex(C),'Signal'],'FontSize',12);

% Create xlabel
xlabel('Sampling Points','FontSize',12);

% Create ylabel
% ylabel('Frequency/min','FontSize',12);

% % Create arrow
% annotation(figure1,'arrow',[0.565307532826538 0.653766413268832],...
%     [0.3125 0.496323529411765],'Color',[1 0 0]);
% 
% % Create arrow
% annotation(figure1,'arrow',[0.551485832757429 0.547339322736697],...
%     [0.321691176470588 0.465073529411765],'Color',[1 0 0]);
% 
% % Create arrow
% annotation(figure1,'arrow',[0.578438147892191 0.657912923289565],...
%     [0.279411764705882 0.481617647058824],'Color',[1 0 0]);
% 
% 
% % Create textbox
% annotation(figure1,'textbox',...
%     [0.535899792674498 0.147058823529412 0.0577422252937111 0.159926470588235],...
%     'String',{'Lane','Change','Events'},...
%     'FontSize',12,...
%     'FitBoxToText','off',...
%     'LineStyle','none',...
%     'Color',[1 0 0]);
% 
% % Create arrow
% annotation(figure1,'arrow',[0.534899792674499 0.505874222529371],...
%     [0.3125 0.470588235294118],'Color',[1 0 0]);


