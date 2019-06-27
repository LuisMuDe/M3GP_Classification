function [validind,state]=strictdepth(ind,pop,params,state,data,parentindices)
%STRICTDEPTH    Applies strict depth filters to a new GPLAB individual.
%   [VALIDIND,STATE]=STRICTDEPTH(IND,POP,PARAMS,STATE,DATA,PARENTS)
%   tests if an individual (IND) conforms to the strict maximum
%   depth rules. If not, returns one of its parents.
%
%   Input arguments:
%      IND - individual to be validated (array)
%      POPULATION - the current population of the algorithm (array)
%      PARAMS - the running parameters of the algorithm (struct)
%      STATE - the current state of the algorithm (struct)
%      DATA - the dataset for use in the algorithm (struct)
%      PARENTS - the indices of the parents of IND (matrix)
%   Output arguments:
%      VALIDIND - valid individual (IND or one of its parents) (array)
%      STATE - the updated state of the algorithm (struct)
%
%   References:
%      Koza J. (1992) "Genetic Programming: On the Programming of
%      Computers by Means of Natural Selection". MIT Press.
%      Silva S. and Almeida J. (2003) "Dynamic maximum tree depth - a
%      simple technique for avoiding bloat in tree-based GP". GECCO-2003.
%
%   See also VALIDATEINDS, STRICTNODES, HEAVYDYNDEPTH, ... (the other filters)
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% tree level is needed:
if isempty(ind.level)
	ind.level=treelevel(ind.tree);
end
      
% if deeper than params.realmaxlevel, substitute by a parent:
if ind.level>params.realmaxlevel
	if ~strcmp(params.output,'silent')
  		fprintf('     (unable to increase maximum depth beyond %d)\n',params.realmaxlevel);
   end
	% just choose the first parent:
   % (anyway, the choice of who is the first parent is already random)
	ind=pop(parentindices(1));
end

validind=ind;
