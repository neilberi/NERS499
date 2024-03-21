function [t, n_peak] = LaserPulse_natpeak(basedir, method)

    assert(strcmp(method, 'max') || strcmp(method, 'centroid'), 'ERROR: "max" and "centroid" are the only valid inputs for method');

    [dt, ~, totalDumps] = getruninfo1D(basedir);

    % Allocate Ez storage
    X = cell(totalDumps, 1);
    Y = cell(totalDumps, 1);
    Z = cell(totalDumps, 1);
    Ez = cell(totalDumps, 1);
    time = cell(totalDumps, 1);
    Rho_p = cell(totalDumps, 1);
    
    % Load Ez
    for t_step = 1:totalDumps
        [X{t_step}, Y{t_step}, Z{t_step}, Ez{t_step}, ~, time{t_step}] = osload(basedir,'e3','','', t_step);
        [~, ~, ~, Rho_p{t_step}, ~, ~] = osload(basedir,'charge','plasma','', t_step);
    end
    X = cell2mat(X)';
    Ez = cell2mat(Ez)';
    Rho_p = cell2mat(Rho_p)';
    
    t = cell2mat(time)';

    Ezh = hilbert(Ez);

    % Find wave peak trajectory
    n_peak = zeros(size(t));
    x_peak = zeros(size(t));
    for i = 1:length(x_peak)
        if (strcmp(method, 'centroid'))
            x_peak(i) = sum(X(:, i).*(abs(Ez(:, i)).^2))./sum((abs(Ez(:, i)).^2));
        else
            xslice = X(:, i);
            x_peak(i) = xslice(abs(Ezh(:, i)) == max(abs(Ezh(:, i))));
        end
        n_peak(i) = interp1(X(:, i), Rho_p(:, i), x_peak(i));
    end

    n_peak = abs(n_peak);

end