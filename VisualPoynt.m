run('init.m')
clc
wz = @(z) param.w0 * sqrt(1 + (z.^2 ./ param.Rl^2));
strahl = wz(linspace(0, 1e-2, 100));

[x,z] = meshgrid(linspace(-max(strahl), max(strahl), 40), linspace(0, 1e-2, 40));

Xpoynt = reshape(x, [1, 40*40]);
Ypoynt = zeros(1,40*40);
Zpoynt = reshape(z, [1, 40*40]);

[pvecNormiert, intensity] = calcPoynting([Xpoynt; Ypoynt; Zpoynt] ./ param.w0, param);

figure;
quiver(Xpoynt, Zpoynt, pvecNormiert(1,:), pvecNormiert(3,:), '*')
hold on
plot(strahl, linspace(0, 1e-2, 100), 'g', 'LineWidth', 1.5)
plot(-strahl, linspace(0, 1e-2, 100), 'g', 'LineWidth', 1.5)
hold off