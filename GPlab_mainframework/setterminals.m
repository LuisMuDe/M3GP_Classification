function params=setterminals(params,varargin)
%SETTERMINALS    Stores terminals info as parameters for the GPLAB algorithm.
%   SETTERMINALS(PARAMS,TERMNAME) returns updated parameter
%   variables where the terminals information (name - arity
%   is always null) has been set with the data provided in the
%   function arguments TERMNAME. Several terminals can be set
%   at the same time by adding several TERMNAME arguments.
%
%   Input arguments:
%      PARAMS - the algorithm running parameters (struct)
%      TERMNAME - the name of the terminal to use (string)
%      ...
%   Output arguments:
%      PARAMS - the updated algorithm running parameters (struct)
%
%   See also SETFUNCTIONS, ADDTERMINALS, ADDFUNCTIONS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox


params.terminals={};

if nargin>1
   params=addterminals(params,varargin{:});
end

