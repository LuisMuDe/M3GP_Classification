function accuracy_complexity(vars,offsets,bw,sizexy)
%ACCURACY_COMPLEXITY    Plots accuracy and complexity measures with GPLAB.
%   ACCURACY_COMPLEXITY(VARS,OFFSETS,BLACKWHITE,SIZEPLOT) draws
%   a plot with the evolution of fitness and complexity measures
%   level and nodes of the best individuals. OFFSETS can be used
%   to improve the visibility of the several lines in the plot
%   (fitness, level, nodes). The plot can be sized by the user with
%   SIZEPLOT and be drawn in black and white by using the flag
%   BLACKWHITE. If OFFSETS is empty, no offsets will be considered.
%   If SIZEPLOT is empty, the default plot size will be adopted;
%   if any of SIZEPLOT dimensions is null, the default size for
%   that dimension will be adopted.
%
%   Input arguments:
%      VARS - all the variables of the algorithm (struct)
%      OFFSETS - the offsets for each line, [] for no offset (1x3 matrix)
%      BLACKWHITE - the flag to draw a b&w or color plot (boolean)
%      SIZEPLOT - the x and y size of plot, [] for default (1x2 matrix)
%
%   See also DESIRED_OBTAINED, OPERATOR_EVOLUTION, PLOTPARETO;
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

h=vars.state.bestsofarhistory;

if isempty(offsets)
   fitoffset=0;
   leveloffset=0;
   nodesoffset=0;
else
   fitoffset=offsets(1);
   leveloffset=offsets(2);
   nodesoffset=offsets(3);
end

if isempty(sizexy)
   sizexy(1)=0;
   sizexy(2)=0;
end

for i=1:size(h,1)
   g(i)=h{i,1};
   f(i)=h{i,2}.fitness;
   l(i)=h{i,2}.level;
   n(i)=h{i,2}.nodes;
   % noruegueses fizeram
   % n(i)=nodes(h{i,2}.tree);
end

g=g';
f=f'+fitoffset;
l=l'+leveloffset;
n=n'+nodesoffset;

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
title('Accuracy versus Complexity');
xlabel('generation');

if fitoffset~=0
   if fitoffset<0
      ylab1=strcat('fitness',int2str(fitoffset));
   else
      ylab1=strcat('fitness+',int2str(fitoffset));
   end
else
   ylab1='fitness';
end

if leveloffset~=0
   if leveloffset<0
      ylab2=strcat('level',int2str(leveloffset));
   else
      ylab2=strcat('level+',int2str(leveloffset));
   end
else
   ylab2='level';
end

if nodesoffset~=0
   if nodesoffset<0
      ylab3=strcat('nodes',int2str(nodesoffset));
   else
      ylab3=strcat('nodes+',int2str(nodesoffset));
   end
else
   ylab3='nodes';
end

ylaball=[ylab1 ', ' ylab2 ', ' ylab3];
ylabel(ylaball);

if bw
   plot(g,f,'k.-',g,l,'k*-',g,n,'k+-');
else
   plot(g,[f,l,n],'.-');
end
legend(ylab1,ylab2,ylab3);