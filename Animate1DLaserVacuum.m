function [] = Animate1DLaserVacuum(basedir, frame_period)
    
    [~, dx, totalDumps] = getruninfo1D(basedir);

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
    
    % Calculate figure y limits
    ylimits = [min(-Ex(:)), max(-Ex(:))];
    
    %% Create animation
    ax = gca;
    for t_step = 1:totalDumps
        xlim([dx*min(X(t_step, :)), dx*max(X(t_step, :))]);
        p1 = plot(dx*X(t_step, :), Ex(t_step, :), '-b', 'LineWidth', 2);
        xlim([dx*min(X(t_step, :)), dx*max(X(t_step, :))]);
        ylim(ylimits);
        ax.FontSize = 16;
        ax.LineWidth = 3;
        grid on;
        title(sprintf('Laser Pulse in Vacuum Simulation\n%s = %f', '$t\omega_{pe}$', time{t_step}), 'Interpreter', 'Latex');
        xlabel('$x\omega_{pe}/c$', 'Interpreter', 'Latex');
        ylabel('$\frac{eE_z}{m_ec\omega_{pe}}$', 'Interpreter', 'Latex');
        pause(frame_period);
    end
end