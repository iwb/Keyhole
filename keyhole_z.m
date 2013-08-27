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
while (currentA > -2)
    
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
        fprintf('Abbruch wegen Apex=Nan. Endgültige Tiefe: %3.0f\n', zeta);
        break;
    end
    
    % Berechnung des Radius
    func2 = @(alpha) khz_func2(alpha, currentA, arguments, param, []);
    alpha_interval(1) = 0; % Minimalwert
    alpha_interval(2) = 3*alpha0; % Maximalwert
    currentAlpha = fzero(func2, alpha_interval);
    
    % Abbruchkriterium
    if(isnan(currentAlpha))
        fprintf('Abbruch wegen Radius=Nan. Endgültige Tiefe: %3.0f\n', zeta);
        break;
    end
    % Plotdata befüllen lassen
    khz_func1(currentA, arguments, param, plotdata);
    % Plotdata befüllen lassen
    khz_func2(currentAlpha, currentA, arguments, param, plotdata);
    
    % Werte übernehmen und sichern
    Apex.Add(currentA);
    Radius.Add(currentAlpha);
    
    if (0)
        xx = linspace(-A0, arguments.prevApex, 100);
        for ii=1:100
            yy(ii)=func1(xx(ii));
        end
        plot(xx, yy);
        xlim([-1 1]*A0);
        ylim([-1 8])
        refline(0,0);
        drawnow;
        
%         
%         xx = linspace(-2*alpha0, 3*alpha0, 100);
%         for ii=1:100
%             yy(ii)=func2(xx(ii));
%         end
%         plot(xx, yy);
%         refline(0,0);
%         drawnow;
        
    end
    
    if (zindex > 60 && currentAlpha >  arguments.prevRadius)
       disp ''; 
    end
    
    % Plot    
    plotdata.z_axis = horzcat(plotdata.z_axis, zeta);
    if mod(zindex, 10) == 0
        
        fprintf('Aktuelle Tiefe z=%5.2fµm, r=%8.3fµm\n', zeta*param.w0*1e6, currentAlpha*param.w0*1e6);
        
        plotKeyhole(plotdata, param);
    end
end

plotKeyhole(plotdata, param);

fprintf('Endgültige Tiefe: z=%5.0fµm\n', zeta*param.w0*1e6);




