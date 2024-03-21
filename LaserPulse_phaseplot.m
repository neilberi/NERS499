function [] = LaserPulse_phaseplot(basedir, method)

    assert(strcmp(method, 'max') || strcmp(method, 'centroid'), 'ERROR: "max" and "centroid" are the only valid inputs for method');

    [~, ~, totalDumps] = getruninfo1D(basedir);

    % Allocate Ez storage
    X = cell(totalDumps, 1);
    Y = cell(totalDumps, 1);
    Z = cell(totalDumps, 1);
    Ez = cell(totalDumps, 1);
    time = cell(totalDumps, 1);
    
    % Load Ez
    for t_step = 1:totalDumps
        [X{t_step}, Y{t_step}, Z{t_step}, Ez{t_step}, ~, time{t_step}] = osload(basedir,'e3','','', t_step);
    end
    X = cell2mat(X)';
    Ez = cell2mat(Ez)';
    t = cell2mat(time)';
    xi = X(:, 1) - t(1);
    [T, Xi] = meshgrid(t, xi);

    Ezh = hilbert(Ez);

    % Find wave peak trajectory
    x_peak = zeros(size(t));
    for i = 1:length(x_peak)
        if (strcmp(method, 'centroid'))
            x_peak(i) = sum(X(:, i).*(abs(Ez(:, i)).^2))./sum((abs(Ez(:, i)).^2));
        else
            xslice = X(:, i);
            x_peak(i) = xslice(abs(Ezh(:, i)) == max(abs(Ezh(:, i))));        
        end
    end
    xi_peak = x_peak - t;
    z_peak = max(abs(Ezh(:))).*ones(size(xi_peak));
    
    % Plot
    hold on;
    s = surf(T, Xi, abs(Ezh), 'EdgeAlpha', 0);
    p = plot3(t, xi_peak, z_peak, '-r');
    p.LineWidth = 3;
    colorbar;
    xlim([min(t), max(t)]);
    ylim([min(xi), max(xi)]);
    view(0, 90);
    title('Electric Field Magnitude ($\frac{eE_z}{m_ec\omega_{pe}}$)', 'Interpreter', 'Latex');
    xlabel('$\omega_{pe}t$', 'Interpreter', 'Latex');
    ylabel('$\frac{\omega_{pe}}{c}(x - ct)$', 'Interpreter', 'Latex');
    legend('field strength', 'pulse peak position', 'Interpreter', 'Latex');
    ax = gca;
    ax.LineWidth = 3;
    ax.FontSize = 16;
    hold off;

end