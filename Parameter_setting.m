%%
clc
clear all
close all
%% Pamerter may vary depending on user settings.

%% Global variable declaration

global Alpha PCp PCa CSEv SEv CSEg MING MINL MAXG MAXL Pcap Acap CCOM CLIQ CCG ...
    CCL CSOCG CSOCL CDISG CDISL SGcap SLcap DISGcap DISLcap COMcap LIQcap ...
    SOC0G SOC0L CGcap CLcap MPC

%% Initial parameter

S = 3;
sample_num = 500;
Epoch = 50;
t = 1;

%% HSCN Parameter
Alpha = [1500];
PCp = 67;
PCa = 63;
CSEv = 5*10^8;
MING = 3500;
MINL = 2500;
MAXG = 5000;
MAXL = 4000;
Pcap = 8000;
Acap = 8000;
CGcap = 8500;
CLcap = 8300;
CCOM = 0.74;
CLIQ = 0.47;
COMcap = 9000;
LIQcap = 9000;
CCG = 0.43;
CCL = 0.27;
CSOCG = 0.65;
CSOCL = 0.46;
SGcap = 9000;
SLcap = 9000;
CDISG = 0.83;
CDISL = 0.41;
SOC0G = 1000;
SOC0L = 1000;
Hmin = 10;
MPC = 10^8;

%% Uncertainty parameter

load('DG_1010.mat');
load('DL_1010.mat');
load('DISGcap_1010.mat');
load('DISLcap_1010.mat');
load('De_ksi_prob_1.mat')
load('DISG_ksi_prob_1.mat')

%% Cost parameter
MA = [2.5*10^8, 37];
Mu = [7.5, 8];
Sigma = [0.12, 0.1];

%% Renewable energy electricity and Market electrcitity price
SEV_list=[];
for t = 1:12
    SEv = MA(1) * exp(-(t-Mu(1))^2 / 2*Sigma(1)^2);
    CSEg = MA(2) * exp(-(t-Mu(2))^2 / 2*Sigma(2)^2);   
    SEV_list(t,1) = SEv;    
end