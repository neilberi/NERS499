function [val] = getruninfo(basedir, param, type)
    assert(strcmp(type, 'str') || strcmp(type, 'num'), "Invalid parameter type: use 'str' or 'num'");
    
    filename = [basedir, '/run-info'];
    fin = fopen(filename);
    line = fgetl(fin);
    while(ischar(line))
        sline = split(line);
        
        if (numel(sline) >= 2)
            if (strcmp(sline{2}, param))
                val = sline{end};
                val = val(1:(end-1));
                if strcmp(type, 'num')
                    val = str2double(val);
                end
            end
        end
        
    line = fgetl(fin);
    end
end