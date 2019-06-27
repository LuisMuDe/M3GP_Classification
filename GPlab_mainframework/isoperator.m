function isit=isoperator(operatornames,possibleoperator)
%ISOPERATOR    True for GPLAB algorithm operator.
%   ISOPERATOR(OPERATORNAMES,POSSIBLEOPERATOR) returns the operator
%   number 1,2... (true) if POSSIBLEOPERATOR is in OPERATORNAMES,
%   or 0 (false) otherwise.
%
%   Input arguments:
%      OPERATORNAMES - an array with names of operators (cell array)
%      POSSIBLEOPERATOR - the name of a possible operator (string)
%   Output argument:
%      the number of the operator, or false (integer)
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox


isit=find(strcmp(operatornames,possibleoperator));

if isempty(isit)
   isit=0;
end


