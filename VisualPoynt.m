run('init.m')
clc
diskreteQuiver= 50;
anzWellen = 10;
diskreteWelle = 1000;
zTiefe = 1e-3;

wz = @(z) param.w0 * sqrt(1 + (z.^2 ./ param.Rl^2));
strahl = wz(linspace(0, -zTiefe, diskreteQuiver*2));

rz = @(z) z .* (1 + (param.Rl.^2 ./ z.^2));
radiusWelle = rz(linspace(0, zTiefe, anzWellen));
dz = linspace(0, zTiefe, anzWellen);
dz = dz(2);

[x,z] = meshgrid(linspace(-max(strahl), max(strahl), diskreteQuiver), linspace(0, -zTiefe, diskreteQuiver));

Xpoynt = reshape(x, [1, diskreteQuiver*diskreteQuiver]);
Ypoynt = zeros(1,diskreteQuiver*diskreteQuiver);
Zpoynt = reshape(z, [1, diskreteQuiver*diskreteQuiver]);

[pvecNormiert, intensity] = calcPoynting([Xpoynt; Ypoynt; Zpoynt] ./ param.w0, param);

ang = linspace(0, pi, diskreteWelle);
xp = zeros(length(radiusWelle), diskreteWelle);
yp = zeros(length(radiusWelle), diskreteWelle);
for i = 1:length(radiusWelle)
    xp(i,:) = (radiusWelle(i) .* cos(ang));
    yp(i,:) = (radiusWelle(i) .* sin(ang)) - radiusWelle(i) + i*dz;
end

figure;
quiver(Xpoynt, Zpoynt, pvecNormiert(1,:), pvecNormiert(3,:), '*')
hold on
plot(strahl, linspace(0, -zTiefe, diskreteQuiver*2), 'g', 'LineWidth', 1.5)
plot(-strahl, linspace(0, -zTiefe, diskreteQuiver*2), 'g', 'LineWidth', 1.5)
if (0)
    for i = 2:size(xp, 1)
        plot(-xp(i,:), -yp(i,:), 'r')
    end
    daspect([1 1 1])
end
hold off