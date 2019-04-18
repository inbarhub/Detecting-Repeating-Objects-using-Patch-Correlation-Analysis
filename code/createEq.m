function [D,bx,by] = createEq(corr_cell,best_corr_map,ms)
X = (-ms.x:ms.x)' * ones(1,2*ms.x+1) ;
Y = ((-ms.y:ms.y)' * ones(1,2*ms.y+1))' ;
nf = size(best_corr_map,2);
bx = (zeros(nf,1));
by = (zeros(nf,1));
k=1 ;
for i = 1:nf
    for j=1:size(best_corr_map{i},2)
        xc = (corr_cell{i}{j});
        m = sum(xc(:)) ;
        xc = xc / m ;
        s = max(xc(:)) ;
        xc(xc<s) = 0 ;
        xc(xc>0) = 1 ;
        dx = sum(sum(xc .* X)) ;
        dy = sum(sum(xc .* Y)) ;
        s = (1);
        D(k,i) = s ;
        D(k,best_corr_map{i}(j)) = -s ;
        bx(k) = dx * s ;
        by(k) = dy * s ;
        k=k+1 ;
    end
    
end
end