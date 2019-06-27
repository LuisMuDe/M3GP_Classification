function y=Undivide(x1)
%MYDIVIDE    Protected division function.
%   Undivide(X1) returns 1 if 1/0 and 1/X1 otherwise.
%
%   Input arguments:
%    
%      X1 - the denominator of the division (double)
%   Output arguments:
%      Y - the division of X1 by X2, or X1 (double)
%
%   See also MYPOWER, MYSQRT, MYLOG, MYLOG2, MYLOG10
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% first make both matrices the same size:
m=max([length(x1)]);
if length(x1)<m
   x1=repmat(x1,m,1);
end


% fill the cells where x2=0 (make them x1):
y=x1.*ones(size(x1));

% fill the remaining cells with the result of the division:
i=find(x1~=0);
y(i)=rdivide(1,x1(i));