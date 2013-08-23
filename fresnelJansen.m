function  pVec = fresnelJansen( r, z, param )
%FRESNELABSORPTION Berechnung des Poyntingvektor und daraus die Fresnel
%Absorption
%   Detailed explanation goes here

fokus = param.fokus;
Rl = param.Rl;
waveLength = param.waveLength;

x = r;
y = 0;
% Poyntingvektor - Komponenten
PoyntR = (2*pi .* x .* (z+fokus)) ./ (Rl^2 * waveLength + (z+fokus).^2 .* waveLength);

PoyntZ = (pi*(-2*Rl^4 + (z+fokus).^2 .* (x.^2 + y.^2 - 2*(z+fokus).^2) - Rl^2 ...
    .* (x.^2 + y.^2 + 4*(z+fokus).^2)) + Rl*(Rl^2 + (z+fokus).^2)*waveLength) ./ ...
    ((Rl^2 + (z+fokus).^2).^2 * waveLength);


% Poyntingvektor - Gesamt + Normierung
pVec = [PoyntR; PoyntZ];
pVec = bsxfun(@rdivide, pVec, sqrt(sum(pVec.^2)));
end

