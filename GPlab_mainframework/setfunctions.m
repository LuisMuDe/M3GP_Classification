function params=setfunctions(params,varargin)
%SETFUNCTIONS    Stores functions info as parameters for the GPLAB algorithm.
%   SETFUNCTIONS(PARAMS,FUNCNAME,FUNCARITY) returns updated
%   parameter variables where the functions information (name,
%   arity) has been set with the data provided in the function
%   arguments FUNCNAME, FUNCARITY. Several functions can be set
%   at the same time by adding several pairs FUNCNAME,FUNCARITY
%   to the list of arguments.
%
%   Input arguments:
%      PARAMS - the algorithm running parameters (struct)
%      FUNCNAME - the name of the function to use (string)
%      FUNCARITY - the arity (no. arguments) of the function (integer)
%      ...
%   Output arguments:
%      PARAMS - the updated algorithm running parameters (struct)
%
%   See also SETTERMINALS, ADDFUNCTIONS, ADDTERMINALS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

params.functions={};

if nargin>1
   params=addfunctions(params,varargin{:});
end

