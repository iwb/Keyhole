%% Errechnet das Keyhole in Z-Richtung

fprintf('Keyhole Berechnung\n')
run('init.m')
clc

%% VHP berechnen
versatz = 0.5 * param.w0;
vhp1 = vhp_dgl(0, param);
vhp2 = vhp_dgl(versatz, param);
%% Startwerte
A0 = vhp1 / param.w0; % VHP an der Blechoberfläche
% Radius der Schmelzfront an der Oberfläche
alpha0 = ((vhp1 - vhp2)^2 + versatz^2) / (2 * (vhp1 - vhp2)) / param.w0;

%% Skalierung und Diskretisierung

% Diskretisierung der z-Achse
dz = -5e-6;
d_zeta = dz / param.w0;

% Blechdicke
max_z = 5e-3;
max_zindex = ceil(max_z/-dz);

Apex = NaN(max_zindex, 1);
Apex(1) = A0;

Radius = NaN(max_zindex, 1);
Radius(1) = alpha0;

%% Variablen für die Schleife
zeta = 0;
prevZeta = 0;
zindex = 0;

currentA = A0;
currentAlpha = alpha0;

%% Schleife über die Tiefe
while (true)
	
	zindex = zindex + 1;
	prevZeta = zeta;
	zeta = zeta + d_zeta;
	
	%% Nullstellensuche mit MATLAB-Verfahren
	% Variablen für Nullstellensuche
	arguments = struct();
	arguments.prevZeta = prevZeta;
	arguments.zeta = zeta;
	arguments.prevApex = currentA;
	arguments.prevRadius = currentAlpha;
	
	% Berechnung des neuen Scheitelpunktes
	func1 = @(A) khz_func1(A, arguments, param, []);
	currentA = fzero(func1, currentA);
	
	% Abbruchkriterium
	if(isnan(currentA))
		fprintf('Abbruch weil Apex = Nan. Endgültige Tiefe: %3.0f\n', zeta);
		break;
	end
	if(currentA < -5)
		fprintf('Abbruch, weil Apex < -5. Endgültige Tiefe: %3.0f\n', zeta);
		break;
	end
	
	% Berechnung des Radius
	func2 = @(alpha) khz_func2(alpha, currentA, arguments, param, []);
	alpha_interval(1) = 0.5*currentA; % Minimalwert
	alpha_interval(2) = 1.05 * currentAlpha; % Maximalwert
	currentAlpha = fzero(func2, alpha_interval);
	
	% Abbruchkriterium
	if(isnan(currentAlpha))
		fprintf('Abbruch weil Radius=Nan. Endgültige Tiefe: %3.0f\n', zeta);
		break;
	end
	if (currentAlpha < 1e-12)
		fprintf('Abbruch weil Keyhole geschlossen. Endgültige Tiefe: %3.0f\n', zeta);
		break;
	end
	if (zindex > 10 && currentAlpha > arguments.prevRadius)
		fprintf('Abbruch weil Radius steigt / KH geschlossen. Endgültige Tiefe: %3.0f\n', zeta);
		break;
	end
	if (zindex >= max_zindex)
		fprintf('Abbruch weil Blechtiefe erreicht.\n');
		break;
	end
	
	% Werte übernehmen und sichern
	Apex(zindex) = currentA;
	Radius(zindex) = currentAlpha;
end

Apex = Apex(1:zindex-1);
Radius = Radius(1:zindex-1);

fprintf('Endgültige Tiefe: z=%5.0fµm\n', zeta*param.w0*1e6);




