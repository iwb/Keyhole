function [ KH_geom, Reason ] = calcKeyhole(zResolution)
%calcKeyhole Berechnet die Geometrie des Keyholes.
%	Parameter ist die Diskretisierung in z-Richtung in �m.
%   R�ckgabewert ist eine 3xn Matrix. IN der ersten Spalte ist der
%   zugeh�rige z-Wert, in der zweiten der Scheitelpunkt und in der dritten
%	Spalte der Radius. Der zweite R�ckgabewert gibt den Abbruchgrund an.
<<<<<<< HEAD

run('init.m')
% Plotdata
plotdata = [];

=======
% Plotdata
plotdata = [];
>>>>>>> TestBranch
%% VHP berechnen
versatz = 0.5 * param.w0;
vhp1 = vhp_dgl(0, param);
vhp2 = vhp_dgl(versatz, param);
%% Startwerte
A0 = vhp1 / param.w0; % VHP an der Blechoberfl�che
% Radius der Schmelzfront an der Oberfl�che
alpha0 = ((vhp1 - vhp2)^2 + versatz^2) / (2 * (vhp1 - vhp2)) / param.w0;

%% Skalierung und Diskretisierung

% Diskretisierung der z-Achse
dz = -zResolution * 1e-6;
d_zeta = dz / param.w0;

% Blechdicke
max_z = 5e-3;
max_zindex = ceil(max_z/-dz);

Apex = NaN(max_zindex, 1);
Apex(1) = A0;

Radius = NaN(max_zindex, 1);
Radius(1) = alpha0;

%% Variablen f�r die Schleife
zeta = 0;
zindex = 0;

currentA = A0;
currentAlpha = alpha0;

%% Schleife �ber die Tiefe
while (true)
	
	zindex = zindex + 1;
	prevZeta = zeta;
	zeta = zeta + d_zeta;
	
	%% Nullstellensuche mit MATLAB-Verfahren
	% Variablen f�r Nullstellensuche
	arguments = struct();
	arguments.prevZeta = prevZeta;
	arguments.zeta = zeta;
	arguments.d_zeta = d_zeta;
	arguments.prevApex = currentA;
	arguments.prevRadius = currentAlpha;
	
	% Berechnung des neuen Scheitelpunktes
	func1 = @(A) khz_func1(A, arguments, param, plotdata);
	currentA = fzero(func1, currentA);
	
	% Abbruchkriterium
	if(isnan(currentA))
		Reason = struct('Num', 1, 'Name', sprintf('Abbruch weil Apex = Nan. Endg�ltige Tiefe: %3.0f\n', zeta));
		break;
	end
	if(currentA < -5)
		Reason = struct('Num', 2, 'Name', sprintf('Abbruch, weil Apex < -5. Endg�ltige Tiefe: %3.0f\n', zeta));
		break;
	end
	
	% Berechnung des Radius
	func2 = @(alpha) khz_func2(alpha, currentA, arguments, param, plotdata);
	alpha_interval(1) = 0.5*currentA; % Minimalwert
	alpha_interval(2) = 1.05 * currentAlpha; % Maximalwert
	currentAlpha = fzero(func2, alpha_interval);
	
	% Abbruchkriterium
	if(isnan(currentAlpha))
		Reason = struct('Num', 3, 'Name', sprintf('Abbruch weil Radius=Nan. Endg�ltige Tiefe: %3.0f\n', zeta));
		break;
	end
	if (currentAlpha < 1e-12)
		Reason = struct('Num', 4, 'Name', sprintf('Abbruch weil Keyhole geschlossen. Endg�ltige Tiefe: %3.0f\n', zeta));
		break;
	end
	if (zindex > 10 && currentAlpha > arguments.prevRadius)
		Reason = struct('Num', 5, 'Name', sprintf('Abbruch weil Radius steigt / KH geschlossen. Endg�ltige Tiefe: %3.0f\n', zeta));
		break;
	end
	if (zindex >= max_zindex)
		Reason = struct('Num', 6, 'Name', sprintf('Abbruch weil Blechtiefe erreicht.\n'));
		break;
	end
	
	% Werte �bernehmen und sichern
	Apex(zindex) = currentA;
	Radius(zindex) = currentAlpha;
end
zindex = zindex - 1;

KH_geom(1, :) = (0:zindex) * d_zeta;
KH_geom(2:3, 1) = [A0 - alpha0; alpha0];
KH_geom(2, 2:end) = Apex(1:zindex) - Radius(1:zindex);
KH_geom(3, 2:end) = Radius(1:zindex);

KH_geom = KH_geom .* param.w0;
end

