function diversity = hamming(params,state,data,pop)
%HAMMING    Calculates hamming diversity of a GPLAB population.
%   DIVERSITY=HAMMING(PARAMS,STATE,POP) calculates a diversity
%   measure on the population. The diversity is calculated
%   based on the average hamming distance between the results
%   output from the population. This requires that the result
%   output by the subfunctions is vectors of numbers between
%   0 and 1.
%
%   Input arguments:
%      PARAMS - the running parameters (struct)
%      STATE - the state before the update (struct)
%      DATA - the dataset for the algorithm to use (struct)
%      POP - current population (array)
%   Output arguments:
%      DIVERSITY - the diversity measure (double)
%
%   Copyright (C) 2003 Jens Thielemann (jtt@sintef.no)
%   Modified by Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% number of combinations of popsize individuals, taken 2 at a time:
% npairs=nchoosek(state.popsize,2);
% with popsize=15, npairs=nchoosek(15,2)=105

% for the extreme case where there is only one individual left in pop,
% simulate that there are two:
% (it is ok to change state and pop because they are not output arguments)
if state.popsize==1
    pop(1:2)=pop(1); % duplicate individual
    state.popsize=2;
end

% make this efficient without undersampling too much on larger populations:
% if popsize>15 create 105 or 10% of population size random pairs, whichever is higher
if state.popsize>15
   npairs=max([105 round(0.1*state.popsize)]);
   pairs=round(rand(npairs,2)*(state.popsize-1))+1;
   % (this ensures integers between 1 and state.popsize)
   % now change second column of all cases where pairs(i,1)==pairs(i,2)
   f=find(pairs(:,1)==pairs(:,2));
   while ~isempty(f) % insist until there are no more such cases
      pairs(f,2)=round(rand(length(f),1)*(state.popsize-1))+1;
      f=find(pairs(:,1)==pairs(:,2));
   end
else % else use all pairs
   pairs=nchoosek(1:state.popsize,2); % see help nchoosek for details
end

% sum distances between all pairs:
diversity=0;
for i=1:size(pairs,1)
    resultind1=pop(pairs(i,1)).result;
    resultind2=pop(pairs(i,2)).result;    
    diversity=diversity+nansum(nansum(abs(resultind1-resultind2)));
end

% normalize value:
diversity=diversity/(size(pairs,1)*length(data.result));

