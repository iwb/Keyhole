%clear all;
close all;
%clc;

fprintf('==========================================\n');

param = struct();

%% Konstanten
param.kappa = 6.7e-6; % = lambda/(rho*cp) [m2/s]
param.b1 = 1/10; % [-]
param.b2 = 3/5; % [-]
param.lambda = 33.63; % [W/(mK)]

% Materialparameter f�r Fresnel Absorption
param.epsilon=0.25;

param.Hm = 2.75e5; % [J/kg]

param.w0 = 25e-6; % 25�m Strahlradius [m]
param.P = 3000; % [W]
param.I0 = param.P/(2 * pi*param.w0^2); % [W/m2]
param.v = 15; % [m/s]

param.waveLength = 1064e-9; % Wellenl�nge des Lasers [m]

param.rho = 7033; % [kg/m^3]
param.cp = 711.4; % [J / kg K]

param.Tm = 1811; % [K] Schmelztemperatur
param.Tv = 3273; % [K] Verdampfungstemperatur
param.T0 = 300; %[K] Umgebungstemperatur

param.fokus = 0;

param.Rl = pi * param.w0 / param.waveLength; % [m]

param.scaled = struct();
% Skalierter Vorschub
param.scaled.Pe = param.w0/param.kappa * param.v;
% Skalierte Maximalintensit�t
param.scaled.gamma = param.w0 * param.I0 / (param.lambda * (param.Tv - param.T0));
% Entdim. Schmelzenthlapie
param.scaled.hm = param.Hm / (param.cp*(param.Tv - param.T0));

%% Parameter ausgeben
fprintf('Vorschub: %0.1f m/s, Leistung: %0.0f W\n', param.v, param.P);

fprintf('==========================================\n');