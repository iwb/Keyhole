function plotKeyhole( plotdata, param )
%PLOTKEYHOLE Summary of this function goes here
%   Detailed explanation goes here
        
        Apex = cell2mat(plotdata.Apex.toArray.cell);
        Radius = cell2mat(plotdata.Radius.toArray.cell);
        Angle =  cell2mat(plotdata.Angle.toArray.cell);
        Intensity = cell2mat(plotdata.Intensity.toArray.cell);
        HeatFlow = cell2mat(plotdata.HeatFlow.toArray.cell);
        Fresnel = cell2mat(plotdata.Fresnel.toArray.cell);
        
        
        subplot(1, 3, 1);
        axis ij
        plot(Apex, plotdata.z_axis);
        hold all;
        plot(Apex-2*Radius, plotdata.z_axis);
        hold all;
        
        x = Apex(end);
        z = plotdata.z_axis(end);
        %[p, i] = calcPoynting([x; 0; z], param);
        %quiver(x, z, -p(1), -p(3), '*');
        
        hold off;
        drawnow;
        
        subplot(1, 3, [2 3]);
        axis ij
        
        plot(Angle, plotdata.z_axis, 'b');
        hold all;
        plot(Intensity, plotdata.z_axis, 'r');
%         hold all;
%         plot(HeatFlow, plotdata.z_axis, 'c');
        hold all
        plot(Fresnel, plotdata.z_axis, '--g')
        hold off;
        drawnow;
end

% x=0:0.1:10;
% y=x.^2;
% plot(x, y);
% hold on;
% quiver(6, 36, 1, -1, '*')
