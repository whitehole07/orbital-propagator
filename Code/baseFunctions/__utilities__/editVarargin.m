function outputVarargin = editVarargin(inputVarargin, field, value, changeIfIn)
%EDITVARA Summary of this function goes here
%   Detailed explanation goes here
% Replace minDv and set title
    if nargin < 4
        changeIfIn = true;
    end

    found_flag = 0;
    for i = 1:size(inputVarargin, 2)
        if strcmp(inputVarargin{i}, field)
            if changeIfIn
                inputVarargin{i+1} = value;
            end
            found_flag = 1;
            break
        end
    end
    if ~found_flag
        inputVarargin{end+1} = field;
        inputVarargin{end+1} = value;
    end

    outputVarargin = inputVarargin;
end

