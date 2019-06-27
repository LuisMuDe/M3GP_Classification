function [validind,state]=dyndepth(ind,pop,params,state,data,parentindices)
%DYNDEPTH    Applies dynamic depth filters to a new GPLAB individual.
%   [VALIDIND,STATE]=DYNDEPTH(IND,POP,PARAMS,STATE,DATA,PARENTS)
%   tests if an individual (IND) conforms to the dynamic maximum
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
%      Silva S. and Almeida J. (2003) "Dynamic maximum tree depth - a
%      simple technique for avoiding bloat in tree-based GP". GECCO-2003.
%
%   See also VALIDATEINDS, STRICTDEPTH, DYNNODES, ... (the other filters)
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% tree level is needed:
if isempty(ind.level)
	ind.level=treelevel(ind.tree);
end
      
% if deeper than state.maxlevel, measure fitness:
if ind.level>state.maxlevel
   [ind,state]=calcfitness(ind,params,data,state,0);
   % if this individual is the best so far, increase dynamic depth:
   if ~isempty(state.bestsofar) && ((params.lowerisbetter && ind.fitness<state.bestsofar.fitness) || (~params.lowerisbetter && ind.fitness>state.bestsofar.fitness))
      state.lastid=state.lastid+1;
      ind.id=state.lastid;
      state.maxlevel=ind.level;
      state.bestsofar=ind;
      if ~strcmp(params.output,'silent')
      	fprintf('     (increasing maximum depth to %d)\n',state.maxlevel);
  		end
  	else
      % else, substitute by a parent (just choose the first parent):
      % (anyway, the choice of who is the first parent is already random)
		ind=pop(parentindices(1));
   end        
           
end

validind=ind;
