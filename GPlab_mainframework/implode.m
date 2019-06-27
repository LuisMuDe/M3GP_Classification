function string=implode(pieces,delimiter)
%IMPLODE    Joins strings with delimiter in between.
%   IMPLODE(PIECES,DELIMITER) returns a string containing all the
%   strings in PIECES joined with the DELIMITER string in between.
%
%   Input arguments:
%      PIECES - the pieces of string to join (cell array), each cell is a piece
%      DELIMITER - the delimiter string to put between the pieces (string)
%   Output arguments:
%      STRING - all the pieces joined with the delimiter in between (string)
%
%   Example:
%      PIECES = {'ab','c','d','e fgh'}
%      DELIMITER = '->'
%      STRING = IMPLODE(PIECES,DELIMITER)
%      STRING = ab->c->d->e fgh
%
%   See also EXPLODE, STRCAT
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

if isempty(pieces) % no pieces to join, return empty string
   string='';
   
else % no need for delimiters yet, so far there's only one piece
   string=pieces{1};   
end

l=length(pieces);
p=1;
while p<l % more than one piece to join with the delimiter, the interesting case
   p=p+1;
	string=strcat(string,delimiter,pieces{p});
end
