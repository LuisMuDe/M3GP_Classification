function antif(actiontruefalse)
%ANTIF    Executes one or other action of the GPLAB artificial ant.
%   ANTIF executes ACTIONTRUEFALSE{1} (action if true) if there is food
%   ahead in the artificial ant trail; executes ACTIONTRUEFALSE{2}
%   (action if false) otherwise. Returns the number of the time step
%   used by the ant after executing the action.
%
%   Input arguments:
%      ACTIONTRUEFALSE - actions to execute in case of true or false (cell array)
%
%   See also ANTFITNESS, ANTFOODAHEAD, ANTMOVE, ANTRIGHT, ANTLEFT, ANTPROGN2, ANTPROGN3
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

%global trail;
global x;
global y;
global direction;
global npellets;
%global maxtime;
global ntime;

global sim
global path

if antfoodahead
   anteval(actiontruefalse{1});
else
   anteval(actiontruefalse{2});
end

if sim
   antpath(ntime,x,y,direction,npellets,1);
   % 1 is the setting of "looked ahead", true only here
end