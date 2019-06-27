function params=addfunctions(params,varargin)
%ADDFUNCTIONS    Stores additional functions info as parameters for GPLAB.
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
%   See also ADDTERMINALS, SETFUNCTIONS, ADDFUNCTIONS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

opinfo=varargin;

next=1;
ninfo=length(opinfo);
i=size(params.functions,1)+1;

while ninfo>=2
	params.functions{i,1}=opinfo{next};
	params.functions{i,2}=opinfo{next+1};
	next=next+2;
	ninfo=ninfo-2;
	i=i+1;
end
  
if ninfo~=0
	warning('ADDFUNCTIONS: last function not set because of incomplete information.')
end
