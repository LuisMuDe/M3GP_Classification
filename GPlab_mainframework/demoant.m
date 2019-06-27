function [v,b]=demoant
%DEMOANT    Demonstration function of the GPLAB toolbox.
%
%   See also DEMO,DEMOPARITY,DEMOPLEXER
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

fprintf('Running artificial ant demo...');

p=resetparams;
p.sampling='roulette';
p.elitism='keepbest';
p.survival='fixedpopsize';
p=setoperators(p,'crossover',2,2);
p=setfunctions(p,'antif',2,'antprogn2',2,'antprogn3',3);
p=setterminals(p,'antright','antleft','antmove');
p.calcfitness='antfitness';
p.lowerisbetter=0;
p.files2data='anttrail';
p.autovars=0;
p.datafilex='santafetrail.txt';
p.datafiley='santafepellets.txt';
p.calcdiversity={};
p.calccomplexity=0;
p.depthnodes='1';
p.graphics={'plotfitness','plotcomplexity'};

[v,b]=gplab(10,20,p);

drawtree(v.state.bestsofar.tree);

antsim(v);