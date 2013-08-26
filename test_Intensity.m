fprintf('Keyhole Berechnung\n')
run('init.m')


dx = 1e-6;
dy = 1e-6;
dz = 1e-6;


x = -2*param.w0 : dx : 2*param.w0;
y = -2*param.w0 : dy : 2*param.w0;

z = 0e-4;
sumz = 0;

for xx = x
    for yy = y
        [pvec, int] = calcPoynting([xx; yy; z], param);
        sumz = sumz + int * dx*dy;
    end
end

sumz*param.I0