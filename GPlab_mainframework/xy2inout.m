function result=xy2inout(x,y)
%XY2INOUT    Transforms matrices into a GPLAB algorithm data set (input and output).
%   XY2INOUT(X,Y) returns a struct array with input and desired output
%   data for use in the GPLAB algorithm, from matrices X and Y, with no
%   repeated [X,Y] rows.
%
%   Input arguments:
%      X - matrix with input data (array)
%      Y - matrix with desired output data (array)
%   Output arguments:
%      DATASET - X and Y data in GPLAB algorithm data set format (struct)
%        DATASET.EXAMPLE(i,:) - one input data row
%        DATASET.RESULT(i) - one desired output data row
%
%   Note:
%      This procedure is not ready to deal with more than one
%      column in the desired output data.
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox


nx=size(x,1);
ny=size(y,1);

if nx==ny % if dimensions match
   
   % join x and y in one single matrix:
   xy=[x y];
   
   % apply uniquenosort (see function for details):
   xy=uniquenosort(xy);
      
   % now separate x and y again:
   d=size(x,2);
   x=xy(:,1:d);
   y=xy(:,d+1:end);
      
   % set variable for the algorithm:
   nx=size(x,1);
   
   result.example(1:nx,:)=x(1:nx,:);
   result.result=y;
   
else
   error('XY2INOUT: the number of inputs and outputs does not match!')
end


