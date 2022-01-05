function KepHistoryPlot(name, tv, xk, xc, varargin)
%ERRORPLOT Summary of this function goes here
%   Detailed explanation goes here

    optionsStruct = struct( ...
        "fName", "Cartesian", ...
        "sName", "Gauss", ...
        "errorPlot", false, ...
        "filtered", [] ...
    );

    para = variableArguments(optionsStruct, varargin, true);
    
    switch name
        case "a"
            ext_name = "Semi-major axis";
            yaxistitle = [
                sprintf("$|a_{%s} - a_{%s}|/a_0$ $[-]$", lower(para.fName), lower(para.sName))
                "$a \> [km]$"
                ];
            relarray = abs(xc - xk) / xc(1);
        case "e"
            ext_name = "Eccentricity";
            yaxistitle = [
                sprintf("$|e_{%s} - e_{%s}|$ $[-]$", lower(para.fName), lower(para.sName))
                "$e \> [-]$"
                ];
            relarray = abs(xc - xk);
        case "i"  % input in radians
            ext_name = "Inclination";
            yaxistitle = [
                sprintf("$|i_{%s} - i_{%s}|/2\\pi$ $[-]$", lower(para.fName), lower(para.sName))
                "$i \> [deg]$"
                ];
            xc = rad2deg(xc); xk = rad2deg(xk); % conversion to degrees
            if para.filtered; para.filtered = rad2deg(para.filtered); end % conversion to degrees
            relarray = abs(xc - xk) / 2*pi;
        case "OM" % input in radians
            ext_name = "RAAN";
            yaxistitle = [
                sprintf("$|\\Omega_{%s} - \\Omega_{%s}|/2\\pi$ $[-]$", lower(para.fName), lower(para.sName))
                "$\Omega \> [deg]$"
                ];
            xc = rad2deg(xc); xk = rad2deg(xk); % conversion to degrees
            if para.filtered; para.filtered = rad2deg(para.filtered); end % conversion to degrees
            relarray = abs(xc - xk) / 2*pi;
        case "om" % input in radians
            ext_name = "Argument of periapsis";
            yaxistitle = [
                sprintf("$|\\omega_{%s} - \\omega_{%s}|/2\\pi$ $[-]$", lower(para.fName), lower(para.sName))
                "$\omega \> [deg]$"
                ];
            xc = rad2deg(xc); xk = rad2deg(xk); % conversion to degrees
            if para.filtered; para.filtered = rad2deg(para.filtered); end % conversion to degrees
            relarray = abs(xc - xk) / 2*pi;
        case "f" % input in radians
            ext_name = "True anomaly";
            yaxistitle = [
                sprintf("$|f_{%s} - f_{%s}|/|f_{gauss}|$ $[-]$", lower(para.fName), lower(para.sName))
                "$f \> [deg]$"
                ];
            xc = rad2deg(xc); xk = rad2deg(xk); % conversion to degrees
            if para.filtered; para.filtered = rad2deg(para.filtered); end % conversion to degrees
            relarray = abs(xc - xk) ./ abs(xk);
        otherwise; error("Variable must me a keplerian element")
    end

    figure("name", ext_name, "numbertitle", "off", "position", [100 100 1300 700]);
    if para.errorPlot
        tiledlayout(1, 2)
        
        % Left plot
        nexttile
        if para.filtered
            plot(tv, xc, tv, xk, tv, para.filtered)
            legend(para.fName, para.sName, "Filtered")
        else
            plot(tv, xc, tv, xk)
            legend(para.fName, para.sName)
        end

        xlim([0 tv(end)])
        xlabel('$Time\>[T]$', 'Interpreter', 'latex', "FontSize", 15)
        ylabel(yaxistitle(2), 'Interpreter', 'latex', "FontSize", 15)
        title("Value")
        
        grid on
        
        % Right plot
        nexttile
        semilogy(tv, relarray)
        
        xlim([0 tv(end)])
        xlabel('$Time\>[T]$', 'Interpreter', 'latex', "FontSize", 15)
        ylabel(yaxistitle(1), 'Interpreter', 'latex', "FontSize", 15)
        title("Relative Error")
        grid on
    else  % value plot only
        if para.filtered
            plot(tv, xc, tv, xk, tv, para.filtered, 'LineWidth', 1.5)
            legend(para.fName, para.sName, "Filtered")
        else
            plot(tv, xc, tv, xk, 'LineWidth', 1.5)
            legend(para.fName, para.sName)
        end
        
        xlim([0 tv(end)])
        xlabel('$Time\>[T]$', 'Interpreter', 'latex')

        ylabel(yaxistitle(2), 'Interpreter', 'latex')

        title(ext_name)
        grid on
    end
end

