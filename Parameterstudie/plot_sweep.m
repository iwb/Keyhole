% Skript zum Plotten der Keyhole-Geoemtrie
%% Daten laden
load('KH_sweep.mat');
%% Überführen in lokale Variablen
[nv, nP] = size(KH);
t = nan(nv, nP);
b = t;
reas = t;
vv = t;
PP = t;
for i = 1:nv
    for j = 1:nP
        t(i,j) = KH{i,j}.t;
        b(i,j) = KH{i,j}.b;
        reas(i,j) = KH{i,j}.reason.Num;
        vv(i,j) = KH{i,j}.v;
        PP(i,j) = KH{i,j}.P;
    end
end
%% Plotten
% [vv, PP] = meshgrid(P, v);
contourf(vv, PP, t);
figure;
contourf(vv, PP, b);
figure;
contourf(vv, PP, reas);
