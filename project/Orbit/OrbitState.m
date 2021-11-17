classdef OrbitState < handle
    %ORBIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        a
        e
        i
        OM
        om
        
        t = 0
        r
        v
        f
        
        T
        n
        eps
        h
        
        body
    end
    
    methods (Access = public)
        
        function obj = OrbitState(varargin)
            %ORBIT Construct an instance of this class
            %   Input parameters: r, v or a, e, i, OM, om, f0 or kep([a e i OM om f]) and body
            
            argumentsStruct = struct( ...
            "r", NaN, ...
            "v", NaN, ...
            "t", 0, ...
            "a", NaN, ...
            "e", NaN, ...
            "i", NaN, ...
            "OM", NaN, ...
            "om", NaN, ...
            "f", NaN, ...
            "kep", NaN, ...
            "body", CelestialBody("Earth") ...
            );
                          
            para = variableArguments(argumentsStruct, varargin, true);
            obj.body = para.body;
            if ~any(isnan([para.r para.v]))
                obj.r = para.r; obj.v = para.v;
                
                [obj.a, obj.e, obj.i, obj.OM, obj.om, obj.f] = ...
                                        obj.CartesianToKeplerian(para.r, para.v);
                                    
            elseif ~any(isnan([para.a para.e para.i para.OM para.om para.f]))
                obj.a = para.a; obj.e = para.e; obj.i = para.i; 
                obj.OM = para.OM; obj.om = para.om; obj.f = para.f;
                
                [obj.r, obj.v] = obj.KeplerianToCartesian(obj.f);
            elseif ~any(isnan(para.kep))
                obj.a = para.kep(1); obj.e = para.kep(2); obj.i = para.kep(3); 
                obj.OM = para.kep(4); obj.om = para.kep(5); obj.f = para.kep(6);

                [obj.r, obj.v] = obj.KeplerianToCartesian(obj.f);
            else
                error("You must pass at least one between cartesian coordinates and keplerian elements")
            end
            
            [obj.T, obj.n, obj.eps, obj.h] = obj.OrbitProperties( ...
                                                    obj.r, obj.v);
            obj.t = para.t;
        end
        
        function orbit_propagation = propagate(obj, mode, data)
            arguments
                obj OrbitState
                mode string = ""
                data = NaN
            end

            if isnan(data)
                warning("No mode specified, propagating the entire orbit.")
                mode = "Dt"; data = 2 * obj.T;
            end

            orbit_propagation = OrbitPropagation("orbit_state_i", obj, mode, data);
        end
    
        function fig = plot(obj, fig)
            switch nargin
                case 1
                    fig = plotOrbit(obj.r, obj.body.R);
                case 2
                    fig = plotOrbit(obj.r, obj.body.R, fig);
                otherwise
                    error("Plot does not accept more than 1 input.");
            end
        end 
    
        function kep = getKep(obj)
            kep = [obj.a obj.e obj.i obj.OM obj.om obj.f];
        end
    
        function [Dv, arc, v] = transferTo(obj, final_state, Dt)
            [Dv, v_l] = lambertTransfer(obj.r, final_state.r, ...
                                obj.v, final_state.v, Dt, obj.body.mu);
            if nargout > 1
                arc = OrbitPropagation( ...
                  "orbit_state_i", OrbitState("r", obj.r, "v", v_l(1, :)', "body", obj.body), ...
                  "Dt", Dt ...
                  );
            end

            if nargout > 2
                v = v_l;
            end
        end
    end
    
    methods (Access = protected)
        
        function [a, e, i, OM, om, f] = CartesianToKeplerian(obj, rr, vv)
            [a, e, i, OM, om, f] = CartesianToKeplerian(rr, vv, obj.body.mu);
        end
        
        function [rr, vv] = KeplerianToCartesian(obj, f)
            [rr, vv] = KeplerianToCartesian(obj.a, obj.e, obj.i, ...
                                    obj.OM, obj.om, f, obj.body.mu);
        end
        
        function [T, n, eps, h] = OrbitProperties(obj, rr, vv)
            [T, n, eps, h] = OrbitProperties(rr, vv, obj.body.mu);
        end
        
    end
end

