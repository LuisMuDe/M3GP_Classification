function [state,pop]=automaticoperatorprobs(pop,oldpop,params,state,data,currentsize,newsize);
%AUTOMATICOPERATORPROBS    Automatic operator probabilities procedure for GPLAB.
%   AUTOMATICOPERATORPROBS(POP,OLDPOP,PARAMS,STATE,DATA,OLDSIZE,NEWSIZE)
%   returns the updated state with new values for the operator
%   probabilities related variables, obtained by using the procedure
%   by Davis 89.
%
%   [STATE,POP]=AUTOMATICOPERATORPROBS(...) also returns the population
%   being created where some needed fitness measures have been added.
%
%   Input arguments:
%      POP - the new population being created (array)
%      OLDPOP - the population in the previous generation (array)
%      PARAMS - the running parameters of the algorithm (struct)
%      STATE - the current state of the algorithm (struct)
%      DATA - the current dataset for the algorithm to run (struct)
%      OLDSIZE - the previous number of valid individuals in POP (integer)
%      NEWSIZE - the current number of valid individuals in POP (integer)
%   Output arguments:
%      STATE - the updated state with new operator related variables (struct)
%      POP - the population updated with some fitness measures (array)
%
%   References:
%      Davis, L. Adapting operator probabilities in genetic algorithms.
%      Third International Con-ference on Genetic Algorithms (1989).
%
%   See also SETINITIALPROBS 
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% move adapt window to accomodate the new individuals:
state=moveadaptwindow(pop,params,state,currentsize,newsize);

if state.generation>0
    
   % build list with ids of individuals to credit:
   c=1;
   listtocredit=[];
   for i=currentsize+1:newsize
      
      % first we need the individuals fitness values:
      if isempty(pop(i).fitness)
   	  [pop(i),state]=calcfitness(pop(i),params,data,state,0);
      end
         
      % the credit is calculated in terms of the difference to the best and worst
      % individual in current pop. all individuals get credit, some more, some less:
      listtocredit(c).id=pop(i).id;
      listtocredit(c).fitness=pop(i).fitness;
      c=c+1;
      
   end

   if ~isempty(listtocredit)
      bestindex=find(state.popranking==1);
      bestindex=bestindex(1); % in case there is more than one in first place
      bestfit=oldpop(bestindex).fitness;
      % bestfit = the best fitness found in the previous population
      worstindex=find(state.popranking==max(state.popranking));
      worstindex=worstindex(1); % the same reason
      worstfit=oldpop(worstindex).fitness;
      % worstfit = the worst fitness found in the previous population
      state=addcredit(params,state,listtocredit,bestfit,worstfit);
   end
            
   % update operator probabilities:
   if state.lastid>=state.lastadaptation + params.adaptinterval*state.gengap
       state=updateoperatorprobs(params,state);
       state.lastadaptation=state.lastid;
   end
   
end
