function operator_evolution(vars,gens,ops,bw,sizexy)
%OPERATOR_EVOLUTION    Plots operator probabilities evolution with GPLAB.
%   OPERATOR_EVOLUTION(VARS,GENERATIONS,OPERATORS,BLACKWHITE,SIZEPLOT)
%   draws a plot with the evolution of the operator probabilities in
%   the GENERATIONS interval, for the operators in OPERATORS. The plot
%   can be sized by the user with SIZEPLOT and be drawn in black and white
%   by using the flag BLACKWHITE. If GENERATIONS is empty, all the
%   generations available will be drawn; if OPERATORS is empty, all the
%   available operators will be drawn, until a certain limit. If SIZEPLOT
%   is empty, the default plot size will be adopted; if any of SIZEPLOT
%   dimensions is null, the default size for that dimension will be adopted.
%
%   Input arguments:
%      VARS - all the variables of the algorithm (struct)
%      GENERATIONS - the interval of generations to draw, [] for all (1x2 matrix)
%      OPERATORS - the operators to draw, [] for all (1xN matrix)
%      BLACKWHITE - the flag to draw a b&w or color plot (boolean)
%      SIZEPLOT - the x and y size of plot, [] for default (1x2 matrix)
%
%   See also DESIRED_OBTAINED, ACCURACY_COMPLEXITY, PLOTPARETO;
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

%symbline={'k+-','k*-','k.-','kx-','ko-','ks-','kd-','kv-','k^-','k<-','k>-','kp-','kh-'};
symbline={'k-','k:','k+-','kx:','k*-','k+:','kx-','k*:','k.-','k.:'};
if ~bw
   symbline={};
end

if isempty(sizexy)
   sizexy(1)=0;
   sizexy(2)=0;
end

h=vars.state.ophistory;

if isempty(gens)
   gens=[0 size(vars.state.ophistory,1)-1];
end

if gens(1)>gens(2)
   warning('OPERATOR_EVOLUTION: inverting generations interval.')
   gens=gens([2,1]);
end

g=gens(1):gens(2);

if ~isempty(find(g > size(vars.state.ophistory,1)-1 || g < 0))
   warning('OPERATOR_EVOLUTION: some generations not available.')
   g=g(find(g <= size(vars.state.ophistory,1)-1 && g >= 0));
end
h=h(g+1,:);

if isempty(ops)
   ops=1:size(vars.state.ophistory,2);
end

if ~isempty(find(ops > size(vars.state.ophistory,2) || ops < 1))
   warning('OPERATOR_EVOLUTION: some operators not available.')
   ops=indices(find(ops <= size(vars.state.ophistory,2) && ops >= 1));
end

if bw && length(ops)>length(symbline)
   warning('OPERATOR_EVOLUTION: cannot use so many operators, discarding the last ones.')
   ops=ops(1:length(symbline));
end

h=h(:,ops);

ff=figure;
set(ff,'Color',[1 1 1]);

if sizexy(1)<=0
   sizexy(1)=400;
end
if sizexy(2)<=0
   sizexy(2)=350;
end

set(ff,'Position',[200 250 sizexy(1) sizexy(2)])
hold on
title('Operators Evolution');
xlabel('generation');
ylabel('probabilities of occurence');


% draw chart:
if bw
   for i=1:length(ops)
      if i==1
         listvars=['g,h(:,' num2str(i) '),''' symbline{i},''''];
      else
         listvars=[listvars ',g,h(:,' num2str(i) '),''' symbline{i},''''];
      end
   end
      
   ss=strcat('plot(',listvars,')');
   eval(ss);   
else
   plot(g,h,'-');
end

% build legend:
for i=1:length(ops)
   if i==1
      lg=['''' vars.params.operatornames{i} ''''];
   else
      lg=[lg ',''' vars.params.operatornames{i} ''''];
   end
end

ss=strcat('legend(',lg,')');
eval(ss);
