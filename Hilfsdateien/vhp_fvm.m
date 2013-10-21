%% Errechnet den Vorheizpunkt mit Hilfe der modifizierten DGL
% Implizite Formulierung, 2D Betrachtung, 1D-Wärmeleitung
clc;

fprintf('Finite Volumen Methode (komplett)\n')
run('init.m')

%% Diskretisierung in X-Richtung (Vorschubrichtung)
num_x = 601;
x = linspace(0, xOffset, num_x);
step_x = x(2) - x(1);

%% Diskretisierung in Z-Richtung (Blechtiefe)
num_z = 401;
z = linspace(0, 2e-3, num_z);
step_z = z(2) - z(1);

%% Diskretisierung der Zeit
steps_t = 100;
dt = xOffset / (v * steps_t);
t = 0 : dt : xOffset/v - dt;

%% Vorbereitung
TempMatrix = ones(num_z, num_x) * T0;

%% Konvergenz checken
s = lambda * dt/(rho * cp * step_z^2);
if(s >= 0.5)
    fprintf('Konvergenzkriterium: s= %.3f\n', s);
else
    fprintf('Konvergenzkriterium: s= %.3f :-)\n', s);
end

%% Vorbereitung
a = lambda / (rho*cp);

msglength1 = 0;
msglength2 = 0;
msglength3 = 0;
msg1 = '';
msg2 = '';
msg3 = '';

for cur_t = 1:steps_t

    msg1 = sprintf('Zeitschritt: %i/%i\n', cur_t, steps_t);
    bs = sprintf(repmat('\b', 1,  msglength1 + msglength2 + msglength3));
    fprintf([bs msg1 msg2 msg3]);
    msglength1 = numel(msg1);
    
    for col = 1:num_x
        
        % Berechnung der diskreten Intensitäten zum aktuellen Zeitunkt an
        % der aktuellen Stelle
        I = A * I0 * exp(-((x(col) - t(cur_t)*v)^2 + versatz^2) ./ (2 * w0^2)); % [W/m^2]
        I = I * step_x^2; % [W]
        
        % LGS aufstellen
        C = zeros(num_z);
        
        for j = 2:num_z-1
            C(j, j-1) = -4*a * step_x / (2 * step_z);
            C(j, j  ) = step_z * 2 * step_x / dt + 8*a * (step_x / (2*step_z));
            C(j, j+1) = -4*a * step_x / (2 * step_z);
        end
        
        rs = TempMatrix(:, col) * 2*step_z*step_x/dt;
        
        C(1, 1) = step_z / dt * 2 * step_x + 4*a * step_x/(2*step_z);
        C(1, 2) = -4*a * step_x / (2*step_z);
        rs(1) = rs(1) + 2 * I / (rho * cp * step_x); % Neumann RB
        
        
        C(end, end-1) = -4*a * step_x / (2 * step_z);
        C(end, end)   = step_z / dt * 2 * step_x + 4*a * (1.5 * step_x / step_z);
        rs(end) = rs(end) + T0 * (4*a * step_x / step_z); % Diriclet RB
        
        % LGS lösen
        
        TempMatrix(:, col) = C \ rs;
        
        if(mod(col, 25) == 0)
            msg2 = sprintf('Fortschritt: %4d/%i\n', col, num_x);
            bs = sprintf(repmat('\b', 1, msglength2 + msglength3));
            fprintf([bs msg2 msg3]);
            msglength2 = numel(msg2);
        end
    end
    
    % VHP ausrechnen
    index = find(TempMatrix(1, :) < Tv, 1, 'first');
    if (index>1)
        interp_x = TempMatrix(1, index-1:index);
        interp_y = x(index-1:index);
        
        vhp = (interp1(interp_x, interp_y, Tv) - t(cur_t) * v) / 1e-6; % VHP in µm
    else
        vhp = NaN;
    end
    
    msg3 = sprintf('==> VHP: %5.1f µm\n---------------\n', vhp);
    bs = sprintf(repmat('\b', 1, msglength3));
    fprintf([bs msg3]);
    msglength3 = numel(msg3);
    
    % plotten
    if(mod(cur_t, 1) == 0)
        pcolor(x, z, TempMatrix);
        shading flat
        set(gca,'YDir','reverse');
        colormap(jet)
        daspect([1 1 1]);
        caxis([0 Tv]);
        
        %plot(x, TempArray(2, :));
        drawnow;
    end
end
