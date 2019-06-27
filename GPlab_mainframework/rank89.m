function [expected,normfitness]=rank89(pop,params,state)
%RANK89    Calculates expected number of offspring for the GPLAB algorithm.
%   RANK89(POPULATION,STATE) returns the vector with the expected number
%   of offspring of all elements in the POPULATION, in the current
%   STATE of the GPLAB algorithm, according to Montana & Davis 89.
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
%      Montana, D.J. and L. Davis. Training feedforward neural networks using genetic
%      algorithms. International Joint Conference on Artificial Intelligence (1989).
%
%   See also RANK85, ABSOLUTE
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

normfitness=[];

montana_davis_interpolmax=0.92;
montana_davis_interpolmin=0.89;
diff=montana_davis_interpolmax-montana_davis_interpolmin;

g=state.generation;
maxg=state.maxgen;

parent_scalar=montana_davis_interpolmax-((g-1)*((diff)/(maxg-1)));

expected=parent_scalar.^(state.popranking-1);

      