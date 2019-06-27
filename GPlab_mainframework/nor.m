function y=nor(x1,x2)
%NAND    Equivalent to the NOT(OR) functions.
%   NAND(X1,X2) returns NOT(OR(X1,X2)).
%
%   Input arguments:
%      X1,X2 - the pair of numbers to evaluate (double)
%   Output arguments:
%      Y - the result of the evaluation (boolean)
%
%   See also NAND
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

y=not(or(x1,x2));
