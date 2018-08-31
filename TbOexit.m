
%Function to simulate Tb Progression from Occult-Reactive 

% Probability of Tb Progression from O-R

function [TbO_R]=TbOexit(TbexitO,TbStatus) %
x = rand;



if  TbStatus== 2 % Occult Cows

    if (x < TbexitO) % If Progression to R
        TbO_R= 3; % Move to Reactive
    else
        TbO_R= 2; % Stay in Occult
 
    end

elseif TbStatus== 6 % Occult Calves
        
    if (x < TbexitO) % If Progression to R
        TbO_R= 7; % Move to Reactive
    else
        TbO_R= 6; % Stay in Occult
 
    end
    

elseif TbStatus==  10 % Occult Heifers
    
    if (x < TbexitO) % If Progression to R
        TbO_R= 11; % Move to Reactive
    else
        TbO_R= 10; % Stay in Occult
 
    end
    

end

end



