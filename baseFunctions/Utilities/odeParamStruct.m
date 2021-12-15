function paramStruct = odeParamStruct(varargin)
%ODEPARAMSTRUCT Summary of this function goes here
%   Detailed explanation goes here

    % Variable Input arguments with default values
    optionsStruct = struct( ...
        "R", NaN, ...
        "J2", NaN, ...
        "OdeSolver", @ode113 ...
    );

    paramStruct = variableArguments(optionsStruct, varargin, true);
end

