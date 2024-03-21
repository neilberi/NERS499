function [] = LaserWignerPlot(E, xi, t, yLim)
    dxi = diff(xi(1:2));
    [wig, f] = wvd(E, 1/dxi);
    k = f*2*pi;
    im = imagesc(xi, k, wig);
    axis xy;
    title(sprintf('Wigner Transform of Electric Field\n t = %f%s', t, '$\omega_{pe}$'), 'Interpreter', 'Latex');
    xlabel('$\frac{\omega_{pe}}{c} (x - ct)$', 'Interpreter', 'Latex');
    ylabel('$\frac{ck}{\omega_{pe}}$', 'Interpreter', 'Latex');
    ax = gca;
    ax.LineWidth = 3;
    ax.FontSize = 20;
    if exist('yLim', 'var')
        ylim(yLim);
    end
end