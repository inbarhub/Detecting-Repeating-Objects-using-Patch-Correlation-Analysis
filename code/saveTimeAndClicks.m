function saveTimeAndClicks(click_count,tot_time,str_for_save,density,points_to_save)
counter = sum(density(:));
fileName=[str_for_save '/res.txt'];
%open file identifier
if exist(fileName,'file')
    fid=fopen(fileName,'a+');
    fprintf(fid,'counter: %f click_num: %f time: %f\n',counter,click_count,tot_time);
else
    fid=fopen(fileName,'w');
    fprintf(fid,'counter: %f click_num: %f time: %f\n',counter,click_count,tot_time);
end
fclose(fid);

if points_to_save ~= 0
    fileName=[str_for_save '/x_dots.txt'];
    %open file identifier
    fid=fopen(fileName,'w');
    for row = 1:length(points_to_save)
        fprintf(fid, '%f\n', points_to_save(row,1));
    end
    fclose(fid);

    fileName=[str_for_save '/y_dots.txt'];
    %open file identifier
    fid=fopen(fileName,'w');
    for row = 1:length(points_to_save)
        fprintf(fid, '%f\n', points_to_save(row,2));
    end
    fclose(fid);
end