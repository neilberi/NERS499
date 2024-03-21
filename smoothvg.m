function [vg] = smoothvg(vg_in, steps)
    vg = zeros(size(vg_in));
    numFull = floor(length(vg_in)/steps);
    for i = 1:numFull
        left = (i-1)*steps + 1;
        right = i*steps;
        vg(left:right) = mean(vg_in(left:right));
    end
    
    if (numFull < length(vg_in)/steps)
        leftover = length(vg_in) - numFull*steps;
        vg((end-leftover+1):end) = mean(vg_in((end-steps+1):end));
    end
end