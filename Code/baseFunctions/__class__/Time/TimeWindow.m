classdef TimeWindow
    %TIMEWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        from
        to
    end
    
    methods (Access = public)
        function obj = TimeWindow(time_from, time_to)
            %TIMEWINDOW Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                time_from Time
                time_to Time
            end
            obj.from = time_from;
            obj.to = time_to;
        end

        function iter = getIterator(obj, step)
            arguments
                obj TimeWindow
                step (1, 1) double = 1 % days
            end
            
            range = obj.from.mjd2000:step:obj.to.mjd2000;
            iter = zeros(1, size(range, 2)); for i = 1:size(range, 2)
                iter(i) = Time("mjd2000", range(i)); end
        end

        function iter = getIteratorRaw(obj, step)
            arguments
                obj TimeWindow
                step (1, 1) double = 1 % days
            end
            
            iter = obj.from.mjd2000:step:obj.to.mjd2000;
        end
    end
end

