% Covid-19 in a college setting - 5Cs
% Modified SEIR model with 14 interacting communities
% ODE functions
% A/T HR = admin and teach high risk HSC/LSC = 1, 2
% A/T LR = admin and teach low risk HSC/LSC = 3, 4
% H/D/G HR = housekeeping and dining high risk HSC/LSC = 5, 6
% H/D/G LR = housekeeping and dining low risk HSC/LSC = 7, 8
% S LR (C/NC) = low risk students compliant/not compliant = 11, 12

function dydt = COVID5C_ODE45(t,y,pars, Betas)

% Parameters---------------------
% SEIR group order
% (A/T HR HSC, LSC; LR HSC, LSC;  H/D/G HR HSC, LSC; LR HSC, LSC; S LR C, S LR NC)
numOfCategories = 10;
% for all but the non-compliant students, there are 8 states.  
% Add H_I for non-compliant students
% (S,E,I,R,M,D,H_S,H_E) 
numOfStates = 8;

alpha = pars(1,:);
beta = Betas; % removed from pars to because it's a matrix per Nina's paper
deltaI = pars(2,:);
deltaM = pars(3,:);
eta = pars(16,:); % unused
g = pars(15,:);
gammaI = pars(4,:);
gammaR = pars(5,:);
kappa = pars(6,:);
Mmax = pars(7,:);
muI = pars(8,:);
muM = pars(9,:);
omegaH = pars(10,:);  % unused ?
omegaI = pars(11,:);
rhoR = pars(12,:); % unused 
rhoS = pars(13,:);
sigma = pars(14,:);

% Initiate DE variables
dydt = [zeros(numOfStates*numOfCategories,1); 0]; % add an additional 0 for dH_I/dt for NC students
S = zeros(numOfCategories,1);
E = zeros(numOfCategories,1);
I = zeros(numOfCategories,1);
R = zeros(numOfCategories,1);
M = zeros(numOfCategories,1);
D = zeros(numOfCategories,1);
H_S = zeros(numOfCategories,1);
H_E = zeros(numOfCategories,1);
H_I = 0;


% Differential Equations -----------------------

% Vector of infected for each category
indices = 1:numOfStates:(1 + numOfStates*(numOfCategories-1));
infVector = y(indices+2);
% Vector of exposed for each category
expVector = y(indices+1);

% All but non-compliant students
for i = 1:(numOfCategories-1)
    j = numOfStates*(i-1);
    S(i) = y(j+1);
    E(i) = y(j+2);
    I(i) = y(j+3);
    R(i) = y(j+4);
    M(i) = y(j+5);
    D(i) = y(j+6);
    H_S(i) = y(j+7);
    H_E(i) = y(j+8);
    
    % g*beta*(I(students who infect others)+alpha*E)
    % make sure g, infVector, alpha, expVector are column vectors
    g=reshape(g,numOfCategories,1);
    alpha = reshape(alpha,numOfCategories,1);
    expTerm = beta(i,:)*(g + infVector + alpha.*expVector);
    % susc to held term - contact tracing
    heldTerm = kappa(i)*sigma(i)*(I(i)/(1+I(i)))*(1/(1 + S(i)+E(i)+I(i)+R(i)));
    %heldTerm = (y(7*11+3)+y(7*13+3))/((y(7*11+3)+y(7*13+3)) + sigma(i));
    % inf to medical - saturation of medical facilities
    medTerm = omegaI(i)*exp(-(M(i)/Mmax(i))^2);
    % dS/dt
    dydt(j+1) = -(expTerm + heldTerm)*S(i) + rhoS(i)*H_S(i);
    % dE/dt
    dydt(j+2) = expTerm*S(i) - (gammaI(i) + gammaR(i))*E(i) - heldTerm*E(i);
    % dI/dt
    dydt(j+3) = gammaI(i)*(E(i)+H_E(i)) - (deltaI(i) + medTerm + muI(i))*I(i);
    % dR/dt
    dydt(j+4) = deltaI(i)*I(i) + deltaM(i)*M(i) + gammaR(i)*(E(i) + H_E(i));
    % dM/dt
    dydt(j+5) = medTerm*I(i)  - (deltaM(i) + muM(i))*M(i);
    % dD/dt
    dydt(j+6) = muI(i)*I(i) + muM(i)*M(i);
    % dH_Sdt
    dydt(j+7) = heldTerm*S(i) - rhoS(i)*H_S(i);
    % dH_Edt
    dydt(j+8) = heldTerm*E(i) - (gammaR(i)+gammaI(i))*H_E(i);
end 
% for non-compliant students
i = numOfCategories;
j = numOfStates*(i-1);
    S(i) = y(j+1);
    E(i) = y(j+2);
    I(i) = y(j+3);
    R(i) = y(j+4);
    M(i) = y(j+5);
    D(i) = y(j+6);
    H_S(i) = y(j+7);
    H_E(i) = y(j+8);
    H_I   =  y(j+9);  
    
 % g*beta*(I(students who infect others)+alpha*E)
    g=reshape(g,numOfCategories,1);
    alpha = reshape(alpha,numOfCategories,1);
    expTerm = beta(i,:)*(g + infVector + alpha.*expVector);
    % susc to held term - contact tracing
    heldTerm = kappa(i)*sigma(i)*(I(i)/(1+I(i)))*(1/(1 + S(i)+E(i)+I(i)+R(i)));
    %heldTerm = (y(7*11+3)+y(7*13+3))/((y(7*11+3)+y(7*13+3)) + sigma(i));
    % inf to medical - saturation of medical facilities
    medTerm = omegaI(i)*exp(-(M(i)/Mmax(i))^2);
    
    % dS/dt
    dydt(j+1) = -(expTerm + heldTerm)*S(i) + rhoS(i)*H_S(i);
    % dE/dt
    dydt(j+2) = expTerm*S(i) - (gammaI(i) + gammaR(i))*E(i) - heldTerm*E(i);
    % dI/dt
    dydt(j+3) = gammaI(i)*E(i) - (deltaI(i) + medTerm + muI(i))*I(i) - heldTerm*I(i);
    % dR/dt
    dydt(j+4) = deltaI(i)*(I(i) + H_I) + deltaM(i)*M(i) + gammaR(i)*(E(i) + H_E(i));
    % dM/dt
    dydt(j+5) = medTerm*(I(i)+H_I)  - (deltaM(i) + muM(i))*M(i);
    % dD/dt
    dydt(j+6) = muI(i)*(I(i)+H_I) + muM(i)*M(i);
    % dH_Sdt
    dydt(j+7) = heldTerm*S(i) - rhoS(i)*H_S(i);
    % dH_Edt
    dydt(j+8) = heldTerm*E(i) - (gammaR(i)+gammaI(i))*H_E(i);
    % dH_Idt
    dydt(j+9) = heldTerm*I(i) + gammaI(i)*H_E(i) - (medTerm + deltaI(i)+muI(i))*H_I;
