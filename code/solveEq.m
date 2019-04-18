function [sx,sy] = solveEq(D,bx,by)
sx = D \ bx ;
sy = D \ by ;
sx = sx - mean(sx(:)) ;
sy = sy - mean(sy(:)) ;