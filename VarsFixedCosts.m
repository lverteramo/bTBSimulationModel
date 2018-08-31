% Function to generate daily nonfeed variable costs and fixed costs per
% animal depending on its age.
% Leslie Verteramo Chiu, Dec. 7, 2016

% These values are estimated such that the final cost of raisin a heifer is
% consistent with the literature 
% (Jason Karszez, Dairy Replacement Programans: Costs & Analysis 3rd Quarter 2012).
% The feed cost are estimated from the functions: BW (Body Weight), and DMI
% (Dry Matter Intake). Then a cost per Kg of DMI is applied to the feed
% amount according to the weight of the animal.
% However, Karszes estimated daily costs of raisin a heifer from birth to
% calving. 
% Any difference from the feed cost and Karszes' estimated total cost is
% estimated in this function. 
% This difference is nonFeed cost plus fixed costs. 

% The estimation of these nonfeed and fixed costs are located in the file
% ('CostParameters_Nov16_16.xls')

% Jan 17, 17. The fixed cost valus per animal per day were changed to match
% as close as possible the raising cost of a heifer of about 2,100
% according to Jason's report.

function  [NonFeedCosts]= VarsFixedCosts(Age,FixedVarsCostDay,CostCalf,par_status)

    if Age== 1 
        NonFeedCosts= CostCalf; % Cost of newborn Calf
        
    elseif Age> 1 && Age<= 28
        NonFeedCosts=  5.0; % 6.09

    elseif Age> 28 && Age<= 439
        NonFeedCosts= 0.85;  % 1.95;

    elseif Age> 439 && Age<= 699
        NonFeedCosts= 1.4;  % 1.57;

    elseif Age> 699 && par_status == 0
        NonFeedCosts= 1.4;  % 2.12;

    elseif Age> 720 && par_status > 0
        NonFeedCosts= FixedVarsCostDay;

    end
end