function params=addterminals(params,varargin)
%ADDTERMINALS    Stores additional terminals info as parameters for GPLAB.
%   ADDTERMINALS(PARAMS,TERMNAME) returns updated parameter
%   variables where the terminals information (name - arity
%   is always null) has been added with the data provided in the
%   function arguments TERMNAME. Several terminals can be added
%   at the same time by adding several TERMNAME arguments.
%
%   Input arguments:
%      PARAMS - the algorithm running parameters (struct)
%      TERMNAME - the name of the terminal to use (string)
%      ...
%   Output arguments:
%      PARAMS - the updated algorithm running parameters (struct)
%
%   See also ADDFUNCTIONS, SETTERMINALS, ADDFUNCTIONS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

opinfo=varargin;

next=1;
ninfo=length(opinfo);
i=size(params.terminals,1)+1;

while ninfo>=1
	params.terminals{i,1}=opinfo{next};
	params.terminals{i,2}=0;
	next=next+1;
	ninfo=ninfo-1;
	i=i+1;
end
  
if ninfo~=0
	warning('ADDTERMINALS: last terminal not set because of incomplete information.')
end
