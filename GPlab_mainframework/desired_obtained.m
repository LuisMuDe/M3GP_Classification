function desired_obtained(vars,indices,x,bw,sizexy)
%DESIRED_OBTAINED    Plots desired and obtained functions with GPLAB.
%   DESIRED_OBTAINED(VARS,INDICESBEST,INPUTVAR,BLACKWHITE,SIZEPLOT)
%   draws a plot with the desired function to approximate and the
%   approximations obtained by the best individuals in INDICESBEST.
%   Only one input variable, X, is represented in each plot. The plot
%   can be sized by the user with SIZEPLOT and be drawn in black and
%   white by using the flag BLACKWHITE. If INDICESBEST is empty, all
%   the available best individuals will be used, until a certain limit.
%   If SIZEPLOT is empty, the default plot size will be adopted; if
%   any of SIZEPLOT dimensions is null, the default size for that
%   dimension will be adopted.
%
%   Input arguments:
%      VARS - all the variables of the algorithm (struct)
%      INDICESBEST - the best individuals to plot, [] for all (1xN matrix)
%      INPUTVAR - the input variable to plot (integer)
%      BLACKWHITE - the flag to draw a b&w or color plot (boolean)
%      SIZEPLOT - the x and y size of plot, [] for default (1x2 matrix)
%
%   See also ACCURACY_COMPLEXITY, OPERATOR_EVOLUTION, PLOTPARETO;
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

symbline={'k+-','k*-','k.-','kx-','ks-','kd-','kv-','k^-','k<-','k>-','kp-','kh-'};
if ~bw
   symbline={};
end


if isempty(sizexy)
   sizexy(1)=0;
   sizexy(2)=0;
end

if isempty(indices)
   indices=1:size(vars.state.bestsofarhistory,1);
end

if bw && length(indices)>length(symbline)
   warning('DESIRED_OBTAINED: cannot use so many indices, discarding the last ones.')
   indices=indices(1:length(symbline));
end

if ~isempty(find(indices > size(vars.state.bestsofarhistory,1) | (indices < 1)))
   warning('DESIRED_OBTAINED: some indices not available.')
   indices=indices(find(indices <= size(vars.state.bestsofarhistory,1) && indices >=1));
end

h=vars.state.bestsofarhistory(indices,2);
hg=vars.state.bestsofarhistory(indices,1);

% get the desired results:
fd=[vars.data.result];

% get the obtained results:
for i=1:length(h)
   individual=calcfitness(h{i},vars.params,vars.data,vars.state,0);
   fr(:,i)=individual.result;
end

% get the correct x variable:
if x<1 || x>length(vars.data(1).example)
   error('DESIRED_OBTAINED: input variable not available.')
end

for i=1:size(vars.data.example,1)
   fx(i,:)=vars.data.example(i,x);
end

[fx,ii]=sortrows(fx);
fr=fr(ii,:);
fd=fd(ii);

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
title('Desired versus Obtained');
if length(vars.data(1).example)>1
   xlabel(strcat('x',int2str(x)));
else
   xlabel('x');
end
ylabel('desired y, approximation y''s');

% draw chart:
if bw
   for i=1:length(indices)
      if i==1
         listvars=['fx,fd,''ko-'',fx,fr(:,' int2str(i) '),''' symbline{i},''''];
      else
         listvars=[listvars ',fx,fr(:,' int2str(i) '),''' symbline{i},''''];
      end
   end
   
   ss=strcat('plot(',listvars,')');
   eval(ss);   
else
   plot(fx,fd,'ko-',fx,fr,'.-');
end

% build legend:
for i=1:length(indices)
   if i==1
      lg=['''to approximate'',' '''on generation ' int2str(hg{i}) ''''];
   else
      lg=[lg ',' '''on generation ' int2str(hg{i}) ''''];
   end
end

ss=strcat('legend(',lg,')');
eval(ss);
