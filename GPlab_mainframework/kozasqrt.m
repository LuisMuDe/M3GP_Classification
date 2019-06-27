function y=kozasqrt(x)
%KOZASQRT    Koza protected SQRT function.
%   KOZASQRT(X) returns SQRT(ABS(X)).
%
%   Input arguments:
%      X - the number to square root (double)
%   Output arguments:
%      Y - the square root of X, or zero (double)
%
%   See also MYSQRT, MYPOWER, MYDIVIDE, MYLOG, MYLOG2, MYLOG10
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

y=sqrt(abs(x));
