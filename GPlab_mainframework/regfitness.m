function ind=regfitness(ind,params,data,terminals,varsvals)
%REGFITNESS    Measures the fitness of a GPLAB individual.
%   REGFITNESS(INDIVIDUAL,PARAMS,DATA,TERMINALS,VARSVALS) returns
%   the fitness of INDIVIDUAL, measured as the sum of differences
%   between the obtained and expected results, on DATA dataset, and
%   also returns the result obtained in each fitness case.
%
%   Input arguments:
%      INDIVIDUAL - the individual whose fitness is to measure (struct)
%      PARAMS - the current running parameters (struct)
%      DATA - the dataset on which to measure the fitness (struct)
%      TERMINALS - the variables to set with the input dataset (cell array)
%      VARSVALS - the string of the variables of the fitness cases (string)
%   Output arguments:
%      INDIVIDUAL - the individual whose fitness was measured (struct)
%
%   See also CALCFITNESS, ANTFITNESS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   Acknowledgements: Marco Medori (marco.medori@poste.it) and Bruno Morelli
%   This file is part of the GPLAB Toolbox

X=data.example;
outstr=ind.str;
for i=params.numvars:-1:1
    outstr=strrep(outstr,strcat('X',num2str(i)),strcat('X(:,',num2str(i),')'));
end

try
    res=eval(outstr);
catch
    % because of the "nesting 32" error of matlab
    res=str2num(evaluate_tree(ind.tree,X));
end

%for t=1:params.numvars
   %for all variables (which are first in input list), ie, X1,X2,X3,...
%   var=terminals{t,1};
%   val=varsvals{t}; % varsvals was previously prepared to be assigned (in genpop)
%   eval([var '=' val ';']);
   % (this eval does assignments like X1=2,X2=4.5,...)
%end
   
% evaluate the individual and measure difference between obtained and expected results:
%res=eval(ind);

% if the individual is just a terminal, res is just a scalar, but we want a vector:
if length(res)<length(data.result)
   res=res*ones(length(data.result),1);
end
sumdif=sum(abs(res-data.result));
ind.result=res;

% raw fitness:
ind.fitness=sumdif; %lower fitness means better individual
% now limit fitness precision, to eliminate rounding error problem:
ind.fitness=fixdec(ind.fitness,params.precision);

