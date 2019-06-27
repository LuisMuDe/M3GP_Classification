function [validind,state]=strictnodes(ind,pop,params,state,data,parentindices)
%STRICTNODES    Applies strict size filters to a new GPLAB individual.
%   [VALIDIND,STATE]=STRICTNODES(IND,POP,PARAMS,STATE,DATA,PARENTS)
%   tests if an individual (IND) conforms to the strict maximum
%   size (number of nodes) rules. If not, returns one of its parents.
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
%      Silva S. and Almeida J. (2003) "Dynamic maximum tree depth - a
%      simple technique for avoiding bloat in tree-based GP". GECCO-2003.
%      Silva S. and Costa E. (2004) "Dynamic limits for bloat control -
%      variations on size and depth". GECCO-2004.
%
%   See also VALIDATEINDS, STRICTDEPTH, HEAVYDYNNODES, ... (the other filters)
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% tree nodes is needed:
if isempty(ind.nodes)
	ind.nodes=nodes(ind.tree);
end
      
% if bigger than params.realmaxnodes, substitute by a parent:
if ind.nodes>params.realmaxlevel
	if ~strcmp(params.output,'silent')
  		fprintf('     (unable to increase maximum nodes beyond %d)\n',params.realmaxlevel);
   end
	% just choose the first parent:
   % (anyway, the choice of who is the first parent is already random)
	ind=pop(parentindices(1));
end

validind=ind;
