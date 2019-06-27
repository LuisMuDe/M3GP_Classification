function [tree1,tree2,sizediff]=swapnodes(tree1,tree2,x1,x2,parent1,childnum1,parent2,childnum2)
%SWAPNODES    Swaps nodes (subtrees) between two GPLAB trees.
%   [NTREE1,NTREE2]=SWAPNODES(TREE1,TREE2,X1,X2) returns the
%   two new trees (NTREE1,NTREE2) resulting from swapping
%   node X1 of TREE1 by node X2 of TREE2. Nodes are swapped
%   with their entire subtrees. Nodes are numbered depth-first.
%
%   Additional input parameters (not set in the first call)
%   are PARENT1/PARENT2 (parent tree of TREE1/TREE2),
%   CHILDNUM1/CHILDNUM2 (order of TREE1/TREE2 among
%   all kids of PARENT1/PARENT2).
%
%   Additional output argument (essential in recursiveness)
%   is SIZEDIFF, the difference in size between NTREE1 and NTREE2.
%   
%   Input arguments:
%      TREE1 - the first tree where to swap nodes (struct)
%      TREE2 - the second tree where to swap nodes (struct)
%      X1 - the number of the node to be substituted in TREE1 (integer)
%      X2 - the number of the node to be substituted in TREE2 (integer)
%      PARENT1 - the parent tree of TREE1 (struct)
%      CHILDNUM1 - order of TREE1 among all kids of PARENT1 (integer)
%      PARENT2 - the parent tree of TREE2 (struct)
%      CHILDNUM2 - order of TREE2 among all kids of PARENT2 (integer)
%   Output arguments:
%      NTREE1 - the first tree resulting from swapping (struct)
%      NTREE2 - the second tree resulting from swapping (struct)
%      SIZEDIFF - size difference between NTREE1 and NTREE2 (integer)
%
%   Note: This is a recursive function.
%
%   See also UPDATENODEIDS, MAKETREE, CROSSOVER, MUTATION
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox


% The procedure is as follows:
%   - find node X1 in TREE1
%   - find node X2 in TREE2
%   - swap nodes

if ~exist('sizediff','var') % more efficient than just if ~exist('parent1')
  sizediff=tree1.nodes-tree2.nodes; 
 % error('LMD: something is wrong sizediff')
end

%LMD sometimes when the root kid is just one node, the search for the node
%by pass the node and goes to negative numbers, by this criteria if it goes to
%negative is because the node is looking for is already found
% if x1 < 0
%     x1=1;
% %LMD debugging     
% %     x1
% %     drawtree(tree1)
% %     error('LMD: something is wrong ')
% end
%LMD before  if x1==1   
if x1<=1 % found node x1 in tree1!
   node2=tree1; % node2 = node to be put in tree2
   
   if ~exist('parent1','var') % more efficient than just if ~exist('parent1')
      parent1.nodeid=0;
      childnum1=0;
   end
   
   %found node x1 in tree1, now look for node x2 in tree2:
   if x2<=1 % found node x2 in tree2!
      node1=tree2; % node1 = node to be put in tree1
      
      if ~exist('parent2','var') % more efficient than just if ~exist('parent2')
         parent2.nodeid=0;
         childnum2=0;
      end
      
      % actual swap:
      tree1=node1;
      tree2=node2;
      sizediff=tree1.nodes-tree2.nodes; % difference in size of the 2 trees
      
      % now update node ids in tree1 and tree2:
      % tree1   
      nextid=parent1.nodeid+1;
      for k=1:childnum1-1
         nextid=nextid+parent1.kids{k}.nodes;
      end
      d=nextid-tree1.nodeid; % difference in node ids
      if d~=0
      	tree1=updatenodeids(tree1,d);
     	end
      % tree2
      nextid=parent2.nodeid+1;
      for k=1:childnum2-1
         nextid=nextid+parent2.kids{k}.nodes;
      end
      d=nextid-tree2.nodeid; % difference in node ids
      if d~=0
        tree2=updatenodeids(tree2,d);
      end
      
   else % node x2 still not found...
      x2=x2-1; % (-1 means one less node remaining for searching)
      nkids=size(tree2.kids,2);
      for k=1:nkids
          if x2<=tree2.kids{k}.nodes
              [tree1,tree2.kids{k},sizediff]=swapnodes(tree1,tree2.kids{k},x1,x2,parent1,childnum1,tree2,k);
              % now update tree2.nodes + maxid and nodeids + maxids of siblings following k:
              tree2.nodes=tree2.nodes-sizediff;
              tree2.maxid=tree2.maxid-sizediff;
              if sizediff~=0
                  for k=k+1:nkids
                      tree2.kids{k}=updatenodeids(tree2.kids{k},-sizediff);
                  end
              end
              break
          else
              x2=x2-tree2.kids{k}.nodes; % (less nodes to search)
          end
      end % for k=1:nkids
   end % else node x2 still not found
   
else % node x1 still not found...
   x1=x1-1; % (-1 means one less node remaining for searching)
   nkids=size(tree1.kids,2);
   for k=1:nkids
      if x1<=tree1.kids{k}.nodes
         [tree1.kids{k},tree2,sizediff]=swapnodes(tree1.kids{k},tree2,x1,x2,tree1,k);
         % now update tree1.nodes + maxid and nodeids + maxids of siblings following k:
         tree1.nodes=tree1.nodes+sizediff;
         tree1.maxid=tree1.maxid+sizediff;
      	 if sizediff~=0
            for k=k+1:nkids
               tree1.kids{k}=updatenodeids(tree1.kids{k},+sizediff);
            end
         end
         break
      else
         x1=x1-tree1.kids{k}.nodes; % (less nodes to search)
      end
   end % for k=1:nkids
   
end % else node x1 still not found
