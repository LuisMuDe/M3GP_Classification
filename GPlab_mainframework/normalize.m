function nv=normalize(v,s)
%NORMALIZE    Normalizes vectors.
%   NORMALIZE(VECTOR,SUM) returns the normalized VECTOR so that
%   the sum of its elements is SUM, and all elements are >=0.
%
%   Input arguments:
%      VECTOR - the vector to normalize (1xN matrix)
%      SUM - the total to which the normalized vector should sum (double)
%   Output arguments:
%      NORMVECTOR - the normalized VECTOR (1xN matrix)
%
%   Example:
%      VECTOR = [1,-1,4,2,0]
%      SUM = 1
%      NORMVECTOR = NORMALIZE(VECTOR,SUM)
%      NORMVECTOR = 0.1818         0    0.4545    0.2727    0.0909
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% if v is a scalar, set it to s and we're done:
if length(v)==1
    nv=s;
    return
end

% if there are negative elements in v, set the lower value to 0
% and the others accordingly:
if min(v)<0
   v=v+abs(min(v));
   if sum(v)==0
       % this means all elements were equal, so just set them all to 1
       v=ones(1,length(v));
   end
end

if sum(v)==0
   error('NORMALIZE: Division by zero!')
else
   nv=s*(v./sum(v));
end
