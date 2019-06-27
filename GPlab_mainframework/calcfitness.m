function [individual,state]=calcfitness(individual,params,data,state,testdata)
%CALCFITNESS    Measures the fitness of a GPLAB individual.
%   CALCFITNESS(INDIVIDUAL,PARAMS,DATA,STATE,TESTDATA) returns
%   the fitness of INDIVIDUAL, measured in DATA with the
%   procedure indicated in PARAMS, considering the current
%   STATE. TESTDATA indicates whether test data should be used,
%   or just regular learning data.
%
%   [INDIVIDUAL,STATE]=CALCFITNESS(...) also returns the
%   updated state.
%
%   Input arguments:
%      INDIVIDUAL - the individual whose fitness is to measure (struct)
%      PARAMS - the algorithm running parameters (struct)
%      DATA - the dataset on which to measure the fitness (struct)
%      STATE - current state of the algorithm (struct)
%      TESTDATA - whether the test data should be used (boolean)
%   Output arguments:
%      INDIVIDUAL - the updated individual (struct)
%      STATE - the updated state of the algorithm (struct)
%
%   See also REGFITNESS, ANTFITNESS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% learning or testing?
% Add the data ban 1 or 0, so the fitness function knows to evaluate
% training or testing 
if testdata
    v=state.testvarsvals;
    ban=1;
else
    v=state.varsvals;
    ban=0;
end

if isempty(state.keepevals) % this means keepevals has not be initialized (on purpose)
    
   %% LMD mod to update state when fitness funtion is call  
   [individual, state]=feval(params.calcfitness,individual,params,data,state,v,ban);
   % select fitness adjustment function (set adjusted fitness beforehand):
   individual.adjustedfitness=individual.fitness;
   if ~isempty(params.adjustfitness)
      individual=feval(params.adjustfitness,individual,params);
   end
   return;
end
% (this can be accessed by historical graphical output functions,
%  with no state or keepevals initialization)


% first check if this same string has already been evaluated:
f=find(strcmp(state.keepevals.inds,individual.str));

if isempty(f) % this string not in keepevals yet
   % select appropriate fitness measurement function:
    %% LMD mod to update state when fitness funtion is call 
   [individual, state]=feval(params.calcfitness,individual,params,data,state,v,ban);
   % select fitness adjustment function (set adjusted fitness beforehand):
   individual.adjustedfitness=individual.fitness;
   if ~isempty(params.adjustfitness)
      individual=feval(params.adjustfitness,individual,params);
   end
   % save evaluation in keepevals:
   % (do not exceed keepevalssize individuals, remove less used individuals)
   nevals=length(state.keepevals.inds);
   if nevals<params.keepevalssize
      i=nevals+1;
   else
      i=find(state.keepevals.used==min(state.keepevals.used));
      i=i(1);
   end
   state.keepevals.used(i)=1;
   state.keepevals.inds{i}=individual.str;
   state.keepevals.fits(i)=individual.fitness;
   state.keepevals.adjustedfits(i)=individual.adjustedfitness;
   state.keepevals.ress{i}=individual.result;
   if isfield(individual,'introns')
      state.keepevals.introns{i}=individual.introns;
   else
      state.keepevals.introns{i}=[];
   end
else % it is in keepevals - use the information stored and increase usage number
   individual.fitness=state.keepevals.fits(f);
   individual.adjustedfitness=state.keepevals.adjustedfits(f);
   individual.result=state.keepevals.ress{f};
   individual.introns=state.keepevals.introns{f};
   state.keepevals.used(f)=state.keepevals.used(f)+1;
end

