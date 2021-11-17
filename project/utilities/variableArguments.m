function options = variableArguments(options, passedVarargin, caseSensitive)
    %# options example
    % options = struct('firstparameter', 1, 'secondparameter', magic(3));

    %# read the acceptable names
    optionNames = fieldnames(options);

    %# count arguments
    nArgs = length(passedVarargin);
    if round(nArgs/2)~=nArgs/2
       error('propertyName/propertyValue pairs required')
    end

    for pair = reshape(passedVarargin,2,[]) %# pair is {propName;propValue}
       if caseSensitive
            inpName = pair{1}; %# case sensitive
       else
            inpName = lower(pair{1}); %# make case insensitive
       end

       if any(strcmp(inpName,optionNames))
          %# overwrite options. If you want you can test for the right class here
          %# Also, if you find out that there is an option you keep getting wrong,
          %# you can use "if strcmp(inpName,'problemOption'),testMore,end"-statements
          options.(inpName) = pair{2};
       else
          error('%s is not a recognized parameter name', inpName)
       end
    end
end

