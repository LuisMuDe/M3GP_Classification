function pop=steady(pop,state)
%STEADY    Applies restrictions to the size of a GPLAB population.
%   STEADY(POPULATION,STATE) returns the first STATE.INITPOPSIZE
%   individuals from POPULATION (parents and offspring), for the
%   next generation. 
%   
%   Input arguments:
%      POPULATION - ordered list of (parents and offspring) individuals (array)
%      STATE - the current state of the algorithm (struct)
%   Output arguments:
%      POPULATION - individuals surviving into the next generation (array)
%
%   See also RESOURCES, LOW, FREÊ
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% limit populatin size to state.initpopsize:
pop=pop(1:min([state.initpopsize length(pop)]));