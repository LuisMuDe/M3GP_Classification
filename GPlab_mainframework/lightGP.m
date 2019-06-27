function accept=light(currentmean,state,params)
%LIGHT    Decides whether to accept a GPLAB individual into the population.
%   LIGHT(MEAN,STATE,PARAMS) returns true (acceptance) if the acceptance
%   of the individual improves the average fitness of the population when
%   compared to the population without the individual. Returns false
%   otherwise. It is easy to accept individuals under these conditions,
%   so the name is LIGHT (compare with normal.m).
%   
%   Input arguments:
%      MEAN - average fitness obtained by accepting the individual (double)
%      STATE - the current state of the algorithm (struct)
%      PARAMS - the parameters of the algorithm (struct)
%   Output arguments:
%      ACCEPT - true if individual is accepted, false otherwise (boolean)
%
%   See also RESOURCES, NORMAL
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

if ((currentmean<state.avgfitness) && (params.lowerisbetter)) || ((currentmean>state.avgfitness) && (~params.lowerisbetter))
    accept=1;
else
    accept=0;
end