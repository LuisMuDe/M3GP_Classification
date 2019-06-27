function [validind,state]=heavydynnodes(ind,pop,params,state,data,parentindices)
%HEAVYDYNNODES    Applies heavy dynamic size filters to a new GPLAB individual.
%   [VALIDIND,STATE]=HEAVYDYNNODES(IND,POP,PARAMS,STATE,DATA,PARENTS)
%   tests if an individual (IND) conforms to the heavy dynamic maximum
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
%   See also VALIDATEINDS, DYNDEPTH, STRICTNODES, ... (the other filters)
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% tree nodes is needed:
if isempty(ind.nodes)
	ind.nodes=treenodes(ind.tree);
end

% measure individual's fitness:
[ind,state]=calcfitness(ind,params,data,state,0);

% if bigger than state.maxlevel:
if ind.nodes>state.maxlevel
   
   % if this individual is the best so far, increase dynamic nodes:
   if ~isempty(state.bestsofar) && ((params.lowerisbetter && ind.fitness<state.bestsofar.fitness) || (~params.lowerisbetter && ind.fitness>state.bestsofar.fitness))
      state.lastid=state.lastid+1;
		ind.id=state.lastid;
      state.maxlevel=ind.nodes;
      state.bestsofar=ind;
      if ~strcmp(params.output,'silent')
      	fprintf('     (increasing maximum nodes to %d)\n',state.maxlevel);
  		end
        
   % else if this individual is not the best so far, check the size of the biggest parent:
   else
   	mnodes=max([pop(parentindices).nodes]);
   	% if parents were first generation (isempty(mnodes)) or this ind is no bigger, accept:
   	if isempty(mnodes) || ind.nodes<=mnodes
      	state.lastid=state.lastid+1;
         ind.id=state.lastid;
      else % else reject (substitute by a parent):
      	% just choose the first parent:
   		% (anyway, the choice of who is the first parent is already random)
			ind=pop(parentindices(1));
      end      
	end
   
% if smaller than state.maxlevel:
elseif ind.nodes<state.maxlevel
   
   % if this individual is the best so far, decrease dynamic nodes:
	if ~isempty(state.bestsofar) && ((params.lowerisbetter && ind.fitness<state.bestsofar.fitness) || (~params.lowerisbetter && ind.fitness>state.bestsofar.fitness))
      state.lastid=state.lastid+1;
      ind.id=state.lastid;
      oldlevel=state.maxlevel;
      if params.veryheavy
	state.maxlevel=ind.nodes;
      else
	state.maxlevel=max([ind.nodes state.iniclevel]); % do not go lower than initial level!
      end
      state.bestsofar=ind;
      if (oldlevel>state.maxlevel) && (~strcmp(params.output,'silent'))
      	fprintf('     (decreasing maximum nodes to %d)\n',state.maxlevel);
      end
   end        
           
end

validind=ind;
