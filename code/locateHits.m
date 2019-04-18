function [hits,K]= locateHits(I,M,M_WithCorrVal,sx,sy,ms)
[w,h] = size(I);
hits = zeros(0,0);
nf = size(M,2);
K = zeros(w,h) ;
for i=1:nf
    if(isempty(M{i}))
        continue;
    end
    dx=sx(i) ;
    dy=sy(i) ;
    B = zeros(2*ms.x+1,2*ms.y+1) ;
    B(-round(dx)+ms.x+1,-round(dy)+ms.y+1) = 1 ;
    tmp=conv2(M{i},B,'same') ;
    tmpWithCorrVal=conv2(M_WithCorrVal{i},B,'same') ;
    [row,col] = find(tmp~=0);
    loc = (tmp~=0);
    a = size(hits,1);
    hits(a+1:a+size(row,1),1) = row;
    hits(a+1:a+size(col,1),2) = col;
    hits(a+1:a+size(col,1),3) = i;
    lala = tmpWithCorrVal(:);
    hits(a+1:a+size(col,1),4) = lala(loc);
    K=K+tmp ;
end