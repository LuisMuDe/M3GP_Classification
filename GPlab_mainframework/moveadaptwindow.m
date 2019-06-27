function state=moveadaptwindow(pop,params,state,oldsize,newsize)
%MOVEADAPTWINDOW    Shifts the GPLAB automatic operator probabilities adaptation window.
%   MOVEADAPTWINDOW(POP,PARAMS,STATE,OLDSIZE,NEWSIZE) returns the
%   updated state of the algorithm where the adaptation window for
%   the automatic operator probabilities procedure (Davis 89)
%   has been shifted to accomodate the new individuals. There are
%   NEWSIZE - OLDSIZE new individuals in POP to accomodate.
%
%   Input arguments:
%      POP - the new population being created (array)
%      PARAMS - the running parameters of the algorithm (struct)
%      STATE - the current state of the algorithm (struct)
%      OLDSIZE - the previous number of valid individuals in POP (integer)
%      NEWSIZE - the current number of valid individuals in POP (integer)
%   Output arguments:
%      STATE - the updated state with shifted adaptation window (struct)
%
%   References:
%      Davis, L. Adapting operator probabilities in genetic algorithms.
%      Third International Con-ference on Genetic Algorithms (1989).
%
%   See also AUTOMATICOPERATORPROBS, UPDATEOPERATORPROBS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

x=length(state.adaptwindow);

for i=oldsize+1:newsize
   
   % we have to test if this identifier is new:
   if isempty(state.adaptwindow)
      lasthistoryid=0;
   else
      lasthistoryid=state.adaptwindow(x).id;
   end
   
   if pop(i).id>lasthistoryid
      % yes, this is a new individual
      % if the new individual exceeds the array capacity, remove first element:
      if x==state.adaptwindowsize
         state.adaptwindow(1:x-1)=state.adaptwindow(2:x);
      else
         x=x+1;
      end
      state.adaptwindow(x).id=pop(i).id;
      state.adaptwindow(x).op=pop(i).origin;
      state.adaptwindow(x).parents=pop(i).parents;
      state.adaptwindow(x).credit=0;
      state.adaptwindow(x).newcredit=0;
                 
   end % if pop(i).id>state.adaptwindow(x).id
end
