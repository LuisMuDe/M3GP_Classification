function antprogn2(actions)
%ANTPROGN2    Executes two actions of the GPLAB artificial ant.
%   ANTPROGN2 executes ACTIONS{1} followed by ACTIONS{2}. Returns the
%   number of the time step used by the ant after both actions.
%
%   Input arguments:
%      ACTIONS - two actions to be executed sequentially (cell array)
%
%   See also ANTFITNESS, ANTFOODAHEAD, ANTMOVE, ANTRIGHT, ANTLEFT, ANTIF, ANTPROGN3
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
