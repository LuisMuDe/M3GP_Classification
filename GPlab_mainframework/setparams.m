function params=setparams(varargin);
%SETPARAMS    Sets the parameter variables for the GPLAB algorithm.
%   SETPARAMS(PARAMS,SETTINGS) applies the SETTINGS to the parameters
%   stored in PARAMS, and returns the updated set of parameters.
%   All the parameters not included in SETTINGS are left unchanged.
%   If PARAMS=[], all the parameters not included in SETTINGS are
%   set with the default values. If SETTINGS='defaults', all the
%   parameters are set with the default values.
%
%   SETPARAMS(PARAMS,SETTINGS,'state') applies the SETTINGS to the
%   state variables, instead of the parameter variables. This is not
%   advisable for the user to do, as it may put the algorithm into
%   an inconsistent state.
%
%   Input arguments:
%      PARAMS - the set of parameter/state variables (struct)
%      SETTINGS - an expression like 'P1=VALUE1,P2=VALUE2...' (string)
%   Output arguments:
%      PARAMS - the set of updated parameter/state variables (struct)
%
%   See also RESETPARAMS, RESETSTATE
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

switch nargin
case 2
   type='';
case 3
   type=varargin{3};
otherwise
   error('SETPARAMS: Wrong number of input arguments!')
end
params=varargin{1};
paramslist=varargin{2};
   
% what will be recognized or not as parameter/state variables,
% and what will be the defaults values:
if strcmp(type,'state')
   [myparams,defaults]=availablestates;
else
   [myparams,defaults]=availableparams;
end

% if params is empty, load the defaults
% if the defaults were requested, load the defaults
if isempty(params) || strcmp(paramslist,'defaults')
   allfields=fieldnames(myparams);
   for i=1:length(allfields)
   	thisparam=allfields{i};
      value=eval(['defaults.' thisparam]);
      eval(['params.' thisparam '=' value ';']);
   end
end

if ~strcmp(paramslist,'defaults')
   
	% settings separators allowed:
	seplist=',';
	% assignment symbols allowed:
	symblist='=';
      
	[paramsetting,numparams]=explode(paramslist,seplist);
   for i=1:numparams
      [thisparam,numpieces]=explode(paramsetting{i},symblist);
      if numpieces==2
         if isfield(myparams,thisparam{1})
            availablevalues=eval(['myparams.' thisparam{1}]);
            % the sum tests the text parameters in which there is a cell array of valid strings;
            % the "isvalid" function tests the remaining parameters:
            if sum(strcmp(availablevalues,thisparam{2}))>0 || (~iscell(availablevalues) && (isempty(str2num(thisparam{2})) || isvalid(str2num(thisparam{2}),availablevalues)))
            	% this is what happens if everything goes right:
               if ~iscell(availablevalues)
                  eval(['params.' thisparam{1} '=' thisparam{2} ';']);
               else
                  eval(['params.' thisparam{1} '=''' thisparam{2} ''';']);
               end
         	else
            	warning(['SETPARAMS: invalid parameter value: ' thisparam{2}])
            end
      	else % if isfield(myparams,thisparam{1})
         	warning(['SETPARAMS: unknown parameter: ' thisparam{1}])
         end % if isfield(myparams,thisparam{1})
   	else % if numpieces==2
      	warning(['SETPARAMS: invalid parameter setting: ' paramsetting{i}])
      end % if numpieces==2
   end % for i=1:numparams
   
end % if ~strcmp(paramslist,'defaults')
