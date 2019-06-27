function [tree,lastnode]=maketreeRoot(level,oplist,oparity,exactlevel,depthnodes,lastnode,root,dimensions)
%MAKETREE    Creates representation tree for the GPLAB algorithm.
%   MAKETREE(MAXLEVEL,OPERATORS,ARITY,EXACTLEVEL,DEPTHNODES,LASTNODE)
%   creates a random tree no deeper than MAXLEVEL (or with no
%   more nodes than MAXLEVEL, depending on parameter DEPTHNODES)
%   using the available OPERATORS with arity ARITY. If EXACTLEVEL
%   is true, the tree level will be exactly MAXLEVEL in depth
%   (or close to it in number of nodes).
%
%   Additional input parameter (not set in the first call)
%   is LASTNODE, the id of the last node created in the tree.
%
%   Additional output argument (essential in recursiveness)
%   is LASTNODE, the id of the last node created in the tree.
%
%   Input arguments:
%      MAXLEVEL - the maximum depth or size of the new tree (integer)
%      OPERATORS - the available functions and terminals (cell array)
%      ARITY - the arity of the operators, in numeric format (array)
%      EXACTLEVEL - whether the new tree is exactly MAXLEVEL (boolean)
%      DEPTHNODES - '1' (limit depth) or '2' (limit nodes) (char)
%      LASTNODE - the id of the last node created in the tree (integer)
%   Output arguments:
%      TREE - the new random tree (struct)
%      LASTNODE - the id of the last node created in the tree (integer)
%
%   Notes:
%      MAKETREE is a recursive function.
%
%   See also NEWIND, TREELEVEL, NODES
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

if ~strcmp(depthnodes,'1') && ~strcmp(depthnodes,'2')
   error('MAKETREE: must specify limit on depth or nodes.')
end

if ~exist('lastnode')
   lastnode=0; 
end
thisnode=lastnode+1;


if level==1
   % we must choose a terminal because of the level limitation
   % (whether it's depth or number of nodes)
   f=find(oparity==0); % f gives all indices of terminals
   if isempty(f)
      error('RAND generated 0.0000! Possible cause: no terminals (including variables) available.')
   end
   ind=intrand(1,size(f,2)); % choose one at random
   op=f(ind);
   
elseif exactlevel
   % we must choose a non terminal because the level must be exactly the indicated.
   % if we are limiting nodes, choose a non terminal with arity that obeys limit
   % (and if that's not possible, choose a terminal)
   if strcmp(depthnodes,'2')
      f=find(oparity~=0 & oparity<=level-1); % f gives all indices of non terminals
      if isempty(f)
         f=find(oparity==0); % f gives all indices of terminals
      end
      ind=intrand(1,size(f,2)); % choose one at random
   else % depthnodes=='1'
      f=find(oparity~=0); % f gives all indices of non terminals
      ind=intrand(1,size(f,2)); % choose one at random
   end   
   if isempty(f)
      error('RAND generated 0.0000! Possible cause: no functions or no terminals (including variables) available.')
   end
   op=f(ind);
   
else
   if strcmp(depthnodes,'2') % check size limitations
      % choose an operator for which the arity obeys the size limitation
      f=find(oparity<=level-1); % f gives all indices of obeying operators
      if isempty(f)
      	error('RAND generated 0.0000! Possible cause: no terminals or functions available, or incompatibility between size and depth.')
      end
      ind=intrand(1,size(f,2)); % choose one at random
   	  op=f(ind);
   else % depthnodes=='1'
      % no size limitations to check, choose random operator:
      f=1:size(oparity,2);
      ind=intrand(1,size(f,2));
      op=f(ind);
   	if op==0
      	error('RAND generated 0.0000! Possible cause: no terminals or functions available.')
   	end   
   end
      
end


% check for terminals to evaluate now - only example right now is 'rand':

%if (oplist{op,2}==0) & (~strncmp(oplist{op,1},'X',1))
%   % IF YOU CHANGE 'X', ALSO CHANGE IN CHECKVARSSTATE
%   % if it's a terminal (but not a variable), evaluate it now
%   t=eval(oplist{op,1});
%   if isstr(t)
%      tree.op=t;
%   else
%      tree.op=num2str(t);
%   end
%else
%   tree.op=oplist{op,1};
%end

% old version: when there was only "rand"
% going back to the old version...
if strcmp(oplist{op,1},'rand')
   r=rand;
   tree.op=num2str(r);
else
   tree.op=oplist{op,1};
end


% generate branches:

tree.kids=[];
tree.nodeid=thisnode;

% if there is a next branch, define level limitation for it:
a=oplist{op,2}; % a = arity of the chosen op

%% LMD To setup the root node for multi-dimensional GP
if root == 1
  root = 0; %To make the first node of the tree a root node o "a" leafs
  tree.op='root'; %root node operator     
% a=intrand(1,params.max_initial_dimensions); %root node arity , this must change base on search requirements 
  a=intrand(1,dimensions); %Randomly generating different tree root size
end
%%


if a~=0
   level=level-1; % discount the node (or depth level) just used
   if strcmp(depthnodes,'2') % if limiting nodes, try to balance the tree
      splitnodes=round(level/a); % distribute remaining places between kids
   end
end

% now generate branches (if a>0, ie, non terminal) with new level limitation:
for i=1:a
   if strcmp(depthnodes,'2')
      % make sure to use all places (because of round, last branch uses the rest)
   	if i==a
      	newlevel=level-(splitnodes*(a-1)); % remaining places
   	else
      	newlevel=splitnodes;
      end
   else
      newlevel=level;
   end
   [t,lastnode]=maketree(newlevel,oplist,oparity,exactlevel,depthnodes,thisnode);
   tree.kids{i}=t;
   thisnode=lastnode+1;
end

tree.nodes=thisnode-tree.nodeid+1;
tree.maxid=lastnode+1;
