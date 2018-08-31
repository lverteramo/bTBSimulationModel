
% Function that estimates Body Weight (BW) for calves, heifers, and cows.
% The animal weight is the sum of three components: function of age, lactation, and pregnancy.
% Formula from Korver, and Van Arendonk (1985), "A Function for Live-Weight...
% Change Between two Calving in Dairy Cattle", Animal Productio 1995. 

function [BWt]= BW(dim,milk,Preg,Age,par_status,MatureWeight) 

%Estimates DMI from the parameters:
% BWt: Body Weight total (kg); 
% Bwa: Body Weight as a function of age
% Bwl: Body Weight as a function of lactation
% Bwp: Body Weight as a function of pregnancy
% Milk: milk production
% Parity: Parity Number
% Age: age in day
% MatureWeight: Expected weight of a full growns cow (pregnant)
% Preg: days pregnant
% P3 and P4, max Kg gained in lactation, and days to reach it,
% respectively.
% P2, P5: Shape parameters in the function of pregnancy

BirthWeight= 42; % 42 Kg based on Karun's model
k= 0.0039; %Growth Rate Parameter (Karun's Model)
P2= 0.015; % Shape Parameter
P5= 50; % Days in which the fetus does not has a significant weight
%BWa= 0; BWl= 0; BWp= 0; % Initialize variables

% Function of age
    BWa= MatureWeight*(1-(1-(BirthWeight/MatureWeight)^(1/3))*exp(-k*Age))^3;

% Function of Lactation
if milk>0 && par_status==1  % If producting Milk
    P3= 20; % kg gained
    P4= 65; % Days to reach it 
    % Function of Lactation for Heifers (first calving)
    BWl= (P3*dim/P4)*exp(1-dim/P4); 

elseif milk>0 && par_status> 1
    P3= 40; % kg gained
    P4= 70; % Days to reach it 
    % Function of Lactation for Cows (>first calving)
    BWl= (P3*dim/P4)*exp(1-dim/P4); 

else
    BWl= 0;
end


% Function of Pregnancy
if Preg-P5>0
    BWp= (P2^3)*(Preg-P5)^3;  % Increase in weight is > 50 Days Pregnant
else
    BWp= 0;
end

BWt= BWa+BWl+BWp; 
end

