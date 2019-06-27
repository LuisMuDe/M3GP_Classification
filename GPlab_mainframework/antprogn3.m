function antprogn3(actions)
%ANTPROGN3    Executes three actions of the GPLAB artificial ant.
%   ANTPROGN3 executes ACTIONS{1} followed by ACTIONS{2} followed by
%   ACTIONS{3}. Returns the number of the time step used by the ant
%   after all actions.
%
%   Input arguments:
%      ACTIONS - three actions to be executed sequentially (cell array)
%
%   See also ANTFITNESS, ANTFOODAHEAD, ANTMOVE, ANTRIGHT, ANTLEFT, ANTIF, ANTPROGN2
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

%global trail;
%global x;
%global y;
%global direction;
%global npellets;
%global maxtime;
%global ntime;

anteval(actions{1});
anteval(actions{2});
anteval(actions{3});
