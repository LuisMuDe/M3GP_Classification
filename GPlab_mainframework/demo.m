function [v,b]=demo
%DEMO    Demonstration function of the GPLAB toolbox.
%   DEMO runs a symbolic regression problem (the quartic
%   polynomial) with 100 individuals for 25 generations,
%   with automatic adaptation of operator probabilities,
%   drawing several plots in runtime, and finishing with
%   two additional post-run plots.
%
%   VARS=DEMO returns all the variables of the algorithm
%   needed to plot charts, continue runs, draw trees, etc.
%
%   [VARS,BEST]=DEMO also returns the best individual found
%   during the run (the same as 'vars.state.bestsofar').
%
%   See also DEMOPARITY,DEMOANT,DEMOPLEXER
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox


fprintf('Running symbolic regression demo...');
p=resetparams;

p=setoperators(p,'crossover',2,2,'mutation',1,1);
p.operatorprobstype='variable';
p.minprob=0;

p.datafilex='quartic_x.txt';
p.datafiley='quartic_y.txt';

p.usetestdata=1;
p.testdatafilex='exp_x.txt';
p.testdatafiley='exp_y.txt';

p.calcdiversity={'uniquegen'};
p.calccomplexity=1;
p.graphics={'plotfitness','plotdiversity','plotcomplexity','plotoperators'};
p.depthnodes='2';

[v,b]=gplab(25,50,p);

desired_obtained(v,[],1,0,[]);
accuracy_complexity(v,[],0,[]);

figure
plotpareto(v);

drawtree(b.tree);