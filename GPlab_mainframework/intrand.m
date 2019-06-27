function n=intrand(inf,sup,x,y)
%INTRAND    Generates an integer random number inside an interval.
%   INTRAND(INFLIMIT,SUPLIMIT,X,Y) returns random integer numbers no
%   smaller than INFLIMIT and no larger than SUPLIMIT, arranged in a
%   X-by-Y matrix. If X and Y are omitted, only one number is generated.
%
%   Input arguments:
%      INFLIMIT - the inferior limit to the random numbers (integer)
%      SUPLIMIT - the superior limit to the random numbers (integer)
%      X - number of rows of the generated matrix (integer, optional)
%      Y - number of columns of the generated matrix (integer, optional)
%   Output arguments:
%      N - the matrix of integer random numbers (array)
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

if mod(sup,1)~=0 || mod(inf,1)~=0
   error('INTRAND: All arguments must be integers!')
end

if ~exist('x','var')
   x=1;
end
if ~exist('y','var')
   y=1;
end

if sup>inf
   s=sup;
   i=inf;
elseif inf>sup
   s=inf;
   i=sup;
else
   n=repmat(inf,x,y);
   return
end

n=ceil(rand(x,y).*(s-i+1))+i-1;
