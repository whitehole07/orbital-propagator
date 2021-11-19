classdef Time
    %TIME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        date
        mjd
        mjd2000
        jd
    end
    
    methods (Access = public)
        function obj = Time(varargin)
            %TIME Construct an instance of this class
            %   Detailed explanation goes here
            
            argumentsStruct = struct( ...
                "date", NaN, ...
                "mjd", NaN, ...
                "mjd2000", NaN, ...
                "jd", NaN ...
            );

            para = variableArguments(argumentsStruct, varargin, true);

            if ~any(isnan(para.date))
                obj.date = para.date;
                obj.mjd = date2mjd(obj.date);
                obj.mjd2000 = date2mjd2000(obj.date);
                obj.jd = date2jd(obj.date);
            elseif ~any(isnan(para.mjd))
                obj.mjd = para.mjd;
                obj.date = mjd2date(obj.mjd);
                obj.mjd2000 = mjd2mjd2000(obj.mjd);
                obj.jd = mjd2jd(obj.mjd);
            elseif ~any(isnan(para.mjd2000))
                obj.mjd2000 = para.mjd2000;
                obj.date = mjd20002date(obj.mjd2000);
                obj.mjd = mjd20002mjd(obj.mjd2000);
                obj.jd = mjd20002jd(obj.mjd2000);
            elseif ~any(isnan(para.jd))
                obj.jd = para.jd;
                obj.date = jd2date(obj.jd);
                obj.mjd = jd2mjd(obj.jd);
                obj.mjd2000 = jd2mjd2000(obj.jd);
            else
                error("You must specify at leat one between date, mjd, mjd200 an jd")
            end
        end
    end
end

