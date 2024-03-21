%% Analyze Laser Group Velocity

clear;
clc;
close all;

Plasma = 1; % 1 if there is plasma, 2 if vacuum

%% Load data

% Run parameters
basedir = 'laser_in_plasma13';
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
end
X = cell2mat(X);
Ez = cell2mat(Ez);
X_p = cell2mat(X_p);    
Rho_p = cell2mat(Rho_p);


%% Calculate k and vg
[t, vg] = LaserPulse_vg(basedir, 'centroid');
if (Plasma)
    [~, n] = LaserPulse_natpeak(basedir, 'centroid');
end

omega0 = getruninfo(basedir, 'omega0', 'num');
dt_sim = getruninfo(basedir, 'dt', 'num');
a0 = getruninfo(basedir, 'a0', 'num');
k = 2./dx.*asin(dx*sqrt(sin(omega0.*dt_sim./2).^2./dt_sim^2 - 1/4*Plasma));
vg_pred = dt_sim./dx.*sin(k.*dx)./sin(omega0.*dt_sim).*ones(size(t));
if (Plasma)
    vg_pred_lin = sqrt(1-omega0^(-2)).*ones(size(t));
    vg_pred_nlin = sqrt(1-omega0^(-2))/sqrt(1+a0^2/2).*n;
else
    vg_pred_lin = ones(size(t));
end

%% Plot

figure;
LaserPulse_phaseplot(basedir, 'centroid');

figure;
p1 = plot(t, smoothvg(vg, 1), '-k');
hold on;
p2 = plot(t, vg_pred_lin, '--b');
p3 = plot(t, vg_pred, '--r');
if (Plasma)
    p4 = plot(t, vg_pred_nlin, '--m');
end
hold off;
p1.LineWidth = 2;
p2.LineWidth = 2;
p3.LineWidth = 2;
p4.LineWidth = 2;
title('Comparison of Predicted $v_g$ to $v_g$ from Simulation', 'Interpreter', 'Latex');
xlabel('$\omega_{pe}t$', 'Interpreter', 'Latex');
ylabel('$v_g/c$', 'Interpreter', 'Latex');
if (Plasma)
    legend('simulation', 'predicted (linear)', 'predicted (numerical)', 'predicted (nonlinear)', 'Interpreter', 'Latex');
else
    legend('simulation', 'predicted (linear)', 'predicted (numerical)', 'Interpreter', 'Latex');

end
ax = gca;
ax.FontSize = 18;
ax.LineWidth = 3;
grid on;


