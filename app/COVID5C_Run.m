% Covid-19 in a college setting - 5Cs
% Written by Maryann Hohn, edited by Ami Radunskaya and Christina Edholm
% Last Edited June 13, 2020
% Modified SEIR model
% Run the ODEs with i.c.

function [t,y]=COVID5C_Run(icICATHDCLR, icS, propNC,scaletracking,scaleoutside)
close all
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------
%--Get parameters-------------------------------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------
run('COVID5C_SetParameters.m')
run('COVID_LAData.m')
run('EstimateBetas.m')  

% increase infectivity of asympatomatic group
pars(1,:) = 1.01*pars(1,:);

pars(6,:)=scaletracking*ones(1,10);

%--# of simulation runs--
tmax = 100; % time simulation stops
tspan = [0 tmax];

%-----------------------------------------------------------------------------------------------------------------------------------------------------------------
% --Outside Influence--------------------------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------

if scaleoutside == 1
% List order: A/T HR HSC, LSC; LR HSC, LSC;  H/D/G HR HSC, LSC; LR HSC, LSC; S LR C, S LR NC)
    pars(15,:)=[0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
elseif scaleoutside == 2
    pars(15,:)= [0, 0, 0.001, 0.001, 0, 0, 0.001, 0.001, 0.001, 0.1];
elseif scaleoutside == 3   
    pars(15,:)= [ 0, 0, 0.01, 0.01, 0, 0, 0.01, 0.01, 0.001, 0.1];
else
    pars(15,:)= [0, 0, 0.01, 0.01, 0, 0, 0.01, 0.01, 0.01, 0.25];
end
% units of g are now people, so these numbers should be bigger?
% pars(15,:) = pars(15,:)*10;
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------
% --Initial conditions--------------------------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------

% List order: A/T HR HSC, LSC; LR HSC, LSC;  H/D/G HR HSC, LSC; LR HSC, LSC; S LR C, S LR NC)

% Passed variables -- 
% StudentPop = Pomona and Pitzer now
% PercentCompliant = 0;
% FracCompliant = PercentCompliant/100;
% pop = max([StaffPops, FracCompliant*StudentPop , StudentPop*(1-FracCompliant)],ones(1,Ngroups));

% % Estimated population in each category
% pop = [10, 90, 100, 400, 20, 80, 20, 280, totalStudentPop-studentPopNC, studentPopNC];

% totalPop = sum(pop)

% Proportion in each SEIRMDH group: a vector of 10, one in each category
%  

%SET: Initial conditions (assume NC=C, A/T=H/D/G, also HSC=LSC
icATHDGExpHR=0;                 %A/T/H/D/G HR Exposed
icATHDGRecHR=0.01;               %A/T/H/D/G HR Recovered
icATHDGHeld_sHR=0;                %A/T/H/D/G HR Held
icATHDGHeld_eHR =0;
%previous must not be more than 1!

if icICATHDCLR == 1
icATHDGExpLR=0.02;                %A/T/H/D/G LR Exposed
icATHDGRecLR=0.05;                %A/T/H/D/G LR Recovered
icATHDGHeld_sLR=0;                  %A/T/H/D/G LR Held
icATHDGHeld_eLR=0;

elseif icICATHDCLR == 2
icATHDGExpLR=0;                   %A/T/H/D/G LR Exposed
icATHDGRecLR=0.05;                %A/T/H/D/G LR Recovered
icATHDGHeld_sLR=0;                  %A/T/H/D/G LR Held
icATHDGHeld_eLR=0;
else 
icATHDGExpLR=0.0;                %A/T/H/D/G LR Exposed
icATHDGRecLR=0.1;                %A/T/H/D/G LR Recovered
icATHDGHeld_sLR=0;                  %A/T/H/D/G LR Held
icATHDGHeld_eLR=0;
    
end

if icS == 1
icSExp=0.1;                 %S NC/C Exposed
icSRec=0.05;                %S NC/C Recovered
icSHeld_s=0;                  %S NC/C Held
icSHeld_e=0;    
icSHeld_i =0;

elseif icS == 2
icSExp=0;                   %S NC/C Exposed
icSRec=0.05;                %S NC/C Recovered
icSHeld_s=0;                  %S NC/C Held
icSHeld_e=0; 
icSHeld_i =0;

else 
icSExp=0.05;                %S NC/C Exposed
icSRec=0.05;                %S NC/C Recovered
icSHeld_s=0;                  %S NC/C Held
icSHeld_e=0;  
icSHeld_i =0;
    
end



% List order: A/T HR HSC, LSC; LR HSC, LSC;  H/D/G HR HSC, LSC; LR HSC, LSC; S LR C, S LR NC)
propInf = [      0,        0,     0,    0,       0,         0,     0,    0,    0,      0];  % assumed 0 for all classes at 5C
propMed = [      0,        0,     0,    0,       0,         0,     0,    0,    0,      0];  % assumed 0 for all classes at 5C
propDead = [     0,        0,     0,    0,       0,         0,     0,    0,    0,      0];  % assumed 0 for all classes at 5C

propExp = [icATHDGExpHR,icATHDGExpHR,icATHDGExpLR,icATHDGExpLR,icATHDGExpHR,icATHDGExpHR,icATHDGExpLR,icATHDGExpLR,icSExp,icSExp];
propRec = [icATHDGRecHR,icATHDGRecHR,icATHDGRecLR,icATHDGRecLR,icATHDGRecHR,icATHDGRecHR,icATHDGRecLR,icATHDGRecLR,icSRec,icSRec]; 
propHeld_S = [icATHDGHeld_sHR,icATHDGHeld_sHR,icATHDGHeld_sLR,icATHDGHeld_sLR,icATHDGHeld_sHR,icATHDGHeld_sHR,icATHDGHeld_sLR,icATHDGHeld_sLR,icSHeld_s,icSHeld_s];
propHeld_E = [icATHDGHeld_eHR,icATHDGHeld_eHR,icATHDGHeld_eLR,icATHDGHeld_eLR,icATHDGHeld_eHR,icATHDGHeld_eHR,icATHDGHeld_eLR,icATHDGHeld_eLR,icSHeld_e,icSHeld_e];
propHeld_I = icSHeld_i;
propSus = 1-propExp-propInf - propRec - propMed - propDead - propHeld_S - propHeld_E;

% Initalize ic vector
ic = zeros(81,1); % 8 states for 10 categories, plus one H_I state

% Divide population into each category
for i=1:10
    j = 8*(i-1);
    % dS/dt
    ic(j+1) = propSus(i)*pop(i);
    % dE/dt
    ic(j+2) = propExp(i)*pop(i);
    % dI/dt
    ic(j+3) = propInf(i)*pop(i);
    % dR/dt
    ic(j+4) = propRec(i)*pop(i);
    % dM/dt
    ic(j+5) = propMed(i)*pop(i);
    % dD/dt
    ic(j+6) = propDead(i)*pop(i);
    % dH_Sdt
    ic(j+7) = propHeld_S(i)*pop(i);
    % dH_Edt
    ic(j+8) = propHeld_E(i)*pop(i);
end


%------------------------------------------------------------------------------------------------------------------------------------------------------------------
% --Run ODE solver-----------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------------------------

[t,y] = ode45(@(t,y) COVID5C_ODE45(t,y,pars, Betas), tspan, ic);

%-----------------------

% Sums
totalSusPop = 0;
totalExpPop = 0;
totalInfPop = 0;
totalRecPop = 0;
totalMedPop = 0;
totalDeadPop = 0;
totalHeldPop = 0;

% Admin/Teaching
n = 0; % categories 1 - 4
susAdminTeach = y(:,8*n+1) + y(:,8*(n+1)+1) + y(:,8*(n+2)+1) + y(:,8*(n+3)+1);
expAdminTeach = y(:,8*n+2) + y(:,8*(n+1)+2) + y(:,8*(n+2)+2) + y(:,8*(n+3)+2);
infAdminTeach = y(:,8*n+3) + y(:,8*(n+1)+3) + y(:,8*(n+2)+3) + y(:,8*(n+3)+3);
recAdminTeach = y(:,8*n+4) + y(:,8*(n+1)+4) + y(:,8*(n+2)+4) + y(:,8*(n+3)+4);
medAdminTeach = y(:,8*n+5) + y(:,8*(n+1)+5) + y(:,8*(n+2)+5) + y(:,8*(n+3)+5);
deadAdminTeach = y(:,8*n+6) + y(:,8*(n+1)+6) + y(:,8*(n+2)+6) + y(:,8*(n+3)+6);
held_sAdminTeach = y(:,8*n+7) + y(:,8*(n+1)+7) + y(:,8*(n+2)+7) + y(:,8*(n+3)+7);
held_eAdminTeach = y(:,8*n+8) + y(:,8*(n+1)+8) + y(:,8*(n+2)+8) + y(:,8*(n+3)+8);
heldAdminTeach = held_sAdminTeach + held_eAdminTeach;


% Staff
n = 4; % categories 5 - 8
susStaff = y(:,8*n+1) + y(:,8*(n+1)+1) + y(:,8*(n+2)+1) + y(:,8*(n+3)+1);
expStaff = y(:,8*n+2) + y(:,8*(n+1)+2) + y(:,8*(n+2)+2) + y(:,8*(n+3)+2);
infStaff = y(:,8*n+3) + y(:,8*(n+1)+3) + y(:,8*(n+2)+3) + y(:,8*(n+3)+3);
recStaff = y(:,8*n+4) + y(:,8*(n+1)+4) + y(:,8*(n+2)+4) + y(:,8*(n+3)+4);
medStaff = y(:,8*n+5) + y(:,8*(n+1)+5) + y(:,8*(n+2)+5) + y(:,8*(n+3)+5);
deadStaff = y(:,8*n+6) + y(:,8*(n+1)+6) + y(:,8*(n+2)+6) + y(:,8*(n+3)+6);
held_sStaff = y(:,8*n+7) + y(:,8*(n+1)+7) + y(:,8*(n+2)+7) + y(:,8*(n+3)+7);
held_eStaff = y(:,8*n+8) + y(:,8*(n+1)+8) + y(:,8*(n+2)+8) + y(:,8*(n+3)+8);
heldStaff = held_sStaff + held_eStaff;


% Students
n = 8; % categories 9 and 10
susStud = y(:,8*n+1) + y(:,8*(n+1)+1);
expStud = y(:,8*n+2) + y(:,8*(n+1)+2);
infStud = y(:,8*n+3) + y(:,8*(n+1)+3);
recStud = y(:,8*n+4) + y(:,8*(n+1)+4);
medStud = y(:,8*n+5) + y(:,8*(n+1)+5);
deadStud = y(:,8*n+6) + y(:,8*(n+1)+6);
held_sStud = y(:,8*n+7) + y(:,8*(n+1)+7);
held_eStud = y(:,8*n+8) + y(:,8*(n+1)+8);

% Non-compliant Students
held_iStud = y(:,end);
heldStud = held_sStud + held_eStud + held_iStud;

for i = 1:80
    if mod(i,8) == 1
        totalSusPop = totalSusPop + y(:, i);
    end
    if mod (i, 8) == 2
        totalExpPop = totalExpPop + y(:, i);
    end
    if mod (i, 8) == 3
        totalInfPop = totalInfPop + y(:, i);
    end
    if mod (i, 8) == 4
        totalRecPop = totalRecPop + y(:, i);
    end
    if mod (i, 8) == 5
        totalMedPop = totalMedPop + y(:, i);
    end
    if mod (i, 8) == 6
        totalDeadPop = totalDeadPop + y(:, i);
    end
    if mod (i, 8) == 0
        totalHeldPop = totalHeldPop + y(:, i);
    end
end
totalHeldPop = totalHeldPop + y(:,end);  % add H_I for NC Students

%totalPopAfterDE = totalSusPop + totalExpPop + totalInfPop + totalRecPop + totalMedPop + totalDeadPop + totalHeldPop;

%------------------------------------------------------------------------------------------------------------------------------------------------------------------
% --Plot solutions------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------------------------



% -- colors --
suspopcolor = 1/255*[16 49 179];
exppopcolor = 1/255*[102 133 255];
infpopcolor = 1/255*[255 75 49];
recpopcolor = 1/255*[52 179 126];
medpopcolor = 1/255*[255 149 49];
heldpopcolor = 1/255*[98 140 202];

% -- figures --
FIG1=figure(1);
subplot(2,1,1)
plot(t,totalSusPop,'color', suspopcolor, 'LineWidth', 1.5) % total susceptible people
hold on
plot(t,totalExpPop,'color', exppopcolor, 'LineWidth', 1.5) % total exposed people
hold on
plot(t,totalInfPop,'color', infpopcolor, 'LineWidth', 1.5) % total infected people
hold on
plot(t,totalRecPop,'color', recpopcolor, 'LineWidth', 1.5) % total recovered people

legend('Susceptible', 'Exposed', 'Infected', 'Recovered')
title('5C SEIR Populations')
%--Change graph font size and weight--
set(gca,'FontSize',14,'fontWeight','bold')

% second subplot in figure
subplot(2,1,2)
plot(t,totalInfPop,'color', infpopcolor, 'LineWidth', 1.5) % total infected
hold on
plot(t,totalMedPop,'color', medpopcolor, 'LineWidth', 1.5) % total medical
hold on
plot(t,totalHeldPop,'color', heldpopcolor, 'LineWidth', 1.5) % total held
hold on
plot(t,totalDeadPop,'k', 'LineWidth', 1.5) % total dead 

legend('Infected', 'Medical care', 'Held', 'Dead')
title('5Cs Infections and Medical Care')
%--Change graph font size and weight--
set(gca,'FontSize',14,'fontWeight','bold') 

fprintf('Total Dead Overall=%s\n',totalDeadPop(end));

%savefig(FIG1,['Simulations/ALLClasses_icICATHDCLR_',num2str(icICATHDCLR), '_icS_',num2str(icS), '_propNC_',num2str(propNC),'_scaletracking_',num2str(scaletracking),'_scaleoutside_',num2str(scaleoutside),'.fig'])

%------------------------------------
%--Graph only admin/teaching staff---
%------------------------------------

FIG2=figure(2);

subplot(2,3,1)
plot(t,susAdminTeach,'color', suspopcolor, 'LineWidth', 1.5) % total susceptible people
hold on
plot(t,expAdminTeach,'color', exppopcolor, 'LineWidth', 1.5) % total exposed people
hold on
plot(t,infAdminTeach,'color', infpopcolor, 'LineWidth', 1.5) % total infected people
hold on
plot(t,recAdminTeach,'color', recpopcolor, 'LineWidth', 1.5) % total recovered people

legend('Susceptible', 'Exposed', 'Infected', 'Recovered')
title('Admin/Teaching Staff SEIR Populations')
%--Change graph font size and weight--
set(gca,'FontSize',14,'fontWeight','bold')

% second subplot in figure
subplot(2,3,4)
plot(t,infAdminTeach,'color', infpopcolor, 'LineWidth', 1.5) % total infected
hold on
plot(t,medAdminTeach,'color', medpopcolor, 'LineWidth', 1.5) % total medical
hold on
plot(t,heldAdminTeach,'color', heldpopcolor, 'LineWidth', 1.5) % total held
hold on
plot(t,deadAdminTeach,'k', 'LineWidth', 1.5) % total dead 

legend('Infected', 'Medical care', 'Held', 'Dead')
title('Admin/Teaching Staff Infections and Medical Care')
%--Change graph font size and weight--
set(gca,'FontSize',14,'fontWeight','bold') 

fprintf('Total Admin Dead Overall=%s\n',deadAdminTeach(end));

%-----------------------------------
%--Graph only staff-----------------
%-----------------------------------


subplot(2,3,2)
plot(t,susStaff,'color', suspopcolor, 'LineWidth', 1.5) % total susceptible people
hold on
plot(t,expStaff,'color', exppopcolor, 'LineWidth', 1.5) % total exposed people
hold on
plot(t,infStaff,'color', infpopcolor, 'LineWidth', 1.5) % total infected people
hold on
plot(t,recStaff,'color', recpopcolor, 'LineWidth', 1.5) % total recovered people

legend('Susceptible', 'Exposed', 'Infected', 'Recovered')
title('Staff SEIR Populations')
%--Change graph font size and weight--
set(gca,'FontSize',14,'fontWeight','bold')

% second subplot in figure
subplot(2,3,5)
plot(t,infStaff,'color', infpopcolor, 'LineWidth', 1.5) % total infected
hold on
plot(t,medStaff,'color', medpopcolor, 'LineWidth', 1.5) % total medical
hold on
plot(t,heldStaff,'color', heldpopcolor, 'LineWidth', 1.5) % total held
hold on
plot(t,deadStaff,'k', 'LineWidth', 1.5) % total dead 

legend('Infected', 'Medical care', 'Held', 'Dead')
title('Staff Infections and Medical Care')
%--Change graph font size and weight--
set(gca,'FontSize',14,'fontWeight','bold') 

fprintf('Total Staff Dead Overall=%s\n',deadStaff(end));

%-----------------------------------
%--Graph only students--------------
%-----------------------------------


subplot(2,3,3)
plot(t,susStud,'color', suspopcolor, 'LineWidth', 1.5) % total susceptible people
hold on
plot(t,expStud,'color', exppopcolor, 'LineWidth', 1.5) % total exposed people
hold on
plot(t,infStud,'color', infpopcolor, 'LineWidth', 1.5) % total infected people
hold on
plot(t,recStud,'color', recpopcolor, 'LineWidth', 1.5) % total recovered people

legend('Susceptible', 'Exposed', 'Infected', 'Recovered')
title('Student SEIR Populations')
%--Change graph font size and weight--
set(gca,'FontSize',14,'fontWeight','bold')

% second subplot in figure
subplot(2,3,6)
plot(t,infStud,'color', infpopcolor, 'LineWidth', 1.5) % total infected
hold on
plot(t,medStud,'color', medpopcolor, 'LineWidth', 1.5) % total medical
hold on
plot(t,heldStud,'color', heldpopcolor, 'LineWidth', 1.5) % total held
hold on
plot(t,deadStud,'k', 'LineWidth', 1.5) % total dead 

legend('Infected', 'Medical care', 'Held', 'Dead')
title('Student Infections and Medical Care')
%--Change graph font size and weight--
set(gca,'FontSize',14,'fontWeight','bold') 

fprintf('Total Students Dead Overall=%s\n',deadStud(end));

DEATH=[totalDeadPop(end),deadAdminTeach(end),deadStaff(end),deadStud(end)];
%savefig(FIG2,['Simulations/SeparateClasses_icICATHDCLR_',num2str(icICATHDCLR), '_icS_',num2str(icS), '_propNC_',num2str(propNC),'_scaletracking_',num2str(scaletracking),'_scaleoutside_',num2str(scaleoutside),'.fig'])

end
