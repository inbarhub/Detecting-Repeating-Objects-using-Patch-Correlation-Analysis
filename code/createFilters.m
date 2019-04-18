function [M,M_WithCorrVal,filter] = createFilters(I,ms,ps,thr,stopCond)
[w,h] = size(I);
p = 1;
C = zeros(size(I));
first = 0;
M = cell(0,0);
M_WithCorrVal = cell(0,0);
corr = cell(0,0);
filter = cell(0,0);
sz = size(I);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r = 10;
x = cell(1,r);
y = cell(1,r);
P = cell(1,r);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% I = gpuArray(I);
padded_I = padarray(I,[ps ps]);
toStop = 0;
for i = 1:80
    flag = 0;
    %%%%%%%%%%%%%%%%%should be parfor
    for j=1:r 
        x{j} = ps + randi(w-2*ps) ;
        y{j} = ps + randi(h-2*ps) ;
        P{j} = I((x{j}-ps):(x{j}+ps),(y{j}-ps):(y{j}+ps)) ;
        n = norm(P{j}(:));
        while(abs(I(x{j},y{j})) < 0.002 | C(x{j},y{j}) > 0 | norm(P{j}(:)) < 0.01)
            x{j} = ps + randi(w-2*ps) ;
            y{j} = ps + randi(h-2*ps) ;
            P{j} = I((x{j}-ps):(x{j}+ps),(y{j}-ps):(y{j}+ps)) ;
        end
       
%         X = gather(normxcorr2_gpu(P{j},padded_I));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        X = normxcorr2(P{j},padded_I);
        X = X(2*ps+1:size(X,1)-2*ps,2*ps+1:size(X,2)-2*ps);  
        
        Y_count = X;
        Y_count(Y_count < thr) = 0 ;
        s(j) = sum(Y_count(:));
    end
    [q,maxi] = max(s) ;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [X,P_out,Y] = tryClosePatches(I,padded_I,x{maxi},y{maxi},ps,thr,sz,P{maxi});
    p
    if(p==1)
        first = q;
    elseif(p==2)
        first = (q+first)/2;
    else
        if(q < stopCond*first)
            toStop = toStop+1;
            flag = 1;
        end
    end
    if(~flag)
        M{p} = double(Y);
        M{p} = checkAutoCorr(M{p},ms,sz);
        if(isempty(M{p}))
            p = p+1;
            continue;
        end
        corr{p} = Y_count;
        filter{p} = P_out;

        M_WithCorrVal{p} = zeros(sz);

        M_WithCorrVal{p}(M{p}~=0) = corr{p}(M{p}~=0);
        C=C+conv2(M{p},ones(5,5)/25,'same') ;
        p = p+1;
    end
end
end