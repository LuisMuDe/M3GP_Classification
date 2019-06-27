function plotpareto(vars)
%PLOTPARETO    Plots the pareto front in GPLAB.
%   PLOTPARETO(VARS) draws a plot which shows the best fitness
%   found for each tree size, i.e. number of nodes, in blue.
%   The red graph is the pareto front, i.e. the set of solutions
%   for which no other solution was found which both has a smaller
%   tree and better fitness. The sizes and fitnesses of the current
%   population are plotted in green.
%
%   Input arguments:
%      VARS - all the variables of the algorithm (struct)
%   Output arguments:
%      none
%
%   See also DESIRED_OBTAINED, OPERATOR_EVOLUTION, ACCURACY_COMPLEXITY;
%
%   Created (2003) by SINTEF (hso@sintef.no,jtt@sintef.no,okl@sintef.no)
%   Modified by Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB toolbox

% ensure #nodes are computed for current population:
for i=1:length(vars.pop)
    if isempty(vars.pop(i).nodes)
        vars.pop(i).nodes=nodes(vars.pop(i).tree);
    end
end

% build pareto front variable:
paretofront=[];
paretofront(1).fitness=[];
for solution=vars.pop
   while length(paretofront)<solution.nodes
      paretofront(end+1).ind=[];
   end
   if isempty(paretofront(solution.nodes).fitness) || ((vars.params.lowerisbetter && solution.fitness<paretofront(solution.nodes).fitness) || (~vars.params.lowerisbetter && solution.fitness>paretofront(solution.nodes).fitness))
      % cross validation
      if vars.params.usetestdata
         testindividual=calcfitness(solution,vars.params,vars.data.test,vars.state,1); % (1 = test data)
         solution.testfitness=testindividual.fitness;
      end
      paretofront(solution.nodes).fitness=solution.fitness;
      paretofront(solution.nodes).ind=solution;
      if vars.params.usetestdata
         paretofront(solution.nodes).testfitness=solution.testfitness;
      end
   end
end
 
% collect fitness and #nodes:
y=[paretofront.fitness];
x=[];
for i=1:size(paretofront,2)
   if ~isempty(paretofront(i).ind)
      x=[x i];
   end
end
if length(y)~=length(x)
    error('','internal error');
end

% compute pareto front:
best=[];
bestind=[];
sofar=[];
for i=1:length(y)
    if i==1 || y(i) > sofar
        sofar=y(i);
        best=[best sofar];
        bestind=[bestind x(i)];
    end
end

hold on
title('Pareto front');
xlabel('nodes');
ylabel('fitness');

% plot:
plot(x,y,'o-',bestind,best,'ro-');
plot([vars.pop.nodes],[vars.pop.fitness],'g*');
if vars.params.usetestdata
   plot(x,[paretofront.testfitness],'m-');
   legend('best for #nodes','pareto front','current population','test fitness');
else
   legend('best for #nodes','pareto front','current population');
end

hold off
