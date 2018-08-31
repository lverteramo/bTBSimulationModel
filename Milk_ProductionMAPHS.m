%%%% 
%%%% Daily Milk Production Estimate considering MAP
%%%% Infected Cows using Becky's Function
% Leslie Verteramo Chiu, Sept, 10, 2016. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Inputs of the function: 
% Parity (Lactation Number), divided into first and the rest. 
% Somatic Cell Linear Score (LS, Log of the SCC)
% Days in Milking (DIM)
% Season: Winter (Jan-Mar), Spring (Apr-Jun), Summer (Jul-Sep), Fall
% (Oct-Dec)
% MAP Path (constant): MAP Infection path based on tests. 
%   Negative: All test are neg. (Susceptible)
%   Low: at least one positive test, either Fecal Culture with <50 cfu/tube,
%   ELISA, or Postmortem tissue culture.
%   High: at least one positive FC or tissue culture with >50cfu/tube.
% 
% MAP Status (time dependent): 4 categories. 
%   Negative, Latent, Low Shedding, and High Shedding.
% 
% MAP Time (Months Spent at a Particular, current, Status Level): 0 if MAP
% Path is Negative; othewise it is the num of months in the non-neg status.
% Months in Latent, Y1, or Y2.
%
% Herd. NY is the baseline. 
% Two Models are considered, with and without MAP Path.
%
% The Full Model is:
% Milk= B0+ B1*Parity+ B2*LS+ B3*Season+ B4Herd+ B5DIM+ B6*e^(-0.1*DIM)+
%         D1*DIM*Parity+ D2*e^(-0.1*DIM)*Parity+ B7*MAPPath+ 
%         B8*MAPStatus+ B9*MapTime+ D3*MapTime*MAPStatus
% 
% Esimated Parameters are: B0-9, D1-2

% LS is estimated or set to an average. In Becky's data, the average is
% 2.48. 
% Season is the result of a functionwt
% Av. Milk Prod In Becky's data is 70.4 Lbs/ day


% This function does not include MAP Path

function [milk]= Milk_ProductionMAPHS(par_status, days_in_milk, Season, LS, ...
        MAPStatus, MAPTime,MilkGenetics)
    % Parameters (From Smith et al. 2016)
    
B0= 42.44;  % Intercept
B1= 9.73;   % >1 Lactation
B2= -0.98;  % Linear Score of Somatic Cell (Log of SCC)
B3Sp= 2.59; % Effect of Spring Season with respect to Fall
B3Su= 1.45; % Summer Effect wrt Fall
B3Wi= 1.24; % Winter Effect wrt Fall
B5= -0.02;  % Days in Milking (DIM)
B6= -27.82; % exp of DIM, exp(-0.1*DIM) 
D1= -0.03;  % DIM * Parity >1
D2= 0.8;    % exp(-0.1*DIM) * Parity>1
B7La= 1.5;  % Latent (Base is Susceptible, negative)
B7LS= -1.37; % Low Shedding
B7HS= -3.96; % High Shedding
B8= -0.79;  % MAP time (in months) in the current non-neg status
B9La= 0.71; % MAP Time * MAP Status (Latent)
B9LS= 0.87; % MAP Time * MAP Status (Low Shedders), Base is High Shedders
% The parameter B10LS is published in the paper as 0.87, which would make
% Y2 production > Susceptible for large MAPTime. 
% That is why it is changed to 0.80, so that it is always less than S but
% close in value.

ProdAdj= -5.6; % Production adjustment in relation to NYS average  production 
                % This adjustment brings the average production per year to
                % 23,000 lb. per cow.





if MilkGenetics ==5 % Change the intercept according to Genetic Potential. if 3, leave as it is.
    B0= B0+5;
elseif MilkGenetics== 4
    B0= B0+2.5;
elseif MilkGenetics== 2
    B0= B0-2.5;
elseif MilkGenetics== 1
    B0= B0-5;    
end

if Season== 1 % 1= Spring 
        Spring= 1; Summer= 0; Winter= 0; 
elseif Season== 2 % 2= Summer
        Spring= 0; Summer= 1; Winter= 0;
elseif Season== 3 % 3= Fall, this is the baseline
        Spring= 0; Summer= 0; Winter= 0;
else % Season= 4; 4= Winter
        Spring= 0; Summer= 0; Winter= 1;    
end

% The difference between this model and ProductionMAP is the number
% assigned to each MAP Status, Here it is 1-4; in the other model (1,3,4,5)

if MAPStatus== 1 % 1= Susceptible 
        Latent= 0; LowShed= 0; HighShed= 0; 
elseif MAPStatus== 2 % 3= Latent 
        Latent= 1; LowShed= 0; HighShed= 0;
elseif MAPStatus== 3 % 4= Low Shedding 
        Latent= 0; LowShed= 1; HighShed= 0;
elseif MAPStatus== 4 % 5= High Shedding 
        Latent= 0; LowShed= 0; HighShed= 1;
else % if none of the above, keep it as Susceptible
        Latent= 0; LowShed= 0; HighShed= 0;
end

% MAPTime, Number of months spent at a particular status level
if MAPStatus== 1
    MAPTime=  0; % MAP Time is 0 for Susceptible COws 
end

if par_status > 1
    par_statusMod= 1;
else
    par_statusMod= 0;
end

% decrease milk production by parities >7






milk= B0+ B1*par_statusMod+ B2*LS+ B3Sp*Spring+ B3Su*Summer+ B3Wi*Winter+...
        B5*days_in_milk+ B6*exp(-0.1*days_in_milk)+...
        D1*days_in_milk*par_statusMod+ D2*par_statusMod*exp(-0.1*days_in_milk)+...
        B7La*Latent+ B7LS*LowShed+ B7HS*HighShed+ B8*MAPTime+...
        B9La*MAPTime*Latent+ B9LS*MAPTime*LowShed + ProdAdj ;



end
