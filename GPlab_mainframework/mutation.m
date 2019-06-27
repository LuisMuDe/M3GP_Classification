function newind=mutation(pop,params,state,i)
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

d=intrand(1,2); % mutation point

% node to mutate (whole branch from this point downwards):
%xnode=findnode(ind.tree,x); 

if (d == 1)%if true, that means the mutation of the root node, leveling up one leaf
    
    root_nodes_no = length(ind.tree.kids);
    nind.tree=maketreeMutlvlup(state.iniclevel,state.functions,state.arity,0,params.depthnodes,0,1,(root_nodes_no+1));
      
    for n = 1: root_nodes_no % copy the old kids to the new mutated tree with one dimension up
    
        x1=nind.tree.kids{n}.nodeid; 
        x2=ind.tree.kids{n}.nodeid; 
     [nind.tree,ind.tree]=swapnodes(nind.tree,ind.tree,x1,x2);
    
    end
    
    ind.tree = nind.tree;
    
        ind.id=[];
        ind.origin='mutationlvlup';
        ind.parents=[pop(i).id];
        ind.xsites=[0];
        ind.str=tree2str(ind.tree);
        ind.fitness=[];
        ind.adjustedfitness=[];
        ind.result=[];
        ind.testfitness=[];
        ind.testadjustedfitness=[];
        ind.nodes=ind.tree.nodes;
        ind.introns=[];
        ind.level=[];
    
else
        x=intrand(2,ind.nodes); % mutation point
        % build a new branch for this tree, no deeper/bigger than the initial random trees:
        % (and obeying the depth/size restrictions imposed by the limits in use)
        %newtree=maketree(state.iniclevel,state.functions,state.arity,0,state.depthnodes,xnode.nodeid-1);
        nind.tree=maketree(state.iniclevel,state.functions,state.arity,0,params.depthnodes,x-1);
        % (the maximum size of the new branch is the same as the initial random trees)
        % (0 means no exact level)

        % swap old branch with new branch in only one step, as if this were
        % crossover (but discard the resulting nind):
        
        ind.tree=swapnodes(ind.tree,nind.tree,x,1);
        %ind.tree=swapnode(ind.tree,x,newtree);

        ind.id=[];
        ind.origin='mutation';
        ind.parents=[pop(i).id];
        ind.xsites=[x];
        ind.str=tree2str(ind.tree);
        ind.fitness=[];
        ind.adjustedfitness=[];
        ind.result=[];
        ind.testfitness=[];
        ind.testadjustedfitness=[];
        ind.nodes=ind.tree.nodes;
        ind.introns=[];
        ind.level=[];
end


newind=ind;
