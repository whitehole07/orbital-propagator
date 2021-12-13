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
                
                obj.CartesianToKeplerian();
            elseif ~any(isnan([para.a para.e para.i para.OM para.om para.f]))
                [obj.a, obj.e, obj.i, obj.OM, obj.om, obj.f] = ...
                    unpack([para.a para.e para.i para.OM para.om para.f]);
                
                obj.KeplerianToCartesian();
            elseif ~any(isnan(para.kep))
                [obj.a, obj.e, obj.i, obj.OM, obj.om, obj.f] = unpack(para.kep);

                obj.KeplerianToCartesian();
            else
                error("You must pass at least one between cartesian coordinates and keplerian elements")
            end
            
            obj.OrbitProperties();
            obj.t = para.t;
        end
        
        function orbit_propagation = propagateTo(obj, mode, data)
            arguments
                obj OrbitState
                mode string = ""
                data = NaN
            end

            if strcmp(mode, "")
                warning("No mode specified, propagating the entire orbit.")
                mode = "Dt"; data = 2 * obj.T;
            end

            orbit_propagation = OrbitPropagation("state_i", obj, mode, data);
        end

        function fig = plot(obj, fig)
            switch nargin
                case 1
                    fig = PlotOrbit(obj.r, "bodyName", obj.body.name);
                case 2
                    PlotOrbit(obj.r, "fig", fig);
                otherwise
                    error("Plot does not accept more than 1 input.");
            end
        end
    
        function kep = getKep(obj)
            kep = [obj.a obj.e obj.i obj.OM obj.om obj.f];
        end
    
        function [Dv, arc, v] = transferTo(obj, final_state)
            Dt = final_state.t - obj.t;
            [Dv, v_l] = LambertTransfer(obj.r, final_state.r, ...
                                obj.v, final_state.v, Dt, obj.body.mu);
            if nargout > 1
                arc = OrbitPropagation( ...
                  "state_i", OrbitState("r", obj.r, "v", v_l(1, :)', "body", obj.body), ...
                  "Dt", Dt ...
                  );
            end

            if nargout > 2
                v = v_l;
            end
        end
    end
    
    methods (Access = protected)
        
        function CartesianToKeplerian(obj)
            [obj.a, obj.e, obj.i, obj.OM, obj.om, obj.f] = ...
                unpack(CartesianToKeplerian(obj.r, obj.v, obj.body.mu));
        end
        
        function KeplerianToCartesian(obj)
            [obj.r, obj.v] = KeplerianToCartesian(obj.getKep(), obj.body.mu);
        end
        
        function OrbitProperties(obj)
            [obj.T, obj.n, obj.eps, obj.h] = OrbitProperties(obj.r, obj.v, obj.body.mu);
        end
        
    end
end

