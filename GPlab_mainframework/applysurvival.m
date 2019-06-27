function [pop,state]=applysurvival(pop,params,state,tmppop)
%APPLYSURVIVAL    Choose new generation of individuals for GPLAB algorithm.
%   APPLYSURVIVAL(OLDPOP,PARAMS,NEWPOP) returns a population of individuals
%   chosen between the individuals of the previous current population,
%   OLDPOP, and the individuals newly created, in NEWPOP, applying the
%   elitism level and survival method specified in PARAMS. The population
%   returned is ordered by priority of survival.
%
%   Input arguments:
%      OLDPOP - the previous current population of the algorithm (array)
%      PARAMS - the running parameters of the algorithm (struct)
%      STATE - the algorithm current state (struct)
%      NEWPOP - the new population of individuals recently created (array)
%   Output arguments:
%      POPULATION - the new current population (array)
%      STATE - the new algorithm current state (struct)
%
%   See also FIXEDPOPSIZE, MAXRESOURCES, MAXDYNRESOURCES_STEADY, GENERATION
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% ------------------
% the elitism level:
% ------------------

elitismlevel=params.elitism;

popsize=length(pop);
tmppopsize=length(tmppop);

if strcmp(elitismlevel,'replace')
   numbest=0;
elseif strcmp(elitismlevel,'keepbest')
   numbest=1;
elseif strcmp(elitismlevel,'halfelitism')
   numbest=ceil(popsize/2);
elseif strcmp(elitismlevel,'totalelitism')
   numbest=popsize;
else
   error('APPLYSURVIVAL: unknown elitism level!')
end 
  

% both pop and tmppop joined in allpop:
% allpopfit contains 3 columns:
%    1) fitness;
%    2) if this individual comes from pop=oldpop (1=yes,0=no);
%    3) if this individual has already been chosen;
allpop=pop;
allpopfitness=[allpop.adjustedfitness]'; % use adjusted fitness
% (if there was no fitness adjustment, adjustedfitness is the same as fitness)
allpopfit(1:popsize,1)=allpopfitness; 
allpopfit(1:popsize,2)=1; % these come from pop
allpopfit(1:popsize,3)=0; % not chosen yet

allpop(popsize+1:popsize+tmppopsize)=tmppop;
allpopfitness=[allpop.adjustedfitness]';
allpopfit(popsize+1:popsize+tmppopsize,1)=allpopfitness(popsize+1:popsize+tmppopsize);
allpopfit(popsize+1:popsize+tmppopsize,2)=0; % these do not come from pop
allpopfit(popsize+1:popsize+tmppopsize,3)=0; % not chosen yet

% sorting by fitness will be needed, so beware of params.lowerisbetter:
if ~params.lowerisbetter
   allpopfit(:,1)=-allpopfit(:,1); % minus sign because the ordering will be ascending
end

% sort allpopfit by column 1 (fitness) (keep index I):
[ans,I]=sortrows(allpopfit,[1]);
% get numbest individuals, sorted by fitness, from allpop
newpop(1:numbest)=allpop(I(1:numbest));
allpopfit(I(1:numbest),3)=ones(numbest,1); % already chosen

% sort allpopfit by column 3 (not chosen first), 2 (tmppop first), and 1 (fitness)
[ans,I]=sortrows(allpopfit,[3,2,1]);
% get all the individuals from tmppop that were not chosen before:
numtmppop=sum(allpopfit(:,2)==0 & allpopfit(:,3)==0);
newpop(numbest+1:numbest+numtmppop)=allpop(I(1:numtmppop));   
allpopfit(I(1:numtmppop),3)=1; % already chosen

% sort allpopfit by column 3 (not chosen first) and column 1 (fitness):
[ans,I]=sortrows(allpopfit,[3,1]);
% get all the remaining individuals that were not chosen before:
numremain=sum(allpopfit(:,3)==0);
newpop(numbest+numtmppop+1:numbest+numtmppop+numremain)=allpop(I(1:numremain));   
%allpopfit(I(1:numremain),3)=1; % already chosen
% (no need to do this, allpopfit will not be used again)


% -----------------------------------------------
% the survival of the ordered list of individuals:
% -----------------------------------------------

[pop,state]=feval(params.survival,newpop,state,params);
