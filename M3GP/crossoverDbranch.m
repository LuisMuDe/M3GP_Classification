function newinds=crossoverDbranch(pop,params,state,indlist)
%CROSSOVER    Creates new individuals for the GPLAB algorithm by crossover.
%   NEWINDS=CROSSOVER(POPULATION,PARAMS,STATE,PARENTS) returns two new individuals
%   created by swaping subtrees of the two PARENTS at random points.
%
%   Input arguments:
%      POPULATION - the population where the parents are (array)
%      PARAMS - the parameters of the algorithm (struct)
%      STATE - the current state of the algorithm (struct)
%      PARENTS - the indices of the parents in POPULATION (1x2 matrix)
%   Output arguments:
%      NEWINDS - the two newly created individuals (1x2 matrix)
%
%   See also MUTATION, APPLYOPERATOR
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

i1=indlist(1);
i2=indlist(2);

ind1=pop(i1);
ind2=pop(i2);

if isempty(ind1.nodes)
   ind1.nodes=nodes(ind1.tree);
end
if isempty(ind2.nodes)
   ind2.nodes=nodes(ind2.tree);
end
%%LMD the random selection goes from 2 and up, one is out of the random
%%selection because is the root node

%the crossover point are dimension branches, to randomly change branches 
% Randomly selects one dimension to be swap  

if length(ind1.tree.kids)==1 && length(ind2.tree.kids)==1  
%There is no case on changing dimension trees on dimension 1
        x1=0; 
        x2=0; 
else
   T1branch=intrand(1,length(ind1.tree.kids));
   T2branch=intrand(1,length(ind2.tree.kids));
    %The id of the node were te dimension is selected 
    try
        x1=ind1.tree.kids{T1branch}.nodeid; 
        x2=ind2.tree.kids{T2branch}.nodeid; 
    catch
        error('LMD: something is wrong with the crossover branch function')
    end
   % the change of dimension trees is done      
   [ind1.tree,ind2.tree]=swapnodes(ind1.tree,ind2.tree,x1,x2);
   
   %change the name of crossover, for backtracking 
   ind1.origin='crossoverDbranch';
   ind2.origin='crossoverDbranch';
end   
ind1.str=tree2str(ind1.tree);
ind1.id=[];

ind1.parents=[pop(i1).id,pop(i2).id];
ind1.xsites=[x1,x2];
ind1.fitness=[];
ind1.adjustedfitness=[];
ind1.result=[];
ind1.testfitness=[];
ind1.testadjustedfitness=[];
ind1.level=[];
ind1.nodes= ind1.tree.nodes;
ind1.introns=[];
ind1.Pruned = 'False';
   
ind2.str=tree2str(ind2.tree);      	
ind2.id=[];

ind2.parents=[pop(i2).id,pop(i1).id];
ind2.xsites=[x2,x1];
ind2.fitness=[];
ind2.adjustedfitness=[];
ind2.result=[];
ind2.testfitness=[];
ind2.testadjustedfitness=[];
ind2.level=[];
ind2.nodes= ind2.tree.nodes;
ind2.introns=[];  
ind2.Pruned = 'False';

newind1=ind1;
newind2=ind2;


newinds=[newind1,newind2];
