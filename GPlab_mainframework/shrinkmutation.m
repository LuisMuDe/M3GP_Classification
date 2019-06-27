function newind=shrinkmutation(pop,params,state,i)
%SHRINKMUTATION    Creates a new individual for GPLAB by shrink mutation.
%   NEWIND=SHRINKMUTATION(POPULATION,PARAMS,STATE,PARENT) returns a new
%   individual created by substituting a random subtree (S) of PARENT by
%   a random subtree of S. The result is a tree smaller than the original,
%   or in special circumstances the original tree with no changes.
%
%   Input arguments:
%      POPULATION - the population where the parent is (array)
%      PARAMS - the parameters of the algorithm (struct)
%      STATE - the current state of the algorithm (struct)
%      PARENT - the index of the parent in POPULATION (integer)
%   Output arguments:
%      NEWIND - the newly created individual (struct)
%
%   See also MUTATION, SWAPMUTATION, CROSSOVER, APPLYOPERATOR
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

ind=pop(i);

% calculate number of nodes (we need it to pick a random branch)
if isempty(ind.nodes)
   ind.nodes=nodes(ind.tree);
end

if ind.nodes>1
    % if there is only 1 node, there is no subbranch, so no need to bother

    possiblechoices=1:ind.tree.nodes;
    % the terminals are not possible choices for the random branch

    x1=[];
    while isempty(x1)
        x=intrand(1,length(possiblechoices));
        node=findnode(ind.tree,possiblechoices(x));
        if isempty(node.kids)
            % node is terminal, remove it from possible choices
            possiblechoices=setdiff(possiblechoices,node.nodeid);
        else
            x1=possiblechoices(x);
            node1=findnode(ind.tree,x1);
        end
    end
    
    % random branch chosen, now chose random sub-branch
    x2=intrand(node1.nodeid+1,node1.maxid);
    node2=findnode(ind.tree,x2);
    
    % do the actual swapping
    ind.tree=swapnodes(ind.tree,node2,x1,1);
else
    % set x1 and x2 only for later setting ind.xsites
    x1=1;
    x2=1;
end % if ind.nodes>1

ind.id=[];
ind.origin='shrinkmutation';
ind.parents=[pop(i).id];
ind.xsites=[x1,x2];
ind.str=tree2str(ind.tree);
ind.fitness=[];
ind.adjustedfitness=[];
ind.result=[];
ind.testfitness=[];
ind.testadjustedfitness=[];
ind.nodes=ind.tree.nodes;
ind.introns=[];
ind.level=[];

newind=ind;
