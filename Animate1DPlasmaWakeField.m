function [] = Animate1DPlasmaWakeField(basedir, frame_period)
    
    [dt, dx, totalDumps] = getruninfo1D(basedir);

    % Allocate data storage
    X_p = cell(totalDumps, 1);
    Y_p = cell(totalDumps, 1);
    Z_p = cell(totalDumps, 1);
    data_p = cell(totalDumps, 1);
    time_p = cell(totalDumps, 1);
    X_b = cell(totalDumps, 1);
    Y_b = cell(totalDumps, 1);
    Z_b = cell(totalDumps, 1);
    data_b = cell(totalDumps, 1);
    time_b = cell(totalDumps, 1);
    
    % Load data
    for t_step = 1:totalDumps
        [X_p{t_step}, Y_p{t_step}, Z_p{t_step}, data_p{t_step}, ~, time_p{t_step}] = osload(basedir,'charge','plasma','', t_step);
        [X_b{t_step}, Y_b{t_step}, Z_b{t_step}, data_b{t_step}, ~, time_b{t_step}] = osload(basedir,'charge','beam','', t_step);
    end
    X_p = cell2mat(X_p);
    data_p = cell2mat(data_p);
    X_b = cell2mat(X_b);
    data_b = cell2mat(data_b);
    
    % Calculate figure y limits
    ylimits = [min(-data_p(:)), max(-data_p(:))];
    
    %% Create animation
    ax = gca;
    for t_step = 1:totalDumps
        xlim([min(dx*X_p(t_step, :)), max(dx*X_p(t_step, :))]);
        p1 = plot(dx*X_p(t_step, :), -data_p(t_step, :), '-b', 'LineWidth', 2);
        hold on;
        p2 = plot(dx*X_b(t_step, :), -data_b(t_step, :)+1, '-r', 'LineWidth', 2);
        hold off;
        xlim([min(dx*X_p(t_step, :)), dx*max(X_p(t_step, :))]);
        ylim(ylimits);
        ax.FontSize = 16;
        ax.LineWidth = 3;
        grid on;
        title(sprintf('Plasma Wakefield Simulation\n%s = %f', '$t\omega_{pe}$', time{t_step}), 'Interpreter', 'Latex');
        xlabel('$x\omega_{pe}/c$', 'Interpreter', 'Latex');
        ylabel('Negative Charge Density', 'Interpreter', 'Latex');
        legend('plasma', 'beam (shifted up to plasma density)', 'Interpreter', 'Latex', 'Location', 'eastoutside');
        pause(frame_period)
    end
end