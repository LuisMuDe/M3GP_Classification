function [pop,lastid]=fullinit(n,lastid,maxlevel,oplist,oparity,depthnodes);
%FULLINIT    Creates a new GPLAB population with the full method.
%   FULLINIT(POPSIZE,LASTID,MAXLEVEL,OPERATORS,ARITY,DEPTHNODES)
%   returns a population of POPSIZE new individuals for the GPLAB
%   algorithm, with unique identifiers beginning on LASTID+1 and
%   randomly created tree representations built with the full
%   method (Koza 92) for initializing trees (depth = MAXLEVEL),
%   using the available OPERATORS. DEPTHNODES='2' means the limit
%   is not on depth, but on number of nodes.
%
%   [POPULATION,LASTID] = FULLINIT(POPSIZE,LASTID,MAXLEVEL,
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
%   See also GROWINIT, RAMPEDINIT, INITPOP, NEWIND
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

uniquestrs={};

for i=1:n
   ntry=1;
   while ntry<=20
   	[pop(i),tmplastid]=newind(lastid,maxlevel,oplist,oparity,1,depthnodes);
   % (1 = full method - the new tree level has to be exactly maxlevel)
      if isempty(find(strcmp(uniquestrs,pop(i).str)))
         uniquestrs{end+1}=pop(i).str;
         break
      end
      ntry=ntry+1;
   end
   lastid=tmplastid;
end

% (cannot vectorize or it will generate n identical twins!)

