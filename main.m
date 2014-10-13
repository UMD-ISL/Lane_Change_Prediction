function main()
clc
clear all
Inroot='N:\tianyu\code1\';%% Need to verify
Outroot_origin='N:\tianyu\code1\';%%Need to verify
% Outroot_trend='result/';%%Need to verify
NumberofTrips=8; %%Need to verify
ColumeofLanechange=21;%%Need to verify   
for i=1:NumberofTrips
    load(strcat('synDataAll_new',num2str(i),'.mat'));
    TextIndex{20,:}='GSR2';
    save(strcat('synDataAll_new',num2str(i),'.mat'),'TextIndex','dataAll_cal','dataAll_ECG','dataAll_BELT');
end
noise_remove(Inroot,Outroot_origin,NumberofTrips,ColumeofLanechange);
end

function noise_remove(Inroot,Outroot_origin,NumberofTrips,ColumeofLanechange)
for mk=1:NumberofTrips
mkdir(Outroot_origin,strcat('figure_',num2str(mk)));
end
for i=1:NumberofTrips
load(strcat(Inroot,'\synDataAll_new',num2str(i)));
DATA=dataAll_cal;
Selected_signal=[];
selected_Text=[];
%% denoise the spikes and choose the signal we want(with interpolate method)
for j=1:(ColumeofLanechange-1)
    Text=TextIndex(j+1,1);
    Text1=Text{1,1};
    switch Text1
        case 'HR'
                     
            data=dataAll_cal(:,j+1);
            Selected_signal(:,1)=data;
            selected_Text{1,1}='HR';
            figure1=draw_graph(DATA,TextIndex,j+1,ColumeofLanechange);
            saveas(figure1,strcat(Outroot_origin,'figure_',num2str(i),'/HR_signal'),'fig');
            close(figure1);

        case 'Te'
            data=dataAll_cal(:,j+1);  
            Selected_signal(:,2)=data;
            selected_Text{2,1}='Te';
            figure1=draw_graph(DATA,TextIndex,j+1,ColumeofLanechange);
            saveas(figure1,strcat(Outroot_origin,'figure_',num2str(i),'/Te_signal'),'fig');
            close(figure1);
        case 'Ti'
            data=dataAll_cal(:,j+1);  
            Selected_signal(:,3)=data;
            selected_Text{3,1}='Ti';
            figure1=draw_graph(DATA,TextIndex,j+1,ColumeofLanechange);
            saveas(figure1,strcat(Outroot_origin,'figure_',num2str(i),'/Ti_signal'),'fig');
            close(figure1);
        case 'Exp Vol'
            data=dataAll_cal(:,j+1);  
            Selected_signal(:,4)=data;
            selected_Text{4,1}='Exp Vol';
            figure1=draw_graph(DATA,TextIndex,j+1,ColumeofLanechange);
            saveas(figure1,strcat(Outroot_origin,'figure_',num2str(i),'/Exp Vol_signal'),'fig');
            close(figure1);
        case 'Insp Vol'
            data=dataAll_cal(:,j+1);  
            Selected_signal(:,5)=data;
            selected_Text{5,1}='Insp Vol';
            figure1=draw_graph(DATA,TextIndex,j+1,ColumeofLanechange);
            saveas(figure1,strcat(Outroot_origin,'figure_',num2str(i),'/Insp Vol_signal'),'fig');
            close(figure1);
        case 'qDEEL'
            data=dataAll_cal(:,j+1);  
            Selected_signal(:,6)=data;
            selected_Text{6,1}='qDEEL';
            figure1=draw_graph(DATA,TextIndex,j+1,ColumeofLanechange);
            saveas(figure1,strcat(Outroot_origin,'figure_',num2str(i),'/qDEEL_signal'),'fig');
            close(figure1);
        case 'GSR2'
            data=dataAll_cal(:,j+1);  
            Selected_signal(:,7)=data;
            selected_Text{7,1}='GSR(microSiemens)';
            figure1=draw_graph(DATA,TextIndex,j+1,ColumeofLanechange);
            saveas(figure1,strcat(Outroot_origin,'figure_',num2str(i),'/GSR(microSiemens)'),'fig');
            close(figure1);
    end
end
Selected_signal=[dataAll_cal(:,1) Selected_signal dataAll_cal(:,ColumeofLanechange)];
selected_Text=[selected_Text;{'Lane Change'}];
dataAll_cal=Selected_signal;
TextIndex=selected_Text;
save(strcat(Outroot_origin,'synDataAll_',num2str(i),'.mat'),'TextIndex','dataAll_cal','dataAll_ECG','dataAll_BELT');
end
end




    