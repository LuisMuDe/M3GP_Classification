function gfxState=graphicsgenerations(params,state,gfxState)
%GRAPHICSGENERATIONS    Draws data from new generations in the GPLAB graphics.
%   GFXSTATE=GRAPHICSGENERATIONS(PARAMS,STATE,GFXSTATE)
%   returns the first points in the graphics where the lines will
%   continue to be drawn after this new generation just drawn.
%
%   Input arguments:
%      PARAMS - the algorithm running parameters (struct)
%      STATE - the current state of the algorithm (struct)
%      GFXSTATE - handles and other variables for the plot elements
%   Output arguments:
%      GFXSTATE - handles and other variables for the plot elements
%
%   See also GRAPHICSINIT, GRAPHICSSTART, GRAPHICSCONTINUE
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

for p=1:length(params.graphics)
   
   if strcmp(params.graphics{p},'plotfitness')
      figure(gfxState.fplotfitness);
      if params.usetestdata
         newpoint1(1,1:7)=state.generation;
      else
         newpoint1(1,1:6)=state.generation;
      end
		newpoint1(2,1)=state.maxfitness;
		newpoint1(2,2)=state.medianfitness;
      newpoint1(2,3)=state.avgfitness;
		newpoint1(2,4)=state.avgfitness-state.stdfitness;
      newpoint1(2,5)=state.avgfitness+state.stdfitness;
      newpoint1(2,6)=state.bestsofar.fitness;
      if params.usetestdata
         newpoint1(2,7)=state.bestsofar.testfitness;
      end
		if ~isempty(gfxState.oldpoint1)
   		linex=[gfxState.oldpoint1(1,:);newpoint1(1,:)];
         warning('off')
         % because we may have log10(0), which will output -Inf and issue a warning
         % or we may have log10(<0), which will output an imaginary number
   		liney=log10([gfxState.oldpoint1(2,:);newpoint1(2,:)]);
   		liney(find(isinf(liney)|imag(liney)))=0;
   		warning('on')
         handles=line(linex,liney);
         set(handles(2),'color','green');
         set(handles(3),'color',[200/255 200/255 0]);
   		set(handles(4:5),'linestyle',':','color',get(handles(3),'color'));
         set(handles(6),'color',get(handles(1),'color'),'linewidth',1.5);
         if params.usetestdata
            set(handles(7),'color','red','linewidth',1.5);
         end
         if params.usetestdata
            lg=['''maximum: ' num2str(newpoint1(2,1)) '''' ',' '''median: ' num2str(newpoint1(2,2)) '''' ',' '''average: ' num2str(newpoint1(2,3)) '''' ',' '''avg - std: ' num2str(newpoint1(2,4)) '''' ',' '''avg + std: ' num2str(newpoint1(2,5)) '''' ',' '''best so far: ' num2str(newpoint1(2,6)) '''' ',' '''test fitness: ' num2str(newpoint1(2,7)) ''''];
         else
            lg=['''maximum: ' num2str(newpoint1(2,1)) '''' ',' '''median: ' num2str(newpoint1(2,2)) '''' ',' '''average: ' num2str(newpoint1(2,3)) '''' ',' '''avg - std: ' num2str(newpoint1(2,4)) '''' ',' '''avg + std: ' num2str(newpoint1(2,5)) '''' ',' '''best so far: ' num2str(newpoint1(2,6)) ''''];
         end
   		ss=strcat('legend(',lg,',-1)');
   		legend off
   		eval(ss);
		end
		gfxState.oldpoint1=newpoint1;
      
   elseif strcmp(params.graphics{p},'plotcomplexity')
      figure(gfxState.fplotcomplexity);
      if params.calccomplexity
         newpoint2(1,1:8)=state.generation;
      else
         newpoint2(1,1:4)=state.generation;
      end
      if strcmp(params.depthnodes,'1') % depth
         newpoint2(2,1)=state.maxlevel*10;
         newpoint2(2,2)=state.bestsofar.level*10;
         if params.calccomplexity
            newpoint2(2,3)=state.avglevelhistory(end)*10;
            newpoint2(2,4)=state.bestsofar.nodes;
            newpoint2(2,5)=state.avgnodeshistory(end);
            newpoint2(2,6)=state.bestsofar.introns;
            newpoint2(2,7)=state.avgintronshistory(end);
            newpoint2(2,8)=state.avgtreefillhistory(end);
         else
         	newpoint2(2,3)=state.bestsofar.nodes;
            newpoint2(2,4)=state.bestsofar.introns;
			end
      else % nodes
         newpoint2(2,1)=state.maxlevel;
         newpoint2(2,2)=state.bestsofar.nodes; % nodes
         if params.calccomplexity
            newpoint2(2,3)=state.avgnodeshistory(end);
            newpoint2(2,4)=state.bestsofar.introns;
            newpoint2(2,5)=state.avgintronshistory(end);
            newpoint2(2,6)=state.bestsofar.level*10;
            newpoint2(2,7)=state.avglevelhistory(end)*10;
            newpoint2(2,8)=state.avgtreefillhistory(end);
         else
            newpoint2(2,3)=state.bestsofar.introns;
            newpoint2(2,4)=state.bestsofar.level*10;
         end
      end
      
		if ~isempty(gfxState.oldpoint2)
			linex=[gfxState.oldpoint2(1,:);newpoint2(1,:)];
   		liney=[gfxState.oldpoint2(2,:);newpoint2(2,:)];
         handles=line(linex,liney);
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
         if strcmp(params.depthnodes,'1') % depth
            if params.calccomplexity
               lg=['''maximum depth: ' num2str(newpoint2(2,1)/10) '''' ',' '''bestsofar depth: ' num2str(newpoint2(2,2)/10) '''' ',' '''avg depth: ' num2str(newpoint2(2,3)/10) '''' ',' '''bestsofar size: ' num2str(newpoint2(2,4)) '''' ',' '''avg size: ' num2str(newpoint2(2,5)) '''' ',' '''bestsofar introns: ' num2str(newpoint2(2,6)) '''' ',' '''avg introns: ' num2str(newpoint2(2,7)) '''' ',' '''avg tree fill: ' num2str(newpoint2(2,8)) ''''];
            else
               lg=['''maximum depth: ' num2str(newpoint2(2,1)/10) '''' ',' '''bestsofar depth: ' num2str(newpoint2(2,2)/10) '''' ',' '''bestsofar size: ' num2str(newpoint2(2,3)) '''' ',' '''bestsofar introns: ' num2str(newpoint2(2,4)) ''''];
            end
         else
            if params.calccomplexity
               lg=['''maximum size: ' num2str(newpoint2(2,1)) '''' ',' '''bestsofar size: ' num2str(newpoint2(2,2)) '''' ',' '''avg size: ' num2str(newpoint2(2,3)) '''' ',' '''bestsofar introns: ' num2str(newpoint2(2,4)) '''' ',' '''avg introns: ' num2str(newpoint2(2,5)) '''' ',' '''bestsofar depth: ' num2str(newpoint2(2,6)/10) '''' ',' '''avg depth: ' num2str(newpoint2(2,7)/10) '''' ',' '''avg tree fill: ' num2str(newpoint2(2,8)) ''''];
            else
               lg=['''maximum size: ' num2str(newpoint2(2,1)) '''' ',' '''bestsofar size: ' num2str(newpoint2(2,2)) '''' ',' '''bestsofar introns: ' num2str(newpoint2(2,3)) '''' ',' '''bestsofar depth: ' num2str(newpoint2(2,4)/10) ''''];
            end
         end
   		ss=strcat('legend(',lg,',-1)');
   		legend off
   		eval(ss);
		end
		gfxState.oldpoint2=newpoint2;
      
   elseif strcmp(params.graphics{p},'plotdiversity')
      lg=[];
		figure(gfxState.fplotdiversity);
      newpoint2a(1,1:length(params.calcdiversity))=state.generation;
      for i=1:length(params.calcdiversity)
         eval(['newpoint2a(2,i)=state.diversityhistory.' params.calcdiversity{i} '(end);']);
      end
		if ~isempty(gfxState.oldpoint2a)
			linex=[gfxState.oldpoint2a(1,1:length(params.calcdiversity));newpoint2a(1,1:length(params.calcdiversity))];
   		liney=[gfxState.oldpoint2a(2,1:length(params.calcdiversity));newpoint2a(2,1:length(params.calcdiversity))];
         line(linex,liney);
         for i=1:length(params.calcdiversity)
         	if isempty(lg)
         		lg=['''' params.calcdiversity{i} ': ' num2str(newpoint2a(2,i)) ''''];
            else
           		lg=[lg ',''' params.calcdiversity{i} ': ' num2str(newpoint2a(2,i)) ''''];
         	end
      	end
   	  	ss=strcat('legend(',lg,',-1)');
   		legend off
   		eval(ss);
   	end
   	gfxState.oldpoint2a=newpoint2a;
      
      
   elseif strcmp(params.graphics{p},'plotoperators')
      
      figure(gfxState.fplotoperators);
      
      % operator probabilities:
      newpoint3(1,1:length(state.operatorprobs))=state.generation;
   	newpoint3(2,:)=state.operatorprobs;
   	if ~isempty(gfxState.oldpoint3)
         handles=line([gfxState.oldpoint3(1,:);newpoint3(1,:)],[gfxState.oldpoint3(2,:);newpoint3(2,:)]);
         set(handles(1:length(state.operatorprobs)),'linewidth',1.5);
      end
   	gfxState.oldpoint3=newpoint3;
      
      % operator frequencies:   
      newpoint4(1,1:length(state.operatorfreqs))=state.generation;
   	newpoint4(2,:)=state.operatorfreqs./sum(state.operatorfreqs);
   	if ~isempty(gfxState.oldpoint4)
         handles=line([gfxState.oldpoint4(1,:);newpoint4(1,:)],[gfxState.oldpoint4(2,:);newpoint4(2,:)]);
         set(handles(1:length(state.operatorprobs)),'linestyle',':');
   	end
      gfxState.oldpoint4=newpoint4;
      
      %reproductions:
      newpoint5(1,1)=state.generation;
   	newpoint5(2,1)=state.reproductionhistory(end)./params.gengap;
   	if ~isempty(gfxState.oldpoint5)
         handles=line([gfxState.oldpoint5(1,:);newpoint5(1,:)],[gfxState.oldpoint5(2,:);newpoint5(2,:)]);
         set(handles,'color','black');
   	end
      gfxState.oldpoint5=newpoint5;
      
      % clonings:   
      newpoint6(1,1:length(state.operatorprobs))=state.generation;
   	newpoint6(2,:)=state.cloninghistory(end,:)./params.gengap;
   	if ~isempty(gfxState.oldpoint6)
         handles=line([gfxState.oldpoint6(1,:);newpoint6(1,:)],[gfxState.oldpoint6(2,:);newpoint6(2,:)]);
         set(handles(1:length(state.operatorprobs)),'marker','x');
   	end
      gfxState.oldpoint6=newpoint6;
      
      % build legend:
      	legend34names=params.operatornames;
         legend34=[];
         % operator probabilities:
      	for o=1:length(state.operatorprobs)
      		legend34values{o}=num2str(state.operatorprobs(o));
         	if isempty(legend34)
         		legend34=['''' 'prob.' legend34names{o} ': ' legend34values{o} ''''];
         	else
            	legend34=[legend34 ',''' 'prob.' legend34names{o} ': ' legend34values{o} ''''];
         	end
         end
         % operator frequencies:
      	for o=1:length(state.operatorprobs)
      		legend34values{o}=num2str(state.operatorfreqs(o));
         	if isempty(legend34)
         		legend34=['''' 'cum.freq.' legend34names{o} ': ' legend34values{o} ''''];
         	else
	        		legend34=[legend34 ',''' 'cum.freq.' legend34names{o} ': ' legend34values{o} ''''];
         	end
         end
         % reproductions:
         if isempty(legend34)
            legend34=['''' '# reproductions: ' num2str(state.reproductionhistory(end)) ''''];
         else
            legend34=[legend34 ',''' '# reproductions: ' num2str(state.reproductionhistory(end)) ''''];
         end
      	ss=strcat('legend(',legend34,',-1)');
      	legend off
			eval(ss);
         % clonings:
         for o=1:length(state.operatorprobs)
      		legend34values{o}=num2str(state.cloninghistory(end,o));
            if isempty(legend34)
               legend34=['''' '# clones ' legend34names{o} ': ' legend34values{o} ''''];
            else
               legend34=[legend34 ',''' '# clones ' legend34names{o} ': ' legend34values{o} ''''];
            end
         end
      	ss=strcat('legend(',legend34,',-1)');
      	legend off
			eval(ss);

   end
   
end
      
drawnow;
