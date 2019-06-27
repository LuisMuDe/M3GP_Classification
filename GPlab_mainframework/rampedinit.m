function [pop,lastid]=rampedinit(n,lastid,maxlevel,oplist,oparity,depthnodes,dimension)
%RAMPEDINIT    Creates a new GPLAB population with ramped half-and-half method.
%   RAMPEDINIT(POPSIZE,LASTID,MAXLEVEL,OPERATORS,ARITY,DEPTHNODES)
%   returns a population of POPSIZE new individuals for the GPLAB
%   algorithm, with unique identifiers beginning on LASTID+1 and
%   randomly created tree representations built with the ramped
%   half-and-half method (Koza 92) for initializing trees, using the
%   available OPERATORS. DEPTHNODES='2' means the limit is not on
%   depth, but on number of nodes, and the procedure is an adaptation.
%
%   [POPULATION,LASTID] = RAMPEDINIT(POPSIZE,LASTID,MAXLEVEL,
%   OPERATORS,ARITY,DEPTHNODES) also returns the current last
%   identification used for any individual of the population.
%
%   Input arguments:
%      POPSIZE - the number of individuals to create (integer)
%      LASTID - the last identifier used for an individual (integer)
%      MAXLEVEL - the maximum depth of the new individuals (integer)
%      OPERATORS - the available operators and their arity (cell array)
%      ARITY - the arity of the operators, in numeric format (array)
%      DEPTHNODES - '1' (limit depth) or '2' (limit nodes) (char)
%   Output arguments:
%      POPULATION - the population of new individuals (array)
%      LASTID - the last identifier used, now updated (integer)
%
%   References:
%      Koza, J.R. Genetic programming - on the programming of computers
%      by means of natural selection. Cambridge, Massachusetts.
%      MIT Press (1992).
%
%   See also FULLINIT, GROWINIT, INITPOP, NEWIND
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

nlevels=maxlevel-1;
levels=2:1:maxlevel; % the lowest levels first

eachlevel=max([1 round(n/nlevels)]);
% each level will have round(n/nlevels) trees, or 1, which one is larger

ncreated=0; % 0 trees created so far
for m=1:nlevels;
   
   thislevel=levels(m);
   
   nfullmethod=round(eachlevel/2); % full method first
   if ncreated<n
      ntocreate=min([n-ncreated nfullmethod]);
      if ntocreate>0
	      [partialpop,lastid]=fullinit(ntocreate,lastid,thislevel,oplist,oparity,depthnodes,dimension);
         pop(ncreated+1:ncreated+ntocreate)=partialpop;
      end
      ncreated=ncreated+ntocreate;
   end
            
   ngrowmethod=eachlevel-nfullmethod;
   if ncreated<n
      ntocreate=min([n-ncreated ngrowmethod]);
      if ntocreate>0
	      [partialpop,lastid]=growinit(ntocreate,lastid,thislevel,oplist,oparity,depthnodes,dimension);
         pop(ncreated+1:ncreated+ntocreate)=partialpop;
      end
      ncreated=ncreated+ntocreate;
   end
      
end % for m=1:nlevels

% if there are not enough individuals (because of roundings) create them as grow in the higher level:
if ncreated<n
   ntocreate=n-ncreated;
   [partialpop,lastid]=growinit(ntocreate,lastid,maxlevel,oplist,oparity,depthnodes,dimension);
   pop(ncreated+1:ncreated+ntocreate)=partialpop;
end


% (I could try to vectorize these procedures but it's so much simpler like this...)

