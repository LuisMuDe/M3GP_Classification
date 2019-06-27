function params=setoperators(params,varargin)
%SETOPERATORS    Stores operators info as parameters for the GPLAB algorithm.
%   SETOPERATORS(PARAMS,OPNAME,NPARENTS,NCHILDREN) returns updated
%   parameter variables where the operators information (name, number
%   of parents needed, number of children produced) has been set with
%   the data provided in the function arguments OPNAME, NPARENTS,
%   NCHILDREN. Several operators can be set at the same time by adding
%   several triplets OPNAME,NPARENTS,NCHILDREN to the list of arguments.
%
%   Input arguments:
%      PARAMS - the algorithm running parameters (struct)
%      OPNAME - the name of the operator to use (string)
%      NPARENTS - the number of parents required by the operator (integer)
%      NCHILDREN - the number of children produced by the operator (integer)
%      ...
%   Output arguments:
%      PARAMS - the updated algorithm running parameters (struct)
%
%   See also ADDOPERATORS, SETPARAMS, RESETPARAMS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

params.operatornames={};
params.operatornparents=[];
params.operatornchildren=[];

params.initialfixedprobs=[];
params.initialvarprobs=[];

params=addoperators(params,varargin);
