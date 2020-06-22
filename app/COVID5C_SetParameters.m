%% Set parameters for single class COVID model

%1
alpha=  0.000678169516617; % 0.002411269034240; % 0.264427629177580; % 0.3052; % 0.3355; % .5;
%2 not in list = has its own vector
beta =  0.000000000522566; % 1.86044e-09; % 1.0284e-09;  %  6.67e-09; % susc to exp
%2
deltaI = 0.081961233707576; % 0.079634414418192; % inf to rec
%3
deltaM =   0.0129; % 0.0288653; % 0.020009336856374; % 0.018016641; % med/quar to rec
%4
gammaE =   0.013318756919848; % 0.074220410737885; % 0.0991; % 0.094297;  % 1/5.1; % exp to infected 
%5
gammaR =  0.039640136674653; % 0.133560396202893; % 1/6.7; % exp to recovered 
%6
kappa = 0; %  tracing effectiveness (between 0 and 1)
%7
Mmax =  1967; % 1845; % 2000; % Max hospital capacity parameter (this is the "leveling off" value from the data)
%8
muI =    0.000006381139258; % 0.000053858358951; % 1.75e-06; %3.50e-06; % inf to dead
%9
muM =     0.019638770031230; %0.017226112374437; % 0.004633115; % med/quar to dead
%10
omegaI =       0.034131890625090; % 0.010347067573 % 0.0068112838; % 0.007832159492399; % 0.0130;  % 0.026002854; % inf to med/quar
%11
omegaH = omegaI;  % might want to make this smaller, since "held" does not mean infected.
%12
rhoR = 1/14; % held to recovered
%13
rhoS = 1/14;  % held to susceptible
%14
sigma = 10; % contacts per infected person per day
% 15
g = 0;
% 16 
eta = .4;


