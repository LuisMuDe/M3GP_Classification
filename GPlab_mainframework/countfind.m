function [n,nc,i,ic]=countfind(x,tofind)
%COUNTFIND    Counts occurences of numbers.
%   COUNTFIND(X,TOFIND) returns how many times the
%   numbers in TOFIND occur in X.
%
%   [N,NCOL] = COUNTFIND(X,TOFIND) also returns the
%   number of occurences for each element in TOFIND.
%
%   [N,NCOL,MASK] = COUNTFIND(X,TOFIND) also returns a
%   list the same length as X with 1's where an
%   occurence was found and 0's elsewhere.
%
%   [N,NCOL,MASK,COLMASK] = COUNTFIND(X,TOFIND) also returns a
%   matrix of 0's and 1's where each row is the MASK for each
%   of the elements in TOFIND.
%
%   Input arguments:
%      X - the list where the occurences will be searched (1xN matrix)
%      TOFIND - the numbers to find (1xN matrix)
%   Output arguments:
%      N - the number of occurences found (integer)
%      NCOL - the number of occurences found for each TOFIND element (1xN matrix)
%      MASK - the list where 1's mean occurences and 0's otherwise (1xN matrix)
%      COLMASK - MASK for each TOFIND element (MxN matrix)
%
%   Example:
%      X=[1,2,3,4,1]
%      TOFIND=[1,4]
%      [N,NCOL,MASK,COLMASK] = COUNTFIND(X,TOFIND)
%      N = 3
%      NCOL = 2    1
%      MASK = 1    0    0    1    1
%      COLMASK = 1    0    0    0    1
%                0    0    0    1    0
%
%   See also FIND, FINDFIRSTINDEX
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox


% both matrices must have the same dimensions:
sizedx=repmat(x,size(tofind,2),1);
sizedtofind=repmat(tofind,size(x,2),1)';

% now get the 0,1 matrix of occurences:
ic=sizedx==sizedtofind;

% now sum each column to get the absolute frequencies of each element:
nc=sum(ic,2)';

% occurences per column:
i=sum(ic~=0,1);

% and total count:
n=sum(i);

% this way of finding n is the vectorization of:
%n=0;
%for c=1:length(tofind)
%   n=n+sum(x==tofind(c));
%end
