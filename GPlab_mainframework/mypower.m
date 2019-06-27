function y=mypower(x1,x2)
%MYPOWER    Protected power function.
%   MYPOWER(X1,X2) returns 0 if X1^X2 is NaN or Inf, 
%   or has imaginary part, otherwise returns X1^X2.
%
%   Input arguments:
%      X1 - the base of the power function (double)
%      X2 - the exponent of the power function (double)
%   Output arguments:
%      Y - the power X1^X2, or 0 (double)
%
%   See also MYDIVIDE, MYSQRT, MYLOG, MYLOG2, MYLOG10
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

y=x1.^x2;
%y(find(isnan(y) | isinf(y) | imag(y)))=0;
y(find(isnan(y) || isinf(y) || ~isreal(y)))=0;
