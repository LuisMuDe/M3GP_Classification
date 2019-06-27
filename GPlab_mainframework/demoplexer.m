function [v,b]=demoplexer
%DEMOPLEXER    Demonstration function of the GPLAB toolbox.
%
%   See also DEMO,DEMOANT,DEMOPARITY
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox


fprintf('Running 11-multiplexer demo...');
p=resetparams;

p.survival='resources';
p.dynamicresources='2';
p.veryheavy=0;

p=setfunctions(p,'and',2,'or',2,'not',1,'myif',3);
p=setterminals(p);
p=setoperators(p,'crossover',2,2);

p.operatorprobstype='fixed';

p.datafilex='11-multiplexer_x.txt';
p.datafiley='11-multiplexer_y.txt';

p.calcdiversity={};
p.calccomplexity=0;

p.fixedlevel=0;
p.dynamiclevel='0';

p.sampling='tournament';
p.tournamentsize=0.05;

p.hits='[100 0]';
p.graphics={};

[v,b]=gplab(20,200,p);

drawtree(b.tree);