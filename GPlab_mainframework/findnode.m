function node=findnode(tree,x)
%FINDNODE    Finds a node in a GPLAB algorithm tree.
%   FINDNODE(TREE,X) returns the subtree of TREE with node
%   number X as root. The nodes are numbered depth-first.
%
%   Input arguments:
%      TREE - the tree where to search the node (struct)
%      X - the number of the node to search (integer)
%   Output arguments:
%      NODE - the subtree with node number X as root (struct)
%
%   Notes:
%      FINDNODE is a recursive function:
%      if x==1 then node=tree else findnode(subtree,x-something)
%
%      FINDNODE fails if a node has more than 3 branches.
%
%   See also SWAPNODE, MAKETREE
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

if x<1
   error('FINDNODE: cannot find node lower than 1!')
elseif x==1
   node=tree;
else
   nkids=size(tree.kids,2);
   if nkids<0
      error('FINDNODE: number of children lower than 0!');
   elseif nkids==0
      error('FINDNODE: cannot find node in empty tree!')
   elseif nkids==1
      node=findnode(tree.kids{1},x-1);
   elseif nkids>3
      error('FINDNODE: tree with more than 3 children!')
   elseif nkids==2
      nnodes=nodes(tree.kids{1})+1;
      if x<=nnodes
         node=findnode(tree.kids{1},x-1);
      else
         node=findnode(tree.kids{2},x-nnodes);
      end
   elseif nkids==3
      nnodes1=nodes(tree.kids{1})+1; %nodes on left subtree (plus actual node)
      nnodes2=nodes(tree.kids{1})+nodes(tree.kids{2})+1; %nodes on left+central subtrees (plus actual node)
      if x<=nnodes1 % node is in left subtree
         node=findnode(tree.kids{1},x-1); % skip actual node
      elseif x>nnodes1 && x<=nnodes2 % node is in central subtree
         node=findnode(tree.kids{2},x-nnodes1); % skip actual node and left subtree
      else % node is in right subtree
         node=findnode(tree.kids{3},x-nnodes2); % skip actual node and left+central subtrees
		end
   end   
end      