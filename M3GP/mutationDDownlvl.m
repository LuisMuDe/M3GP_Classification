function newind=mutationDDownlvl(pop,params,state,i)
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
      
if (length(ind.tree.kids)>1) %mutation dimension down 
    
    root_nodes_no = length(ind.tree.kids);
    nind.tree=maketreeMutlvlup(state.iniclevel,state.functions,state.arity,0,params.depthnodes,0,1,(root_nodes_no-1));
      
    %Randomly eliminates one dimension form the tree
    branch = intrand(1,root_nodes_no-1);
    n1=0;
    for n = 1: (root_nodes_no-1) % copy the old kids to the new mutated tree with one dimension up
        
        if (branch==n)
            n1=n1+2;
        else 
            n1=n1+1;
        end
        try
        x1=nind.tree.kids{n}.nodeid; 
        x2=ind.tree.kids{n1}.nodeid; 
        [nind.tree,ind.tree]=swapnodes(nind.tree,ind.tree,x1,x2);
        catch
             error('LMD: something is wrong with the mutation lvl down function')
        end
    end
    
    ind.tree = nind.tree;
    
        ind.origin='mutationlvldown';    
        
        
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

        ind.origin='mutationBasic';
        ind.xsites=[x];

end

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
