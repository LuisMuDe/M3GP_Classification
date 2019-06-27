function op=pickoperator(state)
%PICKOPERATOR    Draws a genetic operator to apply in the GPLAB algorithm.
%   PICKOPERATOR(STATE) returns the number of the operator chosen
%   according to the current operator probabilities indicated in STATE.
%
%   Input arguments:
%      STATE - the current state of the algorithm (struct)
%   Output arguments:
%      OPNUM - the number of the operator chosen (integer)
%
%   See also APPLYOPERATOR, CROSSOVER, MUTATION
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

if length(state.operatorprobs)==1
   op=1;
else
   % cumulative sum of the operator probabilities:
	cexpected=[0,cumsum(state.operatorprobs)];
	% one random pointer within the limits of the roulette:
	pos=(rand*cexpected(end));
	% find the index where cexpected(1:end-1)<pos<=cexpected(2:end)
	pos=repmat(pos',1,size(cexpected,2)-1);
	[ans,op]=find(cexpected(:,1:end-1)<=pos & pos<=cexpected(:,2:end));
	op=op(1); % we may have more than one - rare, but possible
end