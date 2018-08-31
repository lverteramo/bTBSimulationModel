
%Function to simulate Tb INfection given probability STb_Inf

% Prob of Infection by age category (Cow, Calf, Heifer) are estimated in
% the simulation. 
% TbSusceptibles only get Infected through TbI

function [TbS_O, infected]=Tbinfection_chanceS_OR0(STb_Inf,TbStatus) %
x = rand;
infected= 0;

if x < STb_Inf && TbStatus ~= 13% If Infected by Tb
    infected= 1;
end
TbS_O= TbStatus;
% if TbStatus== 1 % If it is a COW Susceptible
%     if (x < STb_Inf) % If Infected by Tb
%             TbS_O= 2; % Move to Occult
%     else
%             TbS_O= 1; % Stay in Susceptible
%  
%     end
%     
% elseif TbStatus== 5 % If it is a CALF Susceptible
%     if (x < STb_Inf) % If Infected by Tb
%             TbS_O= 6; % Move to Occult Calf
%     else
%             TbS_O= 5; % Stay in Susceptible Calf
%  
%     end
%     
% elseif TbStatus== 9 % If it is a HEIFER Susceptible
%     if (x < STb_Inf) % If Infected by Tb
%             TbS_O= 10; % Move to Occult Heifer
%     else
%             TbS_O= 9; % Stay in Susceptible Heifer
%  
%     end
%     
%     
% end

end




