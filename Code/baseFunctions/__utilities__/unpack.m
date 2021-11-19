function varargout = unpack(x)
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
    varargout = num2cell(x);
end

