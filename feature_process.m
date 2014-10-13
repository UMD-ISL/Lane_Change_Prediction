function [Feature]=feature_process(Selected_signal,selected_Text,TbeforeLC,windowsize,stepsize,lanechangesize,methods,NumberofSignalSelected)
%VIDEODATAPROCESSING Summary of this function goes here
%   UM-Dearborn intellgent system lab
%   Kunqiao Li
[r,c] = size(Selected_signal);
%window = 5;
%step = 1;
%STD_V = [];
% var_name = {'Resp Rate Inst'	'Exp Vol'	'Insp Vol'	'Resp Rate'	'Tt'	'GSR'	'SCL'	'SCR'	'HR'	'RR'};

%how to find the event target
targetindex1=find(Selected_signal(:,end)==1);
targetindex2=find(Selected_signal(:,end)==2);
ID1=[];
ID2=[];
for i=1:length(targetindex1)-1
    if(i==1)
    ID1=targetindex1(1);
    end
    if(targetindex1(i+1)>targetindex1(i)+2)
    ID1=[ID1,targetindex1(i+1)];
    end
end
for i=1:length(targetindex2)-1
    if(i==1)
    ID2=targetindex2(1);
    end
    if(targetindex2(i+1)>targetindex2(i)+2)
    ID2=[ID2,targetindex2(i+1)];
    end
end
%target event index (ID)
LaneChangeOldInd=ID1/10;
NolangechangeInd=ID2/10;
NoLane=NolangechangeInd*10+1-TbeforeLC;
LaneBefore=LaneChangeOldInd*10+1-TbeforeLC;% at this time
[x1,y1]=size(LaneBefore);
[x2,y2]=size(NoLane);
index=1;   %for each lane change before start time
j=1;        %for each lane change we have 30 points of data
windowSegment={};
NowindowSegment={};
for index=1:y1
   for j=1:stepsize:lanechangesize                                  %Enlarge the period of Lanechange
       pointIndex=LaneBefore(index);
       windowIndex=[pointIndex-windowsize+j:pointIndex+(j-1)];
       windowSegment=[windowSegment,windowIndex];

   end
end
for index=1:y2
   for j=1:stepsize:lanechangesize  

       NopointIndex=NoLane(index);
       NowindowIndex=[NopointIndex-windowsize+j:NopointIndex+(j-1)];
       NowindowSegment=[NowindowSegment,NowindowIndex];
          end
end

%% HR Te Ti Exp Vol Insp Vol qDEEL
for i=1:NumberofSignalSelected
    for j=1:length(windowSegment)
        Signal=Selected_signal(windowSegment{j},i);
        [featvec1(j,:),~]=featureextract(Signal);
       
        
    end
    Feature{i,1}=featvec1;
end

for i=1:NumberofSignalSelected
    for j=1:length(NowindowSegment)
        Signal=Selected_signal(NowindowSegment{j},i);
        [featvec2(j,:),~]=featureextract(Signal);
       
        
    end
    Feature{i,2}=featvec2;
    Feature{i,3}=[Feature{i,1};Feature{i,2}];
end

%% RR feature part
% first calculate lane change feature
% for i=1:length(windowSegment)
%     ts=(windowSegment{i}/10)';
%     rr=Selected_signal(windowSegment{i},3);
%     hr=Selected_signal(windowSegment{i},1);
%     ibi=[ts,rr,hr];
%     ibi_fre1=[ts,rr];
%     [output_time_domain_cell{i},description_time]=timeDomainHRV(ibi);
%     output_time_domain_mat(:,i)=output_time_domain_cell{i}';
%     [output_fre_domain_cell{i},description_fre]=freqDomainHRV(ibi_fre1,[0.0165 0.2],[0.2 0.75],[0.75 2],16,20,19,512,20,methods,0);
%     output_fre_domain_mat(:,i)=output_fre_domain_cell{i}';
% end
% for i=1:length(NowindowSegment)
%     ts=(NowindowSegment{i}/10)';
%     rr=Selected_signal(NowindowSegment{i},3);
%     hr=Selected_signal(NowindowSegment{i},1);
%     ibi=[ts,rr,hr];
%     ibi_fre2=[ts,rr];
%     [no_output_time_domain_cell{i},description_time]=timeDomainHRV(ibi);
%     no_output_time_domain_mat(:,i)=no_output_time_domain_cell{i}';
%     [no_output_fre_domain_cell{i},description_fre]=freqDomainHRV(ibi_fre2,[0.0165 0.2],[0.2 0.75],[0.75 2],16,20,19,512,20,methods,0);
%     no_output_fre_domain_mat(:,i)=no_output_fre_domain_cell{i}';
% end
% time_domain_features=[output_time_domain_mat,no_output_time_domain_mat];
% fre_doamin_features=[output_fre_domain_mat,no_output_fre_domain_mat];

end
% i=1;
% 
% trainingInput=[Diff1Vec;Diff1VecSTD;Diff2Vec;Diff2VecSTD;Diff1max;Diff1min;stdVec;meanVec;maxVec;minVec];
% [normal_r,normal_c]=size(trainingInput);
% for i=1:normal_r
%    max1=max(trainingInput(i,:));
%    min1=min(trainingInput(i,:));
%    trainingInput(i,:)=(trainingInput(i,:)-min1)/(max1-min1);
% end
% 
% targetsize=length(windowSegment);
% notargetsize=length(NowindowSegment);
% beforetarget=ones(1,targetsize);
% notarget=zeros(1,notargetsize);
% 
% trainingTarget=[beforetarget,notarget];  
% %% process feature
% 
% %1 first order deriviation
% %2 first order of the STD derivative
% %3 second order of the derivative
% %4 second order of the STD derivative
% %5 first order of max
% %6 first order of min
% %7 standard deviation of the value
% %8 mean of the value
% %9 max of the value
% %10 min of the value
% 
% Diff1VecBefore={}; 
% Diff1VecBeforeSTD={};
% Diff2VecBefore={};
% Diff2VecBeforeSTD={};
% Diff1maxBefore={};
% Diff1minBefore={};
% stdVecBefore={};
% meanVecBefore={};
% maxVecBefore={};
% minVecBefore={};
% 
% noDiff1VecBefore={}; 
% noDiff1VecBeforeSTD={};
% noDiff2VecBefore={};
% noDiff2VecBeforeSTD={};
% noDiff1maxBefore={};
% noDiff1minBefore={};
% nostdVecBefore={};
% nomeanVecBefore={};
% nomaxVecBefore={};
% nominVecBefore={};
% 
% 
% for i=1:length(windowSegment)
%      
%      midVar=diff(Selected_signal(windowSegment{i},1:end-1));
%      
%      tmp1Before = mean(midVar);
%      Diff1VecBefore = [Diff1VecBefore,tmp1Before'];
% 
%      tmp1BeforeSTD = std(midVar);
%      Diff1VecBeforeSTD = [Diff1VecBeforeSTD,tmp1BeforeSTD'];
%      
%      tmp1maxBefore = max(midVar); 
%      Diff1maxBefore=[Diff1maxBefore,tmp1maxBefore'];
%  
%      tmp1minBefore = min(midVar); 
%      Diff1minBefore=[Diff1minBefore,tmp1minBefore'];
%       
%      midVar=diff(midVar);
%      
%      tmp2Before = mean(midVar); 
%      Diff2VecBefore = [Diff2VecBefore,tmp2Before'];
% 
%      
%      tmp2BeforeSTD = std(midVar);
%      Diff2VecBeforeSTD = [Diff2VecBeforeSTD,tmp2BeforeSTD'];
% 
%      
%      
% 
%      
%      tmpBeforeSTD = std(Selected_signal(windowSegment{i},1:end-1));
%      stdVecBefore = [stdVecBefore,tmpBeforeSTD'];
% 
%      
%      tmpBeforeMEAN = mean(Selected_signal(windowSegment{i},1:end-1));
%      meanVecBefore = [meanVecBefore,tmpBeforeMEAN'];
% 
%      
%      tmpBeforeMAX = max(Selected_signal(windowSegment{i},1:end-1));
%      maxVecBefore = [maxVecBefore,tmpBeforeMAX'];
% 
%      
%      tmpBeforeMIN = min(Selected_signal(windowSegment{i},1:end-1));
%      minVecBefore = [minVecBefore,tmpBeforeMIN'];
% 
% 
% end
%  for i=1:length(NowindowSegment)
%      midVar=diff(Selected_signal(NowindowSegment{i},1:end-1));
%      
%      notmp1Before = mean(midVar); 
%      noDiff1VecBefore = [noDiff1VecBefore,notmp1Before'];
%      
%      notmp1BeforeSTD = std(midVar);
%      noDiff1VecBeforeSTD = [noDiff1VecBeforeSTD,notmp1BeforeSTD'];
%      
%      notmp1maxBefore = max(midVar); 
%      noDiff1maxBefore=[noDiff1maxBefore,notmp1maxBefore'];
%      
%      notmp1minBefore = min(midVar); 
%      noDiff1minBefore=[noDiff1minBefore,notmp1minBefore'];
%      
%      midVar=diff(midVar);
%      
%      notmp2Before = mean(midVar); 
%      noDiff2VecBefore = [Diff2VecBefore,tmp2Before'];
% 
%      
%      notmp2BeforeSTD = std(midVar);
%      noDiff2VecBeforeSTD = [Diff2VecBeforeSTD,tmp2BeforeSTD'];
%  
%      notmpBeforeSTD = std(Selected_signal(NowindowSegment{i},1:end-1));
%      nostdVecBefore = [nostdVecBefore,notmpBeforeSTD'];
%      
%      notmpBeforeMEAN = mean(Selected_signal(NowindowSegment{i},1:end-1));
%      nomeanVecBefore = [nomeanVecBefore,notmpBeforeMEAN'];
%      
%      notmpBeforeMAX = max(Selected_signal(NowindowSegment{i},1:end-1));
%      nomaxVecBefore = [nomaxVecBefore,notmpBeforeMAX'];
%      
%      notmpBeforeMIN = min(Selected_signal(NowindowSegment{i},1:end-1));
%      nominVecBefore = [nominVecBefore,notmpBeforeMIN'];
%      
%   end
% %% feature collection
% 
% Diff1Veccell={};
% Diff1VecSTDcell={};
% Diff2Veccell={};
% Diff2VecSTDcell={};
% Diff1maxcell={};
% Diff1mincell={};
% stdVeccell={};
% meanVeccell={};
% maxVeccell={};
% minVeccell={};
% 
% 
% Diff1Veccell=[Diff1VecBefore,noDiff1VecBefore];
% Diff1VecSTDcell=[Diff1VecBeforeSTD,noDiff1VecBeforeSTD];
% Diff2Veccell=[Diff2VecBefore,noDiff2VecBefore];
% Diff2VecSTDcell=[Diff2VecBeforeSTD,noDiff2VecBeforeSTD];
% Diff1maxcell=[Diff1maxBefore,noDiff1maxBefore];
% Diff1mincell=[Diff1minBefore,noDiff1minBefore];
% stdVeccell=[stdVecBefore,nostdVecBefore];
% meanVeccell=[meanVecBefore,nomeanVecBefore];
% maxVeccell=[maxVecBefore,nomaxVecBefore];
% minVeccell=[minVecBefore,nominVecBefore];
% 
% 
% Diff1Vec=[];
% Diff1VecSTD=[];
% Diff2Vec=[];
% Diff2VecSTD=[];
% Diff1max=[];
% Diff1min=[];
% stdVec=[];
% meanVec=[];
% maxVec=[];
% minVec=[];
% 
% 
% for iii=1:length(Diff1Veccell)
%     Diff1Vec=[Diff1Vec,Diff1Veccell{iii}];
%     Diff1VecSTD=[Diff1VecSTD,Diff1VecSTDcell{iii}];
%     Diff2Vec=[Diff2Vec,Diff2Veccell{iii}];
%     Diff2VecSTD=[Diff2VecSTD,Diff2VecSTDcell{iii}];
%     Diff1max=[Diff1max,Diff1maxcell{iii}];
%     Diff1min=[Diff1min,Diff1mincell{iii}];
%     stdVec=[stdVec,stdVeccell{iii}];
%     meanVec=[meanVec,meanVeccell{iii}];
%     maxVec=[maxVec,maxVeccell{iii}];
%     minVec=[minVec,minVeccell{iii}];
% end








