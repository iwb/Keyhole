fprintf('Keyhole Berechnung\n')
run('init.m')

num = 1000;

x = linspace(-10, 10, num);
y = linspace(-10, 10, num);
dx = x(2) - x(1);
dy = y(2) - x(1);

z = -50;

[mesh_x, mesh_y] = meshgrid(x, y);

coordsX = reshape(mesh_x, [1, num^2]);
coordsY = reshape(mesh_y, [1, num^2]);
coordsZ = repmat(z, [1, num^2]);

coords = [coordsX; coordsY; coordsZ];

[pvec, int] = calcPoynting(coords, param);
sumz = sum(int .* (dx * dy));

disp(sumz * param.I0 * param.w0^2);