% Skript zur Durchführung einer Parameterstudie für die Keyholeberechnung
clear all; close all; clc;
%% Initialisierung und Festlegung der Bereiche
addpath 'C:\Users\Markus\Documents\Dissertation\Berechnungen\Keyhole'
fmax = 2000; % [Hz]
Amax = 1e-3; % [m]
vsmax = 12/60; % [m/s]
vmax = sqrt(vsmax^2+(2*pi*fmax*Amax)^2+4*pi*fmax*Amax*vsmax); % [m/s]
% Auflösung in z-Richtung
dz = 20; % [µm]
% Bereiche
v = [5/60 6/60];%1/60:10/60:vmax; % [m/s]
P = [2000 3000]; %1000:25:3000; % [W]
% Vorbelegung
run('init.m');
KH = cell(length(v), length(P));
%% Zyklischer Aufruf des Keyhole-Modells
for i = 1:length(v)
    for j = 1:length(P)
        % Parameterfestlegung
        param.scaled.Pe = param.scaled.Pe/param.v*v(i);
        param.v = v(i);
        param.P = P(j);   
        % Parameter ausgeben
        fprintf('==========================================\n');
        fprintf('Berechnung %0.0f von %0.0d\n', (i-1)*length(P)+j, length(P)*length(v));
        fprintf('Vorschub: %0.2f m/s, Leistung: %0.0f W\n', param.v, param.P);
        fprintf('==========================================\n');
        % Keyhole berechnen
        [KH_geom, Reason] = calcKeyhole(dz);
        KH{i,j}.geom = KH_geom;
        KH{i,j}.reason = Reason;
        KH{i,j}.t = min(KH_geom(1,:));
        KH{i,j}.b = KH_geom(3,1);
    end
end

%% Shutdown und Speichern
clear i j KH_geom Reason fmax Amax vsmax dz vmax param
save('KH_sweep.mat');

