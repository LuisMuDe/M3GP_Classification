function [pop,lastid]=initpop(n,varargin)
%INITPOP    Creates a new population for the GPLAB algorithm.
%   INITPOP(POPSIZE) returns a population of POPSIZE new
%   individuals for the GPLAB algorithm, but with no identifier or
%   tree representation, only the structure to be filled later.
%
%   INITPOP(POPSIZE,LASTID,MAXLEVEL,OPERATORS,ARITY,INITTYPE,DEPTHNODES)
%   returns a population of POPSIZE new individuals for the GPLAB
%   algorithm, with unique identifiers beginning on LASTID+1 and
%   randomly created tree representations built with the INITTYPE
%   initialization method and using the available OPERATORS, no
%   deeper than MAXLEVEL. DEPTHNODES='2' means the limit is not
%   on depth, but on number of nodes.
%
%   [POPULATION,LASTID] = INITPOP(POPSIZE,LASTID,MAXLEVEL,
%   OPERATORS,ARITY,INITTYPE,DEPTHNODES) also returns the current last
%   identification used for any individual of the population.
%
%   Input arguments:
%      POPSIZE - the number of individuals to create (integer)
%      LASTID - the last identifier used for an individual (integer)
%      MAXLEVEL - the maximum depth of the new individuals (integer)
%      OPERATORS - the available operators and their arity (cell array)
%      ARITY - the arity of the operators, in numeric format (array)
%      INITTYPE - the method of tree initialization to use (string)
%      DEPTHNODES - '1' (limit depth) or '2' (limit nodes) (char)
%   Output arguments:
%      POPULATION - the population of new individuals (array)
%      LASTID - the last identifier used, now updated (integer)
%
%   See also GROWINIT, FULLINIT, RAMPEDINIT, NEWIND
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

switch nargin
case 1
   % we want an empty population, no ids and no trees
   pop(1:n)=newind;
case 8
   % we want a normal random population
   % argument 2: last id used for any individual
   % argument 3: maxlevel of individuals
   % argument 4: operators available
   % argument 5: arity of the operators
   % argument 6: method for initializing the population
   lastid=varargin{1};
   maxlevel=varargin{2};
   oplist=varargin{3};
   oparity=varargin{4};
   inittype=varargin{5};
   depthnodes=varargin{6};
   dimension = varargin{7};
   % call the appropriate initialization method:
   [pop,lastid]=feval(inittype,n,lastid,maxlevel,oplist,oparity,depthnodes,dimension);
otherwise
   error('INITPOP: Wrong number of input arguments!')
end
