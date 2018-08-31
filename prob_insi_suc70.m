% %%%%%%%%%%%%%%Natural culling function, open cows prob is deducted from
% %%%%%%%%%%%%%%the paritywise culling prob%%%%%%%%%%%%%%%%%%%%%%%%%%%


 % This function needs to be revised.
 % prob(InsemTrial)= 1-exp(-0.7/9)= 0.0748; since max 9 Insem. Attempts
 % prob(InsemTrial)= 1-exp(-0.7/8)= 0.0838; since max 8 Insem. Attempts
 % prob(InsemTrial)= 1-exp(-0.7/7)= 0.0952; since max 7 Insem. Attempts 
 % prob(InsemTrial)= 1-exp(-0.7/6)= 0.1101; since max 6 Insem. Attempts
 % In other models (e.g Karul's), he sets the pregnancy prob to about 20%
 % per AI event.
 
 % Pregnancy rate is the product of heat detection rate and conception
 % rate.    
 % Heat Detection ranges from 40-60%; Conception rate from 30-60%;
 % Pregnancy rate  from 18-36%. Mich S U
 
 % Change the pregnancy rate to 20%, similar to Karun's.
 
 
function [prob_preg]= prob_insi_suc70(par_status,prob_pregInput,annualProb,AIattempts,MaxParity)
% set pregnancy probability to 70%, or per attempt (8/year)= 13.97%

% % %%%% THE FUNCTION BELOW has a constant pregprob.
% % if par_status>=0 && par_status<=9
% %     prob_preg= prob_pregInput; % Set same preg prob.
% % else
% %     prob_preg= 0; % if parity >9 cull cow
% % end

% ALL PARITIES HAVE SAME PROBABILITY OF PREGNANCY: 13.97%, SUCH THAT THE
% TOTAL YEARLY PROBABILITY IS 70% (IN 8 ATTEMPTS), SAME FOR HEIFERS.
    
if par_status== 0 
    prob_preg= prob_pregInput; % 1 % MM, all heifers get pregnant

% elseif par_status>=1 && par_status<MaxParity
%     prob_preg= 0.20;
    

    
elseif par_status== 1
    prob_preg= 1-exp(log(1-annualProb)/AIattempts); %0.1397  %0.9927 ;Daily Prob of Not Pregnant

elseif par_status== 2
    prob_preg= 1-exp(log(1-annualProb)/AIattempts) ; % 0.1397 (1-0.9926)*21;
    
elseif par_status== 3
    prob_preg= 1-exp(log(1-annualProb)/AIattempts); % 0.1397(1-0.99264)*21;
    
elseif par_status== 4
    prob_preg=  1-exp(log(1-annualProb)/AIattempts); %  (1-0.99266)*21;
    
elseif par_status== 5
    prob_preg= 1-exp(log(1-annualProb)/AIattempts);  %(1-0.99268)*21; 

elseif par_status== 6
    prob_preg= 1-exp(log(1-annualProb)/AIattempts); %  (1-0.9975)*21;

elseif par_status== 7
    prob_preg= 1-exp(log(1-annualProb)/AIattempts); %(1-0.9980)*21;

elseif par_status>= 8
    prob_preg= 1-exp(log(1-annualProb)/AIattempts); % (1-0.9990)*21;
    
elseif par_status>= MaxParity
    prob_preg= 0;
else
    prob_preg= 0; % after 8th (MM) (9th) parity, do not impregnate cow
    
end

end


























% function [p_non_open]=nat_cull_prob(par_status,days_in_milk)
% p=100;
% open_frac=0.000325;
% if par_status==0
%     p_non_open=0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
% elseif par_status==1
%     if days_in_milk<=30
%         p_non_open=0.1433/p;
%     elseif days_in_milk>30 && days_in_milk<=60
%         p_non_open=0.1433/p;
%     elseif days_in_milk>60 && days_in_milk<=90
%         p_non_open=(0.0967/p)-open_frac;
%     elseif days_in_milk>90 && days_in_milk<=120
%         p_non_open=(0.0900/p)-open_frac;
%     elseif days_in_milk>120 && days_in_milk<=150
%         p_non_open=(0.0833/p)-open_frac;
%     elseif days_in_milk>150 && days_in_milk<=180
%         p_non_open=(0.0800/p)-open_frac;
%     elseif days_in_milk>180 && days_in_milk<=210
%         p_non_open=(0.1067/p)-open_frac;
%     elseif days_in_milk>210 && days_in_milk<=240
%         p_non_open=(0.1100/p)-open_frac;
%     elseif days_in_milk>240 && days_in_milk<=270
%         p_non_open=(0.1167/p)-open_frac;
%     elseif days_in_milk>270 && days_in_milk<=300
%         p_non_open=(0.1233/p)-open_frac;
%     elseif days_in_milk>300 && days_in_milk<=330
%         p_non_open=(0.1233/p)-open_frac;
%     elseif days_in_milk>330 && days_in_milk<=360
%         p_non_open=(0.1233/p)-open_frac;
%     elseif days_in_milk>360 && days_in_milk<=390
%         p_non_open=(0.1233/p)-open_frac;
%     elseif days_in_milk>390 && days_in_milk<=420
%         p_non_open=(0.1100/p)-open_frac;
%     elseif days_in_milk>420
%         p_non_open=(0.0202/p)-open_frac;
%     end
% elseif par_status==2
%     if days_in_milk<=30
%         p_non_open=0.1233/p;
%     elseif days_in_milk>30 && days_in_milk<=60
%         p_non_open=0.1500/p;
%     elseif days_in_milk>60 && days_in_milk<=90
%         p_non_open=(0.1500/p)-open_frac;
%     elseif days_in_milk>90 && days_in_milk<=120
%         p_non_open=(0.1567/p)-open_frac;
%     elseif days_in_milk>120 && days_in_milk<=150
%         p_non_open=(0.1667/p)-open_frac;
%     elseif days_in_milk>150 && days_in_milk<=180
%         p_non_open=(0.1867/p)-open_frac;
%     elseif days_in_milk>180 && days_in_milk<=210
%         p_non_open=(0.2033/p)-open_frac;
%     elseif days_in_milk>210 && days_in_milk<=240
%         p_non_open=(0.2467/p)-open_frac;
%     elseif days_in_milk>240 && days_in_milk<=270
%         p_non_open=(0.2400/p)-open_frac;
%     elseif days_in_milk>270 && days_in_milk<=300
%         p_non_open=(0.2567/p)-open_frac;
%     elseif days_in_milk>300 && days_in_milk<=330
%         p_non_open=(0.2100/p)-open_frac;
%     elseif days_in_milk>330 && days_in_milk<=360
%         p_non_open=(0.2000/p)-open_frac;
%     elseif days_in_milk>360 && days_in_milk<=390
%         p_non_open=(0.1833/p)-open_frac;
%     elseif days_in_milk>390 && days_in_milk<=420
%         p_non_open=(0.1400/p)-open_frac;
%     elseif days_in_milk>420
%         p_non_open=(0.0118/p)-open_frac;
%     end
%     
% elseif par_status==3
%     if days_in_milk<=30
%         p_non_open=0.1833/p;
%     elseif days_in_milk>30 && days_in_milk<=60
%         p_non_open=0.2000/p;
%     elseif days_in_milk>60 && days_in_milk<=90
%         p_non_open=(0.1900/p)-open_frac;
%     elseif days_in_milk>90 && days_in_milk<=120
%         p_non_open=(0.2233/p)-open_frac;
%     elseif days_in_milk>120 && days_in_milk<=150
%         p_non_open=(0.2333/p)-open_frac;
%     elseif days_in_milk>150 && days_in_milk<=180
%         p_non_open=(0.2300/p)-open_frac;
%     elseif days_in_milk>180 && days_in_milk<=210
%         p_non_open=(0.2567/p)-open_frac;
%     elseif days_in_milk>210 && days_in_milk<=240
%         p_non_open=(0.2967/p)-open_frac;
%     elseif days_in_milk>240 && days_in_milk<=270
%         p_non_open=(0.2567/p)-open_frac;
%     elseif days_in_milk>270 && days_in_milk<=300
%         p_non_open=(0.2567/p)-open_frac;
%     elseif days_in_milk>300 && days_in_milk<=330
%         p_non_open=(0.2700/p)-open_frac;
%     elseif days_in_milk>330 && days_in_milk<=360
%         p_non_open=(0.2067/p)-open_frac;
%     elseif days_in_milk>360 && days_in_milk<=390
%         p_non_open=(0.1500/p)-open_frac;
%     elseif days_in_milk>390 && days_in_milk<=420
%         p_non_open=(0.1133/p)-open_frac;
%     elseif days_in_milk>420
%         p_non_open=(0.0262/p)-open_frac;
%     end
%     
% elseif par_status==4
%     if days_in_milk<=30
%         p_non_open=0.2467/p;
%     elseif days_in_milk>30 && days_in_milk<=60
%         p_non_open=0.2533/p;
%     elseif days_in_milk>60 && days_in_milk<=90
%         p_non_open=(0.2033/p)-open_frac;
%     elseif days_in_milk>90 && days_in_milk<=120
%         p_non_open=(0.2033/p)-open_frac;
%     elseif days_in_milk>120 && days_in_milk<=150
%         p_non_open=(0.2467/p)-open_frac;
%     elseif days_in_milk>150 && days_in_milk<=180
%         p_non_open=(0.2700/p)-open_frac;
%     elseif days_in_milk>180 && days_in_milk<=210
%         p_non_open=(0.3067/p)-open_frac;
%     elseif days_in_milk>210 && days_in_milk<=240
%         p_non_open=(0.3000/p)-open_frac;
%     elseif days_in_milk>240 && days_in_milk<=270
%         p_non_open=(0.3300/p)-open_frac;
%     elseif days_in_milk>270 && days_in_milk<=300
%         p_non_open=(0.3000/p)-open_frac;
%     elseif days_in_milk>300 && days_in_milk<=330
%         p_non_open=(0.2600/p)-open_frac;
%     elseif days_in_milk>330 && days_in_milk<=360
%         p_non_open=(0.1867/p)-open_frac;
%     elseif days_in_milk>360 && days_in_milk<=390
%         p_non_open=(0.1600/p)-open_frac;
%     elseif days_in_milk>390 && days_in_milk<=420
%         p_non_open=(0.0933/p)-open_frac;
%     elseif days_in_milk>420
%         p_non_open=(0.0242/p)-open_frac;
%     end
%     
% elseif par_status==5
%     if days_in_milk<=30
%         p_non_open=0.2300/p;
%     elseif days_in_milk>30 && days_in_milk<=60
%         p_non_open=0.2600/p;
%     elseif days_in_milk>60 && days_in_milk<=90
%         p_non_open=(0.2533/p)-open_frac;
%     elseif days_in_milk>90 && days_in_milk<=120
%         p_non_open=(0.2067/p)-open_frac;
%     elseif days_in_milk>120 && days_in_milk<=150
%         p_non_open=(0.2667/p)-open_frac;
%     elseif days_in_milk>150 && days_in_milk<=180
%         p_non_open=(0.2367/p)-open_frac;
%     elseif days_in_milk>180 && days_in_milk<=210
%         p_non_open=(0.2633/p)-open_frac;
%     elseif days_in_milk>210 && days_in_milk<=240
%         p_non_open=(0.2633/p)-open_frac;
%     elseif days_in_milk>240 && days_in_milk<=270
%         p_non_open=(0.2400/p)-open_frac;
%     elseif days_in_milk>270 && days_in_milk<=300
%         p_non_open=(0.2933/p)-open_frac;
%     elseif days_in_milk>300 && days_in_milk<=330
%         p_non_open=(0.2067/p)-open_frac;
%     elseif days_in_milk>330 && days_in_milk<=360
%         p_non_open=(0.1867/p)-open_frac;
%     elseif days_in_milk>360 && days_in_milk<=390
%         p_non_open=(0.1567/p)-open_frac;
%     elseif days_in_milk>390 && days_in_milk<=420
%         p_non_open=(0.0700/p)-open_frac;
%     elseif days_in_milk>420
%         p_non_open=(0.0380/p)-open_frac;
%     end
%     
% elseif par_status==6
%     if days_in_milk<=30
%         p_non_open=0.2600/p;
%     elseif days_in_milk>30 && days_in_milk<=60
%         p_non_open=0.1067/p;
%     elseif days_in_milk>60 && days_in_milk<=90
%         p_non_open=(0.2900/p)-open_frac;
%     elseif days_in_milk>90 && days_in_milk<=120
%         p_non_open=(0.2133/p)-open_frac;
%     elseif days_in_milk>120 && days_in_milk<=150
%         p_non_open=(0.1133/p)-open_frac;
%     elseif days_in_milk>150 && days_in_milk<=180
%         p_non_open=(0.1833/p)-open_frac;
%     elseif days_in_milk>180 && days_in_milk<=210
%         p_non_open=(0.3900/p)-open_frac;
%     elseif days_in_milk>210 && days_in_milk<=240
%         p_non_open=(0.3200/p)-open_frac;
%     elseif days_in_milk>240 && days_in_milk<=270
%         p_non_open=(0.2233/p)-open_frac;
%     elseif days_in_milk>270 && days_in_milk<=300
%         p_non_open=(0.2367/p)-open_frac;
%     elseif days_in_milk>300 && days_in_milk<=330
%         p_non_open=(0.1000/p)-open_frac;
%     elseif days_in_milk>330 && days_in_milk<=360
%         p_non_open=(0.1600/p)-open_frac;
%     elseif days_in_milk>360 && days_in_milk<=390
%         p_non_open=(0.0267/p)-open_frac;
%     elseif days_in_milk>390 && days_in_milk<=420
%         p_non_open=(0.267/p)-open_frac;
%     elseif days_in_milk>420
%         p_non_open=(0.0408/p)-open_frac;
%     end
% elseif par_status==7
%     if days_in_milk<=30
%         p_non_open=0.3267/p;
%     elseif days_in_milk>30 && days_in_milk<=60
%         p_non_open=0.0733/p;
%     elseif days_in_milk>60 && days_in_milk<=90
%         p_non_open=(0.2233/p)-open_frac;
%     elseif days_in_milk>90 && days_in_milk<=120
%         p_non_open=(0.1600/p)-open_frac;
%     elseif days_in_milk>120 && days_in_milk<=150
%         p_non_open=(0.1667/p)-open_frac;
%     elseif days_in_milk>150 && days_in_milk<=180
%         p_non_open=(0.3500/p)-open_frac;
%     elseif days_in_milk>180 && days_in_milk<=210
%         p_non_open=(0.4900/p)-open_frac;
%     elseif days_in_milk>210 && days_in_milk<=240
%         p_non_open=(0.3433/p)-open_frac;
%     elseif days_in_milk>240 && days_in_milk<=270
%         p_non_open=(0.2567/p)-open_frac;
%     elseif days_in_milk>270 && days_in_milk<=300
%         p_non_open=(0.5567/p)-open_frac;
%     elseif days_in_milk>300 && days_in_milk<=330
%         p_non_open=(0.1667/p)-open_frac;
%     elseif days_in_milk>330 && days_in_milk<=360
%         p_non_open=(0.1733/p)-open_frac;
%     elseif days_in_milk>360 && days_in_milk<=390
%         p_non_open=(0.3700/p)-open_frac;
%     elseif days_in_milk>390 && days_in_milk<=420
%         p_non_open=(0.3700/p)-open_frac;
%     elseif days_in_milk>420
%         p_non_open=(0.2067/p)-open_frac;
%     end
% elseif par_status>=8
%     if days_in_milk<=30
%         p_non_open=(0.2383/p)-open_frac;
%     elseif days_in_milk>30 && days_in_milk<=60
%         p_non_open=(0.2383/p)-open_frac;
%     elseif days_in_milk>60 && days_in_milk<=90
%         p_non_open=(0.3033/p)-open_frac;
%     elseif days_in_milk>90 && days_in_milk<=120
%         p_non_open=(0.3033/p)-open_frac;
%     elseif days_in_milk>120
%         p_non_open=1;
%     end
% else
%     p_non_open=1;
%     
% end
% 
% end
% 
% 
% %%%%%%%%%%%%%%%%%%Fuction End%%%%%%%%%%%%%%%%%
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% % function [p_non_open]=nat_cull_prob(par_status,days_in_milk)
% % p=100;
% % % open_frac=0.000325;
% % if par_status==1
% %     if days_in_milk<=30
% %         p_non_open=0.1433/p;
% %         %         p_non_open=1-exp(-0.1433/p);
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         p_non_open=0.1433/p;
% %         %         p_non_open=1-exp(-0.1433/p);
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         p_non_open=0.0967/p;
% %         %         p_non_open=1-exp(-0.0967/p);
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         p_non_open=0.0900/p;
% %         %         p_non_open=1-exp(-0.0900/p);
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         p_non_open=0.0833/p;
% %         %         p_non_open=1-exp(-0.0833/p);
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         p_non_open=0.0800/p;
% %         %         p_non_open=1-exp(-0.0800/p);
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         p_non_open=0.1067/p;
% %         %         p_non_open=1-exp(-0.1067/p);
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         p_non_open=0.1100/p;
% %         %         p_non_open=1-exp(-0.1100/p);
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         p_non_open=0.1167/p;
% %         %         p_non_open=1-exp(-0.1167/p);
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         p_non_open=0.1233/p;
% %         %         p_non_open=1-exp(-0.1233/p);
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         p_non_open=0.1233/p;
% %         %         p_non_open=1-exp(-0.1233/p);
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         p_non_open=0.1233/p;
% %         %         p_non_open=1-exp(-0.1233/p);
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         p_non_open=0.1233/p;
% %         %         p_non_open=1-exp(-0.1233/p);
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         p_non_open=0.1100/p;
% %         %         p_non_open=1-exp(-0.1100/p);
% %     elseif days_in_milk>420
% %         p_non_open=0.0202/p;
% %         %         p_non_open=1-exp(-0.0202/p);
% %     end
% % elseif par_status==2
% %     if days_in_milk<=30
% %         p_non_open=0.1233/p;
% %         % p_non_open=1-exp(-0.1233/p);
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         p_non_open=0.1500/p;
% %         % p_non_open=1-exp(-0.1500/p);
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         p_non_open=0.1500/p;
% %         % p_non_open=1-exp(-0.1500/p);
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         p_non_open=0.1567/p;
% %         % p_non_open=1-exp(-0.1567/p);
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         p_non_open=0.1667/p;
% %         % p_non_open=1-exp(-0.1667/p);
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         p_non_open=0.1867/p;
% %         % p_non_open=1-exp(-0.1867/p);
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         p_non_open=0.2033/p;
% %         % p_non_open=1-exp(-0.2033/p);
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         p_non_open=0.2467/p;
% %         % p_non_open=1-exp(-0.2467/p);
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         p_non_open=0.2400/p;
% %         % p_non_open=1-exp(-0.2400/p);
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         p_non_open=0.2567/p;
% %         % p_non_open=1-exp(-0.2567/p);
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         p_non_open=0.2100/p;
% %         % p_non_open=1-exp(-0.2100/p);
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         p_non_open=0.2000/p;
% %         % p_non_open=1-exp(-0.2000/p);
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         p_non_open=0.1833/p;
% %         % p_non_open=1-exp(-0.1833/p);
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         p_non_open=0.1400/p;
% %         % p_non_open=1-exp(-0.1400/p);
% %     elseif days_in_milk>420
% %         p_non_open=0.0118/p;
% %         % p_non_open=1-exp(-0.0118/p);
% %     end
% %
% % elseif par_status==3
% %     if days_in_milk<=30
% %         p_non_open=0.1833/p;
% %         % p_non_open=1-exp(-0.1833/p);
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         p_non_open=0.2000/p;
% %         % p_non_open=1-exp(-0.2000/p);
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         p_non_open=0.1900/p;
% %         % p_non_open=1-exp(-0.1900/p);
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         p_non_open=0.2233/p;
% %         % p_non_open=1-exp(-0.2233/p);
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         p_non_open=0.2333/p;
% %         % p_non_open=1-exp(-0.2333/p);
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         p_non_open=0.2300/p;
% %         % p_non_open=1-exp(-0.2300/p);
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         p_non_open=0.2567/p;
% %         % p_non_open=1-exp(-0.2567/p);
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         p_non_open=0.2967/p;
% %         % p_non_open=1-exp(-0.2967/p);
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         p_non_open=0.2567/p;
% %         % p_non_open=1-exp(-0.2567/p);
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         p_non_open=0.2567/p;
% %         % p_non_open=1-exp(-0.2567/p);
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         p_non_open=0.2700/p;
% %         % p_non_open=1-exp(-0.2700/p);
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         p_non_open=0.2067/p;
% %         % p_non_open=1-exp(-0.2067/p);
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         p_non_open=0.1500/p;
% %         % p_non_open=1-exp(-0.1500/p);
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         p_non_open=0.1133/p;
% %         % p_non_open=1-exp(-0.1133/p);
% %     elseif days_in_milk>420
% %         p_non_open=0.0262/p;
% %         % p_non_open=1-exp(-0.0262/p);
% %     end
% %
% % elseif par_status==4
% %     if days_in_milk<=30
% %         p_non_open=0.2467/p;
% %         % p_non_open=1-exp(-0.2467/p);
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         p_non_open=0.2533/p;
% %         % p_non_open=1-exp(-0.2533/p);
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         p_non_open=0.2033/p;
% %         % p_non_open=1-exp(-0.2033/p);
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         p_non_open=0.2033/p;
% %         % p_non_open=1-exp(-0.2033/p);
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         p_non_open=0.2467/p;
% %         % p_non_open=1-exp(-0.2467/p);
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         p_non_open=0.2700/p;
% %         % p_non_open=1-exp(-0.2700/p);
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         p_non_open=0.3067/p;
% %         % p_non_open=1-exp(-0.3067/p);
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         p_non_open=0.3000/p;
% %         % p_non_open=1-exp(-0.3000/p);
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         p_non_open=0.3300/p;
% %         % p_non_open=1-exp(0.3300/p);
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         p_non_open=0.3000/p;
% %         % p_non_open=1-exp(0.3000/p);
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         p_non_open=0.2600/p;
% %         % p_non_open=1-exp(-0.2600/p);
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         p_non_open=0.1867/p;
% %         % p_non_open=1-exp(-0.1867/p);
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         p_non_open=0.1600/p;
% %         % p_non_open=1-exp(-0.1600/p);
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         p_non_open=0.0933/p;
% %         % p_non_open=1-exp(-0.0933/p);
% %     elseif days_in_milk>420
% %         p_non_open=0.0242/p;
% %         % p_non_open=1-exp(-0.0242/p);
% %     end
% %
% % elseif par_status==5
% %     if days_in_milk<=30
% %         p_non_open=0.2300/p;
% %         % p_non_open=1-exp(-0.2300/p);
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         p_non_open=0.2600/p;
% %         % p_non_open=1-exp(-0.2600/p);
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         p_non_open=0.2533/p;
% %         % p_non_open=1-exp(-0.2533/p);
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         p_non_open=0.2067/p;
% %         % p_non_open=1-exp(-0.2067/p);
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         p_non_open=0.2667/p;
% %         % p_non_open=1-exp(-0.2667/p);
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         p_non_open=0.2367/p;
% %         % p_non_open=1-exp(-0.2367/p);
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         p_non_open=0.2633/p;
% %         % p_non_open=1-exp(-0.2633/p);
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         p_non_open=0.2633/p;
% %         % p_non_open=1-exp(-0.2633/p);
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         p_non_open=0.2400/p;
% %         % p_non_open=1-exp(-0.2400/p);
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         p_non_open=0.2933/p;
% %         % p_non_open=1-exp(-0.2933/p);
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         p_non_open=0.2067/p;
% %         % p_non_open=1-exp(-0.2067/p);
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         p_non_open=0.1867/p;
% %         % p_non_open=1-exp(-0.1867/p);
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         p_non_open=0.1567/p;
% %         % p_non_open=1-exp(-0.1567/p);
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         p_non_open=0.0700/p;
% %         % p_non_open=1-exp(-0.0700/p);
% %     elseif days_in_milk>420
% %         p_non_open=0.0380/p;
% %         % p_non_open=1-exp(-0.0380/p);
% %     end
% %
% % elseif par_status==6
% %     if days_in_milk<=30
% %         p_non_open=0.2600/p;
% %         % p_non_open=1-exp(-0.2600/p);
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         p_non_open=0.1067/p;
% %         % p_non_open=1-exp(-0.1067/p);
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         p_non_open=0.2900/p;
% %         % p_non_open=1-exp(-0.2900/p);
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         p_non_open=0.2133/p;
% %         % p_non_open=1-exp(-0.2133/p);
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         p_non_open=0.1133/p;
% %         % p_non_open=1-exp(-0.1133/p);
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         p_non_open=0.1833/p;
% %         % p_non_open=1-exp(-0.1833/p);
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         p_non_open=0.3900/p;
% %         % p_non_open=1-exp(-0.3900/p);
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         p_non_open=0.3200/p;
% %         % p_non_open=1-exp(-0.3200/p);
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         p_non_open=0.2233/p;
% %         % p_non_open=1-exp(-0.2233/p);
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         p_non_open=0.2367/p;
% %         % p_non_open=1-exp(-0.2367/p);
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         p_non_open=0.1000/p;
% %         % p_non_open=1-exp(-0.1000/p);
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         p_non_open=0.1600/p;
% %         % p_non_open=1-exp(-0.1600/p);
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         p_non_open=0.0267/p;
% %         % p_non_open=1-exp(-0.0267/p);
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         p_non_open=0.267/p;
% %         % p_non_open=1-exp(-0.267/p);
% %     elseif days_in_milk>420
% %         p_non_open=0.0408/p;
% %         % p_non_open=1-exp(-0.0408/p);
% %     end
% % elseif par_status==7
% %     if days_in_milk<=30
% %         p_non_open=0.3267/p;
% %         % p_non_open=1-exp(-0.3267/p);
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         p_non_open=0.0733/p;
% %         % p_non_open=1-exp(-0.0733/p);
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         p_non_open=0.2233/p;
% %         % p_non_open=1-exp(-0.2233/p);
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         p_non_open=0.1600/p;
% %         % p_non_open=1-exp(-0.1600/p);
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         p_non_open=0.1667/p;
% %         % p_non_open=1-exp(-0.1667/p);
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         p_non_open=0.3500/p;
% %         % p_non_open=1-exp(-0.3500/p);
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         p_non_open=0.4900/p;
% %         % p_non_open=1-exp(-0.4900/p);
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         p_non_open=0.3433/p;
% %         % p_non_open=1-exp(-0.3433/p);
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         p_non_open=0.2567/p;
% %         % p_non_open=1-exp(-0.2567/p);
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         p_non_open=0.5567/p;
% %         % p_non_open=1-exp(-0.5567/p);
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         p_non_open=0.1667/p;
% %         % p_non_open=1-exp(-0.1667/p);
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         p_non_open=0.1733/p;
% %         % p_non_open=1-exp(-0.1733/p);
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         p_non_open=0.3700/p;
% %         % p_non_open=1-exp(0.3700/p);
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         p_non_open=0.3700/p;
% %         % p_non_open=1-exp(-0.3700/p);
% %     elseif days_in_milk>420
% %         p_non_open=0.2067/p;
% %         % p_non_open=1-exp(-0.2067/p);
% %     end
% % elseif par_status>=8
% %     if days_in_milk<=30
% %         p_non_open=0.2383/p;
% %         % p_non_open=1-exp(-0.2383/p);
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         p_non_open=0.2383/p;
% %         % p_non_open=1-exp(-0.2383/p);
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         p_non_open=0.3033/p;
% %         % p_non_open=1-exp(-0.3033/p);
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         p_non_open=0.3033/p;
% %         % p_non_open=1-exp(-0.3033/p);
% %     elseif days_in_milk>120
% %         p_non_open=1;
% %     end
% % else
% %     p_non_open=1;
% %
% % end
% %
% % end
% 
% 
% % function [p_non_open]=nat_cull_prob(par_status,days_in_milk)
% % if par_status==1
% %     if days_in_milk<=30
% %         p_non_open=0.1433;
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         p_non_open=0.1433;
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         p_non_open=0.0967;
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         p_non_open=0.0900;
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         p_non_open=0.0833;
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         p_non_open=0.0800;
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         p_non_open=0.1067;
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         p_non_open=0.1100;
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         p_non_open=0.1167;
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         p_non_open=0.1233;
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         p_non_open=0.1233;
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         p_non_open=0.1233;
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         p_non_open=0.1233;
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         p_non_open=0.1100;
% %     elseif days_in_milk>420
% %         p_non_open=0.0202;
% %     end
% % elseif par_status==2
% %     if days_in_milk<=30
% %         p_non_open=0.1233;
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         p_non_open=0.1500;
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         p_non_open=0.1500;
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         p_non_open=0.1567;
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         p_non_open=0.1667;
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         p_non_open=0.1867;
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         p_non_open=0.2033;
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         p_non_open=0.2467;
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         p_non_open=0.2400;
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         p_non_open=0.2567;
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         p_non_open=0.2100;
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         p_non_open=0.2000;
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         p_non_open=0.1833;
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         p_non_open=0.1400;
% %     elseif days_in_milk>420
% %         p_non_open=0.0118;
% %     end
% % elseif par_status==3
% %     if days_in_milk<=30
% %         p_non_open=0.1833;
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         p_non_open=0.2000;
% %             elseif days_in_milk>60 && days_in_milk<=90
% %         p_non_open=0.1900;
% %             elseif days_in_milk>90 && days_in_milk<=120
% %         p_non_open=0.2233;
% %             elseif days_in_milk>120 && days_in_milk<=150
% %         p_non_open=0.2333;
% %             elseif days_in_milk>150 && days_in_milk<=180
% %         p_non_open=0.2300;
% %             elseif days_in_milk>180 && days_in_milk<=210
% %         p_non_open=0.2567;
% %             elseif days_in_milk>210 && days_in_milk<=240
% %         p_non_open=0.2967;
% %             elseif days_in_milk>240 && days_in_milk<=270
% %         p_non_open=0.2567;
% %             elseif days_in_milk>270 && days_in_milk<=300
% %         p_non_open=0.2567;
% %             elseif days_in_milk>300 && days_in_milk<=330
% %         p_non_open=0.2700;
% %             elseif days_in_milk>330 && days_in_milk<=360
% %         p_non_open=0.2067;
% %             elseif days_in_milk>360 && days_in_milk<=390
% %         p_non_open=0.1500;
% %             elseif days_in_milk>390 && days_in_milk<=420
% %         p_non_open=0.1133;
% %             elseif days_in_milk>420
% %         p_non_open=0.0262;
% %     end
% % elseif par_status==4
% %     if days_in_milk<=30
% %         p_non_open=0.2467;
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         p_non_open=0.2533;
% %             elseif days_in_milk>60 && days_in_milk<=90
% %         p_non_open=0.2033;
% %             elseif days_in_milk>90 && days_in_milk<=120
% %         p_non_open=0.2033;
% %             elseif days_in_milk>120 && days_in_milk<=150
% %         p_non_open=0.2467;
% %             elseif days_in_milk>150 && days_in_milk<=180
% %         p_non_open=0.2700;
% %             elseif days_in_milk>180 && days_in_milk<=210
% %         p_non_open=0.3067;
% %             elseif days_in_milk>210 && days_in_milk<=240
% %         p_non_open=0.3000;
% %             elseif days_in_milk>240 && days_in_milk<=270
% %         p_non_open=0.3300;
% %             elseif days_in_milk>270 && days_in_milk<=300
% %         p_non_open=0.3000;
% %             elseif days_in_milk>300 && days_in_milk<=330
% %         p_non_open=0.2600;
% %             elseif days_in_milk>330 && days_in_milk<=360
% %         p_non_open=0.1867;
% %             elseif days_in_milk>360 && days_in_milk<=390
% %         p_non_open=0.1600;
% %             elseif days_in_milk>390 && days_in_milk<=420
% %         p_non_open=0.0933;
% %             elseif days_in_milk>420
% %         p_non_open=0.0242;
% %     end
% % elseif par_status==5
% %     if days_in_milk<=30
% %         p_non_open=0.2300;
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         p_non_open=0.2600;
% %             elseif days_in_milk>60 && days_in_milk<=90
% %         p_non_open=0.2533;
% %             elseif days_in_milk>90 && days_in_milk<=120
% %         p_non_open=0.2067;
% %             elseif days_in_milk>120 && days_in_milk<=150
% %         p_non_open=0.2667;
% %             elseif days_in_milk>150 && days_in_milk<=180
% %         p_non_open=0.2367;
% %             elseif days_in_milk>180 && days_in_milk<=210
% %         p_non_open=0.2633;
% %             elseif days_in_milk>210 && days_in_milk<=240
% %         p_non_open=0.2633;
% %             elseif days_in_milk>240 && days_in_milk<=270
% %         p_non_open=0.2400;
% %             elseif days_in_milk>270 && days_in_milk<=300
% %         p_non_open=0.2933;
% %             elseif days_in_milk>300 && days_in_milk<=330
% %         p_non_open=0.2067;
% %             elseif days_in_milk>330 && days_in_milk<=360
% %         p_non_open=0.1867;
% %             elseif days_in_milk>360 && days_in_milk<=390
% %         p_non_open=0.1567;
% %             elseif days_in_milk>390 && days_in_milk<=420
% %         p_non_open=0.0700;
% %             elseif days_in_milk>420
% %         p_non_open=0.0380;
% %     end
% % elseif par_status==6
% %     if days_in_milk<=30
% %         p_non_open=0.2600;
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         p_non_open=0.1067;
% %             elseif days_in_milk>60 && days_in_milk<=90
% %         p_non_open=0.2900;
% %             elseif days_in_milk>90 && days_in_milk<=120
% %         p_non_open=0.2133;
% %             elseif days_in_milk>120 && days_in_milk<=150
% %         p_non_open=0.1133;
% %             elseif days_in_milk>150 && days_in_milk<=180
% %         p_non_open=0.1833;
% %             elseif days_in_milk>180 && days_in_milk<=210
% %         p_non_open=0.3900;
% %             elseif days_in_milk>210 && days_in_milk<=240
% %         p_non_open=0.3200;
% %             elseif days_in_milk>240 && days_in_milk<=270
% %         p_non_open=0.2233;
% %             elseif days_in_milk>270 && days_in_milk<=300
% %         p_non_open=0.2367;
% %             elseif days_in_milk>300 && days_in_milk<=330
% %         p_non_open=0.1000;
% %             elseif days_in_milk>330 && days_in_milk<=360
% %         p_non_open=0.1600;
% %             elseif days_in_milk>360 && days_in_milk<=390
% %         p_non_open=0.0267;
% %             elseif days_in_milk>390 && days_in_milk<=420
% %         p_non_open=0.267;
% %             elseif days_in_milk>420
% %         p_non_open=0.0408;
% %     end
% % elseif par_status==7
% %     if days_in_milk<=30
% %         p_non_open=0.3267;
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         p_non_open=0.0733;
% %             elseif days_in_milk>60 && days_in_milk<=90
% %         p_non_open=0.2233;
% %             elseif days_in_milk>90 && days_in_milk<=120
% %         p_non_open=0.1600;
% %             elseif days_in_milk>120 && days_in_milk<=150
% %         p_non_open=0.1667;
% %             elseif days_in_milk>150 && days_in_milk<=180
% %         p_non_open=0.3500;
% %             elseif days_in_milk>180 && days_in_milk<=210
% %         p_non_open=0.4900;
% %             elseif days_in_milk>210 && days_in_milk<=240
% %         p_non_open=0.3433;
% %             elseif days_in_milk>240 && days_in_milk<=270
% %         p_non_open=0.2567;
% %             elseif days_in_milk>270 && days_in_milk<=300
% %         p_non_open=0.5567;
% %             elseif days_in_milk>300 && days_in_milk<=330
% %         p_non_open=0.1667;
% %             elseif days_in_milk>330 && days_in_milk<=360
% %         p_non_open=0.1733;
% %             elseif days_in_milk>360 && days_in_milk<=390
% %         p_non_open=0.3700;
% %             elseif days_in_milk>390 && days_in_milk<=420
% %         p_non_open=0.3700;
% %             elseif days_in_milk>420
% %         p_non_open=0.2067;
% %     end
% % elseif par_status>=8
% %     if days_in_milk<=30
% %         p_non_open=0.2383;
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         p_non_open=0.2383;
% %             elseif days_in_milk>60 && days_in_milk<=90
% %         p_non_open=0.3033;
% %             elseif days_in_milk>90 && days_in_milk<=120
% %         p_non_open=0.3033;
% %             elseif days_in_milk>120
% %         p_non_open=1;
% %     end
% % else
% %     p_non_open=1;
% %
% % end
% % end