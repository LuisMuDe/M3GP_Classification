function gfxState=graphicscontinue(params,state,gfxState)
%GRAPHICSCONTINUE    Draws past history lines in the GPLAB graphics.
%   GFXSTATE=GRAPHICSCONTINUE(PARAMS,STATE,GFXSTATE)
%   returns the first points in the graphics where the lines will
%   continue to be drawn after the past history lines just redrawn.
%
%   Input arguments:
%      PARAMS - the algorithm running parameters (struct)
%      STATE - the current state of the algorithm (struct)
%      GFXSTATE - handles and other variables for the plot elements
%   Output arguments:
%      GFXSTATE - handles and other variables for the plot elements
%
%   See also GRAPHICSINIT, GRAPHICSSTART, GRAPHICSGENERATIONS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% restore old history:
for p=1:length(params.graphics)
   
   if strcmp(params.graphics{p},'plotfitness')
		figure(gfxState.fplotfitness);
		% be careful to avoid log10(0) and log10(<0):
		warning('off')
		completefithistory=state.fithistory(:,[1,4,3]);
		completefithistory(:,4)=state.fithistory(:,3)-state.fithistory(:,5);
      completefithistory(:,5)=state.fithistory(:,3)+state.fithistory(:,5);
      if params.usetestdata
         completefithistory(:,6:7)=state.bestfithistory;
      else
         completefithistory(:,6)=state.bestfithistory';
      end
		log10fithistory=log10(completefithistory);
		log10fithistory(find(isinf(log10fithistory)|imag(log10fithistory)))=0;
      warning('on')
      % set same color for both stds:
		handles=plot(0:state.generation,log10fithistory);
		set(handles(2),'color','green');
      set(handles(3),'color',[200/255 200/255 0]);
   	set(handles(4:5),'linestyle',':','color',get(handles(3),'color'));
      set(handles(6),'color',get(handles(1),'color'),'linewidth',1.5);
      if params.usetestdata
      	set(handles(7),'color','red','linewidth',1.5);
      end
      % set lastpoints:
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
		figure(gfxState.fplotcomplexity);
		if strcmp(params.depthnodes,'1') % depth
         if params.calccomplexity
            handles=plot(0:state.generation,[state.levelhistory*10;state.bestlevelhistory*10;state.avglevelhistory*10;state.bestnodeshistory;state.avgnodeshistory;state.bestintronshistory;state.avgintronshistory;state.avgtreefillhistory]);
         else
            handles=plot(0:state.generation,[state.levelhistory*10;state.bestlevelhistory*10;state.bestnodeshistory;state.bestintronshistory]);
         end
      else % nodes
         if params.calccomplexity
            handles=plot(0:state.generation,[state.levelhistory;state.bestnodeshistory;state.avgnodeshistory;state.bestintronshistory;state.avgintronshistory;state.bestlevelhistory*10;state.avglevelhistory*10;state.avgtreefillhistory]);
         else
            handles=plot(0:state.generation,[state.levelhistory;state.bestnodeshistory;state.bestintronshistory;state.bestlevelhistory*10]);
         end
      end
      set(handles(1),'color',get(handles(2),'color'),'linewidth',1.5);
     	set(handles(2),'linestyle',':','marker','*');
      if params.calccomplexity
	      set(handles(3),'color',get(handles(2),'color'));
         set(handles(4),'linestyle',':','marker','*');
         set(handles(5),'color',get(handles(4),'color'));
         set(handles(6),'linestyle',':','marker','*');
         set(handles(7),'color',get(handles(6),'color'));
         set(handles(8),'color','black','marker','.');
      else
      	set(handles(3),'linestyle',':','marker','*');
         set(handles(4),'linestyle',':','marker','*');
      end
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
      figure(gfxState.fplotdiversity);
      alldiversity=[];
      for i=1:length(params.calcdiversity)
         eval(['alldiversity=[alldiversity;state.diversityhistory.' params.calcdiversity{i} '];']);
      end
      %plot(0:state.generation,[state.diversityhistory.uniquegen;state.diversityhistory.hamming]);
      plot(0:state.generation,alldiversity);
      gfxState.oldpoint2a(1,1:length(params.calcdiversity))=state.generation;
      for i=1:length(params.calcdiversity)
         eval(['gfxState.oldpoint2a(2,' int2str(i) ')=state.diversityhistory.' params.calcdiversity{i} '(end);']);
		end
      
   elseif strcmp(params.graphics{p},'plotoperators')
      figure(gfxState.fplotoperators);
      handles=plot(0:state.generation,state.ophistory);
      set(handles(1:length(state.operatorprobs)),'linewidth',1.5);
      for r=1:size(state.opfreqhistory,1)
         if sum(state.opfreqhistory(r,:))==0
            relativefreqhistory(r,:)=normalize(ones(1,length(params.operatornames)),1);
         else
            relativefreqhistory(r,:)=state.opfreqhistory(r,:)./sum(state.opfreqhistory(r,:));
         end
      end
      handles=plot(0:state.generation,relativefreqhistory);
      set(handles(1:length(state.operatorprobs)),'linestyle',':');
	   gfxState.oldpoint3(1,1:length(state.operatorprobs))=state.generation;
   	gfxState.oldpoint3(2,:)=state.operatorprobs;   
	   gfxState.oldpoint4(1,1:length(state.operatorprobs))=state.generation;
   	if sum(state.operatorfreqs)==0
      	gfxState.oldpoint4(2,:)=normalize(ones(1,length(params.operatornames)),1);
      else
         gfxState.oldpoint4(2,:)=state.operatorfreqs./sum(state.operatorfreqs);
      end
      handles=plot(0:state.generation,state.reproductionhistory./params.gengap);
      set(handles,'color','black');
      gfxState.oldpoint5(1,1)=state.generation;
      gfxState.oldpoint5(2,1)=state.reproductionhistory(end)./params.gengap;
      gfxState.oldpoint6(1,1:length(state.operatorprobs))=state.generation;
      gfxState.oldpoint6(2,:)=state.cloninghistory(end,:)./params.gengap;
      handles=plot(0:state.generation,state.cloninghistory./params.gengap);
      set(handles,'marker','x');
   end
      
end
