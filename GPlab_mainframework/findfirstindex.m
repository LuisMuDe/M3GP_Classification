function listi=findfirstindex(x,tofind)
%FINDFIRSTINDEX    Finds the first occurences of numbers.
%   FINDFIRSTINDEX(X,TOFIND) returns the indices of the first
%   occurences in the vector X of the numbers in the vector
%   TOFIND. The elements of TOFIND with no occurences in X
%   will result in a null index (zero).
%
%   Input arguments:
%      X - the list where the occurences will be searched (1xN matrix)
%      TOFIND - the numbers to find (1xN matrix)
%   Output arguments:
%      LIST - the indices of the first occurences of TOFIND in X (1xN matrix)
%
%   Example:
%      X=[7,5,3,4,3,2]
%      TOFIND=[3,8,9,7]
%      LIST = FINDFIRSTINDEX(X,TOFIND)
%      LIST = 3    0    0    1
%
%   See also COUNTFIND, FIND
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox


%example:
%x=[1 5 3 4 3 2]
%tofind=[3 8 9 1]

[ans,ans,ans,i]=countfind(x,tofind);
%i=0 0 1 0 1 0
%  0 0 0 0 0 0
%  0 0 0 0 0 0
%  1 0 0 0 0 0

% find indices of numbers with no occurences:
[wherenorow,ans]=find(sum(i,2)==0);
wherenocol=zeros(length(wherenorow),1);
%wherenorow=2
%           3
%wherenocol=0
%           0

% by doing cumsum twice i garantee there's only one "1" in each row:
cci=cumsum(cumsum(i,2),2);
%cumsum(i,2)=0 0 1 1 2 2
%            0 0 0 0 0 0
%            0 0 0 0 0 0
%            1 1 1 1 1 1
%cumsum(cumsum(i,2),2)=0 0 1 2 4 6
%                      0 0 0 0 0 0
%                      0 0 0 0 0 0
%                      1 2 3 4 5 6

% now find the 1's:
[whererow,wherecol]=find(cci==1);
%whererow=4
%         1
%wherecol=1
%         3

% join the zero's where there were no occurences:
completewhererow=[whererow;wherenorow];
completewherecol=[wherecol;wherenocol];
%completewhererow=4
%                 1
%                 2
%                 3
%completewherecol=1
%                 3
%                 0
%                 0


m=sortrows([completewhererow completewherecol]);
%m(:,1)=1
%       2
%       3
%       4
%m(:,2)=3
%       0
%       0
%       1

% and the transpose of the cols is the list of indices!
listi=m(:,2)';
%listi=3 0 0 1
