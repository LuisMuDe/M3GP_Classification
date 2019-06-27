function y=mysqrt(x)
%MYSQRT    Protected SQRT function.
%   MYSQRT(X) returns zero if X<=0 and SQRT(X) otherwise.
%
%   Input arguments:
%      X - the number to square root (double)
%   Output arguments:
%      Y - the square root of X, or zero (double)
%
%   See also MYPOWER, MYDIVIDE, MYLOG, MYLOG2, MYLOG10
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% fill the cells where x<0 (make them 0):
y=zeros(size(x));

% fill the remaining cells with the result of the square root:
i=find(x>=0);
y(i)=sqrt(x(i));
