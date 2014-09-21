% Skript zur Durchführung einer Parameterstudie für die Keyholeberechnung
%% Initialisierung und Festlegung der Bereiche
addpath 'C:\Users\Markus\Documents\Dissertation\Berechnungen\Keyhole'
fmax = 2000; % [Hz]
Amax = 1e-3; % [m]
vsmax = 12/60; % [m/s]
vmax = sqrt(vsmax^2+(2*pi*fmax*Amax)^2+4*pi*fmax*Amax*vsmax); % [m/s]
% Auflösung in z-Richtung
dz = 20; % [µm]
% Bereiche
v = 1/60:10/60:vmax; % [m/s]
P = 1000:25:3000; % [W]
% Parallelverarbeitung
poolobj = parpool(1);
% Vorbelegung
run('init.m');
KH = cell(length(v), length(P));
%% Zyklischer Aufruf des Keyhole-Modells
for i = 1:length(v)
    parfor j = 1:length(P)
        % Parameterfestlegung
        param.scaled.Pe = param.scaled.Pe/param.v*v(i);
        param.v = v(i);
        param.P = P(j);   
        % Parameter ausgeben
        if poolobj.NumWorkers == 1
            fprintf('==========================================\n');s
            fprintf('Vorschub: %0.1f m/s, Leistung: %0.0f W\n', param.v, param.P);
            fprintf('==========================================\n');
        end
        % Keyhole berechnen
        [KH_geom, Reason] = calcKeyhole(dz);
        KH{i,j}.geom = KH_geom;
        KH{i,j}.reason = Reason;
        KH{i,j}.t = 
    end
end

%% Shutdown und Speichern
delete(poolobj);
clear i j KH_geom Reason fmax Amax vsmax dz
save(KH_sweep.mat);

