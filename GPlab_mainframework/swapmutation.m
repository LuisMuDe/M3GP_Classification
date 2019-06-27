function newind=swapmutation(pop,params,state,i)
%SWAPMUTATION    Creates a new individual for GPLAB by swap mutation.
%   NEWIND=SWAPMUTATION(POPULATION,PARAMS,STATE,PARENT) returns a new
%   individual created by swapping two random subtrees of PARENT.
%   It guarantees the swapping of independent subtrees (not contained
%   in each other) whenever possible, but in special circumstances
%   (single-node tree, single-line tree) the result will be the
%   original tree with no changes. 
%
%   Input arguments:
%      POPULATION - the population where the parent is (array)
%      PARAMS - the parameters of the algorithm (struct)
%      STATE - the current state of the algorithm (struct)
%      PARENT - the index of the parent in POPULATION (integer)
%   Output arguments:
%      NEWIND - the newly created individual (struct)
%
%   See also MUTATION, SHRINKMUTATION, CROSSOVER, APPLYOPERATOR
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

ind=pop(i);

% calculate number of nodes (we need it to pick a random branch)
if isempty(ind.nodes)
   ind.nodes=nodes(ind.tree);
end

if ind.nodes>2
    % if there are only 1 or 2 nodes, it is not possible to find 2
    % different subtrees to swap, so no need to bother...
    
    % first eliminate a possible "root line". there is at least one node
    % (the root) that cannot be used, but this node may have a single
    % child that cannot also be used, and so on. we only stop when we have
    % a node with multiple children.
    possiblechoices=2:ind.tree.nodes;
    for n=1:ind.tree.nodes-1
        node=findnode(ind.tree,n);
        if length(node.kids)==1
            possiblechoices=possiblechoices(2:end);
        else
            break
        end
    end
    if ~isempty(possiblechoices)
        % if there are no possible choices, no swapping will occur
        
        % choose 1st branch to swap and remove it from possible choices:
        r=intrand(1,length(possiblechoices));
        node1=findnode(ind.tree,possiblechoices(r));
        possiblechoices=setdiff(possiblechoices,node1.nodeid:node1.maxid);
        
        % choose 2nd branch to swap, make sure it does not contain the 1st:
        node2=[];
        while isempty(node2)
            r=intrand(1,length(possiblechoices));
            node=findnode(ind.tree,possiblechoices(r));
            if (node.nodeid<=node1.nodeid) && (node.maxid>=node1.nodeid)
                % node contains node1, so remove node from possible choices
                possiblechoices=setdiff(possiblechoices,node.nodeid:node.maxid);
            else
                node2=node;
            end
        end
        
        % do the actual swap, make sure it is done by the right order:
        % (change the far branch first so that the close branch retains id)
        if node1.nodeid<node2.nodeid
            ind.tree=swapnodes(ind.tree,node1,node2.nodeid,1);
            ind.tree=swapnodes(ind.tree,node2,node1.nodeid,1);
        else
            ind.tree=swapnodes(ind.tree,node2,node1.nodeid,1);
            ind.tree=swapnodes(ind.tree,node1,node2.nodeid,1);
        end
    else
        % set node1 and node2 only for later setting ind.xsites
        node1=ind.tree;
        node2=ind.tree;
    end % if ~isempty(possiblechoices)
    
else
    % set node1 and node2 only for later setting ind.xsites
    node1=ind.tree;
    node2=ind.tree;
end % if ind.nodes>2

ind.id=[];
ind.origin='swapmutation';
ind.parents=[pop(i).id];
ind.xsites=[node1.nodeid,node2.nodeid];
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
