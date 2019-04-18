function centers = getCenters(info)
num = size(info,2);
centers = zeros(num,2);
for i = 1:num
    centers(i,1:2) = info(i).center(1:2);
end
end