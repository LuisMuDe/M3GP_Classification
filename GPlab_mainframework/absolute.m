function [expected,normfitness]=absolute(pop,params,state)
%ABSOLUTE    Calculates expected number of offspring for the GPLAB algorithm.
%   ABSOLUTE(POPULATION,STATE) returns the vector with the expected number
%   of offspring of all elements in the POPULATION, in the current
%   STATE of the GPLAB algorithm, according to Holland 75.
%
%   Input arguments:
%      POPULATION - the current population of individuals (array)
%      PARAMS - the current running parameters (struct)
%      STATE - the current state of the algorithm (struct)
%   Output arguments:
%      EXPECTED - the expected number of offspring for each individual (1xN matrix)
%      NORMFITNESS - the normalized fitness of each individual (1xN matrix)
%
%   References:
%      Holland, J.H. Adaptation in natural and artificial systems. MIT Press (1975).
%
%   See also RANK85, RANK89
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% calculate normfitness if needed:
if isempty(state.popnormfitness)
   if params.lowerisbetter
      normfitness=normalize(-state.popadjustedfitness,1);
   else
      normfitness=normalize(state.popadjustedfitness,1);
   end
else
   normfitness=state.popnormfitness;
end

expected=state.popsize*normfitness;
