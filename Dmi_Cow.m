
%Function that estimates Dry Matter Intake (DMI) for Lactationg Cows
% Formula from NRC(2001), 4% Fat Corrected Milk formula from Gaines and
% Davidson (1923).

function [dmi]=Dmi_Cow(BWt,milk,WOL,par_status) %Estimates DMI (kg/day) from the parameters:
% BWt: Body Weight (kg); Milk: Milk Production (kg); Fat: Fat content (kg), 3.5%;
% WOL: Weeks on Lactation (begin with 1); NE: Net energy, Mcal/Kg DM (set to 2.3);

NE= 2.3; % Net Energy (Mcal/Kg)
Fat= milk*0.035; % Fat content in milk produced, assume 3.5% Fat.
FCM= milk*0.4+15*Fat; % Fat Corrected Milk (4% Fat)

if  par_status>0 % For Cows (lactating and/or pregnant)
    if milk==0 % If not lactating, set WOL to 0 
        WOL= 0;
    end
    dmi= (0.372*FCM+0.0968*BWt^0.75)*(1-exp(-0.192*(WOL+3.67))); % DMI for cows (kg/day)
else % For Heifers
    dmi= BWt^0.75*(0.2435*NE-0.0466*NE^2-0.1128)/NE; % DMI for Heifers

end


end


