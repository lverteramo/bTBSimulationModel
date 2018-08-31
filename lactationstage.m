function [S_L]=lactationstage()
%%Exit Prob from S to L, is 0.0017 per day PAPER
x = rand;
if (x < 0.0017);
    %exit_S_to_L= 1; % Head, move to Latent
    
    S_L= 2;
    
else
    %exit_S_to_L=0; % Tail, Stay in Susceptible
    S_L= 1;
    
end
end