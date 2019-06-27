function pop=low(pop,state)
%LOW    Applies restrictions to the size of a GPLAB population.
%   LOW(POPULATION,STATE) returns the first STATE.POPSIZE individuals from
%   POPULATION (parents and offspring), for the next generation. Does
%   basicaly the same as fixedpopsize.m but is used in a different context,
%   that of resource-limited GP, instead of fixed population size GP.
%   
%   Input arguments:
%      POPULATION - ordered list of (parents and offspring) individuals (array)
%      STATE - the current state of the algorithm (struct)
%   Output arguments:
%      POPULATION - individuals surviving into the next generation (array)
%
%   See also RESOURCES, STEADY, FREÊ
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% limit population size to state.popsize:
pop=pop(1:min([state.popsize length(pop)]));
