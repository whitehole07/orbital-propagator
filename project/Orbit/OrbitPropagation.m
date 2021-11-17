classdef OrbitPropagation < handle
    %ORBIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        a
        e
        i
        OM
        om

        orbit_state_i
        orbit_state_f
        
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
        odeOptions = odeset('RelTol', 1e-13, 'AbsTol', 1e-14);
    end
    
    methods (Access = public)
        
        function obj = OrbitPropagation(varargin)
            %ORBIT Construct an instance of this class
            %   Input parameters: orbit_state
            
            argumentsStruct = struct( ...
            "orbit_state_i", NaN, ...
            "orbit_state_f", NaN, ...
            "tf", NaN, ...
            "Dt", NaN ...
            );

            para = variableArguments(argumentsStruct, varargin, true);

            if ~isa(para.orbit_state_i, 'OrbitState')
                error("You must pass the initial orbit state")
            end

            obj.orbit_state_i = para.orbit_state_i;
            obj.a = obj.orbit_state_i.a; obj.e = obj.orbit_state_i.e;
            obj.i = obj.orbit_state_i.i; obj.OM = obj.orbit_state_i.OM;
            obj.om = obj.orbit_state_i.om; obj.body = obj.orbit_state_i.body;
            obj.T = obj.orbit_state_i.T; obj.n = obj.orbit_state_i.n;
            obj.eps = obj.orbit_state_i.eps; obj.h = obj.orbit_state_i.h;

            if isa(para.orbit_state_f, 'OrbitState')
                para.tf = para.orbit_state_f.t;
                obj.orbit_state_f = para.orbit_state_f;
            elseif ~isnan(para.Dt)
                para.tf = obj.orbit_state_i.t + para.Dt;
            elseif isnan(para.tf)
                error("You must pass at least one between orbit_state_f, tf and Dt")
            end
            
            obj.tt = linspace(obj.orbit_state_i.t, para.tf, 1000)';
            [~, obj.rr, obj.vv] = obj.getCartesianCoordinates( ...
                            obj.orbit_state_i.r, obj.orbit_state_i.v, obj.tt);

            [~, obj.ff] = obj.getKeplerianCoordinates(obj.orbit_state_i.f, obj.tt);
            
            if isnan(para.orbit_state_f)
                obj.orbit_state_f = OrbitState( ...
                                                "r", obj.rr(end, :)', ...
                                                "v", obj.vv(end, :)', ...
                                                "t", para.tf, ...
                                                "body", obj.body ...
                                                );
            end 
        end
        
        function fig = plot(obj, fig)
            switch nargin
                case 1
                    fig = plotOrbit(obj.rr, obj.body.R);
                case 2
                    fig = plotOrbit(obj.rr, obj.body.R, fig);
                otherwise
                    error("Plot does not accept more than 1 input.");
            end
        end

        function [lat, lon] = groundtrack(obj, N, theta_g0)
            arguments
                obj OrbitPropagation
                N (1, 1) double = (obj.orbit_state_f.t - obj.orbit_state_i.t) / obj.T
                theta_g0 (1, 1) double = 0.0
            end
            if ~strcmp(obj.body.name, "Earth")
                error("Groundtraks are only supported for Earth")
            end
            
            [t_, r_, ~] = obj.getCartesianCoordinates( ...
                        obj.orbit_state_i.r, obj.orbit_state_i.v, ...
                        linspace(obj.orbit_state_i.t, N*obj.T, N*10000));
                    
            [lat, lon] = groundTrack(r_(:, 1), r_(:, 2), r_(:, 3), ...
                         vecnorm(r_')', obj.body.om, theta_g0, t_, obj.orbit_state_i.t);
            
            plotGroundTrack(lat, lon);
        end
        
        function kep = getKep(obj)
            kep = [obj.a obj.e obj.i obj.OM obj.om];
        end

    end
    
    methods (Access = protected)
        
        function [t, r, v] = getCartesianCoordinates(obj, r0, v0, tspan)
             [t, y] = ode113(@(t,y) odeTwoBp(t, y, obj.body.mu, ... 
                 obj.body.R, obj.body.J2), tspan, [r0 v0], obj.odeOptions);
                             
             r = y(:, 1:3);
             v = y(:, 4:end);
        end
        
        function [t, f] = getKeplerianCoordinates(obj, f0, tspan)
            if obj.e < 1
                [t, f] = tTofEllipse(obj.a, obj.e, ...
                           obj.body.mu, f0, tspan);
            end
            
        end
    end
end

