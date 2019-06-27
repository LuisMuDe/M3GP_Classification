function params=addoperators(params,varargin)
%ADDOPERATORS    Stores additional operators info as parameters for GPLAB.
%   ADDOPERATORS(PARAMS,OPNAME,NPARENTS,NCHILDREN) returns updated
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
%   See also SETOPERATORS, SETPARAMS, RESETPARAMS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

if nargin==2
   opinfo=varargin{1};
else
   opinfo=varargin;
end

params.initialfixedprobs=[];
params.initialvarprobs=[];

next=1;
ninfo=length(opinfo);
i=length(params.operatornames)+1;

while ninfo>=3
	params.operatornames{i}=opinfo{next};
	params.operatornparents(i)=opinfo{next+1};
	params.operatornchildren(i)=opinfo{next+2};
	next=next+3;
	ninfo=ninfo-3;
	i=i+1;
end
  
if ninfo~=0
	warning('ADDOPERATORS: last operator not set because of incomplete information.')
end
