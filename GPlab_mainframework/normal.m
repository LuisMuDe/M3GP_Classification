function accept=normal(currentmean,state,params)
%NORMAL    Decides whether to accept a GPLAB individual into the population.
%   NORMAL(MEAN,STATE,PARAMS) returns true (acceptance) if the acceptance
%   of the individual improves the best average fitness obtained so far.
%   Returns false otherwise. It is not so easy to accept individuals under
%   these conditions, so the name is NORMAL (compare with light.m).
%   
%   Input arguments:
%      MEAN - average fitness obtained by accepting the individual (double)
%      STATE - the current state of the algorithm (struct)
%      PARAMS - the parameters of the algorithm (struct)
%   Output arguments:
%      ACCEPT - true if individual is accepted, false otherwise (boolean)
%
%   See also RESOURCES, LIGHT
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

if ((currentmean<state.bestavgfitnesssofar) && (params.lowerisbetter)) || ((currentmean>state.bestavgfitnesssofar) && (~params.lowerisbetter))
    accept=1;
else
    accept=0;
end