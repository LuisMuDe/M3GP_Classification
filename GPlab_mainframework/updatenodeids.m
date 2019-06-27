function tree=updatenodeids(tree,d)
%UPDATENODEIDS    Updates the node ids of a GPLAB tree.
%   UPDATENODEIDS(TREE,DIFFERENCE) returns TREE with DIFFERENCE
%   added to all its node ids.
%   
%   Input arguments:
%      TREE - the tree to update the node ids (struct)
%      DIFFERENCE - the value to add to the node ids (integer)
%   Output arguments:
%      TREE - the tree with updated node ids (struct)
%
%   See also SWAPNODES
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

tree.nodeid=tree.nodeid+d;
tree.maxid=tree.maxid+d;

for i=1:length(tree.kids)
   tree.kids{i}=updatenodeids(tree.kids{i},d);
end
