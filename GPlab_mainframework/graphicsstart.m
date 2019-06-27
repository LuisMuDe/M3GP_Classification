function gfxState=graphicsstart(params,state,gfxState)
%GRAPHICSSTART    Initializes first drawing points in the GPLAB graphics.
%   GFXSTATE=GRAPHICSSTART(PARAMS,STATE,GFXSTATE) returns the first
%   points in the graphics where the lines will begin to be drawn.
%
%   Input arguments:
%      PARAMS - the algorithm running parameters (struct)
%      STATE - the current state of the algorithm (struct)
%      GFXSTATE - handles and other variables for the plot elements
%   Output arguments:
%      GFXSTATE - handles and other variables for the plot elements
%
%   See also GRAPHICSINIT, GRAPHICSCONTINUE, GRAPHICSGENERATIONS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

for p=1:length(params.graphics)
   
   if strcmp(params.graphics{p},'plotfitness')
      if params.usetestdata
         gfxState.oldpoint1(1,1:7)=state.generation;
      else
         gfxState.oldpoint1(1,1:6)=state.generation;
      end
		gfxState.oldpoint1(2,1)=state.maxfitness;
		gfxState.oldpoint1(2,2)=state.medianfitness;
		gfxState.oldpoint1(2,3)=state.avgfitness;
		gfxState.oldpoint1(2,4)=state.avgfitness-state.stdfitness;
		gfxState.oldpoint1(2,5)=state.avgfitness+state.stdfitness;
        gfxState.oldpoint1(2,6)=state.bestsofar.fitness;
      if params.usetestdata
         gfxState.oldpoint1(2,7)=state.bestsofar.testfitness;
      end

   elseif strcmp(params.graphics{p},'plotcomplexity')
      if params.calccomplexity
         gfxState.oldpoint2(1,1:8)=state.generation;
      else
         gfxState.oldpoint2(1,1:4)=state.generation;
      end
     	if strcmp(params.depthnodes,'1') % depth
	      gfxState.oldpoint2(2,1)=state.maxlevel*10;
         gfxState.oldpoint2(2,2)=state.bestsofar.level*10;
         if params.calccomplexity
            gfxState.oldpoint2(2,3)=state.avglevelhistory(end)*10;
            gfxState.oldpoint2(2,4)=state.bestsofar.nodes;
            gfxState.oldpoint2(2,5)=state.avgnodeshistory(end);
            gfxState.oldpoint2(2,6)=state.bestsofar.introns;
            gfxState.oldpoint2(2,7)=state.avgintronshistory(end);
            gfxState.oldpoint2(2,8)=state.avgtreefillhistory(end);
         else
            gfxState.oldpoint2(2,3)=state.bestsofar.nodes;
            gfxState.oldpoint2(2,4)=state.bestsofar.introns;
         end
      else
         gfxState.oldpoint2(2,1)=state.maxlevel;
         gfxState.oldpoint2(2,2)=state.bestsofar.nodes;
         if params.calccomplexity
            gfxState.oldpoint2(2,3)=state.avgnodeshistory(end);
            gfxState.oldpoint2(2,4)=state.bestsofar.introns;
            gfxState.oldpoint2(2,5)=state.avgintronshistory(end);
            gfxState.oldpoint2(2,6)=state.bestsofar.level*10;
            gfxState.oldpoint2(2,7)=state.avglevelhistory(end)*10;
            gfxState.oldpoint2(2,8)=state.avgtreefillhistory(end);
         else
            gfxState.oldpoint2(2,3)=state.bestsofar.introns;
            gfxState.oldpoint2(2,4)=state.bestsofar.level*10;
         end
      end
     		      
   elseif strcmp(params.graphics{p},'plotdiversity')
      gfxState.oldpoint2a(1,1:length(params.calcdiversity))=state.generation;
      for i=1:length(params.calcdiversity)
         eval(['gfxState.oldpoint2a(2,' int2str(i) ')=state.diversityhistory.' params.calcdiversity{i} '(end);']);
      end
      
   elseif strcmp(params.graphics{p},'plotoperators')
      gfxState.oldpoint3(1,1:length(state.operatorprobs))=state.generation;
	   gfxState.oldpoint3(2,:)=state.operatorprobs;
   	gfxState.oldpoint4(1,1:length(state.operatorprobs))=state.generation;
      gfxState.oldpoint4(2,:)=normalize(ones(1,length(params.operatornames)),1);
      % (relative freqs of operators are all equal in the beginning...)
      gfxState.oldpoint5(1,1)=state.generation;
      gfxState.oldpoint5(2,1)=state.reproductionhistory(end)./params.gengap;
      gfxState.oldpoint6(1,1:length(state.operatorprobs))=state.generation;
      gfxState.oldpoint6(2,:)=state.cloninghistory(end,:)./params.gengap;
   end
      
end
