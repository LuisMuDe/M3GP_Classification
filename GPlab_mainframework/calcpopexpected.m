function [expected,normfitness]=calcpopexpected(pop,params,state)
%CALCPOPEXPECTED    Normalized expected number of offspring for GPLAB.
%   CALCPOPEXPECTED(POPULATION,PARAMS,STATE) returns the vector with the expected
%   number of offspring of all elements in the POPULATION, in the current STATE
%   of the GPLAB algorithm, according to the method specified in PARAMS. This vector
%   is then normalized because it may not add to the population size, due to the
%   ranking system used.
%
%   [EXPECTED,NORMFITNESS]=CALCPOPEXPECTED(POPULATION,PARAMS,STATE) also
%   returns the normalized fitness vector, in case its calculation was
%   needed for the expected number of offspring, or [] otherwise.
%
%   Input arguments:
%      POPULATION - the current population of individuals (array)
%      PARAMS - the running parameters of the algorithm (struct)
%      STATE - the current state of the algorithm (struct)
%   Output arguments:
%      EXPECTED - the expected number of offspring for each individual (1xN matrix)
%      NORMFITNESS - the normalized fitness of each individual, or [] (1xN matrix)
%
%   See also ABSOLUTE, RANK85, RANK89
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% call the procedure to calculate the expected number of offspring of each individual:
[expected,normfitness]=feval(params.expected,pop,params,state);

% we must normalize the expected vector - ranking may not be 1:popsize,
% but something like 1,1,2,3,4,4,popsize-2, so sum(expected)<>popsize.
expected=normalize(expected,state.popsize);
