function porkchopPlot(departure, arrival, Dvs)
%PORKCHOPPLOT Summary of this function goes here
%   Detailed explanation goes here
    figure("name", "Porkchop", "numbertitle", "off");
    contour(departure, arrival, Dvs, min(min(Dvs)):min(min(Dvs)) + 5)
    colorbar
end

