function [expected,normfitness]=rank85(pop,params,state)
%RANK85    Calculates expected number of offspring for the GPLAB algorithm.
%   RANK85(POPULATION,STATE) returns the vector with the expected number
%   of offspring of all elements in the POPULATION, in the current
%   STATE of the GPLAB algorithm, according to Baker 85.
%
%   Input arguments:
%      POPULATION - the current population of individuals (array)
%      PARAMS - the current running parameters (struct)
%      STATE - the current state of the algorithm (struct)
%   Output arguments:
%      EXPECTED - the expected number of offspring for each individual (1xN matrix)
%
%   Note:
%      The second output argument is not referred because it is not
%      used in this function. It is present only for compatibility
%      with the other functions for calculating the expected number
%      of offspring.
%
%   References:
%      Baker, J.E. Adaptive selection methods for genetic algorithms.
%      First International Conference on Genetic Algorithms and Their Applications (1985).
%
%   See also RANK89, ABSOLUTE
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

normfitness=[];

baker_max=1.1;
baker_min=2-baker_max;

expected=baker_min+(baker_max-baker_min)*((state.popsize-state.popranking)/(state.popsize-1));
popr=state.popranking;
pops=state.popsize;

   