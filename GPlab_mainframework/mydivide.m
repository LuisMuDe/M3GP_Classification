function y=mydivide(x1,x2)
%MYDIVIDE    Protected division function.
%   MYDIVIDE(X1,X2) returns X1 if X2==0 and X1/X2 otherwise.
%
%   Input arguments:
%      X1 - the numerator of the division (double)
%      X2 - the denominator of the division (double)
%   Output arguments:
%      Y - the division of X1 by X2, or X1 (double)
%
%   See also MYPOWER, MYSQRT, MYLOG, MYLOG2, MYLOG10
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% first make both matrices the same size:
m=max([length(x1) length(x2)]);
if length(x1)<m
   x1=repmat(x1,m,1);
end
if length(x2)<m
   x2=repmat(x2,m,1);
end

% fill the cells where x2=0 (make them x1):
y=x1.*ones(size(x1));

% fill the remaining cells with the result of the division:
i=find(x2~=0);
y(i)=rdivide(x1(i),x2(i));
