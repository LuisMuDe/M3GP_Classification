function [pop,state]=calcpopfitness(pop,params,data,state)
%CALCPOPFITNESS    Calculate fitness values for a GPLAB population.
%   CALCPOPFITNESS(POPULATION,PARAMS,DATA,STATE) returns the
%   population with the fitness values for all individuals.
%
%   [POPULATION,STATE]=CALCPOPFITNESS(...) also returns the
%   updated state of the algorithm.
%
%   Input arguments:
%      POPULATION - the current population of individuals (array)
%      PARAMS - the running parameters of the algorithm (struct)
%      DATA - the dataset on which to measure the fitness (struct)
%      STATE - the current state of the algorithm (struct)
%   Output arguments:
%      POPULATION - the population updated with fitness (array)
%      STATE - the updated state of the algorithm (struct)
%
%   See also CALCFITNESS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

for i=1:length(pop)
   if isempty(pop(i).fitness)
      [pop(i),state]=calcfitness(pop(i),params,data,state,0);
      % (0 = learning data, not testing)
   end
end

