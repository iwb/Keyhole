%% Errechnet den Vorheizpunkt mit Hilfe der impliziten Finite-Volumen-Methode
% Implizite Formulierung, 2D Betrachtung, 1D-Wärmeleitung
%clc;

fprintf('Finite Volumen Methode (einfach)\n')
run('init.m')

%% Diskretisierung in Z-Richtung (Blechtiefe)
num_z = 500;
z = linspace(0, 100e-6, num_z);
step_z = z(2) - z(1);

%% Diskretisierung der Zeit
steps_t = 3000;
dt = xOffset / (v * (steps_t-1));
t = 0 : dt : xOffset/v;

%% Vorbereitung
TempArray = ones(num_z, 1) * T0;

%% Konvergenz checken
s = lambda * dt/(rho * cp * step_z^2);
if(s >= 0.5)
    fprintf('Konvergenzkriterium: s= %.3f\n', s);
else
    fprintf('Konvergenzkriterium: s= %.3f :-)\n', s);
end

%% Vorbereitung

distance = sqrt((xOffset - t*v).^2 + repmat(versatz, 1, steps_t).^2);
% Berechnung der diskreten Intensitäten zu jedem t
I = A * I0 * exp(-distance.^2 ./ (2 * w0^2)); % [W/m^2]

a = lambda / (rho*cp);

msglength1 = 0;
msg1 = '';

for cur_t = 1:steps_t
    
    if (mod(cur_t, 25) == 0)
        msg1 = sprintf('Zeitschritt: %i/%i\n', cur_t, steps_t);        
        bs = sprintf(repmat('\b', 1,  msglength1));
        fprintf([bs msg1]);        
        msglength1 = numel(msg1);
    end
    
    if(I(cur_t) < 1e-3)
       continue; 
    end
    
        % LGS aufstellen
        C = zeros(num_z);

        for j = 2:num_z-1
            C(j, j-1) = -4*a / (2 * step_z);
            C(j, j  ) = step_z * 2 / dt + 8*a * (1 / (2*step_z));
            C(j, j+1) = -4*a / (2 * step_z);
        end

        rs = TempArray * 2*step_z/dt;

        C(1, 1) = step_z / dt * 2 + 4*a /(2*step_z);
        C(1, 2) = -4*a / (2*step_z);
        rs(1) = rs(1) + 2 * I(cur_t) / (rho * cp); % Neumann RB


        C(end, end-1) = -4*a / (2 * step_z);
        C(end, end)   = step_z / dt * 2 + 4*a * (1.5 / step_z);
        rs(end) = rs(end) + T0 * (4*a / step_z); % Diriclet RB

        % LGS lösen

        TempArray = C \ rs;
    
    % VHP ausrechnen
    if TempArray(1) > Tv
        % VHP gefunden :-)
        fprintf('FVM einfach - Vorheizpunkt: %0.2f µm\n\n', (xOffset - t(cur_t)*v)/1e-6)
        break;
    end
    
    % plotten
    if(mod(cur_t, 50) == 0 && TempArray(1) > T0+1)        
        plot(z, TempArray);
        drawnow;
    end
end



















