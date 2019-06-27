function [indfit,indres]=testind(individual,params);
%TESTIND    Evaluates a GPLAB individual on a different data set.
%   [FITNESS,RESULT]=TESTIND(INDIVIDUAL,PARAMS) requests the names
%   of the test data files (input and desired output, or just input
%   for predictions), evaluates an individual on this new data
%   set, and returns both the FITNESS of the individual and the
%   RESULT obtained. The fitness may not be returned, in case we
%   are doing only predictions (no desired output file provided).
%
%   Input arguments:
%      INDIVIDUAL - the individual to evaluate on the new data set (struct)
%      PARAMS - the algorithm running parameters (struct)
%   Output arguments:
%      FITNESS - the fitness of INDIVIDUAL on the new dataset (double, or string)
%      RESULT - the results obtained by INDIVIDUAL on the new dataset (array)
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox


% this is made with pieces of other functions:


% TAKEN FROM (adapted) checkvarsdata ----------------------------------
% get file names:

parentdir=strrep(which(mfilename),strcat(mfilename,'.m'),'');

filenamex=input('Please name the file (with extension) containing the input data: ','s');
if isempty(findstr(filenamex,filesep))
	% if file was not given with path, use parentdir (where this file is):
   filenamex=strcat(parentdir,filenamex);
end
params.datafilex=filenamex;
x=load(params.datafilex); % load the file

filenamey=input('Please name the file (with extension) containing the desired output: ','s');
if ~isempty(filenamey)
	if isempty(findstr(filenamey,filesep))
		% if file was not given with path, use parentdir (where this file is):
   	filenamey=strcat(parentdir,filenamey);
	end
   params.datafiley=filenamey;
   y=load(params.datafiley); % load the file
else
   params.datafiley=[];
end

% convert files to GPLAB data format:
if ~isempty(params.datafiley)
   data=feval(params.files2data,x,y);
else
   data=feval(params.files2data,x,zeros(length(x),1)); % we don't have y, so use null vector
end


% TAKEN FROM checkvarsstate ------------------------------
% generate variables as needed, so we don't have to use state as an argument:
if (~isempty(params.numvars)) || (params.autovars)
	% create variables automatically:
   if isempty(params.numvars)
      % how many
      s=size(data.example,2);
   else
      s=min([size(data.example,2) params.numvars]);
      % (do not create more than the columns of data.example)
   end
   params.numvars=s; % (fill params.numvars with correct number)
   for v=1:s
      % create variable terminals:
      varterminals{v,1}=strcat('X',num2str(v)); % X1, X2, ...
      % IF YOU CHANGE 'X', ALSO CHANGE IN MAKETREE
      varterminals{v,2}=0; % null arity
   end
   state.terminals=[varterminals; params.terminals]; % variables MUST come first!
else
   % do not create variables
   state.terminals=params.terminals;
   params.numvars=0; % (fill params.numvars with null value)
end


% TAKEN FROM genpop ------------------------------------
% before measuring fitness, prepare the evaluation to be assigned to the variables:
% (if the evaluation set is not constant, this should be done every generation)
% (now I assume it's constant, so this is done only once)
for t=1:params.numvars
	% for all variables (which are first in list of inputs), ie, X1,X2,X3,...
   state.varsvals{t}=mat2str(data.example(:,t));
end


% TAKEN FROM (adapted) calcfitness --------------------
% now calc fitness:
state.keepevals=[];
if ~isempty(params.datafiley)
   individual=calcfitness(individual,params,data,state,0); % (0 = learning data, not testing)
   indfit=individual.fitness;
   indres=individual.result;
else
   individual=calcfitness(individual,params,data,state,0);
   indfit='prediction only - see second output argument';
   indres=individual.result;
end
