classdef OrbitPropagation < handle
    %ORBIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        a
        e
        i
        OM
        om

        state_i
        state_f
        
        % propagation variables
        tt = 0
        rr = 0
        vv = 0
        ff = 0

        T
        n
        eps
        h
        
        body
    end
    
    properties (Access = protected)
    end
    
    methods (Access = public)
        
        function obj = OrbitPropagation(varargin)
            %ORBIT Construct an instance of this class
            %   Input parameters: orbit_state
            
            argumentsStruct = struct( ...
            "state_i", NaN, ...
            "state_f", NaN, ...
            "tf", NaN, ...
            "Dt", NaN ...
            );

            para = variableArguments(argumentsStruct, varargin, true);

            if ~isa(para.state_i, 'OrbitState')
                error("You must pass the initial orbit state")
            end

            obj.state_i = para.state_i;
            [obj.a, obj.e, obj.i, obj.OM, obj.om, ~] = unpack(obj.state_i.getKep());
            
            obj.body = obj.state_i.body;
            obj.T = obj.state_i.T; obj.n = obj.state_i.n;
            obj.eps = obj.state_i.eps; obj.h = obj.state_i.h;

            if isa(para.state_f, 'OrbitState')
                para.tf = para.state_f.t;
                obj.state_f = para.state_f;
            elseif ~isnan(para.Dt)
                para.tf = obj.state_i.t + para.Dt;
            elseif isnan(para.tf)
                error("You must pass at least one between state_f, tf and Dt")
            end
            
            obj.tt = linspace(obj.state_i.t, para.tf, 1000)';
            [~, obj.rr, obj.vv] = obj.getCartesianCoordinates( ...
                            obj.state_i.r, obj.state_i.v, obj.tt);

            [~, obj.ff] = obj.getKeplerianCoordinates(obj.state_i.f, obj.tt);
            
            if ~isa(para.state_f, 'OrbitState')
                obj.state_f = OrbitState( ...
                    "r", obj.rr(end, :)', "v", obj.vv(end, :)', ...
                    "t", para.tf, "body", obj.body ...
                    );
            end 
        end
        
        function fig = plot(obj, fig)
            switch nargin
                case 1
                    fig = PlotOrbit(obj.rr, "bodyName", obj.body.name);
                case 2
                    PlotOrbit(obj.rr, "fig", fig);
                otherwise
                    error("Plot does not accept more than 1 input.");
            end
        end

        function [lat, lon] = groundtrack(obj, N, theta_g0)
            arguments
                obj OrbitPropagation
                N (1, 1) double = (obj.state_f.t - obj.state_i.t) / obj.T
                theta_g0 (1, 1) double = 0.0
            end
            if ~strcmp(obj.body.name, "Earth")
                error("Groundtraks are only supported for Earth")
            end
            
            [t_, r_, ~] = obj.getCartesianCoordinates( ...
                        obj.state_i.r, obj.state_i.v, ...
                        linspace(obj.state_i.t, N*obj.T, N*10000));
                    
            [lat, lon] = GroundTrack(r_, obj.body.om, theta_g0, t_, obj.state_i.t);
            
            PlotGroundTrack(lat, lon);
        end
        
        function kep = getKep(obj)
            kep = [obj.a obj.e obj.i obj.OM obj.om];
        end

    end
    
    methods (Access = protected)
        
        function [t, r, v] = getCartesianCoordinates(obj, r0, v0, tspan)
            [t, r, v] = OdeSolver(r0, v0, tspan, obj.body.mu, obj.body.R, ...
                obj.body.J2);
        end
        
        function [t, f] = getKeplerianCoordinates(obj, f0, tspan)
            if obj.e < 1
                [t, f] = KeplerEquationEllipse(obj.a, obj.e, ...
                           obj.body.mu, f0, tspan);
            end
            
        end
    end
end

