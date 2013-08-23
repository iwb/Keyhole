function vhp = vhp_dgl(versatz, param)
    %% Errechnet den Vorheizpunkt mit Hilfe der Original-DGL
    StartD = 1e-3;
    StartT = 300.01;
    
    % Initialer Abstand zum Laser (1D FDM)
    param.xOffset = 5 * param.w0; % [m]
    

    %% Diskretisierung der Zeit
    steps_t = 10001;
    t = linspace(0, param.xOffset/param.v, steps_t);
    dt = t(2) - t(1);

    %% Intensitätsvektor berechnen
    xVec = (param.xOffset - t*param.v) ./ param.w0; % Normierung mit w0
    yVec = repmat(versatz, 1, steps_t) ./ param.w0; % Normierung mit w0
    zVec = zeros(1, steps_t);
    points = [xVec; yVec; zVec];

    % Berechnung der diskreten Intensitäten zu jedem t
    %Alte Berechnung
%     distance = sqrt((xVec.*param.w0).^2 + (yVec.*param.w0).^2);
%     I2 = 0.39 * param.I0 * exp(-distance.^2 ./ (2 * param.w0^2)); % [W/m^2]
    %Neue Berechnung
    [pVec, intensity] = calcPoynting(points, param);
    Az = calcFresnel(pVec(:, 1), [0;0;1], param);
    I = param.I0 .* intensity .* Az;

%     figure;
%     plot(I, 'b')
%     hold on
%     plot(I2, 'r')
%     hold off
%     legend('verwendet in keyhole_z', 'ursprünglich für vhp', 'Location', 'NorthWest')

    %% Vorbereitung

    % Die Array sind nur zum Speichern
    TempArray = ones(1, steps_t) * param.T0;
    DeltaArray = zeros(1, steps_t);

    delta = StartD;
    Ts = StartT;

    index = 0;
    dTstemp=0;

    % figure(2)
    % subplot(2,1,1)
    % hold off
    % plot(t,TempArray);
    % title('Temperatur')
    % hold on
    % subplot(2,1,2)
    % hold off
    % plot(t,DeltaArray)
    % title('Eindringtiefe')


    %% Rechnen
    for i = 1:steps_t

        dTs = param.kappa/((1-param.b2)*delta)*(I(i)/param.lambda - param.b2*(Ts-param.T0)/delta);
        ddelta = 1/(Ts-param.T0)*(param.kappa*I(i)/param.lambda-dTstemp*delta);

        dTstemp = dTs;
        Ts = Ts + dTs * dt;
        delta = delta + ddelta * dt;

        TempArray(i) = Ts;
        DeltaArray(i) = delta;


%         if(mod(i, 100) == 0)
%             figure(2)
%             subplot(2,1,1)
%             plot(t,TempArray)
%             subplot(2,1,2)
%             plot(t,DeltaArray)
%             drawnow;
%         end

        % VHP ausrechnen
        if ~index && Ts > param.Tv
            % VHP gefunden :-)
            T1 = TempArray(i-1);
            zeitpunkt = t(i-1) + (param.Tv - T1)/(Ts - T1) * dt;
            
            vhp = (param.xOffset - zeitpunkt*param.v);
            
            %fprintf('Original DGL - Vorheizpunkt: %0.2f µm\n\n', 5);
            return;
        end
    end
    
    vhp = NaN;
end