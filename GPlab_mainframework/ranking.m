function r=ranking(v,descending)
%RANKING    Ranks the elements of a vector.
%   RANKING(VECTOR,DESCORDER) returns a vector containing the
%   rank number of each element in VECTOR. If DESCORDER is true,
%   the higher the number the lower the rank number; otherwise,
%   the lower the number the lower the rank number. The same
%   numbers in VECTOR will get the same rank.
%
%   Input arguments:
%      VECTOR - the vector of numbers to rank (1xN matrix)
%      DESCORDER - the flag for descending order ranking (boolean)
%   Output arguments:
%      R - the rank numbers of the elements of VECTOR (1xN matrix)
%
%   Example:
%      VECTOR = [4.43 7.32 3.44 3.44 1.05]
%      DESCORDER = 0
%      R = RANKING(VECTOR,DESCORDER)
%      R = 3     4     2     2     1
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

sv=unique(v);
% now sv is ordered (ascending)

% check order:
if descending
   sv=flipdim(sv,2);
end

% put v against sorted v (sv):
v=repmat(v,size(sv,2),1);
sv=repmat(sv',1,size(v,2));

% now find the row indices where they match, which indicate the rank:
[r,ans]=find(v==sv);
% (do not remove ans, or find will not return x,y, but only the global index)

% transpose r if it's a column vector (it isn't only if all individuals have the same rank):
if size(r,2)==1
   r=r';
end



