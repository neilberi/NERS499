function [dt, dx, totalDumps] = getruninfo1D(basedir)
    filename = [basedir, '/run-info'];
    fin = fopen(filename);
    line = fgetl(fin);
    while(ischar(line))
        sline = split(line);
        
        if (numel(sline) >= 2)
            if (strcmp(sline{2}, 'dt'))
                dt = sline{end};
                dt = dt(1:(end-1));
                dt = str2double(dt);
            elseif (strcmp(sline{2}, 'ndump'))
                ndump = sline{end};
                ndump = ndump(1:(end-1));
                ndump = str2double(ndump);
            elseif (strcmp(sline{2}, 'tmin'))
                tmin = sline{end};
                tmin = tmin(1:(end-1));
                tmin = str2double(tmin);
            elseif (strcmp(sline{2}, 'tmax'))
                tmax = sline{end};
                tmax = tmax(1:(end-1));
                tmax = str2double(tmax);
            elseif (strcmp(sline{2}, 'xmin(1:1)'))
                xmin = sline{end};
                xmin = xmin(1:(end-1));
                xmin = str2double(xmin);
            elseif (strcmp(sline{2}, 'xmax(1:1)'))
                xmax = sline{end};
                xmax = xmax(1:(end-1));
                xmax = str2double(xmax);
            elseif (strcmp(sline{2}, 'nx_p(1:1)'))
                nx_p = sline{end};
                nx_p = nx_p(1:(end-1));
                nx_p = str2double(nx_p);
            end
        end
        
    line = fgetl(fin);
    end

    dt = ndump*dt;
    dx = (xmax-xmin)/nx_p;
    totalDumps = floor((tmax-tmin)/dt);
end