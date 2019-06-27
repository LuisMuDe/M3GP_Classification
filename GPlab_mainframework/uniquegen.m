function diversity = uniquegen(params,state,data,pop)
%UNIQUEGEN    Calculates genotype-based diversity of a GPLAB population.
%   DIVERSITY=UNIQUEGEN(PARAMS,STATE,POP) calculates a diversity
%   measure on the population. The diversity is calculated
%   as the percentage of individuals that account for all
%   the different genotypes in the population.
%
%   Input arguments:
%      PARAMS - the running parameters (struct)
%      STATE - the state before the update (struct)
%      DATA - the dataset for the algorithm to use (struct)
%      POP - current population (array)
%   Output arguments:
%      DIVERSITY - the diversity measure (double)
%
%   See also HAMMING
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% the percentage of unique individuals in the population:
realpopsize=state.popsize;
effectivepopsize=length(unique({pop.str}));
diversity=100*effectivepopsize/realpopsize;