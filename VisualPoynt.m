run('init.m')
clc
num= 50;

wz = @(z) param.w0 * sqrt(1 + (z.^2 ./ param.Rl^2));
strahl = wz(linspace(0, -1e-3, 100));

[x,z] = meshgrid(linspace(-max(strahl), max(strahl), num), linspace(0, -1e-3, num));

Xpoynt = reshape(x, [1, num*num]);
Ypoynt = zeros(1,num*num);
Zpoynt = reshape(z, [1, num*num]);

[pvecNormiert, intensity] = calcPoynting([Xpoynt; Ypoynt; Zpoynt] ./ param.w0, param);

figure;
quiver(Xpoynt, Zpoynt, pvecNormiert(1,:), pvecNormiert(3,:), '*')
hold on
plot(strahl, linspace(0, -1e-3, 100), 'g', 'LineWidth', 1.5)
plot(-strahl, linspace(0, -1e-3, 100), 'g', 'LineWidth', 1.5)
hold off