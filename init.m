%clear all;
close all;
%clc;

fprintf('==========================================\n');

%% Konstanten
% Dimensionsbehaftete Größen
param = struct();
param.kappa = 6.7e-6; % = lambda/(rho*cp) [m2/s]
param.b1 = 1/10; % [-]
param.b2 = 3/5; % [-]
param.lambda = 33.63; % [W/(mK)]

% Materialparameter für Fresnel Absorption
param.epsilon=0.25;

param.Hm = 2.75e5; % [J/kg]

param.w0 = 25e-6; % 25µm Strahlradius [m]
param.P = 100; % [W]
param.I0 = param.P * 2/(pi*param.w0^2); % [W/m2]
param.v = 13.5/60; % [m/s]

param.waveLength = 1064e-9; % Wellenlänge des Lasers [m]

param.rho = 7033; % [kg/m^3]
param.cp = 711.4; % [J / kg K]

param.Tm = 1811; % [K] Schmelztemperatur
param.Tv = 3273; % [K] Verdampfungstemperatur
param.T0 = 300; % [K] Umgebungstemperatur

param.fokus = 0e-6; % Fokusabstand zur Bauteiloberfläche [m]

param.Rl = 0.7e-3; % Rayleighlänge [m]
%param.Rl = pi * param.w0^2 / param.waveLength; % Ideale Rayleighlänge [m]

% Skallierte Größen
param.scaled = struct();
% Rayleighlänge
%param.scaled.Rl = pi * param.w0 / param.waveLength; % [-]
param.scaled.Rl = 0.7e-3 / param.w0; % [-]
% Skalierter Vorschub
param.scaled.Pe = param.w0/param.kappa * param.v;
% Skalierte Maximalintensität
param.scaled.gamma = param.w0 * param.I0 / (param.lambda * (param.Tv - param.T0));
% Entdim. Schmelzenthlapie
param.scaled.hm = param.Hm / (param.cp*(param.Tv - param.T0));
% Skalierte Wellenlänge des Lasers
param.scaled.waveLength = 1064e-9 / param.w0;
% Skalierter Fokus
param.scaled.fokus = 0e-6 / param.w0;

%% Parameter ausgeben
fprintf('Vorschub: %0.1f m/s, Leistung: %0.0f W\n', param.v, param.P);

fprintf('==========================================\n');