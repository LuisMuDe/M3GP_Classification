function y=nullexceeding(x,n)
%NULLEXCEEDING    Nulls numbers in list so that sum does not exceed limit.
%   NULLEXCEEDING(LIST,LIMIT) returns LIST with null values in all elements
%   that would cause list sum to exceed LIMIT. Elements are accepted (number
%   maintained) or rejected (number nulled) by their order in LIST. 
%   
%   Input arguments:
%      LIST - list of integers representing sizes of individuals (array)
%      LIMIT - maximum number of nodes (sum of sizes) to pick in LIST (integer)
%   Output arguments:
%      NEWLIST - same as LIST but with null values in rejected elements (array)
%
%   Example:
%      LIST=[20,18,31,4,30,12,20,10,3,3,1,5]
%      LIMIT=100
%      NEWLIST=NULLEXCEEDING(LIST,LIMIT)
%      NEWLIST=[20,18,31,4,0,12,0,10,3,0,1,0]
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

cumx=cumsum(x);
while sum(cumx>n)>0
   goodcumx=cumx(find(cumx<=n));
   if ~isempty(goodcumx)
     lastgood=goodcumx(end);
   else
     lastgood=0;
   end
   x(find(cumx>n & x+lastgood>n))=0;
   cumx=cumsum(x);
end
y=x;