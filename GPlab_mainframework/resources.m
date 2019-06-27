function [pop,state]=resources(pop,state,params)
%RESOURCES    Chooses a number of GPLAB individuals for next generation.
%   RESOURCES(POPULATION,STATE,PARAMS) returns the individuals in the
%   ordered POPULATION by their order of appearance for the next
%   generation, ensuring that the total number of nodes of these
%   individuals does not exceed STATE.MAXRESOURCES, or increasing
%   STATE.MAXRESOURCES (see references).
%   
%   Input arguments:
%      POPULATION - ordered list of (parents and offspring) individuals (array)
%      STATE - the current state of the algorithm (struct)
%      PARAMS - the parameters of the algorithm (struct)
%   Output arguments:
%      POPULATION - individuals surviving into the next generation (array)
%      STATE - the updated state of the algorithm (struct)
%
%   See also APPLYSURVIVAL, FIXEDPOPSIZE, PIVOTFIXE
%   See also NORMAL, LIGHT, STEADY, LOW, FREE
%
%   References:
%     Silva S, Silva PJN, Costa E. Resource-Limited Genetic Programming:
%     Replacing Tree Depth Limits. ICANNGA-2005.
%     Silva S, Costa E. Resource-Limited Genetic Programming: The Dynamic
%     Approach. GECCO-2005.
%     Silva S, Costa E. Comparing Tree Depth Limits and Resource-Limited
%     GP. CEC-2005.
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% choose individuals from the ordered list, skipping the ones
% causing an excess of nodes (resources):
limitresources=state.maxresources;

% we need the node counting for everyone in the list:
for i=1:length(pop)
   if isempty(pop(i).nodes)
      pop(i).nodes=nodes(pop(i).tree);
   end
end

% now call procedure that attributes size 0 to the ones that cannot be chosen:
popnodes=[pop.nodes];
listnodes=nullexceeding(popnodes,limitresources);
reject=find(listnodes==0);


if strcmp(params.dynamicresources,'1') | strcmp(params.dynamicresources,'2')

    % now take a second look at the individuals that were not chosen, and
    % if they take mean population fitness to a new best value, accept them.
    % as soon as one individual does not increase the best value of
    % mean population fitness, stop searching for other individuals.
    popfitness=[pop.fitness];
    % first check if mean population fitness already has a new best value...
    acceptedpopfitness=popfitness(find(listnodes~=0));
    currentmeanpopfit=mean(acceptedpopfitness);
    if ((currentmeanpopfit<state.bestavgfitnesssofar) && (params.lowerisbetter)) || ((currentmeanpopfit>state.bestavgfitnesssofar) && (~params.lowerisbetter))
        state.bestavgfitnesssofar=currentmeanpopfit;
    end
    % ...then check with each of the rejected individuals,
    % for as long as the mean best population fitness so far continues to increase:
    for i=1:length(reject)
        tmplistnodes=listnodes;
        tmplistnodes(reject(i))=popnodes(reject(i));
        acceptedpopfitness=popfitness(find(tmplistnodes~=0));
        currentmeanpopfit=mean(acceptedpopfitness);
        accept=feval(params.resourcesfitness,currentmeanpopfit,state,params);
        if accept
            state.avgfitness=currentmeanpopfit;
            listnodes=tmplistnodes;
        else
            break % break the for cycle, our search is over
        end
    end

end % if strcmp(params.dynamicresources,'1') | strcmp(params.dynamicresources,'2')

% use the individuals not rejected:
pop=pop(find(listnodes~=0));

% apply restrictions on population size:
pop=feval(params.resourcespopsize,pop,state);

if strcmp(params.dynamicresources,'1') | strcmp(params.dynamicresources,'2')
    % finally update natural resources values:
    newresources=sum([pop.nodes]);
    if strcmp(params.dynamicresources,'2') | (strcmp(params.dynamicresources,'1') & newresources>state.maxresources)
        if params.veryheavy
	  newresources=newresources;
	else
	  newresources=max([newresources state.maxresourceshistory(1)]);
	  % do not go lower than initial resources!
        end
	if newresources~=state.maxresources
            if newresources>state.maxresources
                s='increasing';
            else
                s='decreasing';
            end
            state.maxresources=newresources;
            if ~strcmp(params.output,'silent')
                fprintf('     (%s max resources to %d)\n',s,state.maxresources);
            end
        end
    end
end % if strcmp(params.dynamicresources,'1') | strcmp(params.dynamicresources,'2')
