% LA County Data - April 20, 2020 (START DATE)  through May 16, 2020
    ConfCase=[13823	15165	16449	17567	18545	19159	19567	20460	21017	22522	23233	24262	24936	25699	26238	27866	28665	29526	30334	31241	31703	32269	33247	34552	35447	36324	37374];
    Deaths=[619	666	732	798	850	896	916	948	1004	1065	1119	1174	1212	1231	1260	1315	1369	1420	1470	1515	1531	1570	1617	1663	1711	1752	1793];
    Hpatient=[2393	2471	2448	2458	2406	2417	2462	2549	2543	2550	2364	2395	2380	2299	2371	2370	2292	2323	2276	2221	2270	2310	2248	2351	2207	2201	2086];
    ten_dayCum = 5370;
    CumTo10DayStart = 8453;
%Total Population considered for outbreak
    TotalPopulation = 9651332; 
% Find factors to scale parameters in the 
% low (< 65)  versus high-risk  (>=65) age groups
% The affected parameters are omega_I, omega_H, mu_I, mu_H, delta_I,
% delta_M 
% These numbers are from the LA County public health website, June 11, 2020
pop_old  = 1172554;
pop_young  = 6381782;
cases_old = 10562;
cases_young = 63567;
deaths_old = 1956;
deaths_young = 625;
frac_mu = (deaths_old/cases_old)/(deaths_young/cases_young);
% Assume that the hospitalization (omega) and  death (mu)  rate for
% college-age students is .1* rate for <65 population.
frac_mu_student = .1;

% for the length of hospital stay, used LA County data, see
% RacialEthnicSocioeconomicDataCOVID19, through April 12
pop_low = 227;
stay_length_low = 5.04;
pop_high = 70;
stay_length_high = 6.60;
total_pop_hosp = pop_low + pop_high;
frac_delta = stay_length_low/stay_length_high;
% using data from LA County for length of hospital stay
stay_length_student = 2;
frac_delta_student  =  stay_length_low/stay_length_student;



