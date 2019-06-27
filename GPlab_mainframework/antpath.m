function antpath(ntime,x,y,direction,npellets,looked)
%ANTPATH    Stores the path taken by the GPLAB artificial ant.
%   ANTPATH(NTIME,X,Y,DIRECTION,NPELLETS,LOOKED) stores the path
%   taken by the ant, step by step.
%
%   Input arguments:
%      NTIME - the current time step on the ant evaluation (double)
%      X - the current X position of the ant on the trail (double)
%      Y - the current Y position of the ant on the trail (double)
%      DIRECTION - the current direction the ant is facing (char)
%      NPELLETS - the current number of pellets eaten (double)
%      LOOKED - whether the ant just looked ahead (boolean)
%
%   See also ANTFITNESS, ANTMOVE, ANTIF, ANTRIGHT, ANTLEFT, ANTPROGN2, ANTPROGN3
%
%   Created by Matthew Cliftion (matthew_clifton@hotmail.com)
%   Modified by Sara Silva (sara@dei.uc.pt)
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

global path

path.ntime(ntime+1)=ntime;
path.x(ntime+1)=x;
path.y(ntime+1)=y;
path.direction(ntime+1)=direction;
path.npellets(ntime+1)=npellets;
path.looked(ntime+1)=looked;
