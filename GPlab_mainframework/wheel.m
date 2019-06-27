function [indid,indindex,popexpected,popnormfitness]=wheel(pop,params,state,nsample,toavoid,type)
%WHEEL    Sampling of GPLAB individuals by spinning a wheel.
%   WHEEL(POP,PARAMS,STATE,NSAMPLE,TOAVOID,TYPE) returns NSAMPLE random
%   ids of the individuals chosen from POP using the roulette or sus
%   method, depending on TYPE. The ids in TOAVOID are not chosen.
%
%   [IDS,INDICES]=WHEEL(POP,PARAMS,STATE,NSAMPLE,TOAVOID,TYPE) also
%   returns the indices in POP of the chosen individuals.
%
%   [IDS,INDICES,EXPECTED,NORMFIT]=WHEEL(...) also returns the expected
%   number of offspring and the normalized fitness vectors, which may
%   have been calculated for the roulette or sus method.
%
%   Input arguments:
%      POPULATION - the current population of the algorithm (array)
%      PARAMS - the running parameters of the algorithm (struct)
%      STATE - the current state of the algorithm (struct)
%      NSAMPLE - the number of individuals to draw (integer)
%      TOAVOID - the ids of the individuals to avoid drawing (1xN matrix)
%      TYPE - method to use, roulette or sus (string) 
%   Output arguments:
%      IDS - the ids of the individuals chosen (1xN matrix)
%      INDICES - the indices of the individuals chosen (1xN matrix)
%      EXPECTED - the expected number of children of all individuals (1xN matrix)
%      NORMFIT - the normalized fitness of all individuals (1xN matrix)
%
%   See also ROULETTE, SUS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox


% get the things needed, if they're not available yet:
popids=[pop.id];
if isempty(state.popexpected)
   [popexpected,popnormfitness]=calcpopexpected(pop,params,state);
else
   popexpected=state.popexpected;
   popnormfitness=state.popnormfitness;
end

% roll the roulette with nsample random pointers (equally spaced in sus):

indicesavoid=[];
%  the expected value of the toavoid elements is set to zero:
if ~isempty(toavoid)
   [lixo,lixo,matrixnotavoid,lixo]=countfind(popids,setdiff(popids,toavoid));
   expected=popexpected.*matrixnotavoid;
   indicesavoid=find(matrixnotavoid==0);
else
   expected=popexpected;
end

% cumulative sum of the expected values:
% (single type casting to minimize memory problems)
% (for compatibility with octave, the single type cast was replaced
% by uint32 type cast, which saves the same amount of memory)
% (some matrices were converted to integers for this,
% making sure the type cast does not "cut" the values too short)
%cexpected=single([0,cumsum(expected)]);
cexpected=round(10000*[0,cumsum(expected)]);
maxexpected=cexpected(end);
if maxexpected>intmax('uint32')
   error('ROULETTE: cexpected max value is higher than uint32 max integer!')
else
   cexpected=uint32(cexpected);
end
% random (equally spaced in sus) pointers:
if strcmp(type,'roulette')
    pos=uint32(intrand(1,maxexpected,1,nsample));
elseif strcmp(type,'sus')
    pos=round(scale(rand+[0:nsample-1],[0,nsample],[0,maxexpected]));
    pos=uint32(pos);
else
    error('WHEEL: unknown type of wheel spin, allowed types are roulette and sus.')
end
% for each pos, find the indices where
% cexpected(1:end-1)<pos<=cexpected(2:end)
cexpected=repmat(cexpected,length(pos),1);
pos=repmat(pos',1,size(cexpected,2)-1);
[ans,indindex]=find(cexpected(:,1:end-1)<pos & pos<=cexpected(:,2:end));
indindex=indindex';
indid=popids(indindex);
