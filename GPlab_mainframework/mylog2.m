function y=mylog2(x)
%MYLOG2    Protected LOG2 function.
%   MYLOG2(X) returns zero if X=0 and LOG2(ABS(X)) otherwise.
%
%   Input arguments:
%      X - the number to log (double)
%   Output arguments:
%      Y - the (base 2) logarithm of X, or zero (double)
%
%   See also MYLOG, MYLOG10, MYSQRT, MYDIVIDE, MYPOWER
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% fill the cells where x=0 (make them 0):
y=zeros(size(x));

% fill the remaining cells with the result of the logarithm:
i=find(x~=0);
y(i)=log2(abs(x(i)));
