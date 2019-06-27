function [state,pop]=updatestate(params,state,data,pop)
%UPDATESTATE    Updates the GPLAB algorithm state variables.
%   UPDATESTATE(PARAMS,STATE,POP) returns the state variables updated
%   with the latest measures of rank, fitness and level history.
%
%   [STATE,POP]=UPDATESTATE(PARAMS,STATE,POP) also returns some
%   additional population info that may have been needed.
%
%   Input arguments:
%      PARAMS - the running parameters (struct)
%      STATE - the state before the update (struct)
%      DATA - the dataset for the algorithm to use (struct)
%      POP - current population (array)
%   Output arguments:
%      STATE - the state after the update (struct)
%      POP - current population, updated info (array)
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% first measure fitness on any individuals still with empty fitness:
[pop,state]=calcpopfitness(pop,params,data,state);
state.popfitness=[pop.fitness];
state.popadjustedfitness=[pop.adjustedfitness];

% variable population size and generation gap:
% first check what proportion of population is gengap:
oldpopsize=state.popsize;
p=state.gengap/oldpopsize;
% update population size:
state.popsize=length(pop);
state.popsizehistory(end+1)=state.popsize;
% update generation gap:
state.gengap=max([round(p*state.popsize) 1]);
state.gengaphistory(end+1)=state.gengap;
% now update all the things that depend on pop size or gen gap:
% (tournament size:)
if params.tournamentsize<1 % tournamentsize is a proportion of popsize
    state.tournamentsize=max([round(params.tournamentsize*state.popsize) 2]);
end
% (adaptwindow size:)
oldadaptwindowsize=state.adaptwindowsize;
currentadaptwindowsize=length(state.adaptwindow);
% (old and current sizes may not match because adaptwindow may not be full)
p=oldadaptwindowsize/oldpopsize;
newadaptwindowsize=max([round(p*state.popsize) 1]);
if currentadaptwindowsize>newadaptwindowsize % if the population was reduced
    state.adaptwindow=state.adaptwindow(currentadaptwindowsize-newadaptwindowsize+1:end);
end
state.adaptwindowsize=newadaptwindowsize;

% ranking:
if params.lowerisbetter
   state.popranking=ranking(state.popadjustedfitness,0);
   % (use adjusted fitness because ranking is used in the selection process)
else
   state.popranking=ranking(state.popadjustedfitness,1);
end
% (ranking.m is used instead of sort so we can get rankings like 1,2,2,3,4,4,5,...)

% empty these so they are updated in the next generation (if needed):
state.popnormfitness=[];
state.popexpected=[];

% we will need nodes for various things, even if calccomplexity=0:
for i=1:state.popsize
    if isempty(pop(i).nodes)
        pop(i).nodes=nodes(pop(i).tree);
    end
end
%%LMD Generates some error trying to run the M2GP  
if params.calccomplexity
	% average nodes, average introns, and average level (history):
	for i=1:state.popsize
        if isempty(pop(i).level)
        	pop(i).level=treelevel(pop(i).tree);
        end
%         if isempty(pop(i).introns)
%             [pop(i).introns,state]=intronnodes(pop(i).tree,params,data,state);
%         end
	end
   
   poplevels=[pop.level];
   popnodes=[pop.nodes];
  % popintrons=[pop.introns];
   
   state.avglevelhistory(end+1)=mean(poplevels);
   state.avgnodeshistory(end+1)=mean(popnodes);
  % state.avgintronshistory(end+1)=mean(popintrons);
   
   % tree fill percentage:
   mlevel=max(poplevels);
   avgkids=mean(state.arity(find(state.arity>0)));
   avgkids=repmat(avgkids,state.popsize,mlevel);
   alllevels=repmat(0:1:mlevel-1,state.popsize,1);
   poplevels=repmat(poplevels',1,size(alllevels,2));
   avgkids(alllevels>=poplevels)=0;
   sumparts=avgkids.^alllevels;
   sumlines=sum(sumparts,2);
   fillratio=popnodes'./sumlines;
   state.avgtreefillhistory(end+1)=100*mean(fillratio);
end % if params.calccomplexity

%% LMD Modification to prune dimension of the best idividual of the run 
Pruning='BestRandom'; % Allpop or Best
pop(1).BeforePruningFitness = pop(1).fitness;
if (strcmp(Pruning, 'Best'))
    if isempty(pop(1).Pruned)|| strcmp(pop(1).Pruned, 'False') 
       pop(1)= PrunningTheBest(pop(1),data,params);
    end
elseif (strcmp(Pruning, 'BestRandom'))    
    if isempty(pop(1).Pruned)|| strcmp(pop(1).Pruned, 'False') 
       pop(1)= PrunningTheBestRandom(pop(1),data,params);
    end    
else
    for ccont = 1 : length(pop)
         if isempty(pop(ccont).Pruned)|| strcmp(pop(ccont).Pruned, 'False') 
           pop(ccont)= PrunningTheBest(pop(ccont),data);
        end        
    end
end


% bestsofar and bestsofarhistory:
bestindex=find(state.popranking==1);
if length(bestindex)>1 % there may be more than one, in each case we choose the simpler
    minlevelindex=[];
    for i=1:length(bestindex)
        if strcmp(params.depthnodes,'1')
            if isempty(pop(bestindex(i)).level)
                pop(bestindex(i)).level=treelevel(pop(bestindex(i)).tree);
            end
            if isempty(minlevelindex) || pop(bestindex(i)).level<pop(minlevelindex).level
                minlevelindex=bestindex(i);
            end
        else
            if isempty(pop(bestindex(i)).nodes)
                pop(bestindex(i)).nodes=nodes(pop(bestindex(i)).tree);
            end
            if isempty(minlevelindex) || pop(bestindex(i)).nodes<pop(minlevelindex).nodes
                minlevelindex=bestindex(i);
            end
        end
    end
    bestindex=minlevelindex;
end

if isempty(state.bestsofar) || ((params.lowerisbetter && pop(bestindex).fitness<state.bestsofar.fitness) || (~params.lowerisbetter && pop(bestindex).fitness>state.bestsofar.fitness))
    state.bestsofar=pop(bestindex);
end

% cross validation (and save bestsofar.fitness and eventually bestsofar.testfitness):
if params.usetestdata
   testindividual=calcfitness(state.bestsofar,params,data.test,state,1); % (1 = test data)
   state.bestsofar.testfitness=testindividual.fitness;
   state.bestsofar.testadjustedfitness=testindividual.adjustedfitness;
   state.bestfithistory(end+1,:)=[state.bestsofar.fitness state.bestsofar.testfitness];
else   
   state.bestfithistory(end+1)=state.bestsofar.fitness;
end
if isempty(state.bestsofar.nodes)
   state.bestsofar.nodes=nodes(state.bestsofar.tree);
end


%%LMD Generates some error trying to run the M2GP  
% if isempty(state.bestsofar.introns)
%    [nintrons,state]=intronnodes(state.bestsofar.tree,params,data,state);
%    state.bestsofar.introns=nintrons;
% end
%%LMD just to be able to see the dimensions through generations
state.bestsofar.dimensions = length(state.bestsofar.tree.kids);

if isempty(state.bestsofar.level)
   state.bestsofar.level=treelevel(state.bestsofar.tree);
end
if isempty(state.bestsofarhistory) || (state.bestsofar.id~=state.bestsofarhistory{end,2}.id)
   state.bestsofarhistory{end+1,1}=state.generation;
   state.bestsofarhistory{end,2}=state.bestsofar;
end

% get maximum, minimum, average, median, stddev fitness:
if params.lowerisbetter
   state.maxfitness=min(state.popfitness);
   state.minfitness=max(state.popfitness);
else
   state.maxfitness=max(state.popfitness);
   state.minfitness=min(state.popfitness);
end
state.avgfitness=mean(state.popfitness);
if isempty(state.bestavgfitnesssofar) || ((params.lowerisbetter)&&(state.avgfitness<state.bestavgfitnesssofar)) || ((~params.lowerisbetter)&&(state.avgfitness>state.bestavgfitnesssofar))
   state.bestavgfitnesssofar=state.avgfitness;
end
state.medianfitness=median(state.popfitness);
state.stdfitness=std(state.popfitness);

% save fitness measures in fithistory:
g=state.generation+1; % +1 because generation 0 is also saved
state.fithistory(g,1)=state.maxfitness;
state.fithistory(g,2)=state.minfitness;
state.fithistory(g,3)=state.avgfitness;
state.fithistory(g,4)=state.medianfitness;
state.fithistory(g,5)=state.stdfitness;

% save level, best level, best introns, op and op freqs history:
state.levelhistory(end+1)=state.maxlevel;
state.bestlevelhistory(end+1)=state.bestsofar.level;
state.bestnodeshistory(end+1)=state.bestsofar.nodes;
%%LMD Generates some error trying to run the M2GP  
%state.bestintronshistory(end+1)=state.bestsofar.introns;
state.ophistory(end+1,:)=state.operatorprobs;
state.opfreqhistory(end+1,:)=state.operatorfreqs;
state.reproductionhistory(end+1)=state.reproductions;
state.cloninghistory(end+1,:)=state.clonings;
state.reproductions=0;
state.clonings=zeros(1,length(params.operatornames));

% record natural resources values:
if isempty(state.maxresources)
   % if no value was given yet, the maximum resources are
   % the amount used by the initial population
   for i=1:state.popsize
   	  if isempty(pop(i).nodes)
      	pop(i).nodes=nodes(pop(i).tree);
      end
   end
   state.maxresources=sum([pop.nodes]);
end
state.usedresources=sum([pop.nodes]);
state.maxresourceshistory(end+1)=state.maxresources;
state.usedresourceshistory(end+1)=state.usedresources;

% diversity:
for i=1:length(params.calcdiversity)
   newdiversity = feval(params.calcdiversity{i},params,state,data,pop);
   eval(['state.diversityhistory.' params.calcdiversity{i} '(end+1)=newdiversity;']);
end

   % just to remind,
   % the simple measure from population genetics:
   
   %popindividuals={pop.str};
   %uniqueindividuals=unique(popindividuals);
   %reppopindividuals=repmat(popindividuals',1,length(uniqueindividuals));
   %repuniqueindividuals=repmat(uniqueindividuals,1,length(popindividuals))';
   %uniquematch=strcmp(reppopindividuals,repuniqueindividuals);
   %uniquefreqs=sum(uniquematch,1)/state.popsize;
   %state.diversityhistory(end+1)=1-(sum(uniquefreqs.*uniquefreqs));
   