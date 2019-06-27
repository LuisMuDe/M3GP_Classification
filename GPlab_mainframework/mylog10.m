function y=mylog10(x)
%MYLOG10    Protected LOG10 function.
%   MYLOG10(X) returns zero if X=0 and LOG10(ABS(X)) otherwise.
%
%   Input arguments:
%      X - the number to log (double)
%   Output arguments:
%      Y - the (base 10) logarithm of X, or zero (double)
%
%   See also MYLOG, MYLOG2, MYSQRT, MYDIVIDE, MYPOWER
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% fill the cells where x=0 (make them 0):
y=zeros(size(x));

% fill the remaining cells with the result of the logarithm:
i=find(x~=0);
y(i)=log10(abs(x(i)));
