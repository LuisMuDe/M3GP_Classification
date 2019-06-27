function pop=ajout(pop,state,params,currentbest)
%AJOUT    Adds a number of GPLAB individuals to the population.
%   AJOUT(POPULATION,STATE,PARAMS,BEST) returns a population with more
%   individuals than POP. The number of individuals to add depends on a
%   relationship between the initial and current population size, the
%   initial and current best fitness, and the current and maximum
%   generation of the run. The new individuals are created by swap
%   mutation and shrink mutation.
%   
%   Input arguments:
%      POPULATION - ordered list of (parents and offspring) individuals (array)
%      STATE - the current state of the algorithm (struct)
%      PARAMS - the parameters of the algorithm (struct)
%      BEST - best fitness of current generation (double)
%   Output arguments:
%      POPULATION - next generation of individuals (array)
%
%   See also PIVOTFIXE, SUPPRESSION
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

% number of individuals to add to the population:
% (testing 2 variations, M1 and M2, see Rochat EuroGP-2005)
if strcmp(params.ajout,'M1')
    c=1;
elseif strcmp(params.ajout,'M2')
    if params.lowerisbetter
        c=sqrt(currentbest/state.fithistory(1,1));
    else
        c=sqrt(state.fithistory(1,1)/currentbest);
    end
else
    error('AJOUT: unknown addition method!')
end
n=round((c*state.initpopsize-length(pop))/(state.maxgen-state.generation+1));
% (+1 because out first generation is 0)

% do not add more individuals than needed to reach the initial popsize:
% (it is guaranteed by the way n is calculated, but make sure because of rounding)
n=min([n state.initpopsize-length(pop)]);

% generate new individuals: (see Cuendet thesis and Tomassini CEC-2004)
% (mutate the n best individuals to obtain n new individiuals)
% (regardless of the previous operator probabilities, for creating the new
% individuals there are 2 types of mutation of equal probability)
for i=1:n
    r=rand;
    if r<0.5
        newind=swapmutation(pop,[],state,i);
        % ([] would be the params variable, not needed)
    else
        newind=shrinkmutation(pop,[],state,i);
        % ([] would be the params variable, not needed)
    end
    % check if the new individual is valid:
    % the only filter we use with this technique is the strict depth limit,
    % and only if params.fixedlevel is 1:
    if params.fixedlevel
        params.filters={'strictdepth'};
    else
        params.filters={};
    end
    [validind,state]=validateinds(newind,pop,params,state,[],[i],[]);
    if isempty(validind) % it is not, so just pretend it never happened
        i=i-1;
    else % it is valid, so add it to pop
        pop(end+1)=validind;
    end
end
