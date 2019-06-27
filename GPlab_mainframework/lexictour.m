function [indid,indindex,popexpected,popnormfitness]=lexictour(pop,params,state,nsample,toavoid)
%LEXICTOUR    Sampling of GPLAB individuals by lexicographic parsimony tournament.
%   LEXICTOUR(POP,PARAMS,STATE,NSAMPLE,TOAVOID) returns NSAMPLE ids of
%   individuals chosen from POP using the lexicographic parsimony
%   tournament method (Luke & Panait 2002). The ids in TOAVOID are
%   not chosen.
%
%   [IDS,INDICES]=LEXICTOUR(POP,PARAMS,STATE,NSAMPLE,TOAVOID) also
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
%   See also ROULETTE, SUS, TOURNAMENT, DOUBLETOUR, TOURBEST, SAMPLING
%
%   References:
%   Luke, S. and Panait, L. Lexicographic Parsimony Pressure. GECCO (2002).
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

% same as lines 46-48, but roll the roulette several times drawing fewer
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

% get the fitnesses of these individuals:
tfits=state.popadjustedfitness(tindices);
% (use adjusted fitness because this is part of the selection process)
%example: tfits=[0.9 0.9 0.9 0.5 0.2 0.9 0.3 0.3];

% each row of tgroup* is a set of individuals (a single tournament) to choose the best from:
tgroupinds=reshape(tindices,state.tournamentsize,nsample)';
tgroupfits=reshape(tfits,state.tournamentsize,nsample)';
%(tournamentsize=4; nsample=2)
%example: tgroupinds=[3 1 2 4       tgroupfits=[0.9 0.9 0.9 0.5
%                     5 7 6 6];                 0.2 0.9 0.3 0.3];

% get better fitness from each row and repmat to fit the shape of tgroupfits:
if params.lowerisbetter
   f=tgroupfits==repmat(min(tgroupfits,[],2),1,state.tournamentsize);
else
   f=tgroupfits==repmat(max(tgroupfits,[],2),1,state.tournamentsize);
end
%example: f=[1 1 1 0
%            0 1 0 0]

% (this tournament also selects for parsimony, so after selecting the best fitness
%  values, check tree sizes and select again for smaller trees)

funique=find(sum(f,2)==1); % (rows where size doesn't matter)
%example: funique=2
ftosize=f;
ftosize(funique,:)=0; % (only the non-unique are kept - the rest is set to zero)
%example: ftosize=[1 1 1 0
%                  0 0 0 0]
indindextosize=unique(tgroupinds(find(ftosize==1)))'; % (indices of the individuals to measure)
%example: indindextosize=[3 1 2]
fsizes=zeros(size(f));
for i=1:length(indindextosize)
   if isempty(pop(indindextosize(i)).nodes)
      pop(indindextosize(i)).nodes=nodes(pop(indindextosize(i)).tree);
   end
   fsizes(find(tgroupinds==indindextosize(i)))=1/pop(indindextosize(i)).nodes;
end
%example: fsizes=[1/89 1/45 1/45    0
%                    0    0    0    0]
fsizes(funique,:)=f(funique,:); % (add the rows that were previously set to zero)
%example: fsizes=[1/89 1/45 1/45    0
%                    0    1    0    0]
f=fsizes==repmat(max(fsizes,[],2),1,state.tournamentsize);
% (we need to use max to retain the marks (1) instead of the non-marks (0),
% and that is why we used nodes instead of 1/nodes)
%example: f=[0 1 1 0
%            0 1 0 0]

% now proceed like in the function "findfirstindex" to get the first
% ocurrence of the best value in each row:
% (choosing the first is in fact choosing randomly)

cs=cumsum(cumsum(f,2),2);
%example: cs=[1 3 6 9
%             0 1 2 3]
indindex=tgroupinds(find(cs==1))';
indid=popids(indindex);
%example: indindex=[3 7]; indid=[80 60]