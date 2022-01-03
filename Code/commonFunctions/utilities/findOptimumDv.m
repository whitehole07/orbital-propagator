function [M,I] = findOptimumDv(Dvs)


% FINDOPTIMUMDV:
%
%   This function finds the minimum delta velocity for an interplanetary
%   transfer with a single fly-by and the position (indexes) inside the Dvs matrix
%   that allow to understand in which dates of the departure, gravity assist and 
%   arrival array we get the minimum delta velocity 
% 
% PROTOTYPE:
%
%   [deltav,I] = FindOptimumDv(Dvs);      
% 
% INPUT:
%
%   Dvs = [mxnxk] DVs matrix computed with DvsMatrix.m
%   
% OUTPUT:
%
%   M = [1]       v_min
%   I = [1x3]     [index_dep,index_ga,index_arr]
%
% CONTRIBUTORS:
%
%   Davide Gianmoena


[v_min,index] = min(Dvs,[],'all');

[I1, I2, I3] = ind2sub(size(Dvs),index); 

M = v_min;
I = [I1 I2 I3];


end

