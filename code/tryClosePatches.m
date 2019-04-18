function [X,P_out,Y] = tryClosePatches(I,padded_I,x,y,ps,thr,sz,P_maxi)
newX = cell(0,0);
newY = cell(0,0);
P = cell(0,0);
s = zeros(0);

num = 1;
for i = -1:1
    for j = -1:1
        if(i==0 && j==0)
            s(num) = norm(P_maxi(:));
            P{num} = P_maxi;
            num = num+1;
            continue;
        end
        newX{num} = x+i;
        newY{num} = y+j;
        if(newX{num}-ps < 1 || newX{num}+ps > sz(1) || newY{num}-ps < 1 || newY{num}+ps > sz(2))
            s(num) = -Inf;
            continue;
        end
        P{num} = I((newX{num}-ps):(newX{num}+ps),(newY{num}-ps):(newY{num}+ps)) ;
        s(num) = norm(P{num}(:));
        
        num = num+1;
    end   
end

[~,maxi] = max(s) ;

% X = gather(normxcorr2_gpu(gpuArray(P{maxi}),padded_I));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = normxcorr2((P{maxi}),padded_I);
X = X(2*ps+1:size(X,1)-2*ps,2*ps+1:size(X,2)-2*ps);  
Y = X;
Y(Y < thr) = 0 ;
% Y = double(imregionalmax(Y,8) );
P_out = P{maxi};

