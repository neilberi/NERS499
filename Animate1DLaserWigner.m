function [] = Animate1DLaserWigner(basedir, frame_period, yLim)
    [~, ~, totalDumps] = getruninfo1D(basedir);

    % Allocate data storage
    X = cell(totalDumps, 1);
    Y = cell(totalDumps, 1);
    Z = cell(totalDumps, 1);
    Ex = cell(totalDumps, 1);
    time = cell(totalDumps, 1);
    
    % Load data
    for t_step = 1:totalDumps
        [X{t_step}, Y{t_step}, Z{t_step}, Ex{t_step}, ~, time{t_step}] = osload(basedir,'e3','','', t_step);
    end
    X = cell2mat(X);
    Ex = cell2mat(Ex);
    t = cell2mat(time)';
    
    if exist('yLim', 'var')
        for t_step = 1:totalDumps
            LaserWignerPlot(Ex(t_step, :), X(t_step, :) - t(t_step), t(t_step), yLim);
            pause(frame_period);
        end
    else
        for t_step = 1:totalDumps
            LaserWignerPlot(Ex(t_step, :), X(t_step, :) - t(t_step), t(t_step));
            pause(frame_period);
        end
    end
end