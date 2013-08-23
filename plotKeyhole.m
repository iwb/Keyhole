function plotKeyhole( plotdata )
%PLOTKEYHOLE Summary of this function goes here
%   Detailed explanation goes here
        
        Apex = cell2mat(plotdata.Apex.toArray.cell);
        Radius = cell2mat(plotdata.Radius.toArray.cell);
        Angle =  cell2mat(plotdata.Angle.toArray.cell);
        Intensity = cell2mat(plotdata.Intensity.toArray.cell);
        HeatFlow = cell2mat(plotdata.HeatFlow.toArray.cell);
        
        
        subplot(1, 3, 1);
        axis ij
        plot(Apex, plotdata.z_axis);
        hold all;
        plot(Apex-2*Radius, plotdata.z_axis);
        hold off;
        drawnow;
        
        subplot(1, 3, [2 3]);
        axis ij
        
        plot(Angle, plotdata.z_axis, 'b');
        hold all;
        plot(Intensity, plotdata.z_axis, 'r');
        hold all;
        plot(HeatFlow, plotdata.z_axis, 'c');
        hold off;
        drawnow;
end

