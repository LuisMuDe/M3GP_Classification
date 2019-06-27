function dostop=stopcondition(params,state,data)
%STOPCONDITION    Checks which stop condition the GPLAB algorithm verifies.
%   STOPCONDITION(PARAMS,STATE,DATA) returns the number of
%   the first stop condition that is verified, or zero.
%
%   Input arguments:
%      PARAMS - the algorithm running parameters (struct)
%      STATE - the current state of the algorithm (struct)
%      DATA - the dataset on which to measure the fitness (struct)
%   Output arguments:
%      STOPCOND - the number of a stop condition, or zero (integer)
%
%   Copyright (C) 2003-2007 Sara Silva (sara@itqb.unl.pt)
%   This file is part of the GPLAB toolbox

dostop=0; % dostop is 0 or the number of the first stop condition fulfilled

if isempty(params.hits)
   return
end

% get results from best individual:
state.bestsofar=calcfitness(state.bestsofar,params,data,state,0);
% (do not update state.keepevals - this individual is certainly there already)

% get tolerant desired results (minus or plus x%)...
dataresult=data.result;

%%LMD Generates some error trying to run the M2GP  
% ...for each hit (a hit is a tuple [%fitness cases, %tolerance])
% for i=1:size(params.hits,1)
%    dataresultpercent=(params.hits(i,2)/100)*dataresult;
%    dataresultminus=dataresult-dataresultpercent;
%    dataresultplus=dataresult+dataresultpercent;
%       
%    % now find if we have enough fitness cases within tolerant values:
%    f=(state.bestsofar.result>=dataresultminus & state.bestsofar.result<=dataresultplus);
%    if ((sum(f)/size(f,1))>=(params.hits(i,1)/100))
%       dostop=i;
%       break
%    end
% end
      