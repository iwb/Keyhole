% Skript zum Plotten der Keyhole-Geoemtrie
%% Daten laden
load('KH_sweep.mat');
%% Überführen in lokale Variablen
[nv, nP] = size(KH);
t = zeros(nv, nP);
b = t;
reas = t;
vv = t;
PP = t;
for i = 1:nv
    for j = 1:nP
        t(i,j) = KH{i,j}.t;
        b(i,j) = KH{i,j}.b;
        vv(i,j) = KH{i,j}.v;
        PP(i,j) = KH{i,j}.P;
        if isstruct(KH{i,j}.reason)
            reas(i,j) = KH{i,j}.reason.Num;
        else
            reas(i,j) = KH{i,j}.reason;
        end
    end
end
%% Plotten
% [vv, PP] = meshgrid(P, v);
surf(PP, vv, t);
figure;
contourf(vv, PP, b);
figure;
surf(vv, PP, reas);
