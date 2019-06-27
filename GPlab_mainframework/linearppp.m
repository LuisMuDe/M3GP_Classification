function ind=linearppp(ind,params)
%LINEARPPP    Applies linear parametric parsimony pressure to a GPLAB individual.
%   LINEARPPP(INDIVIDUAL,PARAMS) returns the fitness of an individual
%   after applying linear parametric parsimony pressure of the form
%   fitness = x * fitness + size (if lower fitness is better) or
%   fitness = x * fitness - size (otherwise).
%
%   Input arguments:
%      INDIVIDUAL - the individual whose fitness is to change (struct)
%      PARAMS - the running parameters of the algorithm (struct)
%   Output arguments:
%      INDIVIDUAL - the individual whose fitness was changed (1xN matrix)
%
%   See also CALCFITNESS
%
%   References:
%   Luke, S. and Panait, L. A Comparison of Bloat Control Methods for
%   Genetic Programming. Evolutionary Computation 14(3):309-344 (2006)
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% parameters of this tournament:
% (best cross-problem settings - see reference):
x=32;

if isempty(ind.nodes)
    ind.nodes=nodes(ind.tree);
end

if params.lowerisbetter
    ind.adjustedfitness=x*ind.fitness+ind.nodes;
else
    ind.adjustedfitness=x*ind.fitness-ind.nodes;
end