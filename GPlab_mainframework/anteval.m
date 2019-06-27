function anteval(tree)
%ANTEVAL    Evaluates the tree of a GPLAB artificial ant.
%   ANTEVAL evaluates the tree of an artificial ant by calling feval on the
%   tree root, with or without arguments, where arguments are the subtrees.
%
%   Input arguments:
%      TREE - the tree to be evaluated (struct)
%
%   See also ANTFITNESS, ANTFOODAHEAD, ANTMOVE, ANTRIGHT, ANTLEFT, ANTIF, ANTPROGN2, ANTPROG3
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

global ntime;
global maxtime;

if ntime<maxtime
    
    if isempty(tree.kids)
        % call function to execute terminal:
        feval(tree.op);
    else
        % call function to execute non-terminal with kids as argument:
        feval(tree.op,tree.kids);
    end

end