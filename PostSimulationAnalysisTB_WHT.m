
% Script that analyzes the file ResultsInterval, which is a t x k x jj
% matrix. t: year, k: variables of results, jj: iterations.

% Leslie J. Verteramo Chiu.
% Version 1. Jan, 19, 2017.


% The data is either saved already or stored in the 'ResultsInterval' in the Workplace.
% 


% The variable names are in ResultsIntervalText.

% ResultsIntervalText={'MilkProduction','NatCulledCows','MaleCalves','NatCulledFemaleCalves','TotalGrossNPV','TotalExpensesExFeed','NetNPV'...
%     ,'Parity','CullRate','S','L','Y1','Y2','CS','CI','HS','HI','Inf_AA','VertTrans','Inf_AC','Inf_C','Inf_H','HorTransS_L',...
%     'ProgrL_Y1','ProgrY1_Y2','VertTransC_L','VertTransC_Y1','VertTransC_Y2','HorC_Adult','HorTransC_C','HorTransHeifers'};

ResultsIntervalText={'MilkProduction','NatCulledCows','MaleCalves','NatCulledFemaleCalves','TotalGrossNPV','TotalExpensesExFeed','NetNPV'...
    ,'Parity','CullRate','S','L','Y1','Y2','CS','CI','HS','HI','Inf_AA','VertTrans','Inf_AC','Inf_C','Inf_H','HorTransS_L',...
    'ProgrL_Y1','ProgrY1_Y2','VertTransC_L','VertTransC_Y1','VertTransC_Y2','HorC_Adult','HorTransC_C','HorTransHeifers',...
    'S_Tb','O_Tb','R_Tb','I_Tb','HS_Tb','HO_Tb','HR_Tb','HI_Tb','CSTb','COTb','STb_Inf','STbCa_Inf','STbH_Inf'};

% They arc
% Load WHT saved file

% clear
% 
% filename=('ResultsOct_Current_100_Tb1_2n60d_AVP_WHT.mat');
% S= load(filename);
% Results= S.Results;
% 
% 
% filename=('ResultsInterval_June30_1_8n_WCSPMT_USDA.mat');
% S= load(filename);
% ResultsInterval= S.ResultsInterval;




clear filename S maxrunsWHT locb loc* x timestamp runlength pdk800 pd800

% Estimate the number of consecutive negative WHT
% Tb Results
% Day of WHT with no Tb Infected (O-I)
% ResWHT=ResultsWHT(:,:,1);
% 
% 
% [~,locb]= ismember(0,ResultsWHT(:,6,i)); % index when number of true Tb infected animals is 0
% [~,locbday]= ismember(0,ResultsWHT(:,1,i)); % index when days for WHT is 0 (1 before last WHT)
% [~,locbPos]= ismember(0,ResultsWHT(:,5,i)); % index when TB Negative test occurs
% 
% V= [ResultsWHT((1:locb),5,i)]'; % Get vector or number of true positive WHT until NO Actual TB in herd
% V(V(:,:)>0)= 1  ; % Transform all positive to 1
% timestamp = [find(diff([-1, V,-1]) ~= 0)]; % where does V change
% runlength = diff(timestamp) ;
% to split them for 0's and 1's
%ResWHT=ResultsWHT(:,:,3);

% % Count neg WHT to eliminate bTB in herd. 
% if ResWHT(1,1)==0 % If no bTB found in the herd, no WHT
%     runlength= 0; 
% else 
%     [~,locb]= ismember(0,(ResWHT(:,6))); % index when number of true Tb infected animals is 0
%     
%     while ResWHT(locb,5)>0
%         locb= locb+1;
%     end
%     
%     
%     V= [ResWHT((1:locb),5)]'; % Get vector or number of true positive WHT until NO Actual TB in herd
%     V(V(:,:)>0)= 1; % Transform all positive to 1
%     seq=  (diff( [0 (find(  (V > 0) ) ) numel(V) + 1] ) - 1);
%     maxrun= max(seq);
%     if sum(seq)>0
%         seq(seq(1,:)==0)=[]; 
% 
%     else
%         seq= 1;
%         maxrun= 1;
%     end
%     if maxrun==seq(end)
%         runlength= maxrun;
%     else
%         runlength= maxrun+1;
%     end
% 
% 
% end

clear
%%%%%%%%%%%%%


filename=('ResultsWHT');
S= load(filename);
S= ResultsWHT; % if data in workplace
ResultsWHT= ResWHT1;



repnumtest= 1; % if max num of consecutive neg test are repeated, add one more to max.
                % e.g., if test results are: 1,1,0,1,0,  then max num of
                % WHT is 2, not one
clear jj maxrunsWHT

for jj= 1:size(ResultsWHT,3)
    
    if ResultsWHT(1,1,jj)==0 % If no bTB found in the herd, no WHT
        runlength= 0;
        numWHTnoTB= 0;
    else
        [~,locb]= ismember(0,ResultsWHT(:,6,jj)); % index when number of true Tb infected animals is 0
        while ResultsWHT(locb,5,jj)>0 % if the PCR test is positive, look at next pcr test results
            locb= locb+1;
        end
        numWHTnoTB= locb -1;
        V= [ResultsWHT((1:locb),5,jj)]'; % Get vector or number of true positive WHT until NO Actual TB in herd
        V(V(:,:)>0)= 1; % Transform all positive to 1
        seq=  (diff( [0 (find(  (V > 0) ) ) numel(V) + 1] ) - 1);
        
        
        a = unique(seq);
        freqtest = [a',histc(seq(:),a)];
        
            if freqtest(end,2)>1 && repnumtest==1 % max num cons neg WHT repeats
            runlength= freqtest(end,1)+1; % add one to the max neg WHT sequence
            else
            runlength= freqtest(end,1);   
            end
        
        %%%%%
        
%         maxrun= max(seq);
%         if sum(seq)>0
%             seq(seq(1,:)==0)=[]; 
%             else
%                 seq= 1;
%                 maxrun= 1;
%         end
%         if maxrun==seq(end)
%             runlength= maxrun;
%         else
%             runlength= maxrun+1;
%         end
    end
    
    maxrunsWHT(jj,1:2)= [runlength,numWHTnoTB] ; % store the maximum neg consecutuve WHT to eliminate bTB
    
%     [~,locb]= ismember(0,ResultsWHT(:,6,jj)); % index when number of true Tb infected animals is 0
%     V= [ResultsWHT((1:locb),5,jj)]'; % Get vector or number of true positive WHT until NO Actual TB in herd
%     V(V(:,:)>0)= 1  ; % Transform all positive to 1
%     timestamp = [find(diff([-1, V,-1]) ~= 0)]; % where does V change
%     runlength = diff(timestamp) ;
    %   runsWHTnone(jj,(1:size(runlength(1+(V(1)==1):2:end),2)))= runlength(1+(V(1)==1):2:end); % Store number of times WHT is done with no TB infected animals

  clear locb V 
end

clear locb* V timestamp runlength jj

% maxrunsWHT: col 1: Max Num Neg WHT to eliminate bTB (in all phases!)
%              col 2: Number of TOTAL WHT to eliminate bTB


%runsWHTnoneText={'Number of consecutive WHT before eliminating All TB animals'};
%%%%%%%%%%%%
% List of number of WHT before Eliminating Tb
% maxrunsWHT= maxrunsWHT +1;
% x= accumarray(maxrunsWHT(:,1),1)'

% a1 = unique(maxrunsWHT(:,1));
% freqtest = [a1,histc(maxrunsWHT(:,1),a1)] ;
 %% Frequency of max num WHT for bTB =0, and Num of WHT for bTB=0.
 a2 = unique(maxrunsWHT(:,2));
 freqtest = [(0:max(a2))',histc(maxrunsWHT(:,1:2),0:max(a2))] 
 
 R= ResultsWHT(:,:,2);
 
 % concatenate ResultsWHT 
  ResWHT= ResultsWHT(:,:,maxrunsWHT>0);
  
  
  R= ResWHT(:,:,1);
  
  
  
% ResultsWHT = cat(3,ResWHT,ResWHT1);
%  ResWHT1 = ResultsWHT;
%  
%  save('RMar_1000_Tb1_60d_PERT2_10WHT_WHT.mat','ResWHT1')
% maxrunsWHT(:,1)= max(runsWHTnone,[],2); % Get the maximum run for each iteration




% btb 1 
x1= x;
maxrunsWHT1= maxrunsWHT;

x5= x;
maxrunsWHT5= maxrunsWHT;

x10= x;
maxrunsWHT10= maxrunsWHT;

x25= x;
maxrunsWHT25= maxrunsWHT;

x50= x;
maxrunsWHT50= maxrunsWHT;

x100= x;
maxrunsWHT100= maxrunsWHT;

x1t50= x;
maxrunsWHT1t50= maxrunsWHT;

x1t100= x;
maxrunsWHT1t100= maxrunsWHT;
%%%%%%%%%%%%%%%%

clear pd pdk
pd1= fitdist(maxrunsWHT1,'exponential'); % 1 bTB
pd5= fitdist(maxrunsWHT5,'exponential'); % 5 bTB
pd10= fitdist(maxrunsWHT10,'exponential'); % 10 bTB
pd25= fitdist(maxrunsWHT25,'exponential'); % 25 bTB
pd50= fitdist(maxrunsWHT50,'exponential'); % 50 bTB
pd100= fitdist(maxrunsWHT100,'exponential'); % 100 bTB

pd1t50= fitdist(maxrunsWHT1t50,'exponential'); % 1 to 50 bTB
pd1t100= fitdist(maxrunsWHT1t100,'exponential'); % 1 to 100 bTB

pd= fitdist(maxrunsWHT,'exponential')

pdk = fitdist(maxrunsWHT,'Kernel','Kernel','epanechnikov')
pdk1 = fitdist(maxrunsWHT1,'Kernel','Kernel','epanechnikov')
pdk5 = fitdist(maxrunsWHT5,'Kernel','Kernel','epanechnikov')
pdk10 = fitdist(maxrunsWHT10,'Kernel','Kernel','epanechnikov')
pdk25 = fitdist(maxrunsWHT25,'Kernel','Kernel','epanechnikov')
pdk50 = fitdist(maxrunsWHT50,'Kernel','Kernel','epanechnikov')
pdk100 = fitdist(maxrunsWHT100,'Kernel','Kernel','epanechnikov')
pdk1t50 = fitdist(maxrunsWHT1t50,'Kernel','Kernel','epanechnikov')
pdk1t100 = fitdist(maxrunsWHT1t100,'Kernel','Kernel','epanechnikov')

%histogram(maxrunsWHT)
x_val= 1:1:10;
y= pdf(pd,x_val)  ; % PDF expo
y1= pdf(pd1,x_val) ; 

%yk= pdf(pdk,x_val)  % Exponential Dist
prob1WCS= expcdf(x_val,pd1.mu) % prob x< x_val pd.mu
prob5WCS= expcdf(x_val,pd.mu) % prob x< x_val pd.mu
prob10WCS= expcdf(x_val,pd10.mu) % prob x< x_val pd.mu
prob25WCS= expcdf(x_val,pd25.mu) % prob x< x_val pd.mu
prob50WCS= expcdf(x_val,pd50.mu) % prob x< x_val pd.mu
prob100WCS= expcdf(x_val,pd100.mu) % prob x< x_val pd.mu
prob1t50WCS= expcdf(x_val,pd1t50.mu) % prob x< x_val pd.mu
prob1t100WCS= expcdf(x_val,pd1t100.mu) % prob x< x_val pd.mu

% Kernel Distribution
%ycdf10WCS= cdf(pdk,x_val);
ycdf1WCS= cdf(pdk1,x_val);
ycdf5WCS= cdf(pdk5,x_val);
ycdf10WCS= cdf(pdk10,x_val);
ycdf25WCS= cdf(pdk25,x_val);
ycdf50WCS= cdf(pdk50,x_val);
ycdf100WCS= cdf(pdk100,x_val);

ycdf1t50WCS= cdf(pdk1t50,x_val);
ycdf1t100WCS= cdf(pdk1t100,x_val);

figure
plot(x_val,prob5WCS,'LineWidth',2);
hold on
plot(x_val,prob1WCS,'LineWidth',2);
xlabel('Run Length of Negative WHT'); % X axis Title
ylabel('Probability'); % Y axis Title
legend('5 bTB','1 bTB','Location','southeast'); % Legends
hline= refline([0 .95]');
hline.DisplayName = '95%'
hline.LineStyle = '--'%
hold off


% Kernel Dist
figure
plot(x_val,ycdf1WCS,'LineWidth',2);
hold on
plot(x_val,ycdf5WCS,'LineWidth',2);
hold on
plot(x_val,ycdf10WCS,'LineWidth',2);
hold on
plot(x_val,ycdf25WCS,'LineWidth',2);
hold on
plot(x_val,ycdf50WCS,'LineWidth',2);
hold on
plot(x_val,ycdf100WCS,'LineWidth',2);
hold on
plot(x_val,ycdf1t100WCS,'LineWidth',2);
xlabel('Number of Consecutive Negative WHT'); % X axis Title
ylabel('Probability of bTB Elimination'); % Y axis Title
legend('1 bTB','5 bTB','10 bTB','25 bTB','50 bTB','100 bTB','1-100 bTB','Location','southeast'); % Legends
hline= refline([0 .95]');
hline.DisplayName = '95%';
hline.LineStyle = '--'; %
hold off






% Estimate the average of Test Positives
indTP= zeros(20,1,size(ResultsWHT,3)); % initialize variable to identify first value of Test  
WHTStats= zeros(size(ResultsWHT,3),5); % Variable to store values


indTP= ResultsWHT(:,4,:)>0; % 


[r,c,v]= ind2sub(size(indTP),find(indTP==1));
% v is the number of 3-dimension
% r is the number of the number in the column
% c is all ones

[~,locb]= ismember(1,indTP(:,:,:)); % location of first positive value in indTP

WHTStats= R(locb,4); % Number of Test Positive at first WHT.

end













prob800pc10; % 800 inf, 10% lower Se Sp, expo
ycdf800pc10;  % 800 inf, 10% lower Se Sp, Kernel
prob500pc10
ycdf500pc10
prob250pc10
ycdf250pc10
prob100pc10
ycdf100pc10
prob50pc10
ycdf50pc10
% 
%         x= (pertrng(10000,0.632,1,0.839));
%         xaxis= 0.01:1;
%         hist(x)
% 
% pdk = fitdist(x,'Kernel','Kernel','epanechnikov')
% ycdf= cdf(pdk,xaxis);
% figure
% plot(xaxis,ycdf,'LineWidth',2);
% 
% edges= [.6 .7 .75 .8 .85 .9 .95 1];
% N= histcounts(x,edges);
% N(2,:)= N(1,:)/size(x,1)
% N(3,:)= cumsum(N(2,:))
% N(4,:)= edges(1,1:end-1);
% 



s= 4; % Number of statistics to estimate (mean, stdev, min, max)
% Initialize Matrix to store the statistics of the ResultsInterval variables 
ResultsStats= zeros(size(ResultsInterval,1),size(ResultsInterval,2),s);
ResultsStats(:,:,1)= mean(ResultsInterval,3); % 3rd dimension 1 is mean matrix
ResultsStats(:,:,2)= std(ResultsInterval,0,3); % 3rd dimension 2 is Stdev
% for std, the second argument is the weight; third arg is dimension.
ResultsStats(:,:,3)= min(ResultsInterval,[],3); % 3 is Minimum
ResultsStats(:,:,4)= max(ResultsInterval,[],3); % 4 is Maximum
ResutsStatsText= {'Mean','Std','Min','Max'}; % 3rd dimension names

% Create table of results for each year (1-20) 
j= 1;
    for i= 1:10 % num years * 2 = max i value
        ResTable(i,:)= ResultsStats(365*j,[1:21],1); % Mean 
        ResTable(i+1,:)= ResultsStats(365*j,[1:21],2); % Stdev
   j= j + 1;
    end

clear i j    
Tmax= size(ResultsStats,1); % 14600
xaxis= [1:Tmax]; % x-axis to plot daily observations

% Plot Results
% Cow Population Dynamics
% Number of Cows by Infection Status
% plot(xaxis,ResultsStats(:,10,1),xaxis,ResultsStats(:,11,1),xaxis,ResultsStats(:,12,1),xaxis,ResultsStats(:,13,1));
% xlabel('Days'); % X axis Title
% ylabel('Number of Cows'); % Y axis Title
% legend('Susceptible','Latent','Low Shedders','High Shedders','Location','bestoutside'); % Legends
% %title('Bac05,L-Y1:001,Y1-Y2:0005,Bc033');



% TB Plot 
% TB Infection in Cows
plot(xaxis,ResultsStats(:,32,1),xaxis,ResultsStats(:,33,1),xaxis,ResultsStats(:,34,1),xaxis,ResultsStats(:,35,1));
xlabel('Days'); % X axis Title
ylabel('Number of Cows'); % Y axis Title
legend('Tb-Susceptible','Tb-Occult','Tb-Reactive','Tb-Infectious','Location','bestoutside'); % Legends


% TB Infection in Heifers (introduced Tb in Herd)
plot(xaxis,ResultsStats(:,36,1),xaxis,ResultsStats(:,37,1),xaxis,ResultsStats(:,38,1),xaxis,ResultsStats(:,39,1));
xlabel('Days'); % X axis Title
ylabel('Number of Heifers'); % Y axis Title
legend('Tb-SusceptibleHeif','Tb-OccultHeif','Tb-ReactiveHeif','Tb-InfectiousHeif','Location','bestoutside'); % Legends


% TB Infection in Calves 
plot(xaxis,ResultsStats(:,40,1),xaxis,ResultsStats(:,41,1));
xlabel('Days'); % X axis Title
ylabel('Number of Calves'); % Y axis Title
legend('Tb-SusceptibleCalf','Tb-OccultCalf','Location','bestoutside'); % Legends



