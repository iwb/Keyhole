% Skript zur Durchführung einer Parameterstudie für die Keyholeberechnung
clear all; close all; clc;
%% Initialisierung und Festlegung der Bereiche
addpath 'E:\sw\Keyhole'
fmax = 2000; % [Hz]
Amax = 1e-3; % [m]
vsmax = 12/60; % [m/s]
vmax = sqrt(vsmax^2+(2*pi*fmax*Amax)^2+4*pi*fmax*Amax*vsmax); % [m/s]
% Auflösung in z-Richtung
dz = 20; % [µm]
% Bereiche
v = 1/60:10/60:vmax; % [m/s]
P = 1000:25:3000; % [W]
% Vorbelegung
run('init.m');
KH = cell(length(v), length(P));
%% Zyklischer Aufruf des Keyhole-Modells
for i = 1:length(v)
    for j = 1:length(P)
        % Parameterfestlegung
        param.scaled.Pe = param.scaled.Pe/param.v*v(i);
        param.I0 = (P(j)/param.P)*param.I0; % [W/m2]
        param.scaled.gamma = param.w0 * param.I0 / (param.lambda * (param.Tv - param.T0));
        param.v = v(i);
        param.P = P(j);   
        % Parameter ausgeben
        fprintf('==========================================\n');
        fprintf('Berechnung %0.0f von %0.0d\n', (i-1)*length(P)+j, length(P)*length(v));
        fprintf('Vorschub: %0.2f m/s, Leistung: %0.0f W\n', param.v, param.P);
        % Keyhole berechnen
        try
            [KH_geom, Reason] = calcKeyhole(dz, param);
            KH{i,j}.geom = KH_geom;
            KH{i,j}.reason = Reason;
            KH{i,j}.t = min(KH_geom(1,:));
            KH{i,j}.b = KH_geom(3,1);
            fprintf('Tiefe: %0.0f µm, Breite: %0.0f µm\n', min(KH_geom(1,:))*1e6, KH_geom(3,1)*1e6);
        catch
            KH{i,j}.geom = nan;
            KH{i,j}.reason = nan;
            KH{i,j}.t = nan;
            KH{i,j}.b = nan;
            fprintf('Die Berechnung konnte nicht fertig gestellt werden.\n');
        end
        KH{i,j}.v = v(i);
        KH{i,j}.P = P(i);
        fprintf('==========================================\n');
    end
end

%% Shutdown und Speichern
clear i j KH_geom Reason fmax Amax vsmax dz vmax param
save('KH_sweep.mat');

