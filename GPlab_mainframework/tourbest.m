function [indindex,indid]=tourbest(tindices,pop,params,state,toursize,nsample,prob,bestis);
%TOURBEST    Tournament of GPLAB individuals by size or fitness.
%   TOURBEST(INDICES,POP,PARAMS,STATE,TOURSIZE,NSAMPLE,PROB,BEST) returns
%   the indices and ids of NSAMPLE individuals chosen from INDICES, using
%   a tournament based on size or fitness, depending on the setting of
%   BEST (smallest or fittest). PROB indicates the probability of chosing
%   the best (smallest or fittest) of each tournament.
%
%   Input arguments:
%      INDICES - indices in POP of the individuals for tournament (array)
%      POP - the current population of the algorithm (array)
%      PARAMS - the running parameters of the algorithm (struct)
%      STATE - the current state of the algorithm (struct)
%      TOURSIZE - number of individuals in each tournament (integer)
%      NSAMPLE - number of individuals to return (integer)
%      PROB - probability of chosing the best of each tournament (double)
%      BEST - whether the best is the smallest or fittest (string)
%   Output arguments:
%      INDICES - the indices of the individuals chosen (1xN matrix)
%      IDS - the ids of the individuals chosen (1xN matrix)
%
%   See also TOURNAMENT, DOUBLETOUR
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

popids=[pop.id];

% get values needed (sizes or fitness):
if strcmp(bestis,'smallest') % lower is better
    % get the sizes of the individuals in tindices:
    for i=1:length(tindices)
        if isempty(pop(tindices(i)).nodes)
            pop(tindices(i)).nodes=nodes(pop(tindices(i)).tree);
        end
    end
    tvals=[pop(tindices).nodes];
    %example: tindices=[3 1 2 2 4 2 5 7 7]
    %example: tvals=[25 20 14 40 40 40 15 30 25]
elseif strcmp(bestis,'fittest')
    % get the fitnesses of the individuals in tindices:
    tvals=state.popadjustedfitness(tindices);
    % (use adjusted fitness because this is part of the selection process)
    %example: tindices=[3 1 2 2 4 2 5 7 7]
    %example: tvals=[0.9 0.9 0.9 0.5 0.2 0.9 0.3 0.3 0.2]
    if ~params.lowerisbetter
        warning('off')
        tvals=1./tvals;
        warning('on')
    end
else
    error('TOURBEST: unknown tournament type.')
end


% each row of tgroup* is a set of individuals (a single tournament) to choose from:
tgroupinds=reshape(tindices,toursize,nsample)';
tgroupvals=reshape(tvals,toursize,nsample)';
%(tournamentsize=3; nsample=3)
%example: tgroupinds=[3 1 2       tgroupvals=[25 20 14
%                     2 4 2                   40 40 40
%                     5 7 7]                  15 30 25]

% get best values from each row, and mark them with 1, the rest is 0:

if prob==1
    % if prob==1, the case is simple, choose min of each row and mark it:
    f=tgroupvals==repmat(min(tgroupvals,[],2),1,toursize);
else
    r=rand(nsample,1);
    %example: r=[0.12
    %            0.75
    %            0.86]
    
    % choose minimum value of each row with probability prob, and mark it:
    f=repmat(r<prob,1,toursize).*(tgroupvals==repmat(min(tgroupvals,[],2),1,toursize));
    %(prob=0.7)
    %example: f=[0 0 1
    %            0 0 0
    %            0 0 0]

    % choose the other values of each row with probability 1-prob, and mark it:
    f=f+repmat(r>=prob,1,toursize).*(tgroupvals~=repmat(min(tgroupvals,[],2),1,toursize));
    %example: f=[0 0 1
    %            0 0 0
    %            0 1 1]

    % mark all the rows where there is no mark yet, for example the rows
    % where r>=prob but the only values available are the minimum
    f=f+repmat(sum(f,2)==0,1,toursize);
    %example: f={0 0 1
    %            1 1 1
    %            0 1 1]
end

% now proceed like in the function "findfirstindex" to get the first
% ocurrence of the best value in each row:
% (choosing the first is in fact choosing randomly)

cs=cumsum(cumsum(f,2),2);
%example: cs=[0 0 1
%             1 3 6
%             1 2 3]

indindex=tgroupinds(find(cs==1))';
indid=popids(indindex);
%example: indindex=[2 5 2]; indid=[2025 840 2025];