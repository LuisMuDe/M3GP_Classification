function [ind,lastid]=newind(varargin)
%NEWIND    Creates a new individual for the GPLAB algorithm.
%   NEWIND(LASTID,MAXLEVEL,OPERATORS,ARITY,EXACTLEVEL,DEPTHNODES)
%   returns a new individual for the GPLAB algorithm, with the
%   unique identification LASTID+1 and a randomly created tree
%   representation no deeper than MAXLEVEL and using the available
%   OPERATORS with arity ARITY. If EXACTLEVEL is true, the new
%   tree depth/size will be exactly/close to MAXLEVEL.
%
%   NEWIND returns a new individual, but completely void of
%   information - empty tree - where only its structure remains.
%
%   [INDIVIDUAL,LASTID] = NEWIND(LASTID,MAXLEVEL,OPERATORS,ARITY,
%   EXACTLEVEL,DEPTHNODES) also returns the current last
%   identification used for any individual of the population.
%
%   Input arguments:
%      LASTID - the last identifier used for an individual (integer)
%      MAXLEVEL - the maximum depth/size of the new individual (integer)
%      OPERATORS - the available operators and their arity (cell array)
%      ARITY - the arity of the operators, in numeric format (array)
%      EXACTLEVEL - whether the new tree level is exactly MAXLEVEL (boolean)
%      DEPTHNODES - whether the limit is on depth or number of nodes (char)
%   Output arguments:
%      INDIVIDUAL - the new individual (struct)
%      LASTID - the last identifier used, now updated (integer)
%
%   See also MAKETREE, INITPOP
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   Acknowledgements: SINTEF (hso@sintef.no,jtt@sintef.no,okl@sintef.no)
%   This file is part of the GPLAB Toolbox

switch nargin
case 0
   ind.id=[];
   ind.origin='';
   ind.tree=[];
   ind.str='';   
case 7
   lastid=varargin{1}+1;
   level=varargin{2};
   oplist=varargin{3};
   oparity=varargin{4};
   exactlevel=varargin{5};
   depthnodes=varargin{6};
   dimension = varargin{7};
   ind.id=lastid;
   ind.origin='random';
	ind.tree=maketreeRoot(level,oplist,oparity,exactlevel,depthnodes,0,1,dimension);
   ind.str=tree2str(ind.tree);
   
   %drawtree(ind.tree);
otherwise
   error('NEWIND: wrong number of input arguments!')
end

ind.parents=[];
ind.xsites=[];
ind.nodes=[];
ind.introns=[];
ind.level=[];

ind.fitness=[];
ind.adjustedfitness=[];
ind.result=[];
ind.testfitness=[];
ind.testadjustedfitness=[];
ind.Z= [];
ind.covM = [];
ind.meanOfClassCluster = [];
ind.FE = [];
ind.NFE = [];
ind.Matrix_FE = [];
ind.Matrix_NFE = [];
ind.Pruned = [];


