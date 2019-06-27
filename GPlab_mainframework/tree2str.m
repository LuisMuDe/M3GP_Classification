function str=tree2str(tree)
%TREE2STR    Translates a GPLAB algorithm tree into a string.
%   TREE2STR(TREE) returns the string represented by the tree,
%   in valid Matlab notation, ready for evaluation.
%
%   Input arguments:
%      TREE - the tree to translate (struct)
%   Output arguments:
%      STRING - the string respresented by the tree (string)
%
%   See also MAKETREE
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

str=tree.op;
args=[];
for k=1:length(tree.kids)
   args{k}=tree2str(tree.kids{k});
end
if ~isempty(args)
	str=strcat(str,'(',implode(args,','),')');
end
