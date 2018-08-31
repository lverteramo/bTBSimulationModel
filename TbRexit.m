
%Function to simulate Tb Progressio from Reactive-Infectious 

% Probability of Tb Progression from R-I

function [TbR_I, infected]=TbRexit(TbexitR,TbStatus) %
x = rand;
infected= 0;
if (x < TbexitR)
    infected= 1;
end
        
if  TbStatus== 3 % Reactive Cows

    if (x < TbexitR) % If Progression to R
        TbR_I= 4; % Move to Infectious
    else
        TbR_I= 3; % Stay in Reactive
 
    end

elseif TbStatus== 7 % Reactive Calves
        
    if (x < TbexitR) % If Progression to R
        TbR_I= 8; % Move to Infectious
    else
        TbR_I= 7; % Stay in Reactive
 
    end
    

elseif TbStatus==  11 % Reactive Heifers
    
    if (x < TbexitR) % If Progression to R
        TbR_I= 12; % Move to Infectious
    else
        TbR_I= 11; % Stay in Reactive
 
    end
    

end
    
    

end



