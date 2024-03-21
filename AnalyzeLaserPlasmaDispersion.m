%% Analyze Laser Pulse Frequencies

clear;
clc;
close all;

Plasma = 0; % 1 if there is plasma, 2 if vacuum

%% Load data

% Run parameters
basedir = 'laser_in_vac1';
[dt, dx, totalDumps] = getruninfo1D(basedir);

% Allocate data storage
X = cell(totalDumps, 1);
Y = cell(totalDumps, 1);
Z = cell(totalDumps, 1);
Ez = cell(totalDumps, 1);
time = cell(totalDumps, 1);
X_p = cell(totalDumps, 1);
Rho_p = cell(totalDumps, 1);

% Load data
for t_step = 1:totalDumps
    [X{t_step}, Y{t_step}, Z{t_step}, Ez{t_step}, ~, time{t_step}] = osload(basedir,'e3','','', t_step);
    if (Plasma)
        [X_p{t_step}, ~, ~, Rho_p{t_step}, ~, ~] = osload(basedir,'charge','plasma','', t_step);
    end
end
X = cell2mat(X);
Ez = cell2mat(Ez);
X_p = cell2mat(X_p);
Rho_p = cell2mat(Rho_p);


%% Calculate Hilbert Transform and Plot

dumps = [1, 3, 10, round(height(X)/16), round(height(X)/8), round(height(X)/4), round(height(X)/2), height(X)];
x = cell(length(dumps), 1);
ez = x;
eh = x;
env = x;
k = x;
kInds = x;
rho_p = x;

for i = 1:length(dumps)
    x{i} = X(dumps(i), :);
    ez{i} = Ez(dumps(i), :);
    if (Plasma)
        rho_p{i} = Rho_p(dumps(i), :);
    end
    eh{i} = hilbert(ez{i});
    kInds{i} = abs(eh{i})>=0.1.*max(abs(eh{i}));
    env{i} = abs(eh{i});
    k{i} = gradient(unwrap(angle(eh{i})), dx);
    
    % Clean indices
    for j = 1:length(kInds{i})
        if ((j==1) && (~kInds{i}(j+1)))
            kInds{i}(j) = 0;
        elseif ((j==length(kInds{i})) && (~kInds{i}(j-1)))
            kInds{i}(j) = 0;
        elseif ((j>1) && (j<length(kInds{i})))
            if ((~kInds{i}(j+1)) && (~kInds{i}(j-1)))
                kInds{i}(j) = 0;
            end
        end
        if (k{i}(j) == 0)
            kInds{i}(j) = 0;
        end
    end


    figure;
    if (Plasma)
        subplot(2, 1, 1);
    end
    yyaxis left;
    p1 = plot(x{i}, ez{i}, '-k');
    hold on;
    p2 = plot(x{i}, env{i}, '-b');
    hold off;
    ylabel('$\frac{eE_z}{m_ec\omega_{pe}}$', 'Interpreter', 'Latex');
    yyaxis right;
    p3 = plot(x{i}(kInds{i}), k{i}(kInds{i}), '-m');
    ylabel('$ck/\omega_{pe}$', 'Interpreter', 'Latex');
    title(sprintf('Dump %d: $E_z$ and Wave Number\n%s = %f', dumps(i), '$\omega_{pe}t$', time{dumps(i)}), 'Interpreter', 'Latex');
    xlabel('$x\omega_{pe}/c$', 'Interpreter', 'Latex');
    xlim([min(x{i}), max(x{i})]);
    p1.LineWidth = 2;
    p2.LineWidth = 2;
    p3.LineWidth = 2;
    ax = gca;
    ax.LineWidth = 3;
    ax.FontSize = 20;
    ax.YAxis(1).Color = 'k';
    ax.YAxis(2).Color = 'm';
    grid on;

    if (Plasma)
        subplot(2, 1, 2);
        yyaxis left;
        p2 = plot(x{i}, env{i}, '-b');
        ylabel('$\frac{eE_z}{m_ec\omega_{pe}}$', 'Interpreter', 'Latex');
        yyaxis right;
        p4 = plot(x{i}, -rho_p{i}, '-r');
        ylabel('$-\frac{\omega_{pe}^2 \epsilon_0 m_e}{e} \rho$', 'Interpreter', 'Latex');
        title(sprintf('Dump %d: $E_z$ and Plasma Density\n%s = %f', dumps(i), '$\omega_{pe}t$', time{dumps(i)}, 'Interpreter', 'Latex'));
        xlabel('$x\omega_{pe}/c$', 'Interpreter', 'Latex');
        xlim([min(x{i}), max(x{i})]);
        p1.LineWidth = 2;
        p2.LineWidth = 2;
        p4.LineWidth = 2;
        ax = gca;
        ax.LineWidth = 3;
        ax.FontSize = 20;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'r';
        grid on;
    end
end
