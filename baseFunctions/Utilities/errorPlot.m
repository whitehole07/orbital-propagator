function errorPlot(tv, xk, xc, name, ext_name, mu)
%ERRORPLOT Summary of this function goes here
%   Detailed explanation goes here
    arguments
        tv double
        xk double
        xc double
        name string = "x"
        ext_name string = "Variable"
        mu string = "-" % unit
    end
    
    figure("name", ext_name, "numbertitle", "off", "position", [100 100 1300 700]);
    tiledlayout(1, 2)
    
    % Left plot
    nexttile
    plot(tv, xc, tv, xk)

    xlim([0 tv(end)])
    xlabel('$Time\>[T]$', 'Interpreter', 'latex')
    ylabel(sprintf('$%s\\>[%s]$', name, mu), 'Interpreter', 'latex')
    title("Value Plot")
    legend("Cartesian", "Keplerian")
    grid on
    
    % Right plot
    nexttile
    semilogy(tv, abs(xc - xk))
    
    xlim([0 tv(end)])
    xlabel('$Time\>[T]$', 'Interpreter', 'latex')
    ylabel(sprintf('$|%s_{car} - %s_{kep}|\\>[%s]$', name, name, mu), 'Interpreter', 'latex')
    title("Absolute Error Plot")
    grid on
end

