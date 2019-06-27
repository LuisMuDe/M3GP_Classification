function [pop,state]=generation(pop,params,state,data,varargin)
%GENERATION    Creates a new generation for the GPLAB algorithm.
%   GENERATION(POPULATION,PARAMETERS,STATE,DATA) returns a
%   new population of individuals created by applying the
%   genetic operators to the current population.
%
%   GENERATION(POPULATION,PARAMETERS,STATE,DATA,NEWPOPSIZE)
%   creates a new population with NEWPOPSIZE individuals, which
%   can be different from the size of the current population.
%
%   [POPULATION,STATE]=GENERATION(...) also returns the updated
%   state of the algorithm.
%
%   Input arguments:
%      POPULATION - the current population (array)
%      PARAMETERS - the algorithm running parameters (struct)
%      STATE - the algorithm current state (struct)
%      DATA - the dataset on which the algorithm runs (struct)
%      NEWPOPSIZE - the number of individuals to create (integer)
%   Output arguments:
%      POPULATION - the new population (array)
%      STATE - the algorithm current state, now updated (struct)
%
%   See also GENPOP
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

if nargin==5
   newpopsize=varargin{1};
else
   newpopsize=state.popsize;
end

state.generation=state.generation+1;
if ~strcmp(params.output,'silent')
	fprintf('- Creating generation %d -\n',state.generation);
end

% create a new generation:
      
% first set a temporary empty population, with newpopsize individuals...
tmppop=initpop(newpopsize); % tmppop is an empty population
currentsize=0; % number of non empty individuals in tmppop
      
% ...then apply genetic operators to pop and fill tmppop with the new individuals...
% (and eventually calculate stuff for variable operator probabilities)
parentspool=[];
while currentsize<newpopsize
   
   % first choose between reproduction and genetic operator:
   rrate=params.reproduction;
   if (rrate>0 && rand<rrate)
      % reproduction
      opnum=0;
   else
      % genetic operator - if there's only one don't bother to randomize
      if length(params.operatornames)==1
          opnum=1;
      else
          opnum=pickoperator(state); % pickoperator gives the index of the operator chosen
      end
   end
   [tmppop,newsize,parentspool,state]=applyoperator(pop,params,state,data,tmppop,currentsize,opnum,parentspool);
   
   % if operator probabilities are variable, call procedure to adapt them:
   if strcmp(params.operatorprobstype,'variable')
      [state,tmppop]=automaticoperatorprobs(tmppop,pop,params,state,data,currentsize,newsize);
   end
   
   currentsize=newsize;
end

% note that tmppop may have more individuals than needed, because the last operator applied
% may have produced more offspring than needed to fill the population. tmppop will be
% subject to applysurvival, where the worst individuals will be discarded. (even if there is
% no elitism, if tmppop has more individuals than needed, the worst will be discarded.)

% ...measure fitness on the tmppop individuals with empty fitness...
[tmppop,state]=calcpopfitness(tmppop,params,data,state);

% ...and finally apply survival to choose individuals from both pop and tmppop,
% creating a definite new population

[pop,state]=applysurvival(pop,params,state,tmppop);

%LMD the best is the smallest one but with the best fitness

% bestind = pop(1);
% bestNo = 1;
% 
%            for i=2:round (length(pop)/2) 
%                
%                     if (pop(i).fitness > bestind.fitness)
%                         bestind = pop(i);
%                         bestNo = i;
%                     elseif (pop(i).fitness == bestind.fitness)
%                         if (length(pop(i).tree.kids) < length(bestind.tree.kids))
%                             bestind = pop(i);
%                             bestNo = i;
%                         elseif (length(pop(i).tree.kids) == length(bestind.tree.kids))   
%                            if  (pop(i).nodes < bestind.nodes)
%                                 bestind = pop(i);
%                                 bestNo = i;
%                            elseif (pop(i).nodes == bestind.nodes)
%                                if (pop(i).level < bestind.level)
%                                         bestind = pop(i);
%                                         bestNo = i;
%                                end
%                            end
%                         end
%                     end     
%            end
% pop(bestNo) = pop(1);           
% pop(1) = bestind;

% set state measures (fitness, rank, level history):
[state,pop]=updatestate(params,state,data,pop);
