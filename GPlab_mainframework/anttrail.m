function result=anttrail(x,y)
%ANTTRAIL    Interprets a matrix as a food trail for a GPLAB artificial ant.
%   ANTTRAIL(X,Y) returns a struct array with a matrix (the food trail)
%   and the number of food pellets that can be found in the trail.
%
%   Input arguments:
%      X - matrix with trail (1 is food, 0 is no food) (array)
%      Y - number of food pellets (integer)
%   Output arguments:
%      DATASET - trail and number of food pellets for artificial ant (struct)
%        DATASET.EXAMPLE(:,:) - matrix representing trail
%        DATASET.RESULT - number of food pellets
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

result.example=x;
result.result=y;
