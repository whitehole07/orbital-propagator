classdef CelestialBody
    %CELESTIALBODY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        id

        mu
        R
        J2
        om
        
        name
    end
    
    methods (Access = public)
        function obj = CelestialBody(name, options)
            %CELESTIALBODY Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                name (1, 1) string
                options struct = struct("J2", true)
            end
            
            obj.name = name;
            switch lower(obj.name)
                case "sun"
                    obj.id = 10;
                    obj.mu = astroConstants(4);
                    obj.R = astroConstants(3);
                    obj.J2 = 0; % Undefined/Unnecessary
                    obj.om = NaN; % Undefined/Unnecessary
                case "earth"
                    obj.id = 3;
                    obj.mu = astroConstants(13);
                    obj.R = astroConstants(23);
                    obj.J2 = astroConstants(9);
                    obj.om = 7.2916e-05;
                case "mars"
                    obj.id = 4;
                    obj.mu = astroConstants(14);
                    obj.R = astroConstants(24);
                    obj.J2 = 0; % Undefined/Unnecessary
                    obj.om = NaN; % Undefined/Unnecessary
                otherwise
                    error("Unknown specified celestial body.")
            end

            if ~options.J2
                obj.J2 = 0;
            end

        end

        function [state] = ephemerides(obj, mjd2000)
            [kep, ~] = uplanet(mjd2000, obj.id);
            
            sun = CelestialBody("Sun");
            t = mjd2000 * 86400; % Total seconds passed since January 1, 2000

            state = OrbitState("kep", kep, "t", t, "body", sun);
        end

        function [kep] = rawEphemerides(obj, mjd2000)
            [kep, ~] = uplanet(mjd2000, obj.id);
        end
    end
end

