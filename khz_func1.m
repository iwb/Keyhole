function [ y ] = khz_func1( A, arguments, param )
%KHZ_FUNC1 Summary of this function goes here
%   Detailed explanation goes here
    
    P1 = [arguments.prevA; 0; arguments.prevZeta];
    P2 = [A; 0; arguments.zeta];
    
    d1 = P1 - P2;
    n1 = [-d1(3); 0; d1(1)]; % [x; y; z]
    n1 = n1 ./ norm(n1);
    
    % Berechnung des Poyntingvektors
    %PP1 = mean([P1, P2], 2);
    
    [poyntVec, intensity] = calcPoynting(P2, param);
    
    % Berechnung von qa0
    Az = calcFresnel(poyntVec, n1, param);
    qa0 = param.scaled.gamma * mean(intensity, 2) * Az;
    
    y = qa0 - (1 + param.scaled.hm) * param.scaled.Pe;
end

