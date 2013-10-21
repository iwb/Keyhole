%% Errechnet das Keyhole in Z-Richtung

fprintf('Keyhole Berechnung\n')
run('init.m')
clc

asm = NET.addAssembly('C:\Users\Julius\Documents\Visual Studio 2012\Projects\DA_VHP\DA_VHP\bin\Release\VHP_solver.dll');
a = VHP_solver.VHPcalculator();
a.ReadParam('C:\Users\Julius\Documents\Visual Studio 2012\Projects\DA_VHP\DA_VHP\settings.xml');

disp('C# Assembly:')
tic
for ii=1:100
    vhp1 = a.calcVHP(0);
    vhp2 = a.calcVHP(0.5);
end
toc;

%% VHP berechnen
versatz = 0.5 * param.w0;
disp('Matlab Code:')
tic
for ii=1:100
    vhp1 = vhp_dgl(0, param);
    vhp2 = vhp_dgl(versatz, param);
end
toc;
