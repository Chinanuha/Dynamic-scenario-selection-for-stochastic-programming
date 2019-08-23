function SflPlot = PlotSfl(Out,Gap,LineStyle,Marker,Color)
    for i = 1:numel(Out)/Gap
        MIN(i) = min(Out(1:i*Gap));
    end
    SflPlot = plot(1:numel(Out)/Gap,MIN);
    set(SflPlot,'LineStyle',LineStyle,'Marker',Marker,'Color',Color);
    