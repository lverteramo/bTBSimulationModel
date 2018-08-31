
%%% Dairy Herd Simulation Model with bTB Infected Heifers Introduced %%%

% This program simulates a 1,000 cow dairy operation (closed herd)
% It allows the introduction of bTB infected heifers at time 1,
% and follows the USDA bTB elimination protocol, or any other protocol 
% defined by the user.

% The results of the simulation include: herd's NPV, number of animals (by
% infection status), expenses of contol stategies, among others.

% This model us based on the agent based model by Ma Al-Manum (2016).
% This version written by Leslie J. Verteramo Chiu, PhD. 2018.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clear memory and variables, and set working directory
close all
clc

cd('C:\Users\ljv9\Dropbox\MAP_Project\TB_Model\MatLab_TB'); % Directory
%% Parameters and variables of the Model

MaxSim= 1000 ; % Number of iterations

% For Tb only: WarmUp= 3000, Stability= 0
WarmUp= 0; % Set to 0 if starting simulation from the same herd.
StabilityTime= 0; % Set to 0 if starting simulation from the same herd.
% Can change this value
AnalysisTime= 7300; % after WarmUp+Stability, do the analysis for this time (in days): 20 Yrs= 7300 days

T= StabilityTime+ WarmUp+AnalysisTime; % Total days of simulation including warmup and stability time.
Results= zeros(MaxSim,31); % Initialize matrix to store the main results for each iteration
colherd= 41; % Number of columns in matrix Herd (main matrix of results). 
ResultsWHT= zeros(40,12,MaxSim); % Initialize matrix to store the results of the whole herd tests (for bTB contol) for each iteration

% The following matrix is needed only to esitmat R0 of bTB.
%TBHistAll= zeros(40, 8, MaxSim); % number of bTB infections to determine R0

%% Infection Transmission Parameters

% MAP Progression Rate
ExitRateLtoY1= 0.0018;      % Exit Rate from Latent to Low Shedders 
ExitRateY1toY2= 0.000904;   % Exit Rate from Low Shedders to High Shedders 
% Natural culling rate
nat_cull_prob_same= 0.000132;       % Culling from diseases and accidents.
NatCullProbHeifers= 0.0000192*3;    % Natural Daily Culling Prob for Heifers
NatCullProbCalves=  0.000304*8;     % Natural Daily Culling Prob for Calves 0.00041, model
factorcull= .3;     % factor to modify culling rate for cows

% Maximum parity and pregnancy parameters
AIattempts= 8;  % Number of maximum failed insemination Attempts before culling
MaxParity= 9;   % Number of parity before culling
prob_pregInput= 0.18; % Prob of pregnancy of Heifers. Parity 0
annualProb= 0.70;   % Annulal Prob of Pregnancy for Cows

% MAP Infection and progresison parameters
% Allow Infection to Progress? Yes/No= 1/0. These are switches.
AllowInfection= 0;              % This is for ALL infection status (Vertical and Horizontal)
% % Factors that modify Vertical Transmission. 
% % SET TO 0 if NO VERTICAL INFECTION.

% Factors that modify Progression Rate (to Y1 and Y2)
FactorProgtoY1= 1;              % Factor to midify Progression rate from Latent to Y1. This may be lower than 1 due to vaccines
FactorProgtoY2= 1;              % Factor to midify Progression rate from Latent to Y2. This may be lower than 1 due to vaccines

% MAP Testing: FC and Elisa; 
% Select whether the model allows for testing, then select frequency.

% TEST AND CULL
fcTest= 1; % Test FC, no false negatives
elisaTest= 1; % Test Elisa
FrequencyTest= 1; %0.5; % Annual test, values of rates are for Annual (0.5), Every 6 months (1).
costElisa= 6; 
costFC= 36; 

TestSpecificityElisa= 0.97; %0.95; % Tests Specificity of Elisa. (True Negatives)
TestSpecificityFC= 1; % Tests Specificity of FC. IT has a specificity of 1.
TestSensitivityElisaY1= 0.24; % 0.3; % Test sensitivity for Low Shedders on Elisa Test (True Positives)
TestSensitivityFCY1= 0.5; % Test sensitivity for Low Shedders on FC Test
TestSensitivityElisaY2= 0.78; %0.75; % Test sensitivity for High Shedders on Elisa Test
TestSensitivityFCY2= 0.9; % Test sensitivity for High Shedders on FC Test

% MILK PRODUCTION Y2 (High Shedders of MAP)
PregRateDecreaseY2= 0.9; % Decrease Pregnancy rate by 10% for High Shedders

% Voluntary Cull Cows if their number is greater than the limit in the herd
VoluntCullOption= 1; % cull cows to keep number to 1000. (Y=1/ N=0), for the WarmUp period only
herdLimit= 1000; % Capacity of the number of cows in the herd (1000)

% VoluntaryCulling of Calves
% Keep the number of calves in the calving compartment to a limit, so that 
% the average number of cows is stable.
% Turn Switch ON (=1) if Using Voluntary Calves Culling
VoluntaryCalfCull= 0; % Set to 1 if voluntary culling calves (to sell)

%LimitCalves= 83; % Calves Compartment is 2 months. Multiply desired monthly limit by 2 to get compartment average.
    % if want 40 calves per month, that is 80 per compartment
    % When the number of calves is beyond the limit, sell the
    % youngest calves until reach the limit again.

MilkProdSame= 0; % 1= Make production of Susceptible = Latent   
groupLact= 0; % Separage cows into groups according to their lactation stage.

%% PARAMETERS FOR INITIALIZATION OF MAP INFECTION

% Set to 0 for ALL SUSCEPTIBLE (Healthy)
% The following are for ScenarioWarmUp 1 Parameter
NewInfectedType= 4; % Infection Status (2-4) of the Newly Infected Cows (Start Scenario with this infection status)
parityScenarioWarmUp= [0,0,100,0,0] ; % Scenario 1 only. Number of New Animals in each parity (1-5)
                    % Total sum is the number of Infected Cows
% ScenarioWarmUp 2 Parameter (20%= 0.8; 0.7; 0.2; 0.1); 60%= % 0.5,0.5,0.3,0.2)
PercInfected=   0.5; % 0.8; %0.5 ONLY FOR ScenationWarmUp= 2. Percentage of Initial Infected animals (L+Y1+Y2)     
ScenarioPercL=  0.5; %0.7; %0.5 Percentage of Infected Cows that are L
ScenarioPercY1= 0.3; %0.2; %0.3 Percentage of Infected Cows that are Y1
ScenarioPercY2= 0.2; %0.1; %0.2 Percentage of Infected Cows that are Y2
% These values set to 0.
HeiferHoriz= 0;  % Allow Heifer-Heifer Horizontal Transmission
HorTransSusc= 0; % Allow Horizontal Transmission to S (A-A)

% Allow Infection to Progress? Yes/No= 1/0. These are switches.

% MAP Parameters
AdultCalfHoriz= 1; % Allow Horizontal Transmission from Adult to Calf. This is Environment Effect
CalfCalfHoriz= 1; % Calf Calf Horizontal Transmission
%AdultCalfHorizColostrum= 0;

% Vertical Transmission Parameters
VerticalTrans= 1; % Allow for Vertical, In Utero Transmission.
vertical_L=  0.15; % Vh, Vertical Transmission Prob. from Latent Cow to Calf. (Infected Calf prob)
vertical_Y1= 0.15; % Vy1, Vertical Transmission Prob. from Low Shedder Cow to Calf. (Infected Calf prob)
vertical_Y2= 0.17; % Vy2, Vertical Transmission Prob. from High Shedder Cow to Calf. (Infected Calf prob)
ColostrumS= 0; ColostrumL= 0.3; ColostrumY1= 0.3; ColostrumY2= 0.34; % Transmission Prob Through Colostrum 

ScenarioWarmUp= 0; % MAP Yes =1, No = 0
ControlCullTest= 0; % Yes, No. Allow for Elisa and FC Test.
TimetoCull= 60; % Days to cull positive FC test
ControlCullLowMilk= 0; % Yes, No. Cull if milk production is below normal for 90 days. 
LowMilkDays= 60; % Cull after these days of low milk
LowMilkCullNow= 0; % 1 then cull immediate; 0 cull at end of lactation
ControlCullCalvesTest= 1; % Test and Cull Cows, AND its latest calf

DMICost= 0; %MilkCost/0.64; % /.64 to match cost of DMI per lactatin cow.

%milkAdjustmentFactor= 0.8; % 
beta_c= 9.2 ;
ExitRateLtoY1= 0.0018/1.1; % Exit rate
ExitRateY1toY2= 0.000904/1.1;
MilkProdSame= 0; % Make production of Susceptible = Latent
MilkPrice= 0.427-0.286; % 5-yr average:

% Heifer replacent
percBelowHerdLimHeif= 0.0; %if 5% below the size of the herdLimit, make up the difference with outside heifers (to reach back to 5% below the limit)
numDaystoCalveHeif= 90; % Number of days before calving, upper limit, so that these heifes are considered to enter the cow compartment soon. Any difference from these heifers and a deficit of cows is bought.
buyReplHeifers= 0; % Buy replacement heifers
replaceHeifers= 0;
% Tb Parameters

% Infection dynamics: S-O-R-I (Susceptible, Occult, Reactive, Infectious)
% Frequency parameter (bSI/N)

TbInfectionYN= 1; % Include Tb Infection (1/0)
Cow_Calf_Tb= 1; % Allow Horizontal Cow-Calf infection (1 day spent in cow compartment)
ScenarioWarmUpTb= 1; % Change Tb Status of Random Heifers (1/0)
NewHeifTbStatus= 10; % Change Sucep. Heifers to this new Tb Infection status (Cows: 2 O, 3 R, 4 I. Heifer:Occult 10, Reactive 11, Infectious, 12) 
NewCowTbStatus= 2; % Change Sucep. Cows to this new Tb Infection status (Cows: 2 O, 3 R, 4 I. Heifer:Occult 10, Reactive 11, Infectious, 12) 

% Indemnity from culling positive bTB animals
% timeHeifersIndemnityEnter= 0; % Initialization time to include indemnity heifers
IndemPaymentDays= 21; % set Indemnity payments time (and new heifer introduction) in 3 weeks (for avian influenza is 2-3 weeks)
%%%% bTB Tests Parameters

SensitTestbTB= 1.2; % Change in the transmission coefficien B for bTB to do sensitivity test. (+- 20%)
betaTbf= 2.76*SensitTestbTB; % Obtained from Alvarez, and Becky(2013), 2.3 Alvarez
LambdaTb1= 41; % 41 days, av. time spent in infection status (Alvarez
TbexitO= 1/LambdaTb1; % rate of transition from O to R
LambdaTb2= 630; % 21 months (630 days) av. time spent in infection status R (Alvarez)
TbexitR= 1/LambdaTb2; % rate of transition from R to I.

TtTb= 10;       % Testing Turn-Around time (days) (Dressler et al. 2010)
%TimeIntervalTests= 60;  % Testing Interval Tb (days)
MaxNumTBTests= 40; % Maximum number of TB Tests. Set this number to a high value

VetMiles= 50*0.55; % Average number of miles a Vet travels to get to the farm x mile rate
CostTestTb = 7.13; % Cost of Skin Test (CFT and CCT) (Buhr et al., 2009)

%CostPCRTest= 271.25;     % Price of histology, culture and PCR (USAHA, 2004)
CostHistTest= 45; % Histology test per animal (3 tests at 15 each per animal)
CostCultureTest= 80; % Culture test per animal (2 samples at 40 each per animal) 
DisposalCost= 75; % Cost of disposing 
StartTimeTests= 0; % Start Day of WHT (Initialization)
% Sequence is: test CFT, all pos. animals test for CCT

% Parameters for current protocol
previousUSDAProtocol= 0; % 1 if following pre-2009 protocol, 0 if following the new protocol
USDAProtocol= 1; % Current USDA bTB Protocol

% Previous USDA Protocol:
% 8 neg test to release quarantine
% 1-4 tests 60 days apart, 
% 5th tests at least 180 days apart from 4th test
% 6-8 tests at least 12 month apart

NumConsNegWHTRemoval= 2; % Num consecutuve Neg WHT to leave Removal phase 
MaxNumAssuranceTest= 5; 
TimeIntervalAssuranceTests= 360; % This is either 360 or 720
% 3 test every two years, or 5 tests every year. Quarantintrelease, t=lastRemovalday+180,

% MAP Parameters
allsusceptible= 1; % 1 if the herd is all susceptible, 0 Endemic
ScenarioWarmUp= 0; % 0 no infection
ControlCullTest= 0; % Yes, No. Allow for Elisa and FC Test.
ParityTest= 4; % Test this parity up
TimetoCull= 45; % Days to cull positive FC test
ControlCullLowMilk= 0; % Yes, No. Cull if milk production is below normal for 90 days. 
LowMilkDays= 90; % Cull after these days of low milk
LowMilkCullNow= 0; % 1 then cull immediate; 0 cull at end of lactation

%%%% for scenarios TB
TestsSeSp= 1; % Set Specificity and Sensitivity to a percentage of Smith et al.
TBTestControl= 1; % Do TB Test and Control
TimeIntervalTests= 60;  % Testing Interval Tb (days)
NumTbInfHeif= 1; % Number of Infected Heifers
NumNegWHTClear= 2; % Number of consecutive WHT negative in order to be declared TB free (lift quarantine) 
%%%%%%%
%USDAProtocol= 0; % Follow the Tb eradication Protocol of the USDA

%% Average Values of Tests. bTB

% This revised version (Tb_RevisionJDS_v) includes the parameters used by
% the USDA in its protocol simulation. 
% Next are the test Se, Sp (with mode and 95% CI.), and prior distributions used.
% The CCT values are for series testing.
% CFT: Se 84(60,95) Beta(13.97,3.47), Sp 97(72, 99) Beta(12.90,1.36)
% CCT: Se 94(45,99) Beta(5.30,1.30), Sp 99(75, 100) Beta(13.50,1.13)
% Necropsy: Se 87(68,95) Beta(21,4), Sp 70(59, 80) Beta(48,21)
% Histology: Se 96(85,99) Beta(71,4), Sp 81(57, 93) Beta(14,4)

%% USDA
% Beta distribution test parameters 
% CFT test
% 1/0.
USDAparam= 0; % 1 if using the USDA test parameter values, 0 if using Alternative values

if USDAparam== 1 % if using USDA parameter values

SeCFTBetaA= 13.97; SeCFTBetaB= 3.47; 
SpCFTBetaA= 12.90; SpCFTBetaB= 1.36; 
% CCT test
SeCCTBetaA= 5.30; SeCCTBetaB= 1.30; 
SpCCTBetaA= 13.5; SpCCTBetaB= 1.13; 
% Necropsy 
SeNecBetaA= 21; SeNecBetaB= 4; 
SpNecBetaA= 48; SpNecBetaB= 21;
% Histology 
SeHistBetaA= 71; SeHistBetaB= 4; 
SpHistBetaA= 14; SpHistBetaB= 4;
% Culture Test (only sensitivity, it has perfecte specificity)
% 0.74(95%CI: 46,94)
SeCultureBetaA= 9 ; SeCultureBetaB= 3.2 ; % parameters estimated from NunezGarcia et al. (2018)

else % is NOT using the USDA parameters values, use the Alternative values

SeCFTBetaA= 13; SeCFTBetaB= 4.11; 
SpCFTBetaA= 12.90; SpCFTBetaB= 1.36;  
% CCT test
SeCCTBetaA= 8; SeCCTBetaB= 2.67; 
SpCCTBetaA= 4.5; SpCCTBetaB= 1.5; 
% Necropsy 
SeNecBetaA= 3; SeNecBetaB= 2.52; 
SpNecBetaA= 48; SpNecBetaB= 21;
% Histology 
SeHistBetaA= 2.1; SeHistBetaB= 1.37; 
SpHistBetaA= 14; SpHistBetaB= 4;
% Culture Test (only sensitivity, it has perfecte specificity)
% 0.74(95%CI: 46,94)
SeCultureBetaA= 9 ; SeCultureBetaB= 3.2 ; % parameters estimated from NunezGarcia et al. (2018)

end
%% This shound be betatest=1, not perttest.
betatest= 1; % use beta distribution. IT is either betatest= 1 OR perttest= 1.
perttest= 0; % Switch to use PERT distribution, otherwise use AVP. IT is either betatest= 1 OR perttest= 1.

% Use min-mode-max for simulating using PERT distribution (gamma=1, shape param)
% Mode values were estimated in order to arrive at the average values from
% the literature
SpCFTmin= 0.755; SpCFTmode=0.99; SpCFTmax=0.99; % Specificity of CFT
SeCFTmin= 0.632; SeCFTmode=0.851; SeCFTmax=1; % Sensitivity of CFT
SpCCTmin= 0.788; SpCCTmode=1; SpCCTmax=1; % Specificity of CCT
SeCCTmin= 0.750; SeCCTmode=0.966; SeCCTmax=0.995; % Sensitivity of CCT
SePMmin= 0.285; SePMmode=0.52; SePMmax=0.95; % Sensitivity of Regular PostMortem Test
SePCRmin= 0.8; SePCRmode=1; SePCRmax=1; % Sensitivity of Enhanced PostMortem Test

pertgammaSeCFT= 4; pertgammaSeCCT= 4; 
pertgammaSpCFT= 60; % 9 to get the literature values, which gives 3.6% false pos. 50 to get 1.8% FP
pertgammaSpCCT= 60; % 40 to get the literature values, which gives 3.6% false pos. 50 to get 1.8% FP
pertgammaSePCR= 200; pertgammaSePM= 4; 

% Average 
SpCFT= 0.968;   % Specificity of CFT Test, Caudal Fold Test (Becky, 2013) De la Rua-Domenech et al. 2006.
SpCCT= 0.995;   % Specificity of CCT Test, Comparative Cervical Test (Becky, 2013)
SeCFT= 0.839;   % Sensitivity of CFT to Infectious or Reactor cattel (Becky, 2013)
SeCCT= 0.935;   % Sensitivity of CCT to Infectious or Reactor cattel (Becky, 2013)
SePM=  0.55;     % Sensitivity of Post Mortem inspection to Infectious or Reactor to detect Tb
SePCR= 1;       % Sensitivity of Enhanced Post-Mortem inspection to Infectious or Reactor ot detect Tb
allSerial= 0; % Default, use parallel in removal test, phase 1 (Current USDA)  

NumConsNegWHTRemoval= 2; % Num consecutuve Neg WHT to leave Removal phase  
NumNegWHTClear= 8; % OLD Protocol. Number of consecutive WHT negative in order to be declared TB free (lift quarantine) removal + 1 verification + 5 assurance

%%
for scenarioSim= 1:1

if scenarioSim== 1 % 1 bTB
herdLimit= 1000; %
filename=('herd1000Sus.mat'); % Initial herd 
% Tb Parameters
TbInfectionYN= 1; % Include Tb Infection (1/0)
TBTestControl= 1; % Do TB Test and Control (1/0)
TimeIntervalTests= 60;  % Testing Interval Tb (days) at Removal phase
NumTbInfHeif= 1; % Number of Infected Heifers
NumConsNegWHTRemoval= 2; % Num consecutuve Neg WHT to leave Removal phase
MaxNumAssuranceTest= 5; 
end

for jj= 1:MaxSim % Number of Iterations
%%%% Upload the herd matrix (stable) from the directory depending on the
%%%% size of the herd to analyze
%%%% 1000 cow= 'herd1000Sus.mat'
%%%% This herd file has endemic MAP infection.
%filename=('herd1000Sus.mat');

S= load(filename);
herd= S.herd;
clear S 
id= max(herd(:,2)); % Get max ID number in herd

%%% Parameters and variables of the Model

% Cost Parameters %

% Adapted from Jason Karszer's Report (2012)
% cost of newborn calf alive = 150
% Daily costs 
% from 0-28 days (Milk Period)= 6.5
% from 29-439 days (Weaning to Breeding)= 2.6
% from 440- 699 days (Breeding to 21 days before calving)= 2.9
% from 700- 720 days (21 days before calving)= 3.5

% Original values are changed so that the price of the heifer in this model
% matches that of Jason's report. 
% Multiply original costs by 1.159 to obtain the following costs used in
% this model.

% CostMilkCalf= 6.5; % from 0-28 days. 
% CostWeaning= 2.6; % from 29-439 days Baseline, since it is the lowest cost
% CostBreeding= 2.8; % from 440-699 (if pregnant at 440)
% CostCalving= 3.5; % from 700-720 ( 21 days before calving)
% With these values, the average heifer cost up to 720 days is 2.96/day

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COSTS AND INTERVENTIONS

% The initial cost of calf (150)
CostCalf= 150; % Cost of a newborn calf alive (Male or Female), NOT MARKET VALUE. (Karszes,pg 3)

MaleCalfPrice= 150; % Price of a newborn male calf 
FemaleCalfPrice= 250; % Price of a female calf (they are culled once their number pass a limit)
                  % (100 margin)
CulledCowPrice= 660; % Price of a culled cow due unable to get pregnant or over parity. av cull weight: 1600 Lb, at $100/cwt (50% dressing) 
MatureWeight= 600; % Mature Weight of a Pregnant Cow in Kg.
CullCowPriceperKg= 1.1; % estimated from the AMS.USDA Reports
WeightLossY2Perc= 0.10; % weight loss of Y2 compared to non Y2. (10%) 
HeiferReplCost= 2200*1.1; % Costs estimated from Model. (% margin)

managementChanges= 0; % 1/0 if incorporting management changes or interventions.
NewManagementCostperHead= 0; %55/365; % Cost of changing management practices per animal per day
CostInterventionCows= 0;    % Cost of Intervention strategy per Cow PER DAY
CostInterventionHeifers= 0; % Cost of Intervention strategy per Heifer PER DAY
CostInterventionCalves= 0;  % Cost of Intervention strategy per Calf PER DAY

HighShedFeedCostFactorMilkProd= 1.00; % Multiplicative factor in feed cost for high shedders under milk production
HighShedFeedCostFactorNoMilk= 1.00;  % Multiplicative factor in feed cost for high shedders under NO milk production

InsemCost= 20; % USD. Insemination Cost per service (15 Semen + 5 Vet)
PregnancyDiagnosis= 8; % USD. Cost of Pregnancy diagnosis,42-60-220 days after Insemination

FixedVarsCostDay= 2.5; % This is non-feed variable costs and fixed costs per cow per day > 720 days
maxMAPDays= 300; % Maximum number of MAP DAYS for the Milk Produciton Function

irate= 0.05; % Set Yearly discount rate
dailyirate= 1-exp(-irate/365); % Daily discount rate

% Testing variables, Current Protocol USDA
TestingPhase= 0; % Initialize
lastRemovalday= 0; % initialization of time of last removal test
timeHeifersIndemnityEnter= 0; % Initialization time to include indemnity heifers

% TOTAL HERD VARIABLES %

Total_Calves= zeros(T,6); % Store total male and female calves per t, 
Total_Exp= zeros(T,1); % Store total fixed and other costs

% NPV of fales of male calves, and NPV of voluntary culled Calves (over limit)
N_total_Time= zeros(T,24); %zeros(T,21) Store number of infected animals (MAP, Tb)
NumCulledCows= zeros(T,3); 
NumDeath= zeros(T,14);
NPV= zeros(T,8); % NPV of Milk Production, Culled Cows, Male Calves, Female Calves

% Population dynamics
DeadAnimals= zeros(T,14); % Number of culled calves and heifers

% Average Parity and Culling Rate
avParity= zeros(T,2);
% TB Matrices, Initialization of variables
numtestWHT= 0; % Number of WHT Tests
WHTTrigger= zeros(40,12); % Whole Herd Test Matrix: Time, WHT number, WHT positive results (1/0)
Quarantine= 0;
NegWHT= 0; % Numbers of Negative WHT
ConsNegWHT= 0; % Number of consecutive Negative WHT
% USDAProtocol= 1; % Follow the Tb eradication Protocol of the USDA

numPrimInfected= 0; % initialize the number of primary infections.
%numPrimInfectedcalf= 0;

numNewbTB= zeros(1,3); % Store the number of newly infected bTB per day (cows, heifers, calves)  
TBHist= zeros(1,8); % Store all animals not bTB Susceptible: ID, time Occult, time Infective, time death.
% ID, time Occult Calf (2), tICalf (3), tOH (4), tIH (5), tOC (6), tIC (7), time dead    
%% HERD SIMULATION %%
% Time Loop, each day t
tic;
for t= 1:T
if t == 1
rng('shuffle'); % Random seed 'shuffle'  
end

% At the beginning of each day, for each day do the following:

%%% Get variables of the herd population: total animals, and by infection
% level of MAP.
A= accumarray(herd(:,4),1,[9 1])';  % Count instances of S, L, Y1, Y2. 

Si= A(1); % Susceptible Cows
Li= A(2); % Latent Cows
Y1_i= A(3); % Low Shedders
Y2_i= A(4); % High Shedders
CS_i= A(5); % Susceptible Calves
CI_i= A(6); % Infected Calves
HS_i= A(7); % Susceptible Heifers
HI_i= A(8); % Infected Heifers
%%% Tb
ATb= accumarray(herd(:,43),1,[12 1])';  % Count instances of STb, OTb, RTb, ITb (COWS); and CSTb, COTb, CRTb, CITb (Calves);
                                        % HSTb, HOTb, HRTb, HITb
                                        % (Heifers)

STbi=   ATb(1);
OTbi=   ATb(2);
RTbi=   ATb(3);
ITbi=   ATb(4);
CSTbi=  ATb(5); COTbi= ATb(6); CRTbi= ATb(7); CITbi= ATb(8); % Calves
HSTbi=  ATb(9); HOTbi= ATb(10); HRTbi= ATb(11); HITbi= ATb(12); % Heifers

% Total pop, poulation cell, and replacement cell. Used to update
% transmission rate.
N_total= Si+ Li+ Y1_i+ Y2_i; % 1000. Total

N_totalTbCa= CSTbi+ COTbi+ CRTbi+ CITbi; % Number of Calves
N_totalTbH= HSTbi+ HOTbi+ HRTbi+ HITbi; % Number of Heifers

clear A ATb
%%% Tb    
% Group cows depending on their lactation:1 dry, 2 early, 3 mid, 4 late lactation
% early lactation is 0-3 months; mid lactation is 4-6 months; late
% lactation is 7 months - end
% stored in column 42 of herd matrix.

% begin lactation grouping
if groupLact== 1 % if grouping by lactation stage
    herd(herd(:,6)>0 & herd(:,10)==0,42)= 1; % lactation stage 1 if dry (0 DIM)
    herd(herd(:,6)>0 & (herd(:,10)>0 & herd(:,10)<120),42)= 2; % lactation stage 2 if early (0-4mo)
    herd(herd(:,6)>0 & (herd(:,10)>=120 & herd(:,10)<210),42)= 3; % lactation stage 3 if Mid [4-7mo)
    herd(herd(:,6)>0 & (herd(:,10)>=210),42)= 4; % lactation stage 4 if Mid >=7mo

    Y1_i_dry= sum(herd(:,4)==3 & herd(:,42)== 1); % Number of Y1 in Dry lact stage
    Y2_i_dry= sum(herd(:,4)==4 & herd(:,42)== 1); % Number of Y2 in Dry lact stage
    Y1_i_early= sum(herd(:,4)==3 & herd(:,42)== 2); % Number of Y1 in early lact stage
    Y2_i_early= sum(herd(:,4)==4 & herd(:,42)== 2); % Number of Y2 in early lact stage
    Y1_i_mid= sum(herd(:,4)==3 & herd(:,42)== 3); % Number of Y1 in mid lact stage
    Y2_i_mid= sum(herd(:,4)==4 & herd(:,42)== 3); % Number of Y2 in mid lact stage
    Y1_i_late= sum(herd(:,4)==3 & herd(:,42)== 4); % Number of Y1 in late lact stage
    Y2_i_late= sum(herd(:,4)==4 & herd(:,42)== 4); % Number of Y2 in late lact stage
    L= accumarray(herd(herd(:,42)>0,42),1,[4 1])'; % count the number of cows in each lactation stage 1-4
end
%%% Using the herd infection data, estimate the Infection Probability
%%% per day. Make it 0 for No Externality case.

% Infection Probabilities
% Inf adult-adult (horizontal) fecal-oral for Susceptible only. The
% other infection status only have progression probabilities.
% Tb
% Force of Infection of Tb for COWS, CALVES, AND HEIFERS (Frequency
% Estimate) 
   if groupLact==0 % if group all cows into one group
        if N_total== 0 % Make sure result is not NAN.
            STb_Inf= 0; % Tb
         else
        STb_Inf= 1-exp(-betaTbf*(ITbi/N_total)/365);  % Daily Prob of Tb Infection COWS. Used to simulate calves infection from cows 
        end
   else % group cows by lactation stage
        % estimate bTB infection rate by lactation stage
        % Dry cows
        if L(1)== 0 % Make sure there is no NAN, dry period.
            STb_Inf_dry= 0;   
        else % if there are cows in dry stage
            ITbi_dry= sum(herd(:,43)==4 & herd(:,42)==1);
            STb_Inf_dry= 1-exp(-betaTbf*(ITbi_dry/L(1))/365); % Daily Prob of Tb Infection COWS. Used to simulate calves infection from cows 
        end

        if L(2)== 0 % Make sure there is no NAN, early lactation.
            STb_Inf_early= 0; % Tb 
        else % if there are cows in early lactation
            ITbi_early= sum(herd(:,43)==4 & herd(:,42)==2);
            STb_Inf_early= 1-exp(-betaTbf*(ITbi_early/L(2))/365); % Daily Prob of Tb Infection COWS. Used to simulate calves infection from cows
        end

        if L(3)== 0 % Make sure there is no NAN, mid lactation.
            STb_Inf_mid= 0;
        else % if there are cows in mid lactation
            ITbi_mid= sum(herd(:,43)==4 & herd(:,42)==3);
            STb_Inf_mid= 1-exp(-betaTbf*(ITbi_mid/L(3))/365); % Daily Prob of Tb Infection COWS. Used to simulate calves infection from cows                
        end

        if L(4)== 0 % Make sure there is no NAN, late lactation.
            STb_Inf_late= 0;
        else % if there are cows in late lactation
            ITbi_late= sum(herd(:,43)==4 & herd(:,42)==4);
            STb_Inf_late= 1-exp(-betaTbf*(ITbi_late/L(4))/365)    ; % Daily Prob of Tb Infection COWS. Used to simulate calves infection from cows           
        end        
   end
% All transmission probabilitites by lactation status are now estimated.

    if N_totalTbCa==0
        STbCa_Inf= 0; 
    else
        STbCa_Inf= 1-exp(-betaTbf*(CITbi/N_totalTbCa)/365); % Daily Prob of Tb Infection Calves
    end

    if N_totalTbH==0
        STbH_Inf= 0;
    else
        STbH_Inf= 1-exp(-betaTbf*(HITbi/N_totalTbH)/365); % Daily Prob of Tb Infection Heifers
    end

% Matrix to store number of animals in each infection status, per day.
N_total_Time(t,:)= [N_total, Si, Li, Y1_i, Y2_i, CS_i, CI_i, HS_i, HI_i, ...
    STbi,OTbi,RTbi,ITbi,CSTbi,COTbi,CRTbi,CITbi,HSTbi,HOTbi,HRTbi,HITbi,0,0,0];


%%%% Count the number of infected calves per day.
Num_pregnant= 0;
num_male= 0; % Counter of number of Male Calves born
num_calf= 0; % Counter of number of Female Calves born
Num_Heifers= 0; % Counter of number of Heifers
calf_S= 0; % Counter of number of calves born from Susceptible Cows
calf_L= 0; % Counter of number of calves born from Latent Cows
calf_Y1= 0; calf_Y2= 0; % counter of num of calves born from Y1 and Y2
Inf_Heifer= 0; % Num of Horizontally infected Heifers
Num_InfCalves= 0; % Num of Horizontally infected calves
non_pregnant= 0; % Counter of non-pregnancies 
TransS_L= 0; % Number of Newly infected cows (from Susceptible to Latent)
TransL_Y1= 0; % Progression of the Infection from L to Y1
TransY1_Y2= 0; % Progression of the Infection from Y1 to Y2
vertC_L= 0; vertC_Y1= 0; vertC_Y2= 0; % Number of Vertically infected calves, and infection status of cow.
hori_calf= 0; % Number of Horizontally Infected calves 

%%% Start Herd Loop %%%
for  i= 1:size(herd,1) % Beginning of Herd Loop

%%%% For each animal in the herd, do the following:

     %%% 1. Update t and age
     herd(i,1)= t; % update time   
     herd(i,3)= herd(i,3)+ 1; % update age. Age = Age + 1

%%% 2.1. Run Dead Function, or natural culling probability,
% and eliminate the dead from herd matrix at the end of the herd loop.
% Natural Culling for COWS. Using MAP status. It does not affect bTB
% model. We use MAP status since the bTB model was built from the MAP model. 
% 1 Susceptible (S), 2 Latent(L), 3 Low Shedder(Y1), 
% 4 High Shedder(Y2), 5 Susceptible Calf(SC), 6 Infected Calf(IC), 
% 7 Susceptible Heifer(SH), 8 Infected Heifer (IH)

    if herd(i,4)== 1 || herd(i,4)== 2 || herd(i,4)== 3 || herd(i,4)== 4
        x= rand; % Get a random number U[0,1] Involuntary culling
        death_prob= nat_cull_prob(herd(i,6),factorcull); %nat_cull_prob_same; %nat_cull_prob(herd(i,6)); % Same Probability to all Parities
            if  x <= death_prob %natCullCow % if the random draw is < natural cull prob
            herd(i,15)= 1; % Nat. Culling indicator in the herd matrix
            end   

    % If Calves. Infection Status is 5,6 (SC,IC)    
    elseif herd(i,4)== 5 || herd(i,4)== 6 % if herd(i,3) is calf
        x= rand; % Get a random number U[0,1]
        if x<= NatCullProbCalves %
            herd(i,15)= 2; % Nat. Culling indicator in the herd matrix 
        end

    % If Heifers. Infection Status is 7,8 (SH,IH)
    elseif herd(i,4)== 7 || herd(i,4)== 8 % if herd(i,3) is heifer
        x= rand; % Get a random number U[0,1]
        if  x<= NatCullProbHeifers %
            herd(i,15)= 3; % Nat. Culling indicator in the herd matrix
        end % end of if x< NatCullProbHeifers

    end % end of if herd(i,4)== 1, etc... 
% Dead animals exit herd loop here
%%%% Natural Culling is Done
%%%%% Tb Infection Estimation, and Infection Progression Process
    if TbInfectionYN== 1 % If allow for Tb Infection
        % Cows 
        TbS_O= 0; TbO_R= 0; TbR_I= 0;
        infected= 0;
        if herd(i,43)== 1 % TbS, if susceptible
            if groupLact==0 % if no lactation stage groups
                 [TbS_O, infected]= Tbinfection_chanceS_O(STb_Inf,herd(i,43)); % TbS_O = (1,2)
                 herd(i,43)= TbS_O; % TbS_O =(1,2)
                    if infected== 1
                       N_total_Time(t,22)= N_total_Time(t,22)+1; 
                       numNewbTB(1,1)= numNewbTB(1,1) +1; % Count newly infected animals per day.
                        if ~ismember(herd(i,2), TBHist(:,1)) % Initially infected heifers will be store in TBHist
                            TBHist(end+1,:)= [herd(i,2), 0,0,0,0,herd(i,1)-1,0,0] ; % Matrix for bTB inf. animals id, time S, time I, timeDeath 
                        end

                    end
            elseif herd(i,42)== 1 % Dry. If separated by feeding groups
                 [TbS_O, infected]= Tbinfection_chanceS_O(STb_Inf_dry,herd(i,43)); % TbS_O = (1,2)
                 herd(i,43)= TbS_O; % TbS_O =(1,2)
                    if infected== 1
                       N_total_Time(t,22)= N_total_Time(t,22)+1; 
                       numNewbTB(1,1)= numNewbTB(1,1) +1; % Count newly infected animals per day.
                        if ~ismember(herd(i,2), TBHist(:,1)) % Initially infected heifers will be store in TBHist
                            TBHist(end+1,:)= [herd(i,2), 0,0,0,0,herd(i,1)-1,0,0] ; % Matrix for bTB inf. animals id, time S, time I, timeDeath 
                        end
                    end
            elseif herd(i,42)== 2 % Early Lactation
                 [TbS_O, infected]= Tbinfection_chanceS_O(STb_Inf_early,herd(i,43)); % TbS_O = (1,2)
                 herd(i,43)= TbS_O; % TbS_O =(1,2)
                    if infected== 1
                       N_total_Time(t,22)= N_total_Time(t,22)+1; 
                       numNewbTB(1,1)= numNewbTB(1,1) +1; % Count newly infected animals per day.
                        if ~ismember(herd(i,2), TBHist(:,1)) % Initially infected heifers will be store in TBHist
                            TBHist(end+1,:)= [herd(i,2), 0,0,0,0,herd(i,1)-1,0,0] ; % Matrix for bTB inf. animals id, time S, time I, timeDeath 
                        end
                    end
            elseif herd(i,42)== 3 % Mid Lactation
                 [TbS_O, infected]= Tbinfection_chanceS_O(STb_Inf_mid,herd(i,43)); % TbS_O = (1,2)
                 herd(i,43)= TbS_O; % TbS_O =(1,2)
                    if infected== 1
                       N_total_Time(t,22)= N_total_Time(t,22)+1; 
                       numNewbTB(1,1)= numNewbTB(1,1) +1; % Count newly infected animals per day.
                        if ~ismember(herd(i,2), TBHist(:,1)) % Initially infected heifers will be store in TBHist
                            TBHist(end+1,:)= [herd(i,2), 0,0,0,0,herd(i,1)-1,0,0] ; % Matrix for bTB inf. animals id, time S, time I, timeDeath 
                        end 
                    end            
            elseif herd(i,42)== 4 % Late Lactation
                 [TbS_O, infected]= Tbinfection_chanceS_O(STb_Inf_late,herd(i,43)); % TbS_O = (1,2)
                 herd(i,43)= TbS_O; % TbS_O =(1,2)
                    if infected== 1
                       N_total_Time(t,22)= N_total_Time(t,22)+1; 
                       numNewbTB(1,1)= numNewbTB(1,1) +1; % Count newly infected animals per day.
                        if ~ismember(herd(i,2), TBHist(:,1)) % Initially infected heifers will be store in TBHist
                            TBHist(end+1,:)= [herd(i,2), 0,0,0,0,herd(i,1)-1,0,0] ; % Matrix for bTB inf. animals id, time S, time I, timeDeath 
                        end
                    end
            end

        elseif herd(i,43)== 2 % TbO, If Occult Tb Infection

                 [TbO_R]= TbOexit(TbexitO,herd(i,43)); % TbO_R = (2,3)
                 herd(i,43)= TbO_R; % TbO_R =(2,3)                               

        elseif herd(i,43)== 3 % TbR, If Reactive Tb Infection

                 [TbR_I,infected]= TbRexit(TbexitR,herd(i,43)); % TbR_I = (3,4)
                 herd(i,43)= TbR_I; % TbR_I =(3,4)
                    if infected==1 && ismember(herd(i,2), TBHist(:,1)) % Store time it became I
                        [~,locb]= ismember(herd(i,2), TBHist(:,1));    
                        TBHist(locb,7)= herd(i,1)-1 ; % time becoming I cow
                    end           
        elseif herd(i,43)== 4 % TbI, If Infective Tb Cow, Do Nothing
            %%%% Calves
        elseif herd(i,43)== 5 % Calves TbS_O Susceptible. Calves get infected by spending time with cows and with other calves
            % estimate horizontal Tb infection, calf to calf               
                 [TbS_O, infected]= Tbinfection_chanceS_O(STbCa_Inf,herd(i,43)); % TbS_O = (5,6)
                 herd(i,43)= TbS_O; % TbS_O =(5,6)
                 if infected== 1
                    N_total_Time(t,24)= N_total_Time(t,24)+1; 
                    numNewbTB(1,3)= numNewbTB(1,3) +1; % Count newly infected calves per day.
                    if ~ismember(herd(i,2), TBHist(:,1)) % Initially infected heifers will be store in TBHist
                        TBHist(end+1,:)= [herd(i,2), herd(i,1)-1,0,0,0,0,0,0] ; % Matrix for bTB inf. animals id, time S, time I, timeDeath 
                    end
                end
            if herd(i,3)>= 60 && infected ==1 % if 60 days old or more, become Heifer
               herd(i,43)= 10; % Change to Tb Occult Heifers, 10.

            elseif herd(i,3)>= 60 && infected ==0  % if younger than 60 days old
                herd(i,43)= 9; % Change to Tb Susceptible Heifers, 9.
            end % end of Tb infection among calves Susceptible

        elseif herd(i,43)== 6 % TbO, If Occult Tb Infection in Calves
                if ~ismember(herd(i,2), TBHist(:,1)) % If not recorded because infected via its dam
                    TBHist(end+1,:)= [herd(i,2), herd(i,1)-1,0,0,0,0,0,0] ; % Matrix for bTB inf. animals id, time S, time I, timeDeath 
                end
            if herd(i,3)>= 60 % if 60 days old or more, become Heifer
               herd(i,43)= 10; % Change to Tb Occult Heifers, 10.
               if ~ismember(herd(i,2), TBHist(:,1)) % If not recorded because infected via its dam
                    TBHist(end+1,:)= [herd(i,2), 0,0,herd(i,1)-1,0,0,0,0] ; % Matrix for bTB inf. animals id, time S, time I, timeDeath 
               end

            else % if younger than 60 days old
                 % estimate occult to reactive prob.             
                 [TbO_R]= TbOexit(TbexitO,herd(i,43)); % TbO_R = (6,7)
                 herd(i,43)= TbO_R; % TbO_R =(6,7)          
            end % end of Tb infection among calves Occult

        elseif herd(i,43)== 7 % TbR, If Rreactive Tb Infection
            % estimate reactive to infective probability
                 [TbR_I,infected]= TbRexit(TbexitR,herd(i,43)); % TbR_I = (7,8)
                 herd(i,43)= TbR_I; % TbR_I =(7,8)
                    if infected==1 && ismember(herd(i,2), TBHist(:,1)) % Store time it became I
                        [~,locb]= ismember(herd(i,2), TBHist(:,1));    
                        TBHist(locb,3)= herd(i,1)-1 ; % time Infective calf 
                    end
            if herd(i,3)>= 60 % if 60 days old or more, become Heifer
                    if infected==1 
                       herd(i,43)= 12; % Change to Tb Infective Heifers, 11.    
                        if ismember(herd(i,2), TBHist(:,1)) % Store time it became I
                        [~,locb]= ismember(herd(i,2), TBHist(:,1));    
                        TBHist(locb,5)= herd(i,1)-1 ; % time Infective Heifer
                        end
                    else % If not infected (still Reactive)
                       herd(i,43)= 11; % Change to Tb Reactive Heifers, 11.
                    end                     

            end % end of Tb infection among calves Reactives

        elseif herd(i,43)== 8 % TbI, If Infective calf, Do Nothing                     
            if herd(i,3)>= 60 % if 60 days old or more, become Heifer
               herd(i,43)= 12; % Change to Tb Infective Heifers, 12.

                if ismember(herd(i,2), TBHist(:,1)) % Store time it became I
                    [~,locb]= ismember(herd(i,2), TBHist(:,1));    
                    TBHist(locb,5)= herd(i,1)-1 ; % time Infective Heifer
                end
            end % end of Tb infection among calves Occult
%%%%% Heifers          
        elseif herd(i,43)== 9 % Heifers TbS_O

             [TbS_O, infected]= Tbinfection_chanceS_O(STbH_Inf,herd(i,43)); % TbS_O = (9,10)
             herd(i,43)= TbS_O; % TbS_O =(9,10)
                    if infected== 1
                        N_total_Time(t,23)= N_total_Time(t,23)+1;
                        numNewbTB(1,2)= numNewbTB(1,2) +1; % Count newly infected heifers per day.
                        if ~ismember(herd(i,2), TBHist(:,1)) % Initially infected heifers will be store in TBHist
                            TBHist(end+1,:)= [herd(i,2),0,0,herd(i,1)-1,0,0,0,0] ; % Matrix for bTB inf. animals id, time S, time I, timeDeath 
                        end   
                    end
            if herd(i,8)== 280  % if giving birth now, becomes Cow
               if herd(i,43)== 9  % If Sus Heifer become Susc Cow
                herd(i,43)= 1; % Change to Susceptible Cow, 1.
               elseif herd(i,43)== 10 % if Occult Heifer, Occult Cow
                herd(i,43)= 2;  % Change to Occult Cow 
               end

            end % end of Tb infection among Heifers Susceptible

        elseif herd(i,43)== 10 % Heifer TbO, If Occult Tb Infection
             [TbO_R]= TbOexit(TbexitO,herd(i,43)); % TbO_R = (10,11)
             herd(i,43)= TbO_R; % TbO_R =(10,11)

             if ~ismember(herd(i,2), TBHist(:,1)) % Initially infected heifers will be store in TBHist
                  TBHist(end+1,:)= [herd(i,2),0,0,herd(i,1)-1,0,0,0,0] ; % Matrix for bTB inf. animals id, time S, time I, timeDeath 
             end
           if herd(i,8)== 280 % if giving birth now, becomes Cow
               if herd(i,43)== 10 % If Occult Heifer, Occult Cow
                herd(i,43)= 2; % Change to Tb Occult Cow, 2.
               elseif herd(i,43)== 11 % if Reactive Heifer, Reactive Cow
                herd(i,43)= 3;  % Change to Tb Reactive Cow, 3.
               end

           end % end of Tb infection among Heifers Occult

         elseif herd(i,43)== 11 % TbR, If Rreactive Tb Infection

             [TbR_I, infected]= TbRexit(TbexitR,herd(i,43)); % TbR_I = (11,12)
             herd(i,43)= TbR_I; % TbR_I =(11,12)
                if infected==1 && ismember(herd(i,2), TBHist(:,1)) % Initially infected heifers will be store in TBHist
                    [~,locb]= ismember(herd(i,2), TBHist(:,1));    
                    TBHist(locb,5)= herd(i,1)-1 ; % time Infective Heifer
                end

           if herd(i,8)== 280 % if giving birth now, becomes Cow
               if herd(i,43)== 11 % If Reactive Heifer, Reactive Cow
                herd(i,43)= 3; % Change to Tb Reactive Cow, 3.
               elseif herd(i,43)== 12 % if Infective Heifer, Infective Cow
                herd(i,43)= 4;  % Change to Tb Infectious Cow, 4.
                if ismember(herd(i,2), TBHist(:,1)) % Initially infected heifers will be store in TBHist
                    [~,locb]= ismember(herd(i,2), TBHist(:,1));    
                    TBHist(locb,7)= herd(i,1)-1 ; % time Infective Cow
                end
               end

           end % end of Tb infection among Heifers Reactive

        elseif herd(i,43)== 12 % TbI, If Infective Tb, Do Nothing          
            if herd(i,8)== 280 % if giving birth now, becomes Cow
               herd(i,43)= 4; % If Infective Heifer, Infective Cow
                if ismember(herd(i,2), TBHist(:,1)) % Initially infected heifers will be store in TBHist
                    [~,locb]= ismember(herd(i,2), TBHist(:,1));    
                    TBHist(locb,7)= herd(i,1)-1 ; % time Infective Cow
                end 
           end % end of Tb infection among Heifers Occult
        end
    end

    %%% Estimate Days in new Tb infection level.   
     if TbInfectionYN== 1
        if herd(i,43)==2 || herd(i,43)==3 || herd(i,43)==4 || herd(i,43)==6 ...
                || herd(i,43)==7 || herd(i,43)==8 || herd(i,43)==10 || herd(i,43)==11 ...
                || herd(i,43)==12

            herd(i,34)= herd(i,34)+1; % If Tb infected, increase Tb days by 1.
        end
        if  TbS_O== 2 || TbS_O==6 || TbS_O==10 || TbO_R== 3 || TbO_R== 7 || TbO_R== 11 ...
                || TbR_I== 4 || TbR_I== 8 || TbR_I== 12 % if change to new infection level
            herd(i,34)= 1; % save the day of changing infection level   MAPDays     

        end
     end
%%%%%%%%%%%%% End Tb Infection Process
% At this point, all animals went through the infection and natural death algorithm
% Next, do the lactation algorithm.
% Check if Pregnant and Calving, and create new instance of HERD for the calf.
    if herd(i,5)== 2 % If Pregnant or Calving now
          if herd(i,8)== 280 % Calving now!
              % randomly select gender of the calf 1= male, 2= female
              gen= randi(2,1); % random integer [1,2]
              if gen== 1 % If male calf
                  num_male= num_male + 1; % count number of male calves
              else % if not male, or female
                  num_calf= num_calf +1; % Count number of female calves
                  id= id+1; % increase the number of ID, assign it to this calf
                  herd(i,33)= id; % calf ID in cow's data
            inf_calf_Tb= 5; % All calves are born uninfected
            if Cow_Calf_Tb== 1 % If horizontal Tb Infection allowed
                x= rand;
                if groupLact==0 % if no lactation stage grouping
                    cow_calf_Tb= STb_Inf;
                else
                    cow_calf_Tb= STb_Inf_dry;
                end
                if  x<= cow_calf_Tb % Prob of infection for COWS, since in Cow compartment 
                    inf_calf_Tb= 6; % Occult Tb Infection Calf
                    N_total_Time(t,24)= N_total_Time(t,24)+1;
                    %numPrimInfectedcalf= numPrimInfectedcalf +1;
                end
            end
age= 0;
par= 0;
lac_status= 0;
par_age= 0;
preg_days= 0;
dim= 0; 
momID= herd(i,2); % Id of the cow of the newborn calf
     % Place the female calves in the Herd Matrix (end of the matrix)
     % CALVES. All Newborn Calves are Tb Susceptible (5), unless
     % infected at birth
herd(end+1,:)= [t,id,age,infect_calf,lac_status,par,par_age,preg_days,0,dim,zeros(1,30),momID,0,inf_calf_Tb];
clear age par lac_status par_age preg_days days_left_calving exp_calving_date dim momID

          end % end calf information conditional statements 
                % Update Cow's State after calving                  
                herd(i,5)= 3; % Lactation Status set to VWP (= 3)               
                herd(i,6)= herd(i,6)+ 1; % Update Parity Number 
                herd(i,7)= herd(i,3); % Update the Parity Age. This is the reference age to inseminate
                herd(i,8)= 0; % Pregnancy Days= 0, 
                herd(i,10)= 0; % Days in Milk set to 0, since it has just calved

        if herd(i,4)== 7 % If susceptible heifer
            herd(i,4)= 1; % Becomes Susceptible Cow
            elseif herd(i,4)== 8 % If Infected Heifer
          herd(i,4)= 2; %Becomes Occult Cow

        end       

          else % when pregnant BUT not calving now
              herd(i,8)= herd(i,8)+1; % Pregnancy Days + 1

              if herd(i,6)>0 && herd(i,8)>0 && herd(i,8)<220 % Pregnant not heifer, and not at Dry period
                  herd(i,10)= herd(i,10)+1; % Increase DIM by 1
              elseif herd(i,6)>0 && herd(i,8)>= 220 % if at Dry Period
                  herd(i,10)= 0; % Do not milk
              end

          end % end conditional stat. on calving now (pregnant days)

    elseif herd(i,5)== 3 && herd(i,6)> 0% If VWP
           herd(i,10)= herd(i,10)+1; % Increase DIM by 1

        if herd(i,3)== herd(i,7)+60 % if over the 60 days or VWP
            herd(i,5)= 1; % change status from VWP to ready to inseminate (1)
        end % end of conditional to exit VWP

     % Inseminate cows that are under maximum parity
    elseif herd(i,5)== 1 && herd(i,7)>= MaxParity && (herd(i,4) ~= 7 && herd(i,4) ~= 8) % if ready to be inseminated. Not Heifers, nor cows that will be culled  
        if herd(i,31)== 0 % IF cow is not going to be culled

        % INSEMINATION OF COWS
        % Inseminate at the end of VWP and every 21 days after it

        if  herd(i,3)== herd(i,7)+61 || herd(i,3)==herd(i,7)+ 82 || herd(i,3)==herd(i,7)+ 103 || ...
              herd(i,3)==herd(i,7)+ 124 || herd(i,3)==herd(i,7)+ 145 || herd(i,3)==herd(i,7)+ 166 ...
              || herd(i,3)==herd(i,7)+ 187 || herd(i,3)==herd(i,7)+ 208 || herd(i,3)==herd(i,7)+ 229 ...
              || herd(i,3)==herd(i,7)+ 250 || herd(i,3)==herd(i,7)+ 271 || herd(i,3)==herd(i,7)+ 292

            par_status= herd(i,6); % Parity number
            days_in_milk= herd(i,10); % DIM
            prob_preg= prob_insi_suc70(par_status,prob_pregInput,annualProb,AIattempts,MaxParity); % Function to estimate AI Success Prob.
             x= rand; % random number
             herd(i,18)= herd(i,1); % Time of AI 
             if herd(i,4)== 4 % If High Shedder, derease Pregnancy rate by PregRateDecreaseY2
                 factorPregY2= PregRateDecreaseY2; 
             else
                 factorPregY2= 1;
             end
                    if x < prob_preg *factorPregY2 %Probability of being Pregnant
                        % Pregnant!
                        herd(i,5)= 2; % Change Lact Status to Pregnant = 2
                        herd(i,8)= 0; % First day of pregnancy
                        Num_pregnant= Num_pregnant+ 1; 
                        herd(i,9)= 0; % reset number of unsuccesful AI
                        herd(i,19)= 1; % Pregnant Today
                        herd(i,24)= herd(i,24)+ InsemCost; % Add cost or AI
                    else                       
                        % if not pregnant
                        herd(i,9)= herd(i,9)+ 1; % Number of unsuccesful AI. 
                        non_pregnant= non_pregnant+1;
                        herd(i,24)= herd(i,24)+ InsemCost; % Add cost or AI

                    end
        end % end of insemination attempts

        elseif herd(i,31)==1 % cull cow after lactation
            if herd(i,6)>0 % If parity > 0
                  herd(i,10)= herd(i,10)+ 1; % Increase DIM by 1

            end
        end 
   end % end conditional statements on pregnant or calving
%%% If Susceptible Calves %%% MAP
         if herd(i,4)== 5 % Susceptible calf (SC)
            if herd(i,3)>= 60 % if 60 days old or more, become Heifer
                Num_Heifers= Num_Heifers + 1; % Increase the number of New heifers
                herd(i,4)= 7; % Change to Susceptible Heifers, 7.
            else % if younger than 60 days old   
            end % Calf age conditionals

         %%% If Susceptible Heifers %%%   
         elseif herd(i,4)== 7 % If Susceptible Heifer (SH)

            if herd(i,3)>= 440 && herd(i,5)~= 2  
                herd(i,5)= 1; % Ready to be inseminated
                herd(i,30)= 3; % 3= no change from genetic differences
            end

            % Inseminate if age== 440
            if herd(i,5)== 1 && (herd(i,3)== 440 || herd(i,3)== 461 || herd(i,3)== 482 || ...
                    herd(i,3)== 503 || herd(i,3)== 524 || herd(i,3)== 545 ...
                    || herd(i,3)== 566 || herd(i,3)== 587 || herd(i,3)== 608 || herd(i,3)== 629 || herd(i,3)==750 || herd(i,3)==771) 

                herd(i,6)= 0; % Parity to 0, becomes 1 AFTER it calves or becomes pregnant.
                par_status= 0; 
                days_in_milk= 0; % DIM         
                prob_preg= prob_insi_suc70(par_status,prob_pregInput,annualProb,AIattempts,MaxParity);
                x= rand;
                herd(i,18)= herd(i,1); % Time of AI
                if x<= prob_preg % per day probability of being PREGNANT for 1000 animals, the parameter was found by trial and error process for different parity, as there is insufficient data 
                    % Pregnant!
                    herd(i,5)= 2; % Change status to Pregnant
                    herd(i,6)= 0; % Parity 0, become 1 after it calves
                    herd(i,8)= 0; % First day of pregnancy
                    Num_pregnant= Num_pregnant+ 1; % count numner of pregnancies
                    herd(i,9)= 0; % Reset counter of unsuccesful AI
                    herd(i,19)= 1; % Pregnant Today
                    herd(i,24)= herd(i,24)+ InsemCost; % Add cost or AI
                else % If not pregnant
                    herd(i,8)= 0; % First day of pregnancy
                    herd(i,9)= herd(i,9)+ 1; % Number of unsuccesful AI. 
                    non_pregnant= non_pregnant+1;
                    herd(i,24)= herd(i,24)+ InsemCost; % Add cost or AI
                end % end of pregnancy function
            end % end of heifer insemination conditinal
         end % end Calves and Heifers Conditionals
 %%%%%%%%%%%%%%%%%%%%%%%%%%%

         % If Max Par and ready to be inseminated or in VWP. (not
         % pregnant)
          if  herd(i,6)== MaxParity && (herd(i,5)==1 || herd(i,5)==3) %herd(i,8)>=220 % if number of Parity > Max
             herd(i,15)= 5; % OverParity, Cull the animal in the next iteration
          end

       %%% Diagnosis of Pregnancy. Add number of unsuccessful inseminationa OR add cost of Diagnosis. 
       %%% Do this at 42, 60 AND 220 days afte AI. IF not pregnant,
       %%% keep on AI until pregnant, then test if pregnancy is going
       %%% well.
        if herd(i,5)==2 && (herd(i,1)== herd(i,18)+42 || herd(i,1)== herd(i,18)+60 || herd(i,1)== herd(i,18)+220)  % If 42, 60 or 220 days after AI AND Pregnant
           herd(i,24)= herd(i,24)+ PregnancyDiagnosis; % Add cost of pregnancy diagnosis

        end
         %%% Cull if Open Cows %%%
         if herd(i,9)>= AIattempts && herd(i,20)==0 % If over AI attempts and not yet set to be culled
             herd(i,20)= herd(i,1) + 21; % Cull 21 days later, after finding out it is not pregnant.
         end
         % Cull if time for culling has arrived

         if herd(i,1)== herd(i,20) % cull after it is diagnosed not pregnant
             herd(i,15)= 4; % Open Cow, Cull the animal in the next iteration
         end
%% Milk Production Function %%%%%%%
% MODIFY MILK PRODUCTION FOR Tb INFECTED COWS%%%%
        if (herd(i,4)== 1 || herd(i,4)== 2 || herd(i,4)== 3 || herd(i,4)== 4) % Estimate Milk Production for Cows
            if  herd(i,10)> 0 % if DIM > 0
                if herd(i,4)~= 1 && herd(i,11)>maxMAPDays% Truncate the value of Days in Current Infection Status to 150,300, 600, otherwise Milk Yield is < 0, or too low.
                    MAPTime= ceil(maxMAPDays/30); % number of months in current infection status, otherwise Y2 prod < 0
                elseif herd(i,4)~= 1 && herd(i,11)<=maxMAPDays % MAP Days 300, gives a max loss for Y2 of 31%/year, and max of 37%/day .
                    MAPTime= ceil(herd(i,11)/30); % number of months in current infection status
                else 
                    MAPTime= 0; % for Susceptible cows
                end
            par_status= herd(i,6); % Parity number
            days_in_milk= herd(i,10); % DIM

            Season= season(t); % estimate season
            LS= 3.5 ; % Log somatic cell score, 

            % Make Latent Cows Susceptible for Milk Production 
                if MilkProdSame==1 && herd(i,4)== 2 % Change it to S if L
                MAPStatus= 1;
                else 
                MAPStatus= herd(i,4); % 
                end

            MilkGenetics= herd(i,30); % Milk Production Genetics                
            milk= Milk_ProductionMAPHS(par_status, days_in_milk, ... 
            Season, LS, MAPStatus, MAPTime, MilkGenetics) ;
            herd(i,12)= milk;
            else
                herd(i,12)= 0;
            end
        end
%%%%%% COST AND MILK REVENUE ESTIMATION
        if herd(i,10) > 0 
               herd(i,14)= herd(i,12) * MilkPrice; % Milk Revenue

        elseif herd(i,10)== 0 && (herd(i,4)== 1 || herd(i,4)== 2 || ...
               herd(i,4)== 3 || herd(i,4)==4) % Cows Not Producing Milk
               %herd(i,13)= herd(i,13)+ FeedCostDryCow; % Maintenance Feed Cost
               herd(i,14)= 0; % No Milk Revenue
        end       
%%% Body Weight in Kg
par_status= herd(i,6); % Parity number
Age= herd(i,3); % Age in days
Preg= herd(i,8); % Pregnant Days
dim= herd(i,10); % Days in Milk
milk= herd(i,12); % Milk production
[BWt]= BW(dim,milk,Preg,Age,par_status,MatureWeight);  % This accounts for pregnancy/
herd(i,21)=BWt; % This is the weight without the fetus weight, to estimate carcass value

%%% Estimate DMI      
WOL= ceil(dim/7); % Weeks on Milk. Start in week 1.
[dmi]=Dmi_Cow(BWt,milk,WOL,par_status);
herd(i,22)= dmi; % save dmi in herd matrix


%%% Estimate Daily Feed Cost
herd(i,23)= herd(i,22)*DMICost; % Daily Feed Costs in Kg/day

%%% Total Var+Fixed Costs for Cows and Heifers
[NonFeedCosts]=VarsFixedCosts(Age,FixedVarsCostDay,CostCalf,par_status);
herd(i,24)= NonFeedCosts; % Sum of Non feed variable costs plus fixed costs. 

        if herd(i,4)== 4 
            if  herd(i,10)>0 % If High Shedders AND Producing Milk, add extra feed cost
                herd(i,23)= herd(i,23)*HighShedFeedCostFactorMilkProd; % Factor that increases feed intake for same milk production (decrease in metabolic efficiency)
            else
                herd(i,23)= herd(i,23)*HighShedFeedCostFactorNoMilk; % Factor that increases feed intake while dry (decrease in metabolic efficiency)
            end
        end       
herd(i,13)= 0;  % Make sure costs are not accumulating, set to zero before adding new ones  
end %%% End of the Herd Loop %%%%

%%% Voluntary Culling for cows if above herd size limit

if VoluntCullOption== 1 % 
% Cull oldest cows above 1000
numCows= sum(herd(:,4)== 1 | herd(:,4)== 2 | herd(:,4)== 3 | herd(:,4)== 4); % Number of Cows

    if numCows >  herdLimit && allsusceptible== 0 % if number of cows is greater than the capacity of the herd AND MAP 
        IdAgeC= herd((herd(:,4)==1 | herd(:,4)== 2 | herd(:,4)== 3 | herd(:,4)== 4), [2, 3, 4, 10, 11, 8, 9]); 
        IdAgeC(:,[8 9 10])= zeros(size(IdAgeC,1),3); % add three more columns       
        IdAgeC(IdAgeC(:,5)>=IdAgeC(:,4),8)= 1; % Indicator if MAP Days >= DIM, column 7.   
        IdAgeC(IdAgeC(:,8)==1,9)= IdAgeC(IdAgeC(:,8)==1,4); % If MAP Days >= DIM, place DIM in col. 8 
        IdAgeC(IdAgeC(:,8)==0,9)= IdAgeC(IdAgeC(:,8)== 0,5); % If DIM> MAP Days, place MAP Days in col. 8
        IdAgeC((IdAgeC(:,9)>=1 & IdAgeC(:,3)==4),10)= 1; % Indicator if DIM with MAP > 90 AND Y2
        IdAgeC= sortrows(IdAgeC,[10 2 4 ]); % Sort cows by Y2 with DIM >= 90, Age, DIM  
        IdElim= IdAgeC(herdLimit+1:end,1); % Get ID of the oldest (herdLimit-numCows) cows
        [lia,~]= ismember(herd(:,2),IdElim); % get the location of IdElim cows in herd matrix
        herd(lia,15)= 6 ; % Mark IdElim cows as cull for over limit

    elseif numCows >  herdLimit && allsusceptible== 1 % if number of cows is greater than the capacity of the herd AND NO MAP 
        IdAgeC= herd((herd(:,6)>= 1), [2, 3, 6, 8, 10]); % Create new matrix of all cows 
                % matrix columns: 1 cow ID; 2 Age; 3 Parity; 4 Pregnant days;
                % 5 DIM.
        IdAgeC= sortrows(IdAgeC,[3 4 5]); % Sort cows Parity, Pregnant days, DIM  
        IdElim= IdAgeC(herdLimit+1:end,1); % Get ID of the oldest (herdLimit-numCows) cows
        [lia,~]= ismember(herd(:,2),IdElim); % get the location of IdElim cows in herd matrix
        herd(lia,15)= 6 ; % Mark IdElim cows as cull for over limit

    end
end
clear IdAgeC IDElim lia numCows RepHeiferNum maxID ids idmax herdNew
%%%%%%%%% Test USDA bTB Protocol
if TestingPhase>= 1 && TBTestControl==1 && USDAProtocol==1  % While the Quarantine is in effect, continue testing

if (ismember(t,[StartTimeTests+(0:MaxNumTBTests)*TimeIntervalTests]) && TestingPhase==1) ...
      || (t== lastRemovalday+180 && TestingPhase==2) ...
      || (ismember(t,(lastRemovalday+180+360+(0:MaxNumAssuranceTest-1)*TimeIntervalAssuranceTests)) && TestingPhase==3)   % Trigger WHT next day of Post Mortem Test, and at every interval
numTestPos= 0;

    if perttest== 1  % use PERT Distribution to sample. pertrng(n,xmin,xmax,mode,gamma) 
        SeCFTpert=(pertrng(size(herd,1),SeCFTmin,SeCFTmax,SeCFTmode,pertgammaSeCFT)); SeCCTpert= (pertrng(size(herd,1),SeCCTmin,SeCCTmax,SeCCTmode,pertgammaSeCCT));
        SpCFTpert=(pertrng(size(herd,1),SpCFTmin,SpCFTmax,SpCFTmode,pertgammaSpCFT)); SpCCTpert= (pertrng(size(herd,1),SpCCTmin,SpCCTmax,SpCCTmode,pertgammaSpCCT));   

    elseif betatest== 1 % use BETA Distribution to sample. betarng(A,B,row,col)
        SeCFTrand= betarnd(SeCFTBetaA,SeCFTBetaB,size(herd,1),1); % CFT test
        SpCFTrand= betarnd(SpCFTBetaA,SpCFTBetaB,size(herd,1),1);
        SeCCTrand= betarnd(SeCCTBetaA,SeCCTBetaB,size(herd,1),1); % CCT test
        SpCCTrand= betarnd(SpCCTBetaA,SpCCTBetaB,size(herd,1),1);

    end

    if TestingPhase== 1  % Use one CFT test during Removal phase (testingphase== 1) unlike parallel as in previous version
        if  perttest== 1  % use PERT Distribution to sample
            TrueNegProb= SpCFTpert; % Single test
            FalsePosProb= 1-TrueNegProb; % prob of false positives
            TruePosProb= SeCFTpert; % Single Test True Positive
        elseif  betatest== 1 % use Beta Distribution to sample
            TrueNegProb= SpCFTrand; % Single test
            FalsePosProb= 1-TrueNegProb; % prob of false positives
            TruePosProb= SeCFTrand; % Single Test True Positive
        end
    else % do serial test. CFT test already includes series interactaion (higher prob True Neg, lower Prob false Pos; lower prob true positive)
        if  perttest== 1  % use PERT Distribution to sample
            TrueNegProb= (SpCFTpert+SpCCTpert)-(SpCFTpert.*SpCCTpert); % Serial Test
            FalsePosProb= 1-TrueNegProb; % higher prob of false positives
            TruePosProb= (SeCFTpert).*(SeCCTpert); % Serial Test True Positive
        elseif  betatest== 1 % use Beta Distribution to sample
            TrueNegProb= (SpCFTrand+SpCCTrand)-(SpCFTrand.*SpCCTrand); % Serial Test; % Serial Test CCT
            FalsePosProb= 1-TrueNegProb; % higher prob of false positives
            TruePosProb= (SeCFTrand).*(SeCCTrand); % Serial Test True Positive
        end

    end
numtestWHT= numtestWHT+ 1; % Number of WHT Test, Start WHT and perform each at a specified time

% Run for each WHT, CFT AND CCT
% if numtestWHT> 0 % Tests higher than 0 are Validation Phase, do CFT and CCT

    % Do Removal testing

    % Test Susceptible and Occult for False Positives
    randvect= rand(size(herd,1),1); % Random Vector to simulate Test Results
    % TEST ALL HERD (ANIMALS): Calves, Heifers, Cows. Susceptible and
    % Occult
    randvect(:,2)= (herd(:,43)==1 | herd(:,43)==2  | herd(:,43)==5 | herd(:,43)==6 | herd(:,43)==9 | herd(:,43)==10); % Id Suscept and Occult
    if TestingPhase== 1 % If Removal Phase, test all animals age 60 days and older
        randvect(:,2)= randvect(:,2).*(herd(:,3)>=60); % Test only animals age 60 days or older
    elseif TestingPhase== 2 % Verification Phase, test animals 180 days and older 
        randvect(:,2)= randvect(:,2).*(herd(:,3)>=180); % Test only animals age 180 days or older
    elseif TestingPhase== 3 % Assurance Phase, test animals 180 days and older 
        randvect(:,2)= randvect(:,2).*(herd(:,3)>=360); % Test only animals age 360 days or older    
    end
    % False Positive
    randvect(:,3)= randvect(:,2).*(randvect(:,1)< FalsePosProb); % False Positive of the two tests (parallel)     
    numFalsePos= sum(randvect(:,3)); % Number of False Positive Test Results. healthy animals only.

    % Test Reactive and Infectious for True Positive, Parallel test.
    randvect(:,1)= rand(size(herd,1),1); % New Random Vector to simulate Test Results
    % All animals Reactive and Infectious
    randvect(:,4)= (herd(:,43)==3 | herd(:,43)==4 | herd(:,43)==7 | herd(:,43)==8 | herd(:,43)==11 | herd(:,43)==12); % Id Reactive and Infectious
    if TestingPhase== 1 % If Removal Phase, test all animals age 60 days and older
        randvect(:,4)= randvect(:,4).*(herd(:,3)>=60); % Test only animals age 60 days or older 
    elseif TestingPhase== 2 % Verification Phase, test animals 180 days and older 
        randvect(:,4)= randvect(:,4).*(herd(:,3)>=180); % Test only animals age 180 days or older
    elseif TestingPhase== 3 % Assurance Phase, test animals 180 days and older 
        randvect(:,4)= randvect(:,4).*(herd(:,3)>=360); % Test only animals age 360 days or older    
    end

% Positive Test Results. 
randvect(:,5)= randvect(:,4).*(randvect(:,1)< TruePosProb); % Positive of the two tests (true, true)
herd(:,35)= randvect(:,3)+randvect(:,5); % List all animals that tested positive in CFT and CCT, they will be culled. False Pos and True Pos
herd(:,15)= 13*herd(:,35); % Reason for culling is Test and Cull Tb, reason 13.
numTestPos= sum(herd(:,35)); % Number of Positive Test (True and False)

remain= zeros(size(herd,1),1);
remain(herd(:,15)==0,1)= 1; % Indicator of cattle that is not dead, thus not being culled today, % remain=1 alive, 0= culled
herd(:,37)= remain.*herd(:,43); % Tb Status of those animals in the herd that are alive (ALL Animals, calves included) 

% Enhanced PostMortem Test. Do it to bTB positive tested animals
RI_Tb= zeros(size(herd,1),1); % Vector of zeros to store indicator of True infection for all animals            
RI_Tb((herd(:,43)== 3 | herd(:,43)== 4 | herd(:,43)== 7 | herd(:,43)== 8 | herd(:,43)== 11 | herd(:,43)== 12),1)= 1;        

% Enhanced PostMortem Test. Test False Positives (S and O)
SO_Tb= zeros(size(herd,1),1); % Vector of zeros to store indicator of S and O for all animals     
SO_Tb((herd(:,43)== 1 | herd(:,43)== 2 | herd(:,43)== 5 | herd(:,43)== 6 | herd(:,43)== 9 | herd(:,43)== 10),1)= 1;        

% Do Enhanced Post Mortem Tets

    if sum(herd(:,35))>0 % If there are Positive Tested animal, do Histology PMT
    clear randvectPMT
    randvectPMT(:,[1 2])= herd(:,[2 35]); % Create new matrix of ID and indicator of Test Positive
    randvectPMT(:,3)= RI_Tb; % Infected
    randvectPMT(:,4)= SO_Tb; % Not infected
    randvectPMT(randvectPMT(:,2)==0,:)= []; % KEEP ONLY PMT positive

    randvectPMT(:,5)= rand(size(randvectPMT,1),1); % Create random vector (0,1) to test for Enhanced PMT
        if perttest== 1
            SePCR= pertrng(size(randvectPMT,1),SePCRmin,SePCRmax,SePCRmode,pertgammaSePCR);
        elseif betatest== 1
            SePCR= betarnd(SeHistBetaA,SeHistBetaB,size(randvectPMT,1),1); % Sensitivity Histology
            SpPCR= betarnd(SpHistBetaA,SpHistBetaB,size(randvectPMT,1),1); % Specificity Histology
            SeCulture= betarnd(SeCultureBetaA,SeCultureBetaB,size(randvectPMT,1),1); % Sensitivity Culture
        end

    randvectPMT(:,6)= randvectPMT(:,5)< SePCR; % Enhanced PMT Restults, Positive and infected
    randvectPMT(:,7)= randvectPMT(:,5)< (1-SpPCR); % Enhanced PMT Restults, False Positive 
    % Positive Histology test (true positive and false positive), they
    % will be culture tested. 
    randvectPMT(:,8)= randvectPMT(:,3).*randvectPMT(:,6)+randvectPMT(:,4).*randvectPMT(:,7);
    randvectPMT(:,5)= rand(size(randvectPMT,1),1); % Create random vector (0,1) to test for Enhanced PMT again.
    % True Positive Culture test. This vector is for all
    % positive culture test, since there are no false positives (sp=1)
    randvectPMT(:,9)= (randvectPMT(:,5)< SeCulture).*randvectPMT(:,3).*randvectPMT(:,8); % Culture test Restults, Positive and infected
    numHistologyTestsPos = sum(randvectPMT(:,8)); % Number of animals that testes positive in Histology test(they will be culture tested) 

    % Get ID of true positive culutre tested animals
    IdTruePosCultureTest= randvectPMT(randvectPMT(:,9)==1,1);
    herd(:,36)= 0; % set the indicator of postmortem test to 0
    [lia,~]= ismember(herd(:,2),IdTruePosCultureTest); % get the location of IdFalseNegPMT 
    herd(lia,36)= 1; % True Positive Culture test
    numTruePos= sum(herd(lia,36)== 1); % Number of True Positive from Culture Test

    clear randvectPMT lia idFalseNegPMT remain
   end

    % End Enhanced Port Mortem Test
    NumEPostMort= sum(herd(:,36)); % Num of all PostMortem Test Positive Culture Test
    % Count Animals By Tb Status that were not 
     Adult_O_Tb((herd(:,37)== 2 | herd(:,37)== 10),1)= 1; % Indicator of Non Susceptible (have infection) and Alive       
     Adult_R_Tb((herd(:,37)== 3 | herd(:,37)== 11),1)= 1; % Indicator of Non Susceptible (have infection) and Alive       
     Adult_I_Tb((herd(:,37)== 4 | herd(:,37)== 12),1)= 1; % Indicator of Non Susceptible (have infection) and Alive       
     Calves_O_Tb((herd(:,37)== 6),1)= 1; % Indicator of Non Susceptible (have infection) and Alive       
     Calves_RI_Tb((herd(:,37)== 7 | herd(:,37)== 8),1)= 1; % Indicator of Non Susceptible (have infection) and Alive       

     WHTTrigger(numtestWHT+1,1)= t; % Date of Tb ID in Postmortem Test
     WHTTrigger(numtestWHT+1,2)= TestingPhase; % TestingPhase (1-3), 3 is when quaratntine released
     WHTTrigger(numtestWHT+1,3)= 1; % Positive Tb Result
     WHTTrigger(numtestWHT+1,4)= numTestPos; % Num of Positive Tb Result, cull these 
     WHTTrigger(numtestWHT+1,5)= numTruePos; % Num of True Positive from skin tests

     WHTTrigger(numtestWHT+1,6)=  sum(RI_Tb)+sum(Adult_O_Tb)+sum(Calves_O_Tb)+sum(Calves_RI_Tb); % True Infected (O,R,I) Animals left in Herd (Alive): Adults and Calves.
     WHTTrigger(numtestWHT+1,7)=  sum(Adult_O_Tb); % True Occult (O) Adults left in Herd (Alive)
     WHTTrigger(numtestWHT+1,8)=  sum(Adult_R_Tb); % True Reactive (R) Adults left in Herd (Alive)
     WHTTrigger(numtestWHT+1,9)=  sum(Adult_I_Tb); % True Infected (I) Adults left in Herd (Alive)
     WHTTrigger(numtestWHT+1,10)=  sum(Calves_O_Tb); % True Occult (O) Calves left in Herd (Alive)
     WHTTrigger(numtestWHT+1,11)=  sum(Calves_RI_Tb); % True Infected (R,I) Calves left in Herd (Alive)    

    % TB costs
    if TestingPhase== 1 % If Removal Phase, test all animals age 60 days and older. Cost of two tests.
        herd(:,13)= herd(:,13)+ (herd(:,3)>=60)*2*((CostTestTb/2)+(2*VetMiles/size(herd(:,3>=60),1))); % Include CFT Cost (one test), and vet costs (two visits in parallel tests)
        herd(:,13)= herd(:,13)+ numHistologyTestsPos.*CostCultureTest/size(herd(:,1),1);
    elseif TestingPhase== 2 % Verification Phase, test animals 180 days and older. Cost of one or two tests. One if first test is negative

        if size(herd(:,3>=180),1)>0
        herd(:,13)= herd(:,13)+ (herd(:,3)>=180)*(CostTestTb+(2*VetMiles/size(herd(:,3>=180),1))); % Include CFT and CCTCost, and vet costs (two visits in parallel tests)

            if perttest== 0 && betatest== 0
            randvect(:,6)= randvect(:,2).*(randvect(:,1)< (1-SpCFT)); % False Positive in the first test    
            randvect(:,7)= randvect(:,4).*(randvect(:,1)< SeCFT); % Positive in the first test
            herd(:,13)= herd(:,13)+ (randvect(:,6)+randvect(:,7)).*(herd(:,3)>=180)*(CostTestTb+(2*VetMiles/size(herd(:,3>=180),1)));    
            elseif perttest== 1
            randvect(:,6)= randvect(:,2).*(randvect(:,1)< (1-SpCFTpert)); % False Positive in the first test    
            randvect(:,7)= randvect(:,4).*(randvect(:,1)< SeCFTpert); % Positive in the first test
            herd(:,13)= herd(:,13)+ (randvect(:,6)+randvect(:,7)).*(herd(:,3)>=180)*(CostTestTb+(2*VetMiles/size(herd(:,3>=180),1)));     
            elseif betatest== 1
            randvect(:,6)= randvect(:,2).*(randvect(:,1)< (1-SpCFTrand)); % False Positive in the first test    
            randvect(:,7)= randvect(:,4).*(randvect(:,1)< SeCFTrand); % Positive in the first test
            herd(:,13)= herd(:,13)+ numHistologyTestsPos.*CostCultureTest/size(herd(:,1),1);     
            end       
        end
    elseif TestingPhase== 3 % Assurance Phase, test animals 360 days and older 
        if size(herd(:,3>=360),1)
        herd(:,13)= herd(:,13)+ (herd(:,3)>=360)*2*(CostTestTb+(2*VetMiles/size(herd(:,3>=360),1))); % Include CFT Cost and CCTCost, and vet costs (two visits in parallel tests)  
            if perttest== 0 && betatest== 0
            randvect(:,6)= randvect(:,2).*(randvect(:,1)< (1-SpCFT)); % False Positive in the first test    
            randvect(:,7)= randvect(:,4).*(randvect(:,1)< SeCFT); % Positive in the first test
            herd(:,13)= herd(:,13)+ (randvect(:,6)+randvect(:,7)).*(herd(:,3)>=360)*(CostTestTb+(2*VetMiles/size(herd(:,3>=360),1)));
            elseif perttest== 1
            randvect(:,6)= randvect(:,2).*(randvect(:,1)< (1-SpCFTpert)); % False Positive in the first test    
            randvect(:,7)= randvect(:,4).*(randvect(:,1)< SeCFTpert); % Positive in the first test
            herd(:,13)= herd(:,13)+ (randvect(:,6)+randvect(:,7)).*(herd(:,3)>=360)*(CostTestTb+(2*VetMiles/size(herd(:,3>=360),1)));    
            elseif betatest== 1
            randvect(:,6)= randvect(:,2).*(randvect(:,1)< (1-SpCFTrand)); % False Positive in the first test    
            randvect(:,7)= randvect(:,4).*(randvect(:,1)< SeCFTrand); % Positive in the first test
            herd(:,13)= herd(:,13)+ numHistologyTestsPos.*CostCultureTest/size(herd(:,1),1);    
            end
        end
    end

    herd(:,13)= herd(:,13)+ herd(:,35)*(CostHistTest+DisposalCost); % Include Histology Test Cost

    postestedTb= sum(herd(:,35)); % Number of Positive Test 

    RemainingTb= abs(herd(:,35)-1); % Vector indicating animals that did not Test Positive =1. 0= Tb Positive.
    herd(:,37)= RemainingTb.*herd(:,43); % Tb Status of those animals in the herd that did not test positive  

    if NumEPostMort== 0 % If NO positive ID Results. WHT is negative
        ConsNegWHT= ConsNegWHT+1; % Consecutive Negative WHT
        if ConsNegWHT== NumConsNegWHTRemoval % If the number of consecutive negative WHT equals the number needed to leave Removal testins
            TestingPhase= 2; % Leave Removal phase and enter Verification phase
            lastRemovalday= t; % Time of last removal test
        elseif ConsNegWHT== NumConsNegWHTRemoval+1 % If Verification test is negative
            TestingPhase= 3; % Leave Verification phase and enter Assurance phase (Quarantint is lifted)              
        end
    end

    if numTruePos>0 % If there is a true positive, do again num max WHT to declare TB free
        ConsNegWHT= 0;
        TestingPhase= 1; % Return or stay in removal phase
    end

   if numTestPos> 0
       % flag the incorporation of new heifers as indemnity
       % introduceHeifersIndemnity= 1; % Flag
       numberHeifersIndemnity= numTestPos; % NUmber of Heifers to be introduced as indemnity
       timeHeifersIndemnityEnter= t+IndemPaymentDays; % Introduce new heifers IndemPaymentDays days after culling           
   end

end

% Set Milk Production to 0 for all Tb Positive Test
NoTbPos= zeros(size(herd,1),1);
NoTbPos(herd(:,35)== 0,1)=1; % 1 if No Tb Pos, 0 if Tb Positive
herd(:,14)= herd(:,14).*NoTbPos; % If Positive Tb Test, Milk Production = 0.

end %%%% End bTB Testing loop
clear NonSuscTb TruePosTb NoTbPos

%% Test Post Mortem for TB. First Test to Identify TB in the Herd.
% Test only Reactive and Infected Cows. 

clear randvect remain
if t> StabilityTime+ WarmUp && TBTestControl== 1
if WHTTrigger(1,2)== 0 % If never Trigger Before

     herdCows=herd(ismember(herd(:,43),[3,4,11,12]),[2,15,33]); % Create new Matrix with R,I Tb Cow and Heif. cols: ID, cull indicator, Tb Status
     herdCows(herdCows(:,2)==0,:)=[]; % Keep only culled cows of Heifers (for Post Motem Test)

     if  size(herdCows,1)>0 % If there are culled cows that are Tb status: R,I 

         herdCows(:,4)= rand(size(herdCows,1),1); % generate random vector to estimate postmortem detection on infected cows

         % Test Reactive and Infectious for True Positive
            if perttest== 1
                SePM= pertrng(1,SePMmin,SePMmax,SePMmode,pertgammaSePM);
            elseif betatest== 1
                SePM= betarnd(SeNecBetaA,SeNecBetaB,1,1); % Necropsy test, identify first bTB infected animal
                                                          % Eventually, all post mortem tests have a Sp of 1. We do not simulate false neg. since all herds have these same costs. We only look at the difference between healthy and infected.                                                                                        
            end

         herdCows(:,5)= (herdCows(:,4)<SePM); % True Positive of the Regular Post Mortem Test  

         postestedTb= sum(herdCows(:,5)); % Number of Positive Tb Tested animals Postmortem
         if postestedTb>0 % If there are postmortem detected bTB animals

         StartTimeTests= t+1; % Start WHT Day, Begin Quarantine and WHT the following day
         Quarantine= 1; % Herd under Quarantine
         TestingPhase= 1; % Begin Removal Testing for bTB

         WHTTrigger(1,1)= t; % Date of Tb ID in Postmortem Test
         WHTTrigger(1,2)= 1; % Indicator that today Tb was Found in Postmortem test
         WHTTrigger(1,3)= 1; % Positive Tb Result
         WHTTrigger(1,4)= 0; % Num of Positive Tb Result. Identify the infected animal through postmortem test.
         WHTTrigger(1,5)= postestedTb; % All are True Positive (Postmortem Test)

         [loca,locb]= ismember(herdCows(herdCows(:,5)==1,1),herd(:,2)); % Find index in herd of Postivite tested animal
         herd(locb,15)= 13; % Set reason for culling is Tb, so that it is not sold.

         remain= zeros(size(herd,1),1);
         remain(herd(:,15)==0,1)= 1; % Indicator of cattle that is not dead, thus not being culled today, % remain=1 alive, 0= culled
         herd(:,37)= remain.*herd(:,43); % Tb Status of those animals in the herd that are alive (ALL Animals, calves included)  

         RI_Tb((herd(:,37)== 3 | herd(:,37)== 4 | herd(:,37)== 7 | herd(:,37)== 8 | herd(:,37)== 11 | herd(:,37)== 12),1)= 1; % Indicator of Non Susceptible (have infection) and Alive       

         Adult_O_Tb((herd(:,37)== 2 | herd(:,37)== 10),1)= 1; % Indicator of Non Susceptible (have infection) and Alive       
         Adult_R_Tb((herd(:,37)== 3 | herd(:,37)== 11),1)= 1; % Indicator of Non Susceptible (have infection) and Alive       
         Adult_I_Tb((herd(:,37)== 4 | herd(:,37)== 12),1)= 1; % Indicator of Non Susceptible (have infection) and Alive       
         Calves_O_Tb((herd(:,37)== 6),1)= 1; % Indicator of Non Susceptible (have infection) and Alive       
         Calves_RI_Tb((herd(:,37)== 7 | herd(:,37)== 8),1)= 1; % Indicator of Non Susceptible (have infection) and Alive       

         WHTTrigger(1,6)=  sum(RI_Tb)+sum(Adult_O_Tb)+sum(Calves_O_Tb)+sum(Calves_RI_Tb); % True Infected (O,R,I) Animals left in Herd (Alive): Adults and Calves.
         WHTTrigger(1,7)=  sum(Adult_O_Tb); % True Occult (O) Adults left in Herd (Alive)
         WHTTrigger(1,8)=  sum(Adult_R_Tb); % True Reactive (R) Adults left in Herd (Alive)
         WHTTrigger(1,9)=  sum(Adult_I_Tb); % True Infected (I) Adults left in Herd (Alive)
         WHTTrigger(1,10)=  sum(Calves_O_Tb); % True Occult (O) Calves left in Herd (Alive)
         WHTTrigger(1,11)=  sum(Calves_RI_Tb); % True Infected (R,I) Calves left in Herd (Alive)         
         end
     end
end
end % End loop for WHT Trigger for bTB
clear randvect herdCows remain  RI_Tb Adult_* Calves_* loca locb

%% Tb Scenarios
% Include NumTbInfHeif Number of Heifers with Tb Infection status NewHeifTbStatus
if  ScenarioWarmUpTb== 1 % Include Infected Tb Heifer and Cows Par 1 and 2
   if t== StabilityTime+ WarmUp+1
        ListHeif= [herd(:,2) herd(:,3) herd(:,6) herd(:,43) herd(:,8)]; % ID, Age, Parity, Tb Status, pregnant days

        if sum(ListHeif(:,2)> 540 & ListHeif(:,3)<= 0 & ListHeif(:,5)> 0,1)>= NumTbInfHeif % If number of pregnant heifers age 540 days or older
            indic =(ListHeif(:,2)> 540 & ListHeif(:,3)<= 0 & ListHeif(:,5)> 0);
            ListHeif(~indic,:)= []; % Eliminate Parities >=1, leave only heifers 
            IDRand= datasample(ListHeif(:,1),NumTbInfHeif,'Replace',false); % NumTbInfHeif  Select random ID values to change Tb Status to Occult, 
            [~,Locb]= ismember(IDRand,herd(:,2));
            herd(Locb,43)= NewHeifTbStatus; %NewHeifTbStatus; % Change Tb Infection Status to Occult (10), Reactive (11)
        elseif sum(ListHeif(:,2)> 450 & ListHeif(:,3)<= 0 & ListHeif(:,5)> 0,1)>= NumTbInfHeif % Select yournger heifers 
            indic=(ListHeif(:,2)> 450 & ListHeif(:,3)<= 0 & ListHeif(:,5)> 0);
            ListHeif(~indic,:)= []; % Eliminate Parities >=1, leave only heifers 
            IDRand= datasample(ListHeif(:,1),NumTbInfHeif,'Replace',false); % NumTbInfHeif  Select random ID values to change Tb Status to Occult, 
            [~,Locb]= ismember(IDRand,herd(:,2));
            herd(Locb,43)= NewHeifTbStatus; %NewHeifTbStatus; % Change Tb Infection Status to Occult (10), Reactive (11)
         elseif sum(ListHeif(:,2)> 450 & ListHeif(:,3)<= 0 & ListHeif(:,5)> 0 | ListHeif(:,3)== 1 ,1)>= NumTbInfHeif % Select yournger heifers, include 1 parity cows 
            indic=(ListHeif(:,2)> 450 & ListHeif(:,3)<= 0 & ListHeif(:,5)> 0 | ListHeif(:,3)== 1);
            ListHeif(~indic,:)= []; % Eliminate Parities >=1, leave only heifers 
            IDRand= datasample(ListHeif(:,1),NumTbInfHeif,'Replace',false); % NumTbInfHeif  Select random ID values to change Tb Status to Occult, 
            [~,Locb]= ismember(IDRand,herd(:,2));
            if herd(Locb,43)== 9 % if the animal selected is a heifer (susceptible), change it to 10 (occult 
                herd(Locb,43)= NewHeifTbStatus; %NewHeifTbStatus; % Change Tb Infection Status to Occult (10), Reactive (11)
                elseif herd(Locb,43)== 1 % if it is a cow
                herd(Locb,43)= NewCowTbStatus; %NewCowTbStatus; % Change Tb Infection Status to Occult (2), Reactive (3)    
            end
         elseif sum(ListHeif(:,2)> 450 & ListHeif(:,3)<= 0 & ListHeif(:,5)> 0 | ListHeif(:,3)== 1 | ListHeif(:,3)== 2,1) >= NumTbInfHeif % Select yournger heifers, include 1 and 2  parity cows 
            indic=(ListHeif(:,2)> 450 & ListHeif(:,3)<= 0 & ListHeif(:,5)> 0 | ListHeif(:,3)== 1);
            ListHeif(~indic,:)= []; % Eliminate Parities >=1, leave only heifers 
            IDRand= datasample(ListHeif(:,1),NumTbInfHeif,'Replace',false); % NumTbInfHeif  Select random ID values to change Tb Status to Occult, 
            [~,Locb]= ismember(IDRand,herd(:,2));
            if herd(Locb,43)== 9 % if the animal selected is a heifer (susceptible), change it to 10 (occult 
                herd(Locb,43)= NewHeifTbStatus; %NewHeifTbStatus; % Change Tb Infection Status to Occult (10), Reactive (11)
                elseif herd(Locb,43)== 1 % if it is a cow
                herd(Locb,43)= NewCowTbStatus; %NewCowTbStatus; % Change Tb Infection Status to Occult (2), Reactive (3)    
            end

        end     
   end    
end

clear ListCowS IDRand Locb NumInitialInfect

%% NPV Calculation for Milk Production, Sale of Culled Cows, and Sale of Male Calves

% Estimation of average parity and culling rate 
avParity(t,1)= mean(herd(herd(:,6)>0,6)); % Average Parity of the herd
avParity(t,2)= 1/avParity(t,1); % average Culling Rate of the herd
DeathsHerd= herd(herd(:,15)>0,:); % Create Matrix to store dead animals, all colums than herd 

%%% after this point, herd only includes live animals. DeathsHers
%%% captures all dead animals.

DeadAnimals(t,1)= sum(herd(:,15)== 1); % Natural Culled Cows %
DeadAnimals(t,2)= sum(herd(:,15)== 2); % Natural Culled Calves
DeadAnimals(t,3)= sum(herd(:,15)== 3); % Natural Culled Heifers
DeadAnimals(t,4)= sum(herd(:,15)== 4); % Max AI attempts (Open Cows)
DeadAnimals(t,5)= sum(herd(:,15)== 5); % Over Parity
DeadAnimals(t,6)= sum(herd(:,15)== 6); % Low MIlk Production (High MAP Shedders)
DeadAnimals(t,7)= sum(herd(:,15)== 7); % Voluntary Culled Female Calves (over limit)
DeadAnimals(t,8)= sum(herd(:,15)== 8); % Heifers for Sale
DeadAnimals(t,9)= sum(herd(:,15)== 9); % Voluntary Culled Cows
DeadAnimals(t,10)= sum(herd(:,15)== 10); % Voluntary Culled Calves
DeadAnimals(t,11)= sum(herd(:,15)== 11); % Voluntary Culled Heifers
DeadAnimals(t,12)= sum(herd(:,15)== 12); % Test and Cull Cows (MAP)
DeadAnimals(t,13)= sum(herd(:,15)== 13); % Test and Cull Tb Positive Animals
DeadAnimals(t,14)= sum(herd(:,15)== 14); % Over Limit Cows

if sum(ismember(TBHist(:,1),herd(herd(:,15)>0,2)))>0
[lia, ~]= ismember(TBHist(:,1),herd(herd(:,15)>0,2));
TBHist(lia,8)= t-1;
end

% NPV of Milk Production.
herd(:,25)= herd(:,14)-herd(:,24)-herd(:,23)-herd(:,13); % Gross Profit per animal/day 
StartDay= StabilityTime+ WarmUp+1;
daysInt= herd(1,1)-StartDay; % Interval Days, current day - start day

NumDeath(t,:)= accumarray(DeathsHerd(:,15),1,[14 1])'; % Store Number of deaths for each category (1:6)
NumCulledCows(t,1)= (NumDeath(t,4) + NumDeath(t,5) + NumDeath(t,6)+NumDeath(t,9)); % Num of culled cows at t

TotWeightCullCowsLb= sum(herd(herd(:,15)==4 | herd(:,15)==5 | herd(:,15)==6 | herd(:,15)==9 | herd(:,15)==12 | herd(:,15)==14,21))*2.2;

if isempty(accumarray(DeathsHerd(:,4),1,[8,1]))== 0
NumCullInf= accumarray(DeathsHerd(:,4),1,[8 1]); % Number of death animals, by infection 
else NumCullInf= [0,0,0,0]';
end

NumCCows= sum(NumCullInf(1:4,1)); % Number of culled cows
NumY2Cull= NumCullInf(4,1); % Number of Culled Y2 Cows
if NumCCows== 0
    PercCullY2= 0;
else
PercCullY2= NumY2Cull/NumCCows; % Ratio of Y2 of all Culled
end
% Adjusted Culled Cow's Price for Y2
CullPriceAdjusted= CulledCowPrice*(1-WeightLossY2Perc*PercCullY2);  
Total_Calves(t,:)= [num_male, num_calf,0,0, DeadAnimals(t,8), 0]; % Number of male and female calves per t

if daysInt>= 0 % Calculate Discounted Gross Profit and other revenues after WarmUp Period
    herd(:,26)= herd(:,25)/(1+dailyirate).^daysInt; % Second Method (BW, DMI)
    Total_Calves(t,3)= Total_Calves(t,1)*(MaleCalfPrice) /(1+dailyirate).^daysInt; % Revenue from sale of male calves
    Total_Calves(t,4)= DeadAnimals(t,7)*FemaleCalfPrice/(1+dailyirate).^daysInt; % Revenue from sale of Female calves due to Over Limit
    Total_Calves(t,6)= DeadAnimals(t,8)*HeiferReplCost/(1+dailyirate).^daysInt; % Revenue from selling pregnant heifers
    % If culled by open or over parity, and voluntary culling % Calculate Discounted Gross Profit after WarmUp Period
    NumCulledCows(t,2)= (NumCulledCows(t,1)+NumDeath(t,12))*CullPriceAdjusted/(1+dailyirate).^daysInt;
    Total_Exp(t,1)= sum(herd(:,13)) /(1+dailyirate).^daysInt; % Total Management Changes and Interventions Expenses
end

% Using Function of BW and DMI
% Store in the NPV Matrix for each time period
NPV(t,1)= sum(herd(:,26));      % NPV of net milk revenue of animal per day (using function of BW, DMI) 
NPV(t,2)= NumCulledCows(t,2);   % NPV of selling culled cows 
NPV(t,3)= Total_Calves(t,3);    % NPV of Male Calves Sale
NPV(t,4)= Total_Calves(t,4);    % NPV of Female Calves Sale
NPV(t,8)= Total_Calves(t,6);    % NPV of heifers sold
NPV(t,5)= NPV(t,1)+ NPV(t,2)+ NPV(t,3)+ NPV(t,4) + NPV(t,8); % Sum of Gross Profit NPV Without Intervention Costs
NPV(t,6)= Total_Exp(t,1);       % Total Management Changes and Interventions Expenses
NPV(t,7)= NPV(t,5)-NPV(t,6);    % Net NPV  

% Reset variable values
herd(:,18)= 0; % 1 if Inseminated at time t, 0 otherwise.
herd(:,19)= 0; % 1 if pregnant at time t, 0 otherwise

% Eliminate the dead animals from the herd matrix
herd(herd(:,15)> 0,:)= []; % if the dead indicator > 0, eliminate animal

%%%% Save Results
N_total_Time(t,:)= [N_total, Si, Li, Y1_i, Y2_i, CS_i, CI_i, HS_i, HI_i, ...
STbi,OTbi,RTbi,ITbi,CSTbi,COTbi,CRTbi,CITbi,HSTbi,HOTbi,HRTbi,HITbi,...
N_total_Time(t,[22:24])];

end
%% End of the Time Loop
%%%% End of the simulation and data processing

WHTTrigger(:,1)= WHTTrigger(:,1)-StabilityTime- WarmUp-1; % Change time in WHT Matrix as Time from Infection Introduction
WHTTrigger(WHTTrigger(:,1)<0,1)= 0; % Set all negative time to 0.

% Store the Dicsounted Cost of Indemnity for culling test positive bTB animals
% This amount is not accounted in the far, but assumed the gvment pays for
% it.
Indemnity= 0; % Initialize indemnity variable
if WHTTrigger(1,1) >0 % if infected animals are found in postmortem test
rr= 2;
while WHTTrigger(rr,1) >0

WHTTrigger(rr,12)= WHTTrigger(rr,4)* HeiferReplCost/(1+dailyirate).^WHTTrigger(rr,1);
rr= rr+1; 
end
Indemnity= sum(WHTTrigger(:,12));
end  

%% Dead Animals

% These values are only for the Analysis period.
TotalDeathAnimals= sum(sum(NumDeath(StabilityTime+WarmUp+1:end,:))); % Total Death animals at the end of the simulation
TotalLiveAnimals= size(herd,1); % Total number of live animals at end of simulation 
DeathTotal= sum(NumDeath(StabilityTime+WarmUp+1:end,:),1);

% Sum the daily NPVs 
NPVSim(1,1)= sum(NPV(:,1));
NPVSim(1,2)= sum(NPV(:,2));
NPVSim(1,3)= sum(NPV(:,3));
NPVSim(1,4)= sum(NPV(:,4));
NPVSim(1,5)= sum(NPV(:,5));
NPVSim(1,6)= sum(NPV(:,6));
NPVSim(1,7)= sum(NPV(:,7));

% Parity and Culling Rate
Par= avParity(:,1);
Cull= avParity(:,2);

% Tb Results
% Day of WHT with no Tb Infected (O-I): WHTTrigger cols 6 + 7 (RI + O)
[~,locb]= ismember(0,WHTTrigger(:,6)); % index of WHT when number of ALL true Tb infected animals is 0, 0 occurs only once.
[~,locbday]= ismember(0,WHTTrigger(:,1)); % index of days when all required WHT are 0 (1 before last WHT)
[~,locbPos]= ismember(0,WHTTrigger(:,5)); % index when first TB Negative Postmotem test occurs

V= [WHTTrigger((1:locb),5)]'; % Get vector or number of true positives for each WHT until NO Actual TB in herd
V(V(:,:)>0)= 2  ; % Transform all positive to 2
V(V(:,:)==0)= 1; % Transform all 0 to 1
V(V(:,:)==2)= 0; % Transform all 2 to 0
% Find longest sequence of 1's (actual negative test, 0)
B=[0 V 0];
lgt= find(diff(B)==-1)-find(diff(B)==1);
if WHTTrigger(1,1) >0
    if isempty(lgt)
            maxNegWHT= 1; % Maximum lenght of consecutive negative tests to eliminate bTB
        else
            maxNegWHT= max(lgt); % Maximum lenght of consecutive negative tests
    end
else
    maxNegWHT= 0; % No WHT perfomed
end
ProtoEndday= 0; % Set end day of protocol to 0, 

if WHTTrigger(1,1)==0 % When no bTB pos animal found in the herd, infected animals are eliminated without detection
    %maxNegWHT= 0; 
    TotalWHTnoTB= 0; 
    TotalWHT= 0;
    NumWHTnoTBafterFirstNegWHT= 0;

elseif WHTTrigger(1,1)>0 && WHTTrigger(1,6)==0 % Detect BUT all bTB are eliminated at time of initial detection.
    %maxNegWHT= 0;                              % There is at least one WHT                                                  
    TotalWHTnoTB= 0;       % Total number of WHT
    TotalWHT= locbday-2; % Number of total WHT if at least one WHT done  
    NumWHTnoTBafterFirstNegWHT= 0;
    ProtoEndday= WHTTrigger(locbday-1,1); % Day Protocol Ends

elseif locb < locbPos   % If Positive postmortem Test but no infected animals remaining 
    %  set maxNegWHT to 0    
    %maxNegWHT= 0;
    TotalWHTnoTB= locb-1; 
    TotalWHT= locbday-2; % Number of total WHT if at least one WHT done
    ProtoEndday= WHTTrigger(locbday-1,1); % Day Protocol Ends
    NumWHTnoTBafterFirstNegWHT= 0;

elseif locb >= locbPos   % If negative portmortem test, but still infected animals remaining
    %maxNegWHT= 0;
    TotalWHTnoTB= locb-1;
    TotalWHT= locbday-2; % Number of total WHT if at least one WHT done
    ProtoEndday= WHTTrigger(locbday-1,1); % Day Protocol Ends
    NumWHTnoTBafterFirstNegWHT= locb-locbPos;
end

clear V timestamp runlength lgt B 

% Use this Results for TB without MAP. NumCol= 27

Results(jj,:)= ([DeathTotal(1:7),DeathTotal(13), TotalDeathAnimals, TotalLiveAnimals,NPVSim(1,1), NPVSim(1,2),NPVSim(1,4), NPVSim(1,5),NPVSim(1,6),NPVSim(1,7),...
sum(N_total_Time(StabilityTime+ WarmUp+1,[10 11 12 13])),sum(N_total_Time(StabilityTime+ WarmUp+1,[18 19 20 21])),sum(N_total_Time(StabilityTime+ WarmUp+1,[14 15 16 17])),...
sum(N_total_Time(end,[10 11 12 13])),sum(N_total_Time(end,[18 19 20 21])),sum(N_total_Time(end,[14 15 16 17])),WHTTrigger(1,1),WHTTrigger(1,6),WHTTrigger(locb,1),TotalWHTnoTB,...
TotalWHT,locb-locbPos,maxNegWHT,ProtoEndday,Indemnity]);

% Comment it for All Healthy (No Infection)
ResultsWHT(:,:,jj)= WHTTrigger; % Store all WHTTrigger tables for each iteration in a 3dim matrix

% Results Col,name: 31:STb; 32:OTb; 33:RTb; 34:ITb; 35:HSTb; 36:HOTb;
% 37:HRTb; 38:HITb; 39:CSTb; 40:COTb.

% Result Text for TB Only. 28 columns
ResultsText= {'NumNatCullCows','NumNatCullCalves','NumNatCullHeif','NumCullOpenCows','NumCullOverParCows','NumCullCowsOverLimit','NumCullCalvesOverLimit'...
'NumCullTbTestAnimals','TotDeadAnimals','TotalLiveAnimEnd','MilkNetRev','RevNatCulledCows','NatCulledFemCalves',...
'TotalGrossNPV','TotalExpensesScenario','NetNPV','NumCowsStart','NumHeifStart','NumCalvesStart','NumCowsEnd',...
'NumHeifEnd','NumCalvesEnd','DayFirstTBPos','DayFirstTotalTBAnimals','DayNoTB','NumWHT_NoTB','TotalNumWHT',...
'WHTAft1stTbNegUntilNoActualTb','MaxNumNegativeWHT'};

clear TotalWHT locb locbday locbPos maxNegWHT ProtoEndday Indemnity TotalWHTnoTB 
num_male= 0; NumS= 0; NumE= 0; NumY1= 0; NumY2= 0; NumSC= 0; NumIC= 0; NumSH= 0; NumIH= 0; 
    adult_s_hori= 0; adult_h_hori= 0; adult_y1_hori= 0 ;

end

if scenarioSim== 1 % Save results
save('JDS_Tb1_AltBM_v4_3.mat','Results') % NPV, num animals, costs
save('JDS_Tb1_AltBM_WHT_v4_3.mat','ResultsWHT') % 3dim matrix, num infected bTB, tests


end 
end 

