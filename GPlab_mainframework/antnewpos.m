function [newx,newy]=antnewpos(x,y,direction,trail);
%ANTNEWPOS    Calculates the new location of the GPLAB artificial ant.
%   ANTNEWPOS returns the new location (NEWX and NEWY) of the artificial ant
%   if it moves, considering its current location (X and Y) and DIRECTION on
%   the TRAIL.
%
%   Input arguments:
%      X - the current X position of the ant on the trail (double)
%      Y - the current Y position of the ant on the trail (double)
%      DIRECTION - the current direction the ant is facing (char)
%      TRAIL - the trail the ant is on (array)
%   Output arguments:
%      NEWX - new X location of the ant on the trail (double)
%      NEWY - new Y location of the ant on the trail (double)
%
%   See also ANTFOODAHEAD, ANTMOVE
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

newx=x;
if strcmp(direction,'u') % facing up
   newy=y;
   newx=mod(x-1,size(trail,1));
elseif strcmp(direction,'d') % facing down
   newy=y;
   newx=mod(x+1,size(trail,1));
end
if newx==0
    newx=size(trail,1);
end

newy=y;
if strcmp(direction,'r') % facing right
   newx=x;
   newy=mod(y+1,size(trail,1));
elseif strcmp(direction,'l') % facing left
   newx=x;
   newy=mod(y-1,size(trail,1));
end
if newy==0
    newy=size(trail,1);
end
