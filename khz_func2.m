function [ y ] = khz_func2( alpha, A, arguments, param, plotdata )
%KHZ_FUNC2 Summary of this function goes here
%   Detailed explanation goes here
    
    % Berechnung des Normalenvektors
    Avec = [arguments.prevApex; A];
    AlphaVec = [arguments.prevRadius; alpha];
    
    winkel = 1*pi/180;
    tmp_x = Avec - AlphaVec .* (1-cos(winkel));
    tmp_y = AlphaVec .* sin(winkel);
    
    P1 = [arguments.prevApex; 0; arguments.prevZeta];
    P2 = [A; 0; arguments.zeta];
    P3 = [tmp_x(1); tmp_y(1); arguments.prevZeta];
    %P4 = [tmp_x(2); tmp_y(2); arguments.zeta];
    
    d1 = P1 - P2;
    n1 = [-d1(3); 0; d1(1)]; % [x; y; z]
    n1 = n1 ./ norm(n1);
    
    d2 = P3 - P2;
    n2 = cross(d1, d2);
    n2 = n2 ./ norm(n2);
    
    % Berechnung des Poyntingvektors
    %PP1 = mean([P1, P2], 2);
    
    tmp_x = Avec - AlphaVec .* (1-cos(winkel/2));
    tmp_y = AlphaVec .* sin(winkel/2);
    %ds = mean(winkel/2 * AlphaVec);
    ds = winkel/2;
    
    %PP2 = [mean(tmp_x); mean(tmp_y); mean([arguments.prevZeta, arguments.zeta])];
    PP2 = [tmp_x(2); tmp_y(2); arguments.zeta];
    
    [poyntVec, intensity] = calcPoynting([P2, PP2], param);
    
    % Berechnung von qa0 und qa2
    Az = calcFresnel(poyntVec, [n1, n2], param);

    qa0 = param.I0 * intensity(1) * Az(1);
    qa1 = param.I0 * intensity(2) * Az(2);
    qa2 = 2*(qa1 - qa0)/ds^2;    % Da qa0 minimal größer ist, wird qa2 negtiv.
    deltaT = param.Tv - param.T0;
    
    y = qa2/(param.lambda * deltaT) + param.v/param.kappa + (param.Hm * param.v)/(param.cp * deltaT * param.kappa);
    % 0 = qa2 + (1+hm) * Pe
    
    if ~isempty(plotdata)
    end
end




















