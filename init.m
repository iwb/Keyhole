%clear all;
%close all;
%clc;

%% Konstanten
% Dimensionsbehaftete Gr��en
param = struct();
param.kappa = 8.8119e-6; % = lambda/(rho*cp) [m2/s]
param.b1 = 1/10; % [-]
param.b2 = 3/5; % [-]
param.lambda = 30.50; % [W/(mK)]

% Materialparameter f�r Fresnel Absorption
param.epsilon=0.25;

param.Hm = 2.75e5;% + 6.3e6; % [J/kg]

param.w0 = 25e-6; % 25�m Strahlradius [m]
param.P = 2000; % [W]
param.I0 = param.P * 2/(pi*param.w0^2); % [W/m2]
param.v = 1.3823; % [m/s]

param.waveLength = 1064e-9; % Wellenl�nge des Lasers [m]

param.rho = 7035; % [kg/m^3]
param.cp = 492; % [J / kg K]

param.Tm = 1793; % [K] Schmelztemperatur
param.Tv = 3133; % [K] Verdampfungstemperatur
param.T0 = 300; % [K] Umgebungstemperatur

param.fokus = 0e-6; % Fokusabstand zur Bauteiloberfl�che [m]

param.Rl = pi * param.w0^2 / param.waveLength; % Ideale Rayleighl�nge [m]
%param.Rl = 171e-6; % Rayleighl�nge [m]

% Skallierte Gr��en
param.scaled = struct();
% Rayleighl�nge
param.scaled.Rl = param.Rl / param.w0; % [-]
% Skalierter Vorschub
param.scaled.Pe = param.w0/param.kappa * param.v;
% Skalierte Maximalintensit�t
param.scaled.gamma = param.w0 * param.I0 / (param.lambda * (param.Tv - param.T0));
% Entdim. Schmelzenthlapie
param.scaled.hm = param.Hm / (param.cp*(param.Tv - param.T0));
% Skalierte Wellenl�nge des Lasers
param.scaled.waveLength = param.waveLength / param.w0;
% Skalierter Fokus
param.scaled.fokus = param.fokus / param.w0;