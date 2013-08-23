%% Errechnet das Keyhole in Z-Richtung

fprintf('Keyhole Berechnung\n')
run('init.m')
clc

%% VHP berechnen
versatz = 0.5 * param.w0;

vhp1 = vhp_dgl(0, param);
vhp2 = vhp_dgl(versatz, param);


%% Startwerte
A0 = vhp1  / param.w0; % VHP an der Blechoberfl�che
% Radius der Schmelzfront an der Oberfl�che
alpha0 = ((vhp1 - vhp2)^2 + versatz^2) / (2 * (vhp1 - vhp2)) / param.w0;

%% Skalierung und Diskretisierung

% Diskretisierung der z-Achse
dz = -5e-6;
d_zeta = dz/param.w0;

Apex = java.util.ArrayList();
Apex.ensureCapacity(1000);
Apex.add(A0);

Radius =java.util.ArrayList();
Radius.ensureCapacity(1000);
Radius.add(alpha0);

%% Variablen f�r die Schelife
zeta = 0;
prevZeta = 0;
zindex = 0;

currentA = A0;
currentAlpha = alpha0;

% Plotdaten
plotdata = struct();
plotdata.Apex = Apex;
plotdata.Radius = Radius;
plotdata.Angle = java.util.ArrayList();
plotdata.Intensity = java.util.ArrayList();
plotdata.HeatFlow = java.util.ArrayList();
plotdata.z_axis = 0;

plotdata.Angle.add(0);
plotdata.Intensity.add(0);
plotdata.HeatFlow.add(0);

h = NaN;

%% Schleife �ber die Tiefe
while (currentA > -2)
    
    zindex = zindex + 1;
    prevZeta = zeta;
    zeta = zeta + d_zeta;
    
    %% Nullstellensuche mit MATLAB-Verfahren
    % Variablen f�r Nullstellensuche
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
        fprintf('Abbruch wegen Apex=Nan. Endg�ltige Tiefe: %3.0f\n', zeta);
        break;
    end
    
    % Berechnung des Radius
    func2 = @(alpha) khz_func2(alpha, currentA, arguments, param, []);
    alpha_interval(1) = 0; % Minimalwert
    alpha_interval(2) = 2*alpha0; % Maximalwert
    currentAlpha = fzero(func2, alpha_interval);
    
    % Abbruchkriterium
    if(isnan(currentAlpha))
        fprintf('Abbruch wegen Radius=Nan. Endg�ltige Tiefe: %3.0f\n', zeta);
        break;
    end
    % Plotdata bef�llen lassen
    khz_func1(currentA, arguments, param, plotdata);
    % Plotdata bef�llen lassen
    khz_func2(currentAlpha, currentA, arguments, param, plotdata);
    
    % Werte �bernehmen und sichern
    Apex.add(currentA);
    Radius.add(currentAlpha);
    
    if (true)
        xx = linspace(-1, 3, 100);
        for ii=1:100
            yy(ii)=func2(xx(ii));
        end
        plot(xx, yy);
        refline(0,0);
        drawnow;
    end
    
    if (zindex > 60 && currentAlpha >  arguments.prevRadius)
       disp ''; 
    end
    
    % Plot    
    plotdata.z_axis = horzcat(plotdata.z_axis, zeta);
    if mod(zindex, 1) == 0
        
        fprintf('Aktuelle Tiefe z=%5.2f, r=%8.3f\n', zeta, currentAlpha);
        
        %plotKeyhole(plotdata, param);
    end
end

plotKeyhole(plotdata, param);


fprintf('Endg�ltige Tiefe: z=%5.0f �m\n', zeta *-param.w0/1e-6);




