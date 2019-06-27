function [pop,state]=pivotfixe(pop,state,params)
%PIVOTFIXE    Chooses a number of GPLAB individuals for next generation.
%   PIVOTFIXE(POPULATION,STATE,PARAMS) returns the individuals in the
%   ordered POPULATION by their order of appearance for the next
%   generation, maybe removing or adding individuals from the initial
%   choice, depending on how the best fitness is evolving (see ref).
%   
%   Input arguments:
%      POPULATION - ordered list of (parents and offspring) individuals (array)
%      STATE - the current state of the algorithm (struct)
%      PARAMS - the parameters of the algorithm (struct)
%   Output arguments:
%      POPULATION - individuals surviving into the next generation (array)
%      STATE - the updated state of the algorithm (struct)
%
%   See also APPLYSURVIVAL, FIXEDPOPSIZE, RESOURCES, SUPPRESSION, AJOUT
%
%   References:
%      - Denis Rochat, Marco Tomassini and Leonardo Vanneschi, Dynamic Size
%        Populations in Distributed Genetic Programming, EuroGP-2005.
%      - Denis Rochat, Programmation Genetique parallele: operateurs
%        genetiques varies et populations dynamiques, Masters Thesis, 2004.
%      - Jerome Cuendet, Populations Dynamiques en Programmation Genetique,
%        Masters Thesis, 2004.
%      - Tomassini, Vanneschi, Cuendet and Fernandez, A new technique for
%        dynamic size populations in genetic programming, CEC-2004.
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% first of all, choose popsize individuals to start with:
pop=pop(1:state.popsize);

% every 'periode' generations, add or delete individuals:
if mod(state.generation,params.periode)==0

    % calculate currentbest and previousbest:
    % currentbest = best fitness achieved till the current generation
    % (not the best of the current population, because we may not have elitism)
    % previousbest = best fitness achieved till 'periode' generations back
    % (state.fithistory(g,:) refers to generation g-1)
    % (state.fithistory(g-periode+1,:) refers to generation g-periode)
    if params.lowerisbetter
        previousbest=min(state.fithistory(1:state.generation-params.periode+1,1));
        currentbest=min([min([pop.fitness]) previousbest]);
        % if we had guaranteed elitism this would suffice:
        %previousbest=state.fithistory(1:state.generation-params.periode+1,1);
        %currentbest=min([pop.fitness]);
    else
        previousbest=max(state.fithistory(1:state.generation-params.periode+1,1));
        currentbest=max([max([pop.fitness]) previousbest]);
    end

    % update delta:
    state.delta=(previousbest-currentbest)/params.periode;
    if ~params.lowerisbetter
        state.delta=minus(state.delta);
    end

    % now resize population, depending on delta:
    if state.delta>state.pivot
        pop=suppression(pop,state,params,previousbest,currentbest);
    else
        pop=ajout(pop,state,params,currentbest);
    end

end % if mod(state.generation,params.periode)==0

