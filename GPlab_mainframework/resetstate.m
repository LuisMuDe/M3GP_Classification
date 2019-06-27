function state=resetstate;
%RESETSTATE    Resets the state variables for the GPLAB algorithm.
%   RESETSTATE sets all the GPLAB algorithm state variables with the
%   default initial values.
%
%   Output arguments:
%      STATE - the set of default initial state variables (struct)
%
%   See also RESETPARAMS, SETPARAMS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

state=setparams([],'defaults','state');