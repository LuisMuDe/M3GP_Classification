function [indid,indindex,popexpected,popnormfitness]=doubletour(pop,params,state,nsample,toavoid)
%DOUBLETOUR    Sampling of GPLAB individuals by a double tournament method.
%   DOUBLETOUR(POP,PARAMS,STATE,NSAMPLE,TOAVOID) returns NSAMPLE ids of
%   individuals chosen from POP using the double tournament method. The
%   ids in TOAVOID are not chosen.
%
%   [IDS,INDICES]=DOUBLETOUR(POP,PARAMS,STATE,NSAMPLE,TOAVOID) also
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
%   See also TOURNAMENT, LEXICTOUR, ROULETTE, SUS, TOURBEST, SAMPLING
%
%   References:
%   Luke, S. and Panait, L. A Comparison of Bloat Control Methods for
%   Genetic Programming. Evolutionary Computation 14(3):309-344 (2006)
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% we are not calculating these, but they are output arguments:
popexpected=[];
popnormfitness=[];

% double tournament selection:
% do a tournament based on fitness where the individuals participating
% were chosen with a tournament based on size (if do_fitness_first=0)
% or vice-versa (if do_fitness_first=1).


% parameters of this tournament:
% (best cross-problem settings - see reference):
do_fitness_first=0;
F=state.tournamentsize; %(fitness tournament size)
% (same as regular tournament setting)
D=1.4; %(parsimony tournament size, 1<=D<=2)
% (two individuals participate and the smaller wins with probability D/2)
   
state.popexpected=ones(1,state.popsize);

% we need to draw 2 x F x nsample individuals for the double tournament:
totalsample=2*F*nsample;
p=min([params.drawperspin totalsample]); % (p = how many to draw per spin)
for i=1:p:totalsample
    partialsample=min([p totalsample-i+1]);
    [tids(i:i+partialsample-1),tindices(i:i+partialsample-1)]=roulette(pop,params,state,partialsample,toavoid);
end

% shuffle:
[tids,myorder]=shuffle(tids); % shuffle randomly
tindices=orderby(tindices,myorder); % shuffle exactly like tids, with the same order


% now do both tournaments, first fitness then size, or vice-versa:
if do_fitness_first
    % first tournament - fitness:
    [indindex,indid]=tourbest(tindices,pop,params,state,F,2*nsample,1,'fittest');
    % (no need to shuffle now)
    % second tournament - size:
    [indindex,indid]=tourbest(indindex,pop,params,state,2,nsample,D/2,'smallest');
else
    % first tournament - size:
    [indindex,indid]=tourbest(tindices,pop,params,state,2,F*nsample,D/2,'smallest');
    % (no need to shuffle now)
    % second tournament - size:
    [indindex,indid]=tourbest(indindex,pop,params,state,F,nsample,1,'fittest');
end
