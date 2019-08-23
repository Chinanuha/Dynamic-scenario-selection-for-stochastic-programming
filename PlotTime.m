function TimePlot = PlotTime(t,Gap,LineStyle,Marker,Color,extra)
    for i = 1:numel(t)/Gap
        T(i) = sum(t(1:i*Gap)) + extra;
    end
    TimePlot = plot(1:numel(t)/Gap,T);
    set(TimePlot,'LineStyle',LineStyle,'Marker',Marker,'Color',Color);
    