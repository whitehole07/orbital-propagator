function [M, I] = findMin(array)
%FINDMIN Summary of this function goes here
%   Detailed explanation goes here

    arguments
        array double
    end
    
    % Find possible minimum
    M = min(array, [], 'all');

    switch length(size(array))
        case 2
            % Find indices
            [i, j] = find(array == M);

            % Index vector
            I = [i j];
        case 3
            % Reduce dimension
            [Ms, is] = min(array);
        
            % Squeeze
            Ms = squeeze(Ms); is = squeeze(is);
        
            % Find minimum value position inside the Dvs matrix
            [j, k] = find(squeeze(Ms) == M); i = squeeze(is(j, k));
        
            % Index vector
            I = [i j k];
    end
end

