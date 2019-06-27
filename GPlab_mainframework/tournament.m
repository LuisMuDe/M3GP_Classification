function [indid,indindex,popexpected,popnormfitness]=tournament(pop,params,state,nsample,toavoid)
%TOURNAMENT    Sampling of GPLAB individuals by the tournament method.
%   TOURNAMENT(POP,PARAMS,STATE,NSAMPLE,TOAVOID) returns NSAMPLE ids of
%   individuals chosen from POP using the tournament method. The ids in
%   TOAVOID are not chosen.
%
%   [IDS,INDICES]=TOURNAMENT(POP,PARAMS,STATE,NSAMPLE,TOAVOID) also
%   returns the indices in POP of the chosen individuals.
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
%
%   Note:
%      The two last output arguments are not referred because they are
%      not used in this function. They are present only for compatibility
%      with the other functions for sampling individuals.
%
%   See also ROULETTE, SUS, LEXICTOUR, DOUBLETOUR, TOURBEST, SAMPLING
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% we are not calculating these, but they are output arguments:
popexpected=[];
popnormfitness=[];

% tournament selection:
% first get tournamentsize individuals (randomly) from the population;
% (we can use the roulette procedure for this, since we may want to avoid some indices -
% - rand would turn out difficult to avoid indices)
% then choose the one with best fitness.

popids=[pop.id];
state.popexpected=ones(1,state.popsize);

% roll the roulette to draw nsample*tournamentsize individuals:
%[tids,tindices]=roulette(pop,params,state,nsample*state.tournamentsize,toavoid);
%example: tids=[80 50 50 35 40 60 10 10]; tindices=[3 1 2 4 5 7 6 6];

% same as lines 43-45, but roll the roulette several times drawing fewer
% individuals each time, to minimize memory problems:
totalsample=nsample*state.tournamentsize;
p=min([params.drawperspin totalsample]); % (p = how many to draw per spin)
for i=1:p:totalsample
    partialsample=min([p totalsample-i+1]);
    [tids(i:i+partialsample-1),tindices(i:i+partialsample-1)]=roulette(pop,params,state,partialsample,toavoid);
end

% shuffle:
[tids,myorder]=shuffle(tids); % shuffle randomly
tindices=orderby(tindices,myorder); % shuffle exactly like tids, with the same order

[indindex,indid]=tourbest(tindices,pop,params,state,state.tournamentsize,nsample,1,'fittest');
%(1 means the probability of choosing the fittest is 1 - in some tournaments it isn't)

