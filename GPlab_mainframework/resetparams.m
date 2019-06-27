function params=resetparams;
%RESETPARAMS    Resets the parameter variables for the GPLAB algorithm.
%   RESETPARAMS sets all the GPLAB algorithm parameter variables with the
%   default values.
%
%   Output arguments:
%      PARAMS - the set of default parameter variables (struct)
%
%   See also SETPARAMS, RESETSTATE
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

params=setparams([],'defaults');