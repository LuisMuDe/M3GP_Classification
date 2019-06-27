function [pool,expected,normfitness]=sampling(pop,params,state,opnum)
%SAMPLING    Draws individuals for parenthood in the GPLAB algorithm.
%   SAMPLING(POPULATION,PARAMS,STATE,OPNUM) returns a pool of individuals
%   chosen to be parents of the new generation, by the sampling method
%   specified in PARAMS.
%
%   [POOL,EXPECTED,NORMFITNESS]=SAMPLING(POPULATION,PARAMS,STATE,OPNUM)
%   also returns the expected number of offspring and the normalized
%   fitness vectors, which may have been calculated to be used by the
%   sampling method.
%
%   Input arguments:
%      POPULATION - the current population of the algorithm (array)
%      PARAMS - the running parameters of the algorithm (struct)
%      STATE - the current state of the algorithm (struct)
%      OPNUM - the number of the genetic operator to apply (integer)
%   Output arguments:
%      POOL - the pool of individuals chosen for parenthood (matrix)
%      EXPECTED - the expected number of children of individuals (1xN matrix)
%      NORMFITNESS - the normalized fitness of individuals (1xN matrix)
%
%   See also ROULETTE, SUS, TOURNAMENT, PICKPARENTS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% *** opnum not needed now. when it is needed, check if opnum=0 (reproduction)

% call the right sampling procedure (check with params which one is it):
[pool,newparentsindex,expected,normfitness]=feval(params.sampling,pop,params,state,state.popsize,[]);
% - [] is the list of individuals' ids that must be avoided in sampling. the sampling
% procedures are ready to deal with this, although it's not being used now.
% - newparentsid=pool is the list of individuals' ids recently sampled. newparentsindex
% is their indices in pop.

%shuffle pool so we can later take out parents without need to randomize again:
%pool=shuffle(pool);
%no, lets shuffle everytime we take parents out (in pickparents.m)

% now add the second row, which will contain the number of offspring each individual must
% produce before being taken out of the pool:
pool(2,:)=1;

% NOTES:
%
% I had two choices here:
%
% A: draw popsize individuals, add a second row with the number of offspring each one
% must produce before being taken out of the pool. (use the operator parameters to
% decrement the second row of pool - every time an operator is used the parents
% have the second row decremented by childrenproduced/parentsneeded)
%
% B: draw as many individuals as will be needed, and remove them from the pool after
% they have been used once. (use operator parameters to decide how many individuals
% will be needed in the worst case). this would create problems with sus, because we
% need popsize equally spaced pointers - if we add pointers thinking of the worst
% case we will end up using the beginning of the roulette a lot more than the end.
%
% All this is meant to avoid drawing individuals each time an operator is to be applied.

