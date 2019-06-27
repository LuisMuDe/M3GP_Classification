function gfxState=graphicsinit(params)
%GRAPHICSINIT    Initializes graphics for the GPLAB algorithm.
%   GFXSTATE=GRAPHICSINIT(PARAMS) returns handles for
%   newly created plots with axes titles already set.
%
%   Input arguments:
%      PARAMS - the algorithm running parameters (struct)
%   Output arguments:
%      GFXSTATE - handles and other variables for the plot elements
%
%   See also GRAPHICSSTART, GRAPHICSCONTINUE, GRAPHICSGENERATIONS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% go through all listed plots in params.graphics, by the specified order:
for p=1:length(params.graphics)
   
   eval(['gfxState.f' params.graphics{p} '=figure;']);
   switch p
   	case 3, eval(['set(gfxState.f' params.graphics{p} ',''position'',[25 400 475 320])']);
   	case 4, eval(['set(gfxState.f' params.graphics{p} ',''position'',[25 35 475 320])']);
   	case 1, eval(['set(gfxState.f' params.graphics{p} ',''position'',[525 400 475 320])']);
   	case 2, eval(['set(gfxState.f' params.graphics{p} ',''position'',[525 35 475 320])']);
   end
   
   if strcmp(params.graphics{p},'plotfitness')
      title('Fitness');
      xlabel('generation');
		ylabel('log10(fitness)');
		hold on;
      
   elseif strcmp(params.graphics{p},'plotcomplexity')
      title('Structural complexity');
      xlabel('generation');
 		ylabel('tree depth*10 / tree size / %introns');
		hold on;
      
   elseif strcmp(params.graphics{p},'plotdiversity')
      title('Population diversity');
      xlabel('generation');
   	ylabel('population diversity');
   	hold on;
      
   elseif strcmp(params.graphics{p},'plotoperators')
      title('Genetic operators');
      xlabel('generation');
   	ylabel('operator probability / frequency');
   	hold on;
   end
   
end