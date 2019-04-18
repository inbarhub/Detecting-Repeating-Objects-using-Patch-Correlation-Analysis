function saveTimeAndClicks(click_count,tot_time,str_for_save,density)
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
