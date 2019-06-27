function [parents,pool]=pickparents(params,pool,opnum)
%PICKPARENTS    Picks parents from pool for a GPLAB genetic operator.
%   PICKPARENTS(PARAMS,POOL,OPNUM) returns the indices of the parents
%   chosen in POOL to be used by the genetic operator OPNUM.
%
%   [PARENTS,POOL]=PICKPARENTS(PARAMS,POOL,OPNUM) also returns the
%   pool after being updated.
%
%   Input arguments:
%      PARAMS - the running parameters of the algorithm (struct)
%      POOL - the pool of parents from which to choose (matrix)
%      OPNUM - the number of the genetic operator to apply (integer)
%   Output arguments:
%      PARENTS - the indices of the chosen parents (1xN matrix)
%      POOL - the updated pool of parents (matrix)
%
%   See also SAMPLING
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

if opnum==0
   % reproduction:
   needed=1;
   produced=1;
else
   % genetic operator:
   needed=params.operatornparents(opnum);
   produced=params.operatornchildren(opnum);
end   

sizepool=size(pool,2);

% when the pool is almost exhausted, it may happen that we have a certain number of
% elements there and we have an operator that needs more parents than that. so we must
% replicate the remaining elements of pool

if needed>sizepool
   i=ceil(needed/sizepool);
   % (how many times we need to replicate the pool elements)
   pool=repmat(pool,1,i);
   % after this we may even have too many elements in pool,
   % but pool will be discarded after this anyway
end

% shuffle and take out the first needed individuals:
pool=shuffle(pool,2); % shuffle entire columns
parents=pool(1,1:needed);

% parents now contains all the individuals needed for the operator.
% now decrement the second row of pool, that contains how many offspring each
% individual must still produce to be removed from the pool, and remove the
% ones that have reached 0 (it means they have produced all the offspring they
% were supposed to produce).

% decrementing 2nd row:
pool(2,1:needed)=pool(2,1:needed)-(produced/needed);

% removing zeros from the pool:
pool=pool(:,pool(2,:)>0);