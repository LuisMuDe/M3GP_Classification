function [v,b]=demoparity
%DEMOPARITY    Demonstration function of the GPLAB toolbox.
%
%   See also DEMO,DEMOANT,DEMOPLEXER
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox


fprintf('Running parity-3 demo...');
p=resetparams;
p=setoperators(p,'crossover',2,2);
p=setfunctions(p,'nand',2,'nor',2,'and',2,'or',2);
p=setterminals(p);
p.datafilex='parity3bit_x.txt';
p.datafiley='parity3bit_y.txt';
p.operatorprobstype='fixed';
p.calccomplexity=1;
p.calcdiversity={'hamming'};
p.graphics={'plotfitness','plotdiversity','plotcomplexity'};
p.depthnodes='1';
[v,b]=gplab(20,50,p);
drawtree(v.state.bestsofar.tree);
