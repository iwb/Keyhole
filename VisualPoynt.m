run('init.m')
clc
wz = @(z) param.w0 * sqrt(1 + (z.^2 ./ param.Rl^2));
strahl = wz(linspace(0, 1e-2, 100));

[x,z] = meshgrid(linspace(-max(strahl), max(strahl), 500), linspace(0, 1e-2, 500));

Xpoynt = reshape(x, [1, 500*500]);
Ypoynt = zeros(1,500*500);
Zpoynt = reshape(z, [1, 500*500]);

[pvecNormiert, intensity] = calcPoynting([Xpoynt; Ypoynt; Zpoynt] ./ param.w0, param);

figure;
quiver(Xpoynt, Zpoynt, pvecNormiert(1,:), pvecNormiert(3,:), '*')
hold on
plot(strahl, linspace(0, 1e-2, 100), 'g', 'LineWidth', 1.5)
plot(-strahl, linspace(0, 1e-2, 100), 'g', 'LineWidth', 1.5)
hold off