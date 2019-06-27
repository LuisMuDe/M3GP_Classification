function [mystates,defaults]=availablestates
%AVAILABLESTATES    Describes the GPLAB algorithm state variables.
%   AVAILABLESTATES returns a structured variable containing the
%   possible values of each state variable or simply hints on
%   validating each element.
%   
%   [STATEVARS,DEFAULTS]=AVAILABLESTATES also returns the default
%   initial values for each element.
%
%   Output arguments:
%      STATEVARS - the structure of the algorithm state (struct)
%      DEFAULTS - the default initial algorithm state (struct)
%
%   See also AVAILABLEPARAMS, RESETSTATE, RESETPARAMS, SETPARAMS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% available state elements:

mystates=struct(...
   'initpopsize',[],...
   'popsize',[],...
   'popsizehistory',[],...
   'maxresources',[],...
   'maxresourceshistory',[],...
   'usedresources',[],...
   'usedresourceshistory',[],...   
   'gengap',[],...
   'gengaphistory',[],...
   'iniclevel',[],...
   'maxlevel',[],...
   'generation',[],...
   'maxgen',[],...
   'popfitness',[],...
   'popadjustedfitness',[],...
   'popnormfitness',[],...
   'popranking',[],...
   'popexpected',[],...
   'maxfitness',[],...
   'avgfitness',[],...
   'bestavgfitnesssofar',[],...
   'minfitness',[],...
   'medianfitness',[],...
   'stdfitness',[],...
   'fithistory',[],...
   'bestfithistory',[],...
   'operatorprobs',[],...
   'operatorfreqs',[],...
   'opfreqhistory',[],...
   'lastid',[],...
   'functions',[],...
   'terminals',[],...
   'arity',[],...
   'bestsofar',[],...
   'adaptwindow',[],...
   'ophistory',[],...
   'lastadaptation',[],...
   'adaptwindowsize',[],...
   'tournamentsize',[],...
   'reproductions',[],...
   'clonings',[],...
   'reproductionhistory',[],...
   'cloninghistory',[],...
   'levelhistory',[],...
   'diversityhistory',[],...
   'avgnodeshistory',[],...
   'avglevelhistory',[],...
   'avgintronshistory',[],...
   'avgtreefillhistory',[],...
   'bestlevelhistory',[],...
   'bestnodeshistory',[],...
   'bestintronshistory',[],...
   'bestsofarhistory',[],...
   'keepevals',[],...
   'varsvals',[],...
   'testvarsvals',[],...
   'pivot',[],...
   'delta',[]...
   );


% possible values or some hints for validation:

mystates.generation='special_posint'; % a positive integer (zero allowed)
mystates.initpopsize='posint'; % a positive integer (zero NOT allowed)
mystates.popsize='posint'; % a positive integer (zero NOT allowed)
mystates.popsizehistory='list <- no need for validation';
mystates.maxresources='posint';
mystates.maxresourceshistory='list <- no need for validation';
mystates.usedresources='posint';
mystates.usedresourceshistory='list <- no need for validation';
mystates.gengap='posint';
mystates.gengaphistory='list <- no need for validation';
mystates.iniclevel='posint';
mystates.maxlevel='posint';
mystates.maxgen='special_posint';
mystates.popfitness='list <- no need for validation';
mystates.popadjustedfitness='list <- no need for validation';
mystates.popnormfitness='list <- no need for validation';
mystates.popranking='list <- no need for validation';
mystates.popexpected='list <- no need for validation';
mystates.maxfitness='special_anyfloat'; % any float
mystates.avgfitness='special_anyfloat';
mystates.bestavgfitnesssofar='special_anyfloat';
mystates.minfitness='special_anyfloat';
mystates.medianfitness='special_anyfloat';
mystates.stdfitness='special_anyfloat';
mystates.fithistory='list <- no need for validation'; % max(best),min(worst),avg,median,stddev
mystates.bestfithistory='list <- no need for validation'; % only bestsofar.fitness and bestsofar.testfitness
mystates.operatorprobs='list <- no need for validation';
mystates.operatorfreqs='list <- no need for validation';
mystates.opfreqhistory='list <- no need for validation';
mystates.lastid='special_posint';
mystates.functions='list <- no need for validation';
mystates.terminals='list <- no need for validation';
mystates.arity='list <- no need for validation';
mystates.bestsofar='individual <- no need for validation';
mystates.adaptwindow='list <- no need for validation';
mystates.ophistory='list <- no need for validation';
mystates.lastadaptation='posint';
mystates.adaptwindowsize='posint';
mystates.tournamentsize='posnumeric';
mystates.reproductions='special_posint';
mystates.clonings='list <- no need for validation';
mystates.reproductionhistory='list <- no need for validation';
mystates.cloninghistory='list <- no need for validation';
mystates.levelhistory='list <- no need for validation';
mystates.diversityhistory='list <- no need for validation';
mystates.avglevelhistory='list <- no need for validation';
mystates.avgnodeshistory='list <- no need for validation';
mystates.avgintronshistory='list <- no need for validation';
mystates.avgtreefillhistory='list <- no need for validation';
mystates.bestlevelhistory='list <- no need for validation';
mystates.bestnodeshistory='list <- no need for validation';
mystates.bestintronshistory='list <- no need for validation';
mystates.bestsofarhistory='list <- no need for validation';
mystates.keepevals='list <- no need for validation';
mystates.varsvals='list <- no need for validation';
mystates.testvarsvals='list <- no need for validation';
mystates.pivot='automatic, no need for validation';
mystates.delta='automatic, no need for validation';

% default state:

defaults=[];
defaults.generation='0';
defaults.initpopsize='[]';
defaults.popsize='[]';
defaults.popsizehistory='[]';
defaults.maxresources='[]';
defaults.maxresourceshistory='[]';
defaults.usedresources='[]';
defaults.usedresourceshistory='[]';
defaults.gengap='[]';
defaults.gengaphistory='[]';
defaults.iniclevel='[]';
defaults.maxlevel='[]';
defaults.maxgen='0';
defaults.popfitness='[]';
defaults.popadjustedfitness='[]';
defaults.popnormfitness='[]';
defaults.popranking='[]';
defaults.popexpected='[]';
defaults.maxfitness='[]';
defaults.avgfitness='[]';
defaults.bestavgfitnesssofar='[]';
defaults.minfitness='[]';
defaults.medianfitness='[]';
defaults.stdfitness='[]';
defaults.fithistory='[]';
defaults.bestfithistory='[]';
defaults.operatorprobs='[]';
defaults.operatorfreqs='[]';
defaults.opfreqhistory='[]';
defaults.lastid='0';
defaults.functions='[]';
defaults.terminals='[]';
defaults.arity='[]';
defaults.bestsofar='[]';
defaults.adaptwindow='[]';
defaults.lastadaptation='0';
defaults.adaptwindowsize='[]';
defaults.tournamentsize='[]';
defaults.ophistory='[]';
defaults.reproductions='0';
defaults.clonings='[]';
defaults.reproductionhistory='[]';
defaults.cloninghistory='[]';
defaults.levelhistory='[]';
defaults.diversityhistory='{}';
defaults.avglevelhistory='[]';
defaults.avgnodeshistory='[]';
defaults.avgintronshistory='[]';
defaults.avgtreefillhistory='[]';
defaults.bestlevelhistory='[]';
defaults.bestnodeshistory='[]';
defaults.bestintronshistory='[]';
defaults.bestsofarhistory='{}';
defaults.keepevals='[]';
defaults.varsvals='{}';
defaults.testvarsvals='{}';
defaults.pivot='[]';
defaults.delta='0';