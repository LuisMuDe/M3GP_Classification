function params=checkvarsparams(start,continuing,params,n);
%CHECKVARSPARAMS    Initializes GPLAB algorithm parameter variables.
%   CHECKVARSPARAMS(START,CONTINUE,PARAMS,POPSIZE) returns a complete
%   set of valid parameter variables for the GPLAB algorithm, after
%   checking for necessary initializations and eventually request
%   some input from the user.
%
%   Input arguments:
%      START - true if no generations have been run yet (boolean)
%      CONTINUE - true if some generations have been run (boolean)
%      PARAMS - the algorithm running parameters (struct)
%      POPSIZE - the number of individuals in the population (integer)
%   Output arguments:
%      PARAMS - the complete running parameter variables (struct)
%
%   See also CHECKVARSSTATE, CHECKVARSDATA, GPLAB
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% check parameter variables:

if start 
   if isempty(params)
      params=setparams([],'defaults','params');
      if ~strcmp(params.output,'silent')
   	fprintf('\n- Setting algorithm parameters with default initial values.\n');
      end   	
   else
      if ~strcmp(params.output,'silent')
         fprintf('\n- Using algorithm parameters with previously set values.\n');
      end
   end
   
   % how many individuals to draw per spin:
   % if empty, set it to maximum value, otherwise make sure we have an integer.
   % (if out of memory, set a lower value in availableparams.m)
   if isempty(params.drawperspin)
       params.drawperspin=intmax;
   else
       params.drawperspin=round(params.drawperspin);
   end
   
   % manage initial operator probabilities:
   if isempty(params.initialvarprobs)
      params.initialvarprobs=normalize(ones(1,length(params.operatornames)),1);
   end
   if isempty(params.initialfixedprobs)
      params.initialfixedprobs=normalize(ones(1,length(params.operatornames)),1);
   end
   
   % manage min probability of any operator, so that the user doesn't set it too low:
   realminprob=0.01/length(params.operatornames);
   if params.minprob<realminprob
      params.minprob=realminprob;
      if ~strcmp(params.output,'silent')
         fprintf('\n   (increasing parameter ''minprob'' to %f)\n',params.minprob);
      end
   end
   
   % manage what is considered a small difference in operator probabilities,
   % considering the percentage changed in each adaptation:
   if isempty(params.smalldifference)
      % the maximum change of the operator with minimum probability:
      maxchangeofminimum=params.percentchange*params.minprob/length(params.operatornames);
      % lets adopt it:
      params.smalldifference=maxchangeofminimum;
   end
   
   % manage filters for strict/dynamic depth/size:
   f1={};
   f2={};
   if strcmp(params.depthnodes,'1') % depth
      if params.fixedlevel
         f1={'strictdepth'};
      end
      if strcmp(params.dynamiclevel,'1')
         f2={'dyndepth'};
      elseif strcmp(params.dynamiclevel,'2')
         f2={'heavydyndepth'};
      end
   else % nodes
      if params.fixedlevel
         f1={'strictnodes'};
      end
      if strcmp(params.dynamiclevel,'1')
         f2={'dynnodes'};
      elseif strcmp(params.dynamiclevel,'2')
         f2={'heavydynnodes'};
      end
   end
   params.filters={f1{:},f2{:}};
   
   % set depth/size parameters that are still empty:
   if isempty(params.inicmaxlevel)
      if strcmp(params.depthnodes,'1') %depth
         params.inicmaxlevel=6;
      else %nodes
         params.inicmaxlevel=28;
         % for symbolic regression of the quartic polynomial and parity 3 problems,
         % this is the number of nodes that gives an initial distribution of sizes
         % more alike the distribution obtained with depth 6. 28 is where the difference
         % between both problems, in the 't' value of the Kolmogorov-Smirnov, is minimal.
      end
      if ~strcmp(params.output,'silent')
         fprintf('\n   (setting parameter ''inicmaxlevel'' automatically...)\n');
      end
   end
   if ~strcmp(params.dynamiclevel,'0') && isempty(params.inicdynlevel)
      if strcmp(params.depthnodes,'1') %depth
         params.inicdynlevel=6;
      else %nodes
         params.inicdynlevel=28;
      end
      if ~strcmp(params.output,'silent')
         fprintf('\n   (setting parameter ''inicdynlevel'' automatically...)\n');
      end
   end
   if ~params.fixedlevel && isempty(params.realmaxlevel)
      if strcmp(params.depthnodes,'1') %depth
         params.realmaxlevel=17;
      else %nodes
         params.realmaxlevel=512;
         % this does not need to be higher for simple problems like symbolic regression
         % of the quartic polinimial and parity 3. some numbers were retrieved from the
         % runs with depth, like the average nodes, tree fill rate, and absolute maximum
         % number of nodes, for each depth, in both problems. 512 nodes is more than
         % ever needed on a tree with depth 17, because tree fill rate is very low.
      end
      if ~strcmp(params.output,'silent')
         fprintf('\n   (setting parameter ''realmaxlevel'' automatically...)\n');
      end
   end
   
   % make sure inicdynlevel is correct:
   if params.inicdynlevel<1
      % correct possible error:
      params.inicdynlevel=1;
      if ~strcmp(params.output,'silent')
         fprintf('\n   (increasing parameter ''inicdynlevel'' to %d)\n',params.inicdynlevel);
      end
   end
      
   % make sure realmaxlevel is at least as high as inicdynlevel:
   if params.inicdynlevel>params.realmaxlevel
      params.realmaxlevel=params.inicdynlevel;
      if ~strcmp(params.output,'silent')
         fprintf('\n   (increasing parameter ''realmaxlevel'' to %d)\n',params.realmaxlevel);
      end
   end
      
   % make sure inicmaxlevel is at least as low as inicdynlevel:
   if params.inicdynlevel<params.inicmaxlevel
      params.inicmaxlevel=params.inicdynlevel;
      if ~strcmp(params.output,'silent')
         fprintf('\n   (decreasing parameter ''inicmaxlevel'' to %d)\n',params.inicmaxlevel);
      end
   end
      
   % make sure inicmaxlevel is correct:
   if params.inicmaxlevel<1
      % correct possible error:
      params.inicmaxlevel=1;
      if ~strcmp(params.output,'silent')
         fprintf('\n   (increasing parameter ''inicmaxlevel'' to %d)\n',params.inicmaxlevel);
      end
   end
      
   % manage generation gap:
   if isempty(params.gengap)
      params.gengap=n;
   else
      if params.gengap<=0 % if gengap is negative
         % correct possible error:
         params.gengap=n;
         if ~strcmp(params.output,'silent')
            fprintf('\n   (increasing parameter ''gengap'' to %d)\n',params.gengap);
         end
      end
      if params.gengap>=1 && mod(params.gengap,1)~=0 % if gengap is >=1 and not integer 
         % correct possible error:
         params.gengap=round(params.gengap);
         if ~strcmp(params.output,'silent')
            fprintf('\n   (rounding parameter ''gengap'' to %d)\n',params.gengap);
         end
      end
   end
   
   % manage automatic probability setting variables (Davis 89)
   if strcmp(params.operatorprobstype,'variable') || strcmp(params.initialprobstype,'variable')
      if isempty(params.adaptinterval)
         params.adaptinterval=1;
         % (by default, adapt operator probabilities every generation)
         if ~strcmp(params.output,'silent')
            fprintf('\n   (setting parameter ''adaptinterval'' automatically...)\n');
         end
      end
      if isempty(params.adaptwindowsize)
         params.adaptwindowsize=max([params.numbackgen*params.gengap params.numbackgen*n]);
	     % (by default, adapt window size includes numbackgen generations of individuals
	     %  or numbackgen times the population size, which one is larger)
	     if ~strcmp(params.output,'silent')
	       fprintf('\n   (setting parameter ''adaptwindowsize'' automatically...)\n');
	     end
      end
   end

   % manage tournament size:
   if (strcmp(params.sampling,'tournament') || strcmp(params.sampling,'lexictour') || strcmp(params.sampling,'doubletour'))
      if isempty(params.tournamentsize)
         params.tournamentsize=0.01;
      	 % (by default, the tournament size is 1% of the population size)
      	 % (if tournamentsize were integer, it would mean absolute numbers)
         if ~strcmp(params.output,'silent')
            fprintf('\n   (setting parameter ''tournamentsize'' automatically...)\n');
         end
      end
      if params.tournamentsize<=0
         % correct possible error:
         params.tournamentsize=0.01;
         if ~strcmp(params.output,'silent')
             fprintf('\n   (increasing parameter ''tournamentsize'' to %d)\n',max([round(params.tournamentsize*n) 2]));
         end
      end
      if params.tournamentsize>n
         % correct possible error, tournament size bigger than popsize:
         params.tournamentsize=n;
         if ~strcmp(params.output,'silent')
             fprintf('\n   (decreasing parameter ''tournamentsize'' to %d)\n',params.tournamentsize);
         end
      end
      % (if tournamentsize==1 the selection for reproduction will be random)
      % (if tournamentsize==popsize only the best individual will produce offspring)
   end

end % if start

if continuing
   if ~strcmp(params.output,'silent')
      fprintf('\n- Using algorithm parameters with previously set values.\n');   
   end
end

% manage directory where to save the algorithm files:
if ~strcmp(params.savetofile,'never')
    
    parentdir=strrep(which(mfilename),strcat(mfilename,'.m'),'');
    
    if isempty(params.savedir)
        % ask user the directory name
        dirname=input('\nPlease name the directory to store the algorithm files: ','s');
    else
        % read directory name from params
        dirname=params.savedir;
    end
       
    % if file was not given with path, use parentdir (where this file is)
    
    % if file was given with path, extract path and directory name:
    % (if the only filesep found is the last character, ignore it, there is no path)
    f=findstr(dirname,filesep);
    if ~isempty(f) && (length(f)~=1 || f(1)~=length(dirname)) 
        % mark the position of the last filesep occuring in dirname
        % (if the directory name ends with filesep, mark the previous one)
        lastfilesep=f(end);
        if lastfilesep==length(dirname)
            lastfilesep=f(end-1);
        end
        parentdir=dirname(1:lastfilesep);
        dirname=dirname(lastfilesep+1:end);
    end
    
    % attempt to create the directory:
    status=mkdir(parentdir,dirname);
    switch status
    case 0
        error('CHECKVARSPARAMS: invalid directory name!');
        %case 2
        %error('CHECKVARSPARAMS: directory already exists!');
    end
    dirname=strcat(parentdir,dirname);
    params.savedir=dirname;
end
% manage "keepevalssize"
if isempty(params.keepevalssize)
   params.keepevalssize=n; % keep only popsize most used individuals
end

% remove 'plotdiversity' from list of plots to draw, in case diversity is not calculated:
if isempty(params.calcdiversity)
   f=find(strcmp(params.graphics,'plotdiversity'));
   if ~isempty(f)
      params.graphics={params.graphics{find(~strcmp(params.graphics,'plotdiversity'))}};
      if ~strcmp(params.output,'silent')
         fprintf('\n   Diversity parameter off: diversity plot will not be drawn.\n');
      end
   end
end

if strcmp(params.output,'verbose')
   fprintf('\n');
   params
   fprintf('\n');
end
