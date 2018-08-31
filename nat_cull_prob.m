
%%%%%%%%%%%%%%     Natural culling function, open cows prob is deducted from
%%%%%%%%%%%%%%     the paritywise culling prob    %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% These are conditional probabilities of natural culling given ONLY the number of lactation. 

% Maximum parity after which the cow is culled can be changed. Currently
% set at 8.
% For the Natural Cull Prob. since in the paper they include both nat cull
% and sales, we used the nat cull prob for Heifers x 2, so Cows are twice as likely to die than Heifers.
% (0.0000278 vs 0.0000556) and adjusted the prob. so that older cows are
% more likely to be involuntarily culled than younger cows.


function [death_prob]= nat_cull_prob(par_status,factorcull) % 

factorcullHighPar= 1.1*factorcull; % Change this to increase longevity (decrease cull rate)
    if par_status== 0 % parity number. Lactation number. 
        death_prob= 0; % MM
        
elseif par_status== 1 % 1st lactation 4% annual prob= 0.0001096
    death_prob= 0.0001096*factorcull; %0.000167; % MM
    %death_prob= 0.0000356;

elseif par_status== 2 % 2nd lactation. 5% annual prob= 0.000132
    death_prob= 0.000132*factorcull; %0.000167; % same as 1st lactation
%     death_prob= 0.0000456;
elseif par_status== 3 % 3rd lactation. 7% annual prob= 0.0001918 
    death_prob= 0.0001918*factorcull; 
%     death_prob= 0.0000556;
elseif par_status== 4 % 4th lactation. 8% annual prob= 0.0002192
    death_prob= 0.0002192*factorcull; %0.000333;
%     death_prob= 0.0000556;
elseif par_status== 5 %         9% annual prob= 0.0002466
    death_prob= 0.0002466*factorcullHighPar; %0.000416;
%     death_prob= 0.0000656;
elseif par_status== 6%      10% annual prob= 0.0002739
    death_prob= 0.0002739*factorcullHighPar; %0.000556;
%     death_prob= 0.0000756;0.0002739
elseif par_status== 7 %     11% annual prob= 0.0003014
    death_prob= 0.0003014*factorcullHighPar;
%     death_prob= 0.0000856;
elseif par_status== 8% 12% annual prob= 0.0003836
    death_prob= 0.00038365*factorcullHighPar; %0.000833;
%     death_prob= 0.0000956;
else
    death_prob= 0.000411*factorcullHighPar; %0.000933; % MM = 1; 15%= 0.000411
%     death_prob= 0.0000956;
    end

end


























% function [death_prob]=nat_cull_prob(par_status,days_in_milk)
% p=100;
% open_frac=0.000325;
% if par_status==0
%     death_prob=0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
% elseif par_status==1
%     if days_in_milk<=30
%         death_prob=0.1433/p;
%     elseif days_in_milk>30 && days_in_milk<=60
%         death_prob=0.1433/p;
%     elseif days_in_milk>60 && days_in_milk<=90
%         death_prob=(0.0967/p)-open_frac;
%     elseif days_in_milk>90 && days_in_milk<=120
%         death_prob=(0.0900/p)-open_frac;
%     elseif days_in_milk>120 && days_in_milk<=150
%         death_prob=(0.0833/p)-open_frac;
%     elseif days_in_milk>150 && days_in_milk<=180
%         death_prob=(0.0800/p)-open_frac;
%     elseif days_in_milk>180 && days_in_milk<=210
%         death_prob=(0.1067/p)-open_frac;
%     elseif days_in_milk>210 && days_in_milk<=240
%         death_prob=(0.1100/p)-open_frac;
%     elseif days_in_milk>240 && days_in_milk<=270
%         death_prob=(0.1167/p)-open_frac;
%     elseif days_in_milk>270 && days_in_milk<=300
%         death_prob=(0.1233/p)-open_frac;
%     elseif days_in_milk>300 && days_in_milk<=330
%         death_prob=(0.1233/p)-open_frac;
%     elseif days_in_milk>330 && days_in_milk<=360
%         death_prob=(0.1233/p)-open_frac;
%     elseif days_in_milk>360 && days_in_milk<=390
%         death_prob=(0.1233/p)-open_frac;
%     elseif days_in_milk>390 && days_in_milk<=420
%         death_prob=(0.1100/p)-open_frac;
%     elseif days_in_milk>420
%         death_prob=(0.0202/p)-open_frac;
%     end
% elseif par_status==2
%     if days_in_milk<=30
%         death_prob=0.1233/p;
%     elseif days_in_milk>30 && days_in_milk<=60
%         death_prob=0.1500/p;
%     elseif days_in_milk>60 && days_in_milk<=90
%         death_prob=(0.1500/p)-open_frac;
%     elseif days_in_milk>90 && days_in_milk<=120
%         death_prob=(0.1567/p)-open_frac;
%     elseif days_in_milk>120 && days_in_milk<=150
%         death_prob=(0.1667/p)-open_frac;
%     elseif days_in_milk>150 && days_in_milk<=180
%         death_prob=(0.1867/p)-open_frac;
%     elseif days_in_milk>180 && days_in_milk<=210
%         death_prob=(0.2033/p)-open_frac;
%     elseif days_in_milk>210 && days_in_milk<=240
%         death_prob=(0.2467/p)-open_frac;
%     elseif days_in_milk>240 && days_in_milk<=270
%         death_prob=(0.2400/p)-open_frac;
%     elseif days_in_milk>270 && days_in_milk<=300
%         death_prob=(0.2567/p)-open_frac;
%     elseif days_in_milk>300 && days_in_milk<=330
%         death_prob=(0.2100/p)-open_frac;
%     elseif days_in_milk>330 && days_in_milk<=360
%         death_prob=(0.2000/p)-open_frac;
%     elseif days_in_milk>360 && days_in_milk<=390
%         death_prob=(0.1833/p)-open_frac;
%     elseif days_in_milk>390 && days_in_milk<=420
%         death_prob=(0.1400/p)-open_frac;
%     elseif days_in_milk>420
%         death_prob=(0.0118/p)-open_frac;
%     end
%     
% elseif par_status==3
%     if days_in_milk<=30
%         death_prob=0.1833/p;
%     elseif days_in_milk>30 && days_in_milk<=60
%         death_prob=0.2000/p;
%     elseif days_in_milk>60 && days_in_milk<=90
%         death_prob=(0.1900/p)-open_frac;
%     elseif days_in_milk>90 && days_in_milk<=120
%         death_prob=(0.2233/p)-open_frac;
%     elseif days_in_milk>120 && days_in_milk<=150
%         death_prob=(0.2333/p)-open_frac;
%     elseif days_in_milk>150 && days_in_milk<=180
%         death_prob=(0.2300/p)-open_frac;
%     elseif days_in_milk>180 && days_in_milk<=210
%         death_prob=(0.2567/p)-open_frac;
%     elseif days_in_milk>210 && days_in_milk<=240
%         death_prob=(0.2967/p)-open_frac;
%     elseif days_in_milk>240 && days_in_milk<=270
%         death_prob=(0.2567/p)-open_frac;
%     elseif days_in_milk>270 && days_in_milk<=300
%         death_prob=(0.2567/p)-open_frac;
%     elseif days_in_milk>300 && days_in_milk<=330
%         death_prob=(0.2700/p)-open_frac;
%     elseif days_in_milk>330 && days_in_milk<=360
%         death_prob=(0.2067/p)-open_frac;
%     elseif days_in_milk>360 && days_in_milk<=390
%         death_prob=(0.1500/p)-open_frac;
%     elseif days_in_milk>390 && days_in_milk<=420
%         death_prob=(0.1133/p)-open_frac;
%     elseif days_in_milk>420
%         death_prob=(0.0262/p)-open_frac;
%     end
%     
% elseif par_status==4
%     if days_in_milk<=30
%         death_prob=0.2467/p;
%     elseif days_in_milk>30 && days_in_milk<=60
%         death_prob=0.2533/p;
%     elseif days_in_milk>60 && days_in_milk<=90
%         death_prob=(0.2033/p)-open_frac;
%     elseif days_in_milk>90 && days_in_milk<=120
%         death_prob=(0.2033/p)-open_frac;
%     elseif days_in_milk>120 && days_in_milk<=150
%         death_prob=(0.2467/p)-open_frac;
%     elseif days_in_milk>150 && days_in_milk<=180
%         death_prob=(0.2700/p)-open_frac;
%     elseif days_in_milk>180 && days_in_milk<=210
%         death_prob=(0.3067/p)-open_frac;
%     elseif days_in_milk>210 && days_in_milk<=240
%         death_prob=(0.3000/p)-open_frac;
%     elseif days_in_milk>240 && days_in_milk<=270
%         death_prob=(0.3300/p)-open_frac;
%     elseif days_in_milk>270 && days_in_milk<=300
%         death_prob=(0.3000/p)-open_frac;
%     elseif days_in_milk>300 && days_in_milk<=330
%         death_prob=(0.2600/p)-open_frac;
%     elseif days_in_milk>330 && days_in_milk<=360
%         death_prob=(0.1867/p)-open_frac;
%     elseif days_in_milk>360 && days_in_milk<=390
%         death_prob=(0.1600/p)-open_frac;
%     elseif days_in_milk>390 && days_in_milk<=420
%         death_prob=(0.0933/p)-open_frac;
%     elseif days_in_milk>420
%         death_prob=(0.0242/p)-open_frac;
%     end
%     
% elseif par_status==5
%     if days_in_milk<=30
%         death_prob=0.2300/p;
%     elseif days_in_milk>30 && days_in_milk<=60
%         death_prob=0.2600/p;
%     elseif days_in_milk>60 && days_in_milk<=90
%         death_prob=(0.2533/p)-open_frac;
%     elseif days_in_milk>90 && days_in_milk<=120
%         death_prob=(0.2067/p)-open_frac;
%     elseif days_in_milk>120 && days_in_milk<=150
%         death_prob=(0.2667/p)-open_frac;
%     elseif days_in_milk>150 && days_in_milk<=180
%         death_prob=(0.2367/p)-open_frac;
%     elseif days_in_milk>180 && days_in_milk<=210
%         death_prob=(0.2633/p)-open_frac;
%     elseif days_in_milk>210 && days_in_milk<=240
%         death_prob=(0.2633/p)-open_frac;
%     elseif days_in_milk>240 && days_in_milk<=270
%         death_prob=(0.2400/p)-open_frac;
%     elseif days_in_milk>270 && days_in_milk<=300
%         death_prob=(0.2933/p)-open_frac;
%     elseif days_in_milk>300 && days_in_milk<=330
%         death_prob=(0.2067/p)-open_frac;
%     elseif days_in_milk>330 && days_in_milk<=360
%         death_prob=(0.1867/p)-open_frac;
%     elseif days_in_milk>360 && days_in_milk<=390
%         death_prob=(0.1567/p)-open_frac;
%     elseif days_in_milk>390 && days_in_milk<=420
%         death_prob=(0.0700/p)-open_frac;
%     elseif days_in_milk>420
%         death_prob=(0.0380/p)-open_frac;
%     end
%     
% elseif par_status==6
%     if days_in_milk<=30
%         death_prob=0.2600/p;
%     elseif days_in_milk>30 && days_in_milk<=60
%         death_prob=0.1067/p;
%     elseif days_in_milk>60 && days_in_milk<=90
%         death_prob=(0.2900/p)-open_frac;
%     elseif days_in_milk>90 && days_in_milk<=120
%         death_prob=(0.2133/p)-open_frac;
%     elseif days_in_milk>120 && days_in_milk<=150
%         death_prob=(0.1133/p)-open_frac;
%     elseif days_in_milk>150 && days_in_milk<=180
%         death_prob=(0.1833/p)-open_frac;
%     elseif days_in_milk>180 && days_in_milk<=210
%         death_prob=(0.3900/p)-open_frac;
%     elseif days_in_milk>210 && days_in_milk<=240
%         death_prob=(0.3200/p)-open_frac;
%     elseif days_in_milk>240 && days_in_milk<=270
%         death_prob=(0.2233/p)-open_frac;
%     elseif days_in_milk>270 && days_in_milk<=300
%         death_prob=(0.2367/p)-open_frac;
%     elseif days_in_milk>300 && days_in_milk<=330
%         death_prob=(0.1000/p)-open_frac;
%     elseif days_in_milk>330 && days_in_milk<=360
%         death_prob=(0.1600/p)-open_frac;
%     elseif days_in_milk>360 && days_in_milk<=390
%         death_prob=(0.0267/p)-open_frac;
%     elseif days_in_milk>390 && days_in_milk<=420
%         death_prob=(0.267/p)-open_frac;
%     elseif days_in_milk>420
%         death_prob=(0.0408/p)-open_frac;
%     end
% elseif par_status==7
%     if days_in_milk<=30
%         death_prob=0.3267/p;
%     elseif days_in_milk>30 && days_in_milk<=60
%         death_prob=0.0733/p;
%     elseif days_in_milk>60 && days_in_milk<=90
%         death_prob=(0.2233/p)-open_frac;
%     elseif days_in_milk>90 && days_in_milk<=120
%         death_prob=(0.1600/p)-open_frac;
%     elseif days_in_milk>120 && days_in_milk<=150
%         death_prob=(0.1667/p)-open_frac;
%     elseif days_in_milk>150 && days_in_milk<=180
%         death_prob=(0.3500/p)-open_frac;
%     elseif days_in_milk>180 && days_in_milk<=210
%         death_prob=(0.4900/p)-open_frac;
%     elseif days_in_milk>210 && days_in_milk<=240
%         death_prob=(0.3433/p)-open_frac;
%     elseif days_in_milk>240 && days_in_milk<=270
%         death_prob=(0.2567/p)-open_frac;
%     elseif days_in_milk>270 && days_in_milk<=300
%         death_prob=(0.5567/p)-open_frac;
%     elseif days_in_milk>300 && days_in_milk<=330
%         death_prob=(0.1667/p)-open_frac;
%     elseif days_in_milk>330 && days_in_milk<=360
%         death_prob=(0.1733/p)-open_frac;
%     elseif days_in_milk>360 && days_in_milk<=390
%         death_prob=(0.3700/p)-open_frac;
%     elseif days_in_milk>390 && days_in_milk<=420
%         death_prob=(0.3700/p)-open_frac;
%     elseif days_in_milk>420
%         death_prob=(0.2067/p)-open_frac;
%     end
% elseif par_status>=8
%     if days_in_milk<=30
%         death_prob=(0.2383/p)-open_frac;
%     elseif days_in_milk>30 && days_in_milk<=60
%         death_prob=(0.2383/p)-open_frac;
%     elseif days_in_milk>60 && days_in_milk<=90
%         death_prob=(0.3033/p)-open_frac;
%     elseif days_in_milk>90 && days_in_milk<=120
%         death_prob=(0.3033/p)-open_frac;
%     elseif days_in_milk>120
%         death_prob=1;
%     end
% else
%     death_prob=1;
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
% % function [death_prob]=nat_cull_prob(par_status,days_in_milk)
% % p=100;
% % % open_frac=0.000325;
% % if par_status==1
% %     if days_in_milk<=30
% %         death_prob=0.1433/p;
% %         %         death_prob=1-exp(-0.1433/p);
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         death_prob=0.1433/p;
% %         %         death_prob=1-exp(-0.1433/p);
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         death_prob=0.0967/p;
% %         %         death_prob=1-exp(-0.0967/p);
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         death_prob=0.0900/p;
% %         %         death_prob=1-exp(-0.0900/p);
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         death_prob=0.0833/p;
% %         %         death_prob=1-exp(-0.0833/p);
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         death_prob=0.0800/p;
% %         %         death_prob=1-exp(-0.0800/p);
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         death_prob=0.1067/p;
% %         %         death_prob=1-exp(-0.1067/p);
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         death_prob=0.1100/p;
% %         %         death_prob=1-exp(-0.1100/p);
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         death_prob=0.1167/p;
% %         %         death_prob=1-exp(-0.1167/p);
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         death_prob=0.1233/p;
% %         %         death_prob=1-exp(-0.1233/p);
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         death_prob=0.1233/p;
% %         %         death_prob=1-exp(-0.1233/p);
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         death_prob=0.1233/p;
% %         %         death_prob=1-exp(-0.1233/p);
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         death_prob=0.1233/p;
% %         %         death_prob=1-exp(-0.1233/p);
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         death_prob=0.1100/p;
% %         %         death_prob=1-exp(-0.1100/p);
% %     elseif days_in_milk>420
% %         death_prob=0.0202/p;
% %         %         death_prob=1-exp(-0.0202/p);
% %     end
% % elseif par_status==2
% %     if days_in_milk<=30
% %         death_prob=0.1233/p;
% %         % death_prob=1-exp(-0.1233/p);
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         death_prob=0.1500/p;
% %         % death_prob=1-exp(-0.1500/p);
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         death_prob=0.1500/p;
% %         % death_prob=1-exp(-0.1500/p);
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         death_prob=0.1567/p;
% %         % death_prob=1-exp(-0.1567/p);
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         death_prob=0.1667/p;
% %         % death_prob=1-exp(-0.1667/p);
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         death_prob=0.1867/p;
% %         % death_prob=1-exp(-0.1867/p);
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         death_prob=0.2033/p;
% %         % death_prob=1-exp(-0.2033/p);
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         death_prob=0.2467/p;
% %         % death_prob=1-exp(-0.2467/p);
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         death_prob=0.2400/p;
% %         % death_prob=1-exp(-0.2400/p);
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         death_prob=0.2567/p;
% %         % death_prob=1-exp(-0.2567/p);
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         death_prob=0.2100/p;
% %         % death_prob=1-exp(-0.2100/p);
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         death_prob=0.2000/p;
% %         % death_prob=1-exp(-0.2000/p);
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         death_prob=0.1833/p;
% %         % death_prob=1-exp(-0.1833/p);
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         death_prob=0.1400/p;
% %         % death_prob=1-exp(-0.1400/p);
% %     elseif days_in_milk>420
% %         death_prob=0.0118/p;
% %         % death_prob=1-exp(-0.0118/p);
% %     end
% %
% % elseif par_status==3
% %     if days_in_milk<=30
% %         death_prob=0.1833/p;
% %         % death_prob=1-exp(-0.1833/p);
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         death_prob=0.2000/p;
% %         % death_prob=1-exp(-0.2000/p);
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         death_prob=0.1900/p;
% %         % death_prob=1-exp(-0.1900/p);
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         death_prob=0.2233/p;
% %         % death_prob=1-exp(-0.2233/p);
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         death_prob=0.2333/p;
% %         % death_prob=1-exp(-0.2333/p);
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         death_prob=0.2300/p;
% %         % death_prob=1-exp(-0.2300/p);
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         death_prob=0.2567/p;
% %         % death_prob=1-exp(-0.2567/p);
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         death_prob=0.2967/p;
% %         % death_prob=1-exp(-0.2967/p);
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         death_prob=0.2567/p;
% %         % death_prob=1-exp(-0.2567/p);
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         death_prob=0.2567/p;
% %         % death_prob=1-exp(-0.2567/p);
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         death_prob=0.2700/p;
% %         % death_prob=1-exp(-0.2700/p);
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         death_prob=0.2067/p;
% %         % death_prob=1-exp(-0.2067/p);
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         death_prob=0.1500/p;
% %         % death_prob=1-exp(-0.1500/p);
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         death_prob=0.1133/p;
% %         % death_prob=1-exp(-0.1133/p);
% %     elseif days_in_milk>420
% %         death_prob=0.0262/p;
% %         % death_prob=1-exp(-0.0262/p);
% %     end
% %
% % elseif par_status==4
% %     if days_in_milk<=30
% %         death_prob=0.2467/p;
% %         % death_prob=1-exp(-0.2467/p);
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         death_prob=0.2533/p;
% %         % death_prob=1-exp(-0.2533/p);
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         death_prob=0.2033/p;
% %         % death_prob=1-exp(-0.2033/p);
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         death_prob=0.2033/p;
% %         % death_prob=1-exp(-0.2033/p);
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         death_prob=0.2467/p;
% %         % death_prob=1-exp(-0.2467/p);
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         death_prob=0.2700/p;
% %         % death_prob=1-exp(-0.2700/p);
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         death_prob=0.3067/p;
% %         % death_prob=1-exp(-0.3067/p);
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         death_prob=0.3000/p;
% %         % death_prob=1-exp(-0.3000/p);
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         death_prob=0.3300/p;
% %         % death_prob=1-exp(0.3300/p);
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         death_prob=0.3000/p;
% %         % death_prob=1-exp(0.3000/p);
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         death_prob=0.2600/p;
% %         % death_prob=1-exp(-0.2600/p);
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         death_prob=0.1867/p;
% %         % death_prob=1-exp(-0.1867/p);
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         death_prob=0.1600/p;
% %         % death_prob=1-exp(-0.1600/p);
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         death_prob=0.0933/p;
% %         % death_prob=1-exp(-0.0933/p);
% %     elseif days_in_milk>420
% %         death_prob=0.0242/p;
% %         % death_prob=1-exp(-0.0242/p);
% %     end
% %
% % elseif par_status==5
% %     if days_in_milk<=30
% %         death_prob=0.2300/p;
% %         % death_prob=1-exp(-0.2300/p);
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         death_prob=0.2600/p;
% %         % death_prob=1-exp(-0.2600/p);
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         death_prob=0.2533/p;
% %         % death_prob=1-exp(-0.2533/p);
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         death_prob=0.2067/p;
% %         % death_prob=1-exp(-0.2067/p);
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         death_prob=0.2667/p;
% %         % death_prob=1-exp(-0.2667/p);
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         death_prob=0.2367/p;
% %         % death_prob=1-exp(-0.2367/p);
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         death_prob=0.2633/p;
% %         % death_prob=1-exp(-0.2633/p);
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         death_prob=0.2633/p;
% %         % death_prob=1-exp(-0.2633/p);
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         death_prob=0.2400/p;
% %         % death_prob=1-exp(-0.2400/p);
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         death_prob=0.2933/p;
% %         % death_prob=1-exp(-0.2933/p);
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         death_prob=0.2067/p;
% %         % death_prob=1-exp(-0.2067/p);
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         death_prob=0.1867/p;
% %         % death_prob=1-exp(-0.1867/p);
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         death_prob=0.1567/p;
% %         % death_prob=1-exp(-0.1567/p);
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         death_prob=0.0700/p;
% %         % death_prob=1-exp(-0.0700/p);
% %     elseif days_in_milk>420
% %         death_prob=0.0380/p;
% %         % death_prob=1-exp(-0.0380/p);
% %     end
% %
% % elseif par_status==6
% %     if days_in_milk<=30
% %         death_prob=0.2600/p;
% %         % death_prob=1-exp(-0.2600/p);
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         death_prob=0.1067/p;
% %         % death_prob=1-exp(-0.1067/p);
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         death_prob=0.2900/p;
% %         % death_prob=1-exp(-0.2900/p);
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         death_prob=0.2133/p;
% %         % death_prob=1-exp(-0.2133/p);
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         death_prob=0.1133/p;
% %         % death_prob=1-exp(-0.1133/p);
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         death_prob=0.1833/p;
% %         % death_prob=1-exp(-0.1833/p);
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         death_prob=0.3900/p;
% %         % death_prob=1-exp(-0.3900/p);
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         death_prob=0.3200/p;
% %         % death_prob=1-exp(-0.3200/p);
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         death_prob=0.2233/p;
% %         % death_prob=1-exp(-0.2233/p);
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         death_prob=0.2367/p;
% %         % death_prob=1-exp(-0.2367/p);
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         death_prob=0.1000/p;
% %         % death_prob=1-exp(-0.1000/p);
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         death_prob=0.1600/p;
% %         % death_prob=1-exp(-0.1600/p);
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         death_prob=0.0267/p;
% %         % death_prob=1-exp(-0.0267/p);
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         death_prob=0.267/p;
% %         % death_prob=1-exp(-0.267/p);
% %     elseif days_in_milk>420
% %         death_prob=0.0408/p;
% %         % death_prob=1-exp(-0.0408/p);
% %     end
% % elseif par_status==7
% %     if days_in_milk<=30
% %         death_prob=0.3267/p;
% %         % death_prob=1-exp(-0.3267/p);
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         death_prob=0.0733/p;
% %         % death_prob=1-exp(-0.0733/p);
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         death_prob=0.2233/p;
% %         % death_prob=1-exp(-0.2233/p);
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         death_prob=0.1600/p;
% %         % death_prob=1-exp(-0.1600/p);
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         death_prob=0.1667/p;
% %         % death_prob=1-exp(-0.1667/p);
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         death_prob=0.3500/p;
% %         % death_prob=1-exp(-0.3500/p);
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         death_prob=0.4900/p;
% %         % death_prob=1-exp(-0.4900/p);
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         death_prob=0.3433/p;
% %         % death_prob=1-exp(-0.3433/p);
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         death_prob=0.2567/p;
% %         % death_prob=1-exp(-0.2567/p);
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         death_prob=0.5567/p;
% %         % death_prob=1-exp(-0.5567/p);
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         death_prob=0.1667/p;
% %         % death_prob=1-exp(-0.1667/p);
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         death_prob=0.1733/p;
% %         % death_prob=1-exp(-0.1733/p);
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         death_prob=0.3700/p;
% %         % death_prob=1-exp(0.3700/p);
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         death_prob=0.3700/p;
% %         % death_prob=1-exp(-0.3700/p);
% %     elseif days_in_milk>420
% %         death_prob=0.2067/p;
% %         % death_prob=1-exp(-0.2067/p);
% %     end
% % elseif par_status>=8
% %     if days_in_milk<=30
% %         death_prob=0.2383/p;
% %         % death_prob=1-exp(-0.2383/p);
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         death_prob=0.2383/p;
% %         % death_prob=1-exp(-0.2383/p);
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         death_prob=0.3033/p;
% %         % death_prob=1-exp(-0.3033/p);
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         death_prob=0.3033/p;
% %         % death_prob=1-exp(-0.3033/p);
% %     elseif days_in_milk>120
% %         death_prob=1;
% %     end
% % else
% %     death_prob=1;
% %
% % end
% %
% % end
% 
% 
% % function [death_prob]=nat_cull_prob(par_status,days_in_milk)
% % if par_status==1
% %     if days_in_milk<=30
% %         death_prob=0.1433;
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         death_prob=0.1433;
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         death_prob=0.0967;
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         death_prob=0.0900;
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         death_prob=0.0833;
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         death_prob=0.0800;
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         death_prob=0.1067;
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         death_prob=0.1100;
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         death_prob=0.1167;
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         death_prob=0.1233;
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         death_prob=0.1233;
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         death_prob=0.1233;
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         death_prob=0.1233;
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         death_prob=0.1100;
% %     elseif days_in_milk>420
% %         death_prob=0.0202;
% %     end
% % elseif par_status==2
% %     if days_in_milk<=30
% %         death_prob=0.1233;
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         death_prob=0.1500;
% %     elseif days_in_milk>60 && days_in_milk<=90
% %         death_prob=0.1500;
% %     elseif days_in_milk>90 && days_in_milk<=120
% %         death_prob=0.1567;
% %     elseif days_in_milk>120 && days_in_milk<=150
% %         death_prob=0.1667;
% %     elseif days_in_milk>150 && days_in_milk<=180
% %         death_prob=0.1867;
% %     elseif days_in_milk>180 && days_in_milk<=210
% %         death_prob=0.2033;
% %     elseif days_in_milk>210 && days_in_milk<=240
% %         death_prob=0.2467;
% %     elseif days_in_milk>240 && days_in_milk<=270
% %         death_prob=0.2400;
% %     elseif days_in_milk>270 && days_in_milk<=300
% %         death_prob=0.2567;
% %     elseif days_in_milk>300 && days_in_milk<=330
% %         death_prob=0.2100;
% %     elseif days_in_milk>330 && days_in_milk<=360
% %         death_prob=0.2000;
% %     elseif days_in_milk>360 && days_in_milk<=390
% %         death_prob=0.1833;
% %     elseif days_in_milk>390 && days_in_milk<=420
% %         death_prob=0.1400;
% %     elseif days_in_milk>420
% %         death_prob=0.0118;
% %     end
% % elseif par_status==3
% %     if days_in_milk<=30
% %         death_prob=0.1833;
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         death_prob=0.2000;
% %             elseif days_in_milk>60 && days_in_milk<=90
% %         death_prob=0.1900;
% %             elseif days_in_milk>90 && days_in_milk<=120
% %         death_prob=0.2233;
% %             elseif days_in_milk>120 && days_in_milk<=150
% %         death_prob=0.2333;
% %             elseif days_in_milk>150 && days_in_milk<=180
% %         death_prob=0.2300;
% %             elseif days_in_milk>180 && days_in_milk<=210
% %         death_prob=0.2567;
% %             elseif days_in_milk>210 && days_in_milk<=240
% %         death_prob=0.2967;
% %             elseif days_in_milk>240 && days_in_milk<=270
% %         death_prob=0.2567;
% %             elseif days_in_milk>270 && days_in_milk<=300
% %         death_prob=0.2567;
% %             elseif days_in_milk>300 && days_in_milk<=330
% %         death_prob=0.2700;
% %             elseif days_in_milk>330 && days_in_milk<=360
% %         death_prob=0.2067;
% %             elseif days_in_milk>360 && days_in_milk<=390
% %         death_prob=0.1500;
% %             elseif days_in_milk>390 && days_in_milk<=420
% %         death_prob=0.1133;
% %             elseif days_in_milk>420
% %         death_prob=0.0262;
% %     end
% % elseif par_status==4
% %     if days_in_milk<=30
% %         death_prob=0.2467;
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         death_prob=0.2533;
% %             elseif days_in_milk>60 && days_in_milk<=90
% %         death_prob=0.2033;
% %             elseif days_in_milk>90 && days_in_milk<=120
% %         death_prob=0.2033;
% %             elseif days_in_milk>120 && days_in_milk<=150
% %         death_prob=0.2467;
% %             elseif days_in_milk>150 && days_in_milk<=180
% %         death_prob=0.2700;
% %             elseif days_in_milk>180 && days_in_milk<=210
% %         death_prob=0.3067;
% %             elseif days_in_milk>210 && days_in_milk<=240
% %         death_prob=0.3000;
% %             elseif days_in_milk>240 && days_in_milk<=270
% %         death_prob=0.3300;
% %             elseif days_in_milk>270 && days_in_milk<=300
% %         death_prob=0.3000;
% %             elseif days_in_milk>300 && days_in_milk<=330
% %         death_prob=0.2600;
% %             elseif days_in_milk>330 && days_in_milk<=360
% %         death_prob=0.1867;
% %             elseif days_in_milk>360 && days_in_milk<=390
% %         death_prob=0.1600;
% %             elseif days_in_milk>390 && days_in_milk<=420
% %         death_prob=0.0933;
% %             elseif days_in_milk>420
% %         death_prob=0.0242;
% %     end
% % elseif par_status==5
% %     if days_in_milk<=30
% %         death_prob=0.2300;
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         death_prob=0.2600;
% %             elseif days_in_milk>60 && days_in_milk<=90
% %         death_prob=0.2533;
% %             elseif days_in_milk>90 && days_in_milk<=120
% %         death_prob=0.2067;
% %             elseif days_in_milk>120 && days_in_milk<=150
% %         death_prob=0.2667;
% %             elseif days_in_milk>150 && days_in_milk<=180
% %         death_prob=0.2367;
% %             elseif days_in_milk>180 && days_in_milk<=210
% %         death_prob=0.2633;
% %             elseif days_in_milk>210 && days_in_milk<=240
% %         death_prob=0.2633;
% %             elseif days_in_milk>240 && days_in_milk<=270
% %         death_prob=0.2400;
% %             elseif days_in_milk>270 && days_in_milk<=300
% %         death_prob=0.2933;
% %             elseif days_in_milk>300 && days_in_milk<=330
% %         death_prob=0.2067;
% %             elseif days_in_milk>330 && days_in_milk<=360
% %         death_prob=0.1867;
% %             elseif days_in_milk>360 && days_in_milk<=390
% %         death_prob=0.1567;
% %             elseif days_in_milk>390 && days_in_milk<=420
% %         death_prob=0.0700;
% %             elseif days_in_milk>420
% %         death_prob=0.0380;
% %     end
% % elseif par_status==6
% %     if days_in_milk<=30
% %         death_prob=0.2600;
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         death_prob=0.1067;
% %             elseif days_in_milk>60 && days_in_milk<=90
% %         death_prob=0.2900;
% %             elseif days_in_milk>90 && days_in_milk<=120
% %         death_prob=0.2133;
% %             elseif days_in_milk>120 && days_in_milk<=150
% %         death_prob=0.1133;
% %             elseif days_in_milk>150 && days_in_milk<=180
% %         death_prob=0.1833;
% %             elseif days_in_milk>180 && days_in_milk<=210
% %         death_prob=0.3900;
% %             elseif days_in_milk>210 && days_in_milk<=240
% %         death_prob=0.3200;
% %             elseif days_in_milk>240 && days_in_milk<=270
% %         death_prob=0.2233;
% %             elseif days_in_milk>270 && days_in_milk<=300
% %         death_prob=0.2367;
% %             elseif days_in_milk>300 && days_in_milk<=330
% %         death_prob=0.1000;
% %             elseif days_in_milk>330 && days_in_milk<=360
% %         death_prob=0.1600;
% %             elseif days_in_milk>360 && days_in_milk<=390
% %         death_prob=0.0267;
% %             elseif days_in_milk>390 && days_in_milk<=420
% %         death_prob=0.267;
% %             elseif days_in_milk>420
% %         death_prob=0.0408;
% %     end
% % elseif par_status==7
% %     if days_in_milk<=30
% %         death_prob=0.3267;
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         death_prob=0.0733;
% %             elseif days_in_milk>60 && days_in_milk<=90
% %         death_prob=0.2233;
% %             elseif days_in_milk>90 && days_in_milk<=120
% %         death_prob=0.1600;
% %             elseif days_in_milk>120 && days_in_milk<=150
% %         death_prob=0.1667;
% %             elseif days_in_milk>150 && days_in_milk<=180
% %         death_prob=0.3500;
% %             elseif days_in_milk>180 && days_in_milk<=210
% %         death_prob=0.4900;
% %             elseif days_in_milk>210 && days_in_milk<=240
% %         death_prob=0.3433;
% %             elseif days_in_milk>240 && days_in_milk<=270
% %         death_prob=0.2567;
% %             elseif days_in_milk>270 && days_in_milk<=300
% %         death_prob=0.5567;
% %             elseif days_in_milk>300 && days_in_milk<=330
% %         death_prob=0.1667;
% %             elseif days_in_milk>330 && days_in_milk<=360
% %         death_prob=0.1733;
% %             elseif days_in_milk>360 && days_in_milk<=390
% %         death_prob=0.3700;
% %             elseif days_in_milk>390 && days_in_milk<=420
% %         death_prob=0.3700;
% %             elseif days_in_milk>420
% %         death_prob=0.2067;
% %     end
% % elseif par_status>=8
% %     if days_in_milk<=30
% %         death_prob=0.2383;
% %     elseif days_in_milk>30 && days_in_milk<=60
% %         death_prob=0.2383;
% %             elseif days_in_milk>60 && days_in_milk<=90
% %         death_prob=0.3033;
% %             elseif days_in_milk>90 && days_in_milk<=120
% %         death_prob=0.3033;
% %             elseif days_in_milk>120
% %         death_prob=1;
% %     end
% % else
% %     death_prob=1;
% %
% % end
% % end