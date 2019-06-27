function [indid,indindex,popexpected,popnormfitness]=sus(pop,params,state,nsample,toavoid)
%SUS    Sampling of GPLAB individuals by the SUS method.
%   SUS(POP,PARAMS,STATE,NSAMPLE,TOAVOID) returns NSAMPLE random
%   ids of the individuals chosen from POP using the SUS method
%   (Baker 87). The ids in TOAVOID are not chosen.
%
%   [IDS,INDICES]=SUS(POP,PARAMS,STATE,NSAMPLE,TOAVOID) also
%   returns the indices in POP of the chosen individuals.
%
%   [IDS,INDICES,EXPECTED,NORMFIT]=SUS(...) also returns the expected
%   number of offspring and the normalized fitness vectors, which may
%   have been calculated for the sus procedure.
%
%   Input arguments:
%      POPULATION - the current population of the algorithm (array)
%      PARAMS - the running parameters of the algorithm (struct)
%      STATE - the current state of the algorithm (struct)
%      NSAMPLE - the number of individuals to draw (integer)
%      TOAVOID - the ids of the individuals to avoid drawing (1xN matrix)
%   Output arguments:
%      IDS - the ids of the individuals chosen (1xN matrix)
%      INDICES - the indices of the individuals chosen (1xN matrix)
%      EXPECTED - the expected number of children of all individuals (1xN matrix)
%      NORMFIT - the normalized fitness of all individuals (1xN matrix)
%
%   References:
%      Baker, J.E. Reducing bias and inefficiency in the selection algorithm.
%      Second International Conference on Genetic Algorithms (1987).
%
%   See also WHEEL, ROULETTE, TOURNAMENT, SAMPLING
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

[indid,indindex,popexpected,popnormfitness]=wheel(pop,params,state,nsample,toavoid,'sus');
