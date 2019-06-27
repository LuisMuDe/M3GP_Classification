function [validinds,state]=validateinds(inds,pop,params,state,data,parentindices,opnum)
%VALIDATEINDS    Applies validation procedures to new GPLAB individuals.
%   [VALIDINDS,STATE]=VALIDATEINDS(INDS,POP,PARAMS,STATE,DATA,PARENTS,OPNUM)
%   returns a list of individuals (VALIDINDS) containing all the individuals
%   (INDS) considered valid, and substitute individuals (usually one of the
%   parents) for the ones considered invalid. It also returns the updated
%   state of the algorithm.
%
%   Input arguments:
%      INDS - list of individuals to be validated (array)
%      POPULATION - the current population of the algorithm (array)
%      PARAMS - the running parameters of the algorithm (struct)
%      STATE - the current state of the algorithm (struct)
%      DATA - the dataset for use in the algorithm (struct)
%      PARENTS - the indices of the parents that generated INDS (matrix)
%      OPNUM - the number of the gen.operator that generated INDS (integer)
%   Output arguments:
%      VALIDINDS - the list of valid individuals (array)
%      STATE - the updated state of the algorithm (struct)
%
%   See also APPLYOPERATOR, DYNDEPTH, STRICTNODES, ... (all the filters)
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

for i=1:length(inds)
   
   % apply the validating functions specified in params.filters by the order specified:
   indtocheck=inds(i);
   oldind=indtocheck;

   for f=1:length(params.filters)
      
      % no need to check if it already has an id:
      if isempty(indtocheck.id)
         [indchecked,state]=feval(params.filters{f},indtocheck,pop,params,state,data,parentindices);
         indtocheck=indchecked;
      end
   end
   
   % attribute id if it still doesn't have one:
   % (if it passed all the filters without being rejected or fully accepted):
   if isempty(indtocheck.id)
      state.lastid=state.lastid+1;
		indtocheck.id=state.lastid;
   end
   
   newind=indtocheck;
   validinds(i)=indtocheck;
   
   % if an individual's id is the same as its parents id, then it's a cloning:
   if sum(oldind.parents==newind.id)>0
      % distinguish clones from different genetic operators:
      state.clonings(opnum)=state.clonings(opnum)+1;
   end
   
end
