function pop=free(pop,state)
%FREE    Applies no restrictions to the size of a GPLAB population.
%   FREE(POPULATION,STATE) returns all the individuals in POPULATION,
%   with no attempt to restrict their number in any way. It does nothing!
%   
%   Input arguments:
%      POPULATION - ordered list of (parents and offspring) individuals (array)
%      STATE - the current state of the algorithm (struct)
%   Output arguments:
%      POPULATION - individuals surviving into the next generation (array)
%
%   See also RESOURCES, STEADY, LOW
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% do NOT limit populatin size in any way, so do nothing
