function comp = compensateBorders(info,radius,sz)
comp = 0;
distY = NaN;
if(info.center(1) < radius)
    distY = info.center(1);
elseif(info.center(1) > sz(1)-radius)
    distY = sz(1)-info.center(1);
end

distX = NaN;
if(info.center(2) < radius)
    distX = info.center(2);
elseif(info.center(2) > sz(2)-radius)
    distX = sz(2)-info.center(2);
end

if((isnan(distX) && isnan(distY)))
    return;
end
comp = radius-min(distY,distX);
end