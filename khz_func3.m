function [ y ] = khz_func2( alpha, A, arguments, param, plotdata )
%KHZ_FUNC2 Summary of this function goes here
%   Detailed explanation goes here

% Berechnung des Normalenvektors
Avec = [arguments.prevApex; A];
AlphaVec = [arguments.prevRadius; alpha];

winkel = 15*pi/180;
tmp_x = Avec - AlphaVec .* (1-cos(winkel));
tmp_y = AlphaVec .* sin(winkel);

P1 = [arguments.prevApex; 0; arguments.prevZeta];
P2 = [A; 0; arguments.zeta];
P3 = [tmp_x(1); tmp_y(1); arguments.prevZeta];
P4 = [tmp_x(2); tmp_y(2); arguments.zeta];

d1 = P1 - P2;
n1 = [-d1(3); 0; d1(1)]; % [x; y; z]
n1 = n1 ./ norm(n1);

if ~isempty(plotdata)
	disp '';
end


tmp_x = -sin(winkel);
tmp_y = cos(winkel);

P4_tangent = [tmp_x; tmp_y; 0];

d3 = P3 - P4;
n2 = cross(d3, P4_tangent);
n2 = n2 ./ norm(n2);
	

[poyntVec, intensity] = calcPoynting(P4, param);


% Berechnung von qa2 analog zu qa0
Az = calcFresnel(poyntVec, n2, param);
qa0 = param.scaled.gamma * intensity * Az;

y = qa0 - (1 + param.scaled.hm) * param.scaled.Pe * cos(winkel);
end




















