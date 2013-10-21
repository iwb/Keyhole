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
dz = -1e-6;
d_zeta = dz / param.w0;

Apex = List();
Apex.EnsureCapacity(1000);
Apex.Add(A0);

Radius = List();
Radius.EnsureCapacity(1000);
Radius.Add(alpha0);

%% Variablen für die Schleife
zeta = 0;
prevZeta = 0;
zindex = 0;

currentA = A0;
currentAlpha = alpha0;

% Plotdaten
plotdata = struct();
plotdata.Apex = Apex;
plotdata.Radius = Radius;
plotdata.Angle = List();
plotdata.Intensity = List();
plotdata.HeatFlow = List();
plotdata.Fresnel = List();
plotdata.z_axis = 0;

plotdata.Angle.Add(NaN);
plotdata.Intensity.Add(NaN);
plotdata.HeatFlow.Add(NaN);
plotdata.Fresnel.Add(NaN);

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
    if(currentA < -3)
        fprintf('Abbruch, weil Apex < -3. Endgültige Tiefe: %3.0f\n', zeta);
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
    if (zindex * dz <= -5e-3)
        fprintf('Abbruch weil Blechtiefe erreicht.\n');
        break;
    end
    
    % Plotdata befüllen lassen
    khz_func1(currentA, arguments, param, plotdata);
    % Plotdata befüllen lassen
    khz_func2(currentAlpha, currentA, arguments, param, plotdata);
    
    % Werte übernehmen und sichern
    Apex.Add(currentA);
    Radius.Add(currentAlpha);
    
    % Plot
    plotdata.z_axis = horzcat(plotdata.z_axis, zeta);
    if mod(zindex, 20) == 0
        
        fprintf('Aktuelle Tiefe z=%5.2fµm, r=%8.3fµm, A=%8.3fµm\n', zeta*param.w0*1e6, currentAlpha*param.w0*1e6, currentA*param.w0*1e6);
        
        plotKeyhole(plotdata, param);
    end
	
	
    if (0)
        xx = linspace(-A0, A0, 1000);
        yy = zeros(1, 1000);
        for ii=1:1000
            yy(ii)=func1(xx(ii));
        end
        plot(xx, yy);
        ylimit = [-1 1] .* 10;
        xlim([-1 1]*A0);
        ylim(ylimit)
        refline(0,0);
        line([1 1] .* arguments.prevApex, ylimit);
        drawnow;
	end
	if(0)
        %
		%figure;
		plotKeyhole(plotdata, param);
		
        xx = linspace(0, 2*alpha0, 1000);
        yy = zeros(1, 1000);
        for ii=1:1000
            yy(ii)=func2(xx(ii));
        end
        plot(xx, yy);
        refline(0,0);
        ylimit = [-1 1] .* 1e2;
        ylim(ylimit);
        hold all;
        
        line([1 1] .* alpha_interval(1), ylimit);
        line([1 1] .* alpha_interval(2), ylimit);
        
        drawnow;
        xlim([0 2] .* alpha0);
	end
end

plotKeyhole(plotdata, param);
%xlim([-1.5 1.5]);
%ylim([-1e-3/param.w0 0]);
% figure;
% plot(Radius.ToArray());

fprintf('Endgültige Tiefe: z=%5.0fµm\n', zeta*param.w0*1e6);




