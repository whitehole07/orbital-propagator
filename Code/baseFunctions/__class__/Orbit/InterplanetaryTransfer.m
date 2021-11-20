classdef InterplanetaryTransfer < handle
    %ORBIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        dep_planet  % Departure Planet
        arr_planet  % Arrival Planet
        
        dep_window  % Departure Time Window
        arr_window  % Arrival Time Window

        Dvs         % Dvs Matrix
        Dv          % Min Dv

        departure   % minDv Departure date
        arrival     % minDv Arrival date

        body        % Central body
        options     % Transfer options
    end

    properties (Access = private)
        deps  % Departure Iterator
        arrs  % Arrival Iterator
    end
    
    methods (Access = public)
        
        function obj = InterplanetaryTransfer(dep_planet, arr_planet, dep_window, arr_window, body, options)
            %ORBIT Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                dep_planet CelestialBody
                arr_planet CelestialBody
                dep_window TimeWindow
                arr_window TimeWindow
                body CelestialBody
                options struct = struct("step", .5, "verbosity", 0)  % days
            end
            
            obj.dep_planet = dep_planet; obj.arr_planet = arr_planet;
            obj.dep_window = dep_window; obj.arr_window = arr_window;
            obj.body = body; obj.options = options;
            
            % Compute Dvs Matrix
            obj.computeDvs();

            % Compute Min Dv
            obj.computeMinDv();
        end

        function porkchopPlot(obj, varargin)
            % Replace minDv and set title
            found_flags = struct("minDv", 0, "title", 0);
            for i = 1:size(varargin, 2)
                if strcmp(varargin{i}, "minDv")
                    varargin{i+1} = obj.Dv;
                    found_flags.minDv = 1;
                    break
                end
                if strcmp(varargin{i}, "title")
                    found_flags.title = 1;
                    break
                end
            end
            if ~found_flags.minDv
                varargin{end+1} = "minDv";
                varargin{end+1} = obj.Dv;
            end
            if ~found_flags.title
                varargin{end+1} = "title";
                varargin{end+1} = sprintf("Porkchop Plot: %s to %s", obj.dep_planet.name, obj.arr_planet.name);
            end

            % Porkchop Plot
            PorkchopPlot(obj.deps, obj.arrs, obj.Dvs, varargin);
        end
        
    end
    
    methods (Access = protected)
        function computeDvs(obj)
            % Get departure and arrival raw iterators
            obj.deps = obj.dep_window.getIteratorRaw(obj.options.step);
            obj.arrs = obj.arr_window.getIteratorRaw(obj.options.step);

            % Compute the Dvs matrix
            obj.Dvs = DvsMatrix(obj.deps, obj.dep_planet.id, ...
                obj.arrs, obj.arr_planet.id, obj.body.mu, obj.options.verbosity);
        end

        function computeMinDv(obj)
            % Find minimum value position inside the Dvs matrix
            [x, y] = find(obj.Dvs == min(min(obj.Dvs)));
            init_dep = obj.deps(y);
            init_arr = obj.arrs(x);

            % Use fminunc to refine the solution
            [min_dep, min_arr, obj.Dv] = MinDvFminUnc(init_dep, init_arr, ...
                            obj.dep_planet.id, obj.arr_planet.id, obj.body.mu);

            obj.departure = Time("mjd2000", min_dep);
            obj.arrival = Time("mjd2000", min_arr);
        end
    end
end

