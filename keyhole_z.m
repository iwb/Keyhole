%% Errechnet das Keyhole in Z-Richtung

fprintf('Keyhole Berechnung\n')
run('init.m')
clc

%% VHP berechnen
versatz = 0.5 * param.w0;

vhp1 = vhp_dgl(0, param);
vhp2 = vhp_dgl(versatz, param);


%% Startwerte
A0 = vhp1  / param.w0; % VHP an der Blechoberfläche
% Radius der Schmelzfront an der Oberfläche
alpha0 = ((vhp1 - vhp2)^2 + versatz^2) / (2 * (vhp1 - vhp2)) / param.w0;

%% Skalierung und Diskretisierung

%I = @(distance) param.I0 * exp(-distance.^2 ./ (2 * param.w0^2)); % [W/m^2]

% Diskretisierung der z-Achse
dz = -10e-6;
d_zeta = dz/param.w0;

A = zeros(1,100);
alpha = zeros(1,100);

A(1) = A0;
alpha(1) = alpha0;

%% Iteration über die z-Achse
zeta = 0;
prevZeta = 0;
zindex = 1;
deltaA = 10;
deltaAlpha = 10;
loopindex = 1;

MyPlotArray = zeros(2, 0);
global AAzz mu;

figure;

%% Schleife über die Tiefe
while (A(zindex) > -2)
	
    prevZeta = zeta;
    zeta = zeta + d_zeta;
    zindex = zindex + 1;
    
    if zindex > numel(A)
        A(zindex * 2) = 0;
        alpha(zindex * 2) = 0;
    end
    
    %% Nullstellensuche mit MATLAB-Verfahren
    % Variablen für Nullstellensuche
    arguments = struct();
    arguments.prevZeta = prevZeta;
    arguments.zeta = zeta;
    arguments.prevA = A(zindex-1);
    arguments.prevAlpha = alpha(zindex-1);
    
    % Berechnung des Scheitelpunktes
    func1 = @(A) khz_func1(A, arguments, param);
    A(zindex) = fzero(func1, A(zindex-1));
    
    MyPlotArray(1, end+1) = AAzz;
    MyPlotArray(2, end) = mu;
    
    if mod(loopindex, 10) == 0
       subplot(2,1,1);
       plot(MyPlotArray(1, :));
       hold all;
       plot(MyPlotArray(2, :));
       hold off;
       drawnow;        
    end
    
    % Abbruchkriterium
    if(isnan(A(zindex)))
       A = A(1:zindex-1);
       alpha = alpha(1:zindex-1);
       fprintf('Abbruch wegen A=Nan. Endgültige Tiefe: %3.0f\n', zeta);
       break;
    end
    
    % Berechnung des Radius
    func2 = @(alpha) khz_func2( alpha, A(zindex), arguments, param);
    alpha_interval(1) = max(A(zindex), 0); % Minimalwert
    alpha_interval(2) = alpha(zindex-1); % Maximalwert
    alpha(zindex) = fzero(func2, alpha_interval(2));
    
%     if (A(zindex) - 2*alpha(zindex) > A(zindex-1) - 2*alpha(zindex-1))
%         % Der Radius darf eigentlich nicht mehr wachsen....
%         alpha(zindex) = alpha(zindex-1);
%     end

%     if (zindex > 75)
%         expected_radius = 2*alpha(zindex-1) - alpha(zindex-2);
%         if (alpha(zindex) > expected_radius)
%             % Der Radius darf eigentlich nicht mehr wachsen....
%             alpha(zindex) = expected_radius;
%         end
%     end
        
    
    % Abbruchkriterium
    if(isnan(alpha(zindex)))
       A = A(1:zindex-1);
       alpha = alpha(1:zindex-1);
       fprintf('Abbruch wegen alpha=Nan. Endgültige Tiefe: %3.0f\n', zeta);
       break;
    end
    
    if (false)
        xx = linspace(0, 3, 100);
        for ii=1:100
            yy(ii)=func1(xx(ii));
        end
        plot(xx, yy);
    end
    
    % Plot
    if mod(loopindex, 10) == 0
        
        fprintf('Aktuelle Tiefe z=%3.0f, r=%8.3f\n', zeta, alpha(zindex));
        
        subplot(2,1,2);
        plot(A);
        hold all;
        plot(A-2*alpha);
        hold off;
        drawnow;
    end
    
    loopindex = loopindex + 1;    
end

plot(A);
hold all;
plot(A-2*alpha);
hold off;


figure;
plot(alpha);


fprintf('Endgültige Tiefe: z=%5.0f µm\n', zeta *-param.w0/1e-6);

%     % Berechnung der drei DGLs
%     deltaA = (1/(1 + hm - param.b1) * (gamma*qa0 - param.b1/Q(i)));
%     A(i+1,1) = A(i,1) + deltaA*d_tau;
%
%     deltaAlpha = (1/(1 + hm) * ((gamma*qa2 - param.b2/Q(i)) + ...
%         (1 + hm + param.b2)/(1 + hm - param.b1) * (gamma*qa0 - param.b1/Q(i))));
%     alpha(i+1,1) = alpha(i,1) + deltaAlpha*d_tau;
%
%     deltaQ = (gamma*qa0 - (1 + hm)*deltaA/d_tau);
%     Q(i+1,1) = Q(i,1) + deltaQ*d_tau;
%










