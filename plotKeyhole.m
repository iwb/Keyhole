%% Skript zur grafischen Ausgabe der Keyhole-Geometrie
% Erwartete Variable
% KH_geom: 3 x n Matrix (Zeile 1: z-Koordinaten, Zeile 2: Kreismittelpunkte, Zeile 3: Radii)

% Überführen in lokale Variablen
z = KH_geom(1,:)';
x0 = KH_geom(2,:)';
r = KH_geom(3,:)';

% Initialisierung
nx = 25; % (Halbe) Anzahl der x-Werte pro z-Schicht

% Anlegen der Datenstruktur
KH = cell(size(KH_geom,2),1);

% Berechnung der Werte für jede z-Schicht
for i = 1 : 1 : length(z)
    KH{i} = struct('z', [], 'x0', [], 'r', [], 'x', zeros(2 * nx, 1), 'y', zeros(2 * nx, 1));
    KH{i}.z = z(i);
    KH{i}.x0 = x0(i);
    KH{i}.r = r(i);
    KH{i}.x(1 : nx) = linspace(x0(i) - r(i), x0(i) + r(i), nx);
    KH{i}.x(nx + 1 : 2 * nx) = flip(KH{i}.x(1 : nx));
    KH{i}.y(1 : nx) = real(sqrt(KH{i}.r^2 - (KH{i}.x(1 : nx) - KH{i}.x0).^2));
    KH{i}.y(nx + 1 : 2 * nx) = -KH{i}.y(1 : nx);
end

% Grafische Ausgabe

fig = figure;
set(fig,'Units','Centimeters')
set(fig, 'Position', [1 1 15.5 10]);
for i = 1 : 1 : numel(KH)
   plot3(KH{i}.x,KH{i}.y, ones(2 * nx) * KH{i}.z, 'Color', [0 0 0]);
   hold on;
end
set(gca, 'FontName', 'Arial', 'Fontsize', 13);
grid on;
xlabel('{\itx}-Koordinate','FontName', 'Arial', 'Fontsize', 13);
ylabel('{\ity}-Koordinate','FontName', 'Arial', 'Fontsize', 13);
zlabel('{\itz}-Koordinate','FontName', 'Arial', 'Fontsize', 13);
% daspect([1 1 25]);