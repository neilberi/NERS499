function [] = Animate1DLaserPlasma(basedir, frame_period)
    
    [dt, dx, totalDumps] = getruninfo1D(basedir);

    % Allocate data storage
    X = cell(totalDumps, 1);
    Y = cell(totalDumps, 1);
    Z = cell(totalDumps, 1);
    Ez = cell(totalDumps, 1);
    time = cell(totalDumps, 1);
    X_p = cell(totalDumps, 1);
    rho_p = cell(totalDumps, 1);
    
    % Load data
    for t_step = 1:totalDumps
        [X{t_step}, Y{t_step}, Z{t_step}, Ez{t_step}, ~, time{t_step}] = osload(basedir,'e3','','', t_step);
        [X_p{t_step}, ~, ~, rho_p{t_step}, ~, ~] = osload(basedir,'charge','plasma','', t_step);
    end
    X = cell2mat(X);
    Ez = cell2mat(Ez);
    X_p = cell2mat(X_p);
    rho_p = cell2mat(rho_p);
    
    % Calculate figure y limits
    ylimitsLeft = [min(Ez(:)), max(Ez(:))];
    ylimitsRight = [min(-rho_p(round(end/4):(end-1), 2:(end-1)), [], 'all'), max(-rho_p(round(end/4):(end-1), 2:(end-1)), [], 'all')];
    
    %% Create animation
    ax = gca;
    for t_step = 1:totalDumps
        xlim([dx*min(X(t_step, :)), dx*max(X(t_step, :))]);
        yyaxis left;
        p2 = plot(dx*X(t_step, :), Ez(t_step, :), '-b', 'LineWidth', 2);
        ylabel('$\frac{eE_z}{m_ec\omega_{pe}}$', 'Interpreter', 'Latex');
        ylim(ylimitsLeft);
        yyaxis right;
        p1 = plot(dx*X_p(t_step, :), -rho_p(t_step, :), '.r', 'MarkerSize', 12);
        ylabel('$-\rho/\rho_0$', 'Interpreter', 'Latex');
        ylim(ylimitsRight);
        xlim([dx*min(X(t_step, :)), dx*max(X(t_step, :))]);
        ax.FontSize = 16;
        ax.LineWidth = 3;
        grid on;
        title(sprintf('Laser Pulse in Plasma Simulation\n%s = %f', '$t\omega_{pe}$', time{t_step}), 'Interpreter', 'Latex');
        xlabel('$x\omega_{pe}/c$', 'Interpreter', 'Latex');
        legend('laser', 'plasma')
        pause(frame_period);
    end
end