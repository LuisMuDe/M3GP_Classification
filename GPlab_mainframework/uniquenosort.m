function x=uniquenosort(x)
%UNIQUENOSORT    Eliminates duplicate rows without altering order.
%   UNIQUEX=UNIQUENOSORT(X) runs through the rows of a matrix and
%   eliminates all repeated rows (always maintaining the first
%   occurence and removing the next ones), without altering the
%   order of the rows (unlike UNIQUE, that sorts the input).
%
%   Input arguments:
%      X - matrix to eliminate the duplicates from (matrix)
%   Output arguments:
%      UNIQUEX - X without duplicate rows, same order (matrix)
%
%   See also UNIQUE, XY2INOUT
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox


x_inv=x(end:-1:1,:);
% (invert because unique removes the first ocurrences of the duplicates,
% and I want to keep the first ocurrence and remove the following ones)

[ans,i]=unique(x_inv,'rows'); % apply unique just to know which indices to use

x_inv=x_inv(sort(i),:); % new x_inv does not contain its first occurrences of duplicates...
x=x_inv(end:-1:1,:); % ...so new x does not contain last occurrences of duplicates!