function filtered = MovmeanLPF(t, data, time_window)
%unpack Convenient way to unpack an array to single variables
%
% PROTOTYPE:
% [a1, a2, ..., aN] = unpack(x)
%
% INPUT:
% x   [N-D array]    Generic array of scalars to be unpacked
%
% OUTPUT:
% a1  [1x1] First generic output
% .
% .
% .
% aN  [1x1] Last generic output
%
% CONTRIBUTORS:
% Daniele Agamennone
%
% VERSIONS
% 2021-11-18: First version
%   
    % Check spacing
    Dt = t(end) - t(end - 1);
    toll = 1e-4; % diff tolerance
    if any((diff(t) - Dt) >= toll)
        error("Data array must be equally spaced in time.")
    end

    % Movmean filter
    window_points = time_window / Dt;
    filtered = movmean(data, window_points);
end

