function initialprobs=setinitialprobs(params,state,data)
%SETINITIALPROBS    Sets the initial operator probabilities for the GPLAB algorithm.
%   SETINITIALPROBS(PARAMS,STATE,DATA) returns the initial operator
%   probabilities calculated using the procedure described in David 89.
%
%   Input arguments:
%      PARAMS - the running parameters of the algorithm (struct)
%      STATE - the current state of the algorithm (struct)
%      DATA - the current dataset for the algorithm to run (struct)
%   Output arguments:
%      INITIALPROBS - the obtained initial operator probabilities (1xN matrix)
%
%   References:
%      Davis, L. Adapting operator probabilities in genetic algorithms.
%      Third International Con-ference on Genetic Algorithms (1989).
%
%   See also AUTOMATICOPERATORPROBS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

outputtype=params.output;
params.output='silent';
params.calccomplexity=0;
% auxiliary variable:
tmpstate=state;
% how many operators do we have:
numoperators=length(params.operatornames);

% step 1 - atribute initial probabilities all equal for all operators,
% or other values, if known to be better:
if ~strcmp(outputtype,'silent')
	fprintf('\n   (initial operator probabilities: %s)\n',mat2str(tmpstate.operatorprobs,4));
end
%opprobs=tmpstate.operatorprobs; % store them
% (tmpstate already has the initial operator probs that were in params, normalized)  

% repeated steps 2-6 (handbook of genetic algorithms says 2-5, but...)
dontstop=1;
while dontstop
   
	% step 2 - initialize the population:
   [initialpop,tmpstate]=genpop(params,tmpstate,data,tmpstate.popsize,params.inicmaxlevel);

	% repeated steps 3 and 4: (handbook of genetic algorithms, page 96)
	for i=1:2
   
   	% step 3 - run the algorithm on the initial population to create x new individuals,
      % where x is the interval between operator adaptations:
      [newpop,newstate]=generation(initialpop,params,tmpstate,data,params.adaptinterval);   

   	% step 4 - adapt operator probabilities and store them:
      % (the adaptation was already done in generation, just store them)
      %opprobs(i+1,:)=newstate.operatorprobs;
      opprobs(i,:)=newstate.operatorprobs;
      
	end

	% step 5 - repeat 3 and 4 -> done

	% step 6 - average all sets of operator probs and save them:
   % (also measure the difference between new and old and see if it's small)
   oldoperatorprobs=tmpstate.operatorprobs;
   newoperatorprobs=mean(opprobs,1); % average value of each column
   newoperatorprobs=normalize(newoperatorprobs,1); % normalize
   if length(find(abs(newoperatorprobs-oldoperatorprobs)>params.smalldifference))==0
      dontstop=0; % we have a small difference in all probabilities!
   else
      % increase small difference so we don't get stuck here forever:
      params.smalldifference=params.smalldifference*1.1; % increase 10%
   end
   %   dont forget to save the new probs and use them for the next cicle:
   tmpstate.operatorprobs=newoperatorprobs;
   %opprobs=tmpstate.operatorprobs;
   if ~strcmp(outputtype,'silent')
		fprintf('\n   (new operator probabilities: %s)\n',mat2str(tmpstate.operatorprobs,4));
	end
   
end % while dontstop
   
% step 7 - using the new operator fitnesses, repeat steps 2-5,
% until the new fitnesses are almost the same as the old -> done


% finally, the only thing we need to output:
initialprobs=tmpstate.operatorprobs;
