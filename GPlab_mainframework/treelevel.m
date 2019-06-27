function s=treelevel(tree)
%TREELEVEL    Counts the number of levels of a GPLAB algorithm tree.
%   TREELEVEL(TREE) returns the number of levels, or depth, of a
%   GPLAB algorithm individual representation tree.
%
%   Input arguments:
%      TREE - the tree to measure (struct)
%   Output arguments:
%      NLEVELS - the depth level of the tree (integer)
%
%   See also NODES, MAKETREE
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

nkids=size(tree.kids,2);
if nkids<0
   error('TREELEVEL: number of children lower than 0!');
end

s=1; % root of this subtree
if nkids>0
   for i=1:nkids
      k(i)=treelevel(tree.kids{i});      
   end
   s=s+max(k);
end
