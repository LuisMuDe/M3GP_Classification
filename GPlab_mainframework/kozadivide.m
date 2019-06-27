function y=kozadivide(x1,x2)
%KOZADIVIDE    Koza protected division function.
%   KOZADIVIDE(X1,X2) returns 1 if X2==0 and X1/X2 otherwise.
%
%   Input arguments:
%      X1 - the numerator of the division (double)
%      X2 - the denominator of the division (double)
%   Output arguments:
%      Y - the division of X1 by X2, or 1 (double)
%
%   See also MYDIVIDE, MYPOWER, MYSQRT, MYLOG, MYLOG2, MYLOG10
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% first make both matrices the same size:
if sum(size(x1)==size(x2))~=2
   nx1=repmat(x1,size(x2));
   nx2=repmat(x2,size(x1));
   x1=nx1;
   x2=nx2;
end

% fill the cells where x2=0 (make them 1):
y=ones(size(x1));

% fill the remaining cells with the result of the division:
i=find(x2~=0);
y(i)=rdivide(x1(i),x2(i));
