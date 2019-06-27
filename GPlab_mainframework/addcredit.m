function state=addcredit(params,state,listtocredit,bestfit,worstfit)
%ADDCREDIT    Attributes credit to GPLAB individuals in credit list. 
%   ADDCREDIT(PARAMS,STATE,TOCREDIT,BESTFIT,WORSTFIT) returns the updated
%   state of the algorithm after adding credit to the individuals
%   in the TOCREDIT list, and eventually their ancestors too,
%   according to Davis 89. The amount of credit is proportional
%   to the difference between the individual's fitness and BESTFIT,
%   the highest fitness in the previous population, and WORSTFIT,
%   the lowest fitness in the previous population.
%
%   Input arguments:
%      PARAMS - the running parameters of the algorithm (struct)
%      STATE - the current state of the algorithm (struct)
%      TOCREDIT - list of ids of individuals to credit (1xN matrix)
%      BESTFIT - previous best fitness in population (double)
%      WORSTFIT - previous worst fitness in population (double)
%   Output arguments:
%      STATE - the updated state with added credit (struct)
%
%   References:
%      Davis, L. Adapting operator probabilities in genetic algorithms.
%      Third International Con-ference on Genetic Algorithms (1989).
%
%   See also AUTOMATICOPERATORPROBS, UPDATEOPERATORPROBS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% for all the individuals in the new generation that deserve credit:
for i=1:length(listtocredit) 
   
   % lets give positive credit to individuals better than the best, negative otherwise:
   if params.lowerisbetter
      difffitness=bestfit-listtocredit(i).fitness;
   else
      difffitness=listtocredit(i).fitness-bestfit;
   end
   
	for g=1:params.numbackgen % give credit back to numbackgen generations
		% what is the index(es) of the wanted individual(s) in the structure array adaptwindow:
      if g==1 % (this is the individual, not its ancestors - its only one)
         tocredit.ids=listtocredit(i).id;
         tocredit.totals=difffitness; % total credit to receive
         tocredit.shares=1; % the total will be divided by the number of shares to make
      end % (if not g==1, then tocredit was already set in last iteration)
            
      % we need the positions in the history array, not just the ids:
      historypos=tocredit.ids-state.adaptwindow(1).id+1;
      
      % give the amount of credit to all the individuals in historypos:
      for a=1:length(historypos)
         if historypos(a)>0 && historypos(a)<=params.adaptwindowsize
         	state.adaptwindow(historypos(a)).newcredit=tocredit.totals(a)/tocredit.shares(a);
            %(the amount of credit passed is shared between the parents)
            state.adaptwindow(historypos(a)).credit=state.adaptwindow(historypos(a)).credit+state.adaptwindow(historypos(a)).newcredit;
         % else '=== discarding - too old ==='
         end
      end
      
      % who are the next (ancestors) to credit:
      if g~=params.numbackgen
         tocredit.ids=[];
         tocredit.totals=[];
         tocredit.shares=[];
         a=1;
         for c=1:length(historypos)
            if historypos(c)>0 && historypos(c)<=params.adaptwindowsize
               parents=state.adaptwindow(historypos(c)).parents;
            	numparents=length(parents);
            	b=a+numparents-1;
            	tocredit.ids(a:b)=parents;
            	for n=a:b
               	tocredit.totals(n)=state.adaptwindow(historypos(c)).newcredit * params.percentback;
            	end
            	tocredit.shares(a:b)=numparents;
            	a=b+1;
            end
         end % for c=1:length(historypos)

      end
   end % for g=1:state.numbackgen
   
end
