function vscaled=scale(v,from,to)
%SCALE    Maps numbers from one interval to another.
%   SCALE(NUMBERS,SOURCE,OBJECT) returns the elements in NUMBERS mapped
%   from the SOURCE interval into the OBJECT interval.
%
%   Input arguments:
%      NUMBERS - the numbers to scale (MxN matrix, can be a scalar)
%      SOURCE - the interval to which NUMBERS belong (1x2 matrix)
%      OBJECT - the interval into which NUMBERS are to be mapped (1x2 matrix)
%   Output arguments:
%      SCALED_NUMBERS - NUMBERS after being mapped from SOURCE to OBJECT
%
%   Example:
%      NUMBERS = [10 25 ; 30 40]
%      SOURCE = [10,40]
%      OBJECT = [-1,1]
%      SCALED_NUMBERS = SCALE(NUMBERS,SOURCE,OBJECT)
%      SCALED_NUMBERS = -1.0000         0
%                        0.3333    1.0000
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox


if size(from)==[1,2] & size(to)==[1,2] & ndims(v)<=2
   
   % issue an error if "from" has the same lower and upper limit, which would result in div by zero
   if from(1,1)==from(1,2)
      error('SCALE: same lower and upper limit on second argument!')
   end
   % issue a warning if any lower limit is higher than the respective upper limit
   if from(1,1)>from(1,2) || to(1,1)>to(1,2)
      warning('SCALE: lower limit is higher than upper limit.')      
   end
   % issue a warning if matrix v has numbers outside the source interval
   if min(min(v)')<min(from) || max(max(v)')>max(from)
      warning('SCALE: some numbers are outside the source interval.')      
   end
   
   ncols=size(v,2);
   nrows=size(v,1);
   from=repmat(from',1,ncols);
   to=repmat(to',1,ncols);
   
   vscaled=(v-repmat(from(1,:),nrows,1)).*repmat((diff(to)./diff(from)),nrows,1)+repmat(to(1,:),nrows,1);
   % this is the vectorization of...
   %for i=1:size(v,1)
   %   vscaled(i,:)=(v(i,:)-from(1,:)).*(diff(to)./diff(from))+to(1,:);
   %end
   % ...which is already a half-vectorization, of course!
   % the complete vectorization seems to be >80% faster than the "half-vectorization"!

else
   error('SCALE: incorrect dimensions of input arguments!')
end
