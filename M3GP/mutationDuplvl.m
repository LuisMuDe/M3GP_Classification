function newind=mutationDuplvl(pop,params,state,i)
%MUTATION    Creates a new individual for GPLAB by mutation.
%   NEWIND=MUTATION(POPULATION,PARAMS,STATE,PARENT) returns a new individual
%   created by substituting a random subtree of PARENT by a new
%   randomly created tree, with the same depth/size restrictions
%   as the initial random trees.
%
%   Input arguments:
%      POPULATION - the population where the parent is (array)
%      PARAMS - the parameters of the algorithm (struct)
%      STATE - the current state of the algorithm (struct)
%      PARENT - the index of the parent in POPULATION (integer)
%   Output arguments:
%      NEWIND - the newly created individual (struct)
%
%   See also CROSSOVER, APPLYOPERATOR
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

ind=pop(i);

% calculate number of nodes (we need it to pick a random branch)
if isempty(ind.nodes)
   ind.nodes=nodes(ind.tree);
end

%d=intrand(1,3); % random lvl up o basic mutation
%if 1 add one dimension up 
%if 2 removes one dimension (one dimension down)
%else classic mutation

% node to mutate (whole branch from this point downwards):
%xnode=findnode(ind.tree,x); 

    root_nodes_no = length(ind.tree.kids);
    nind.tree=maketreeMutlvlup(state.iniclevel,state.functions,state.arity,0,params.depthnodes,0,1,(root_nodes_no+1));
      
    for n = 1: root_nodes_no % copy the old kids to the new mutated tree with one dimension up
    
        try
        x1=nind.tree.kids{n}.nodeid; 
        x2=ind.tree.kids{n}.nodeid; 
        [nind.tree,ind.tree]=swapnodes(nind.tree,ind.tree,x1,x2);
        catch
            error('LMD: something is wrong with the mutation lvl up function')
        end
    
    end
    
    ind.tree = nind.tree;
    
        ind.origin='mutationlvlup';
   

        ind.id=[];
       % ind.origin='mutation';
        ind.parents=[pop(i).id];
        
        ind.str=tree2str(ind.tree);
        ind.fitness=[];
        ind.adjustedfitness=[];
        ind.result=[];
        ind.testfitness=[];
        ind.testadjustedfitness=[];
        ind.nodes=ind.tree.nodes;
        ind.introns=[];
        ind.level=[];
        ind.Pruned = 'False';


newind=ind;
