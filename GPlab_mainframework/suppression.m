function pop=suppression(pop,state,params,previousbest,currentbest)
%SUPPRESSION    Removes a number of GPLAB individuals from the population.
%   SUPPRESSION(POPULATION,STATE,PARAMS,PBEST,BEST) returns a population
%   with less individuals than POP. The number of individuals to remove
%   depends on a relationship between population size, current best
%   fitness and the previous best fitness achieved a number of generations
%   back. The largest individuals are selected from twice the worst
%   individuals, and removed from the population.
%   
%   Input arguments:
%      POPULATION - ordered list of (parents and offspring) individuals (array)
%      STATE - the current state of the algorithm (struct)
%      PARAMS - the parameters of the algorithm (struct)
%      PBEST - best fitness of generation current-params.periode (double)
%      BEST - best fitness of current generation (double)
%   Output arguments:
%      POPULATION - next generation of individuals (array)
%
%   See also PIVOTFIXE, AJOUT
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

% number of individuals to remove from the population:
if params.lowerisbetter
    gain=(previousbest-currentbest)/previousbest;
else
    gain=previousbest/(currentbest-previousbest);
end
m=round(length(pop)*gain); % (see Rochat thesis)

% do not remove more than popsize-1 individuals:
m=min([m length(pop)-1]);

% remove individuals:
% (the population is ordered by fitness, so the worst are removed)
pop=pop(1:length(pop)-m);
