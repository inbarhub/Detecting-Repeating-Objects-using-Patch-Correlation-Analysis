function intervals = getZerosIntervals(vec)
sz = size(vec,2);
loc = find(vec==0);
p = 1;
intervals = [];
for i = 1:size(loc,2)
    if(isnan(vec(loc(i))))
        continue;
    end
    intervals(p,1) = loc(i);
    intervals(p,2) = 1;
    vec(loc(i)) = NaN;
    for j = loc(i)+1:sz  
        if(vec(j) == 0)
            intervals(p,2) = intervals(p,2)+1;
            vec(j) = NaN;
        else
            break;
        end
    end
    p = p+1;
end
end