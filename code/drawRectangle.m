function new_I = drawRectangle(new_I,x_start,x_end,y_start,y_end,r,g,I)
p = 2;
new_I(x_start:x_end,y_start:min(y_start+p,size(I,2)),1) = r;
new_I(x_start:x_end,y_start:min(y_start+p,size(I,2)),2) = g;
new_I(x_start:x_end,y_start:min(y_start+p,size(I,2)),3) = 0;

new_I(x_start:x_end,y_end:min(y_end+p,size(I,2)),1) = r;
new_I(x_start:x_end,y_end:min(y_end+p,size(I,2)),2) = g;
new_I(x_start:x_end,y_end:min(y_end+p,size(I,2)),3) = 0;

new_I(x_start:min(x_start+p,size(I,1)),y_start:y_end,1) = r;
new_I(x_start:min(x_start+p,size(I,1)),y_start:y_end,2) = g;
new_I(x_start:min(x_start+p,size(I,1)),y_start:y_end,3) = 0;

new_I(x_end:min(x_end+p,size(I,1)),y_start:y_end,1) = r;
new_I(x_end:min(x_end+p,size(I,1)),y_start:y_end,2) = g;
new_I(x_end:min(x_end+p,size(I,1)),y_start:y_end,3) = 0;
end
