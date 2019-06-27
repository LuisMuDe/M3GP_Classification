function [nintrons,state]=intronnodes(tree,params,data,state)
%INTRONNODES    Counts the number of intron nodes of a GPLAB tree.
%   INTRONNODES(TREE,PARAMS,DATA,STATE) returns the number of
%   nodes in intron branches of the TREE (branches whose existence
%   does not affect the evaluation of the individual in all fitness
%   cases) of a GPLAB representation tree.
%
%   Input arguments:
%      TREE - the tree to count introns (struct)
%      PARAMS - the algorithm running parameters (struct)
%      DATA - the dataset on which to evaluate (struct)
%      STATE - current state of the algorithm (struct)
%   Output arguments:
%      NINTRONS - the number of nodes considered introns (integer)
%      STATE - updated state of the algorithm (struct)
%
%   See also NODES
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

nkids=size(tree.kids,2);
if nkids<0
   error('INTRONNODES: number of children lower than 0!');
end

nintrons=0;
if nkids>0
   
    % prepare 'ind' variable with necessary fields, then call calcfitness:
    rootind.str=tree2str(tree);
    rootind.tree=tree;
    rootind.nodes=tree.nodes;
    [rootind,state]=calcfitness(rootind,params,data,state,0);
      
   for i=1:nkids
       % prepare 'ind' variable with necessary fields, then call calcfitness:
       kidind.str=tree2str(tree.kids{i});
       kidind.tree=tree.kids{i};
       kidind.nodes=tree.kids{i}.nodes;
       [kidind,state]=calcfitness(kidind,params,data,state,0);
      if sum(rootind.result==kidind.result)==length(rootind.result)
         % (if both evaluations return the same results for all fitness cases)
         existintrons(i)=1; % this kid says the other kids are introns
      else
         existintrons(i)=0; % this one cannot prove there are
      end
   end % for i=1:nkids

   % get all kids that say the others are introns:
   ki=find(existintrons==1);
      
   if isempty(ki) % if there are no kids that say the others are introns
      % sum the introns of all kids:
      for i=1:nkids
         [nintronnodes,state]=intronnodes(tree.kids{i},params,data,state);
         nintrons=nintrons+nintronnodes;
      end
   else
      % choose the smaller kid to stay and say the others are introns:
      % (but choose the EFFECTIVE smaller, ie, the smaller size after removing introns inside)
      for i=1:length(ki)
         kidnodes(i)=nodes(tree.kids{ki(i)});
         [kidintrons(i),state]=intronnodes(tree.kids{ki(i)},params,data,state);
      end
      kideffectives=kidnodes-kidintrons;
      m=min(kideffectives); % this is the effective size of the smaller effective kid
      mi=find(kideffectives==m);
      mi=mi(1); % in case there's more than one with the same minimum effective size
      nintrons=nintrons+nodes(tree)-kidnodes(mi)+kidintrons(mi);
   end   
         
end % if nkids>0
