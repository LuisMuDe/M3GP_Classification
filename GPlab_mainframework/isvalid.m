function v=isvalid(value,domain)
%ISVALID    Validates a value according to a domain.
%   ISVALID(VALUE,DOMAIN) returns true if VALUE belongs to
%   the specified DOMAIN, false otherwise.
%
%   Input arguments:
%      VALUE - the value to validate (any type)
%      DOMAIN - the domain in which to validate the value (string)
%   Output arguments:
%      ISVALID - whether the value is valid inside the domain (boolean)
%
%   Note:
%      Domains available are:
%        'boolean' -> true (1) or false (0)
%        'posint' -> a positive integer, zero not allowed
%        'special_posint' -> a positive integer or zero
%        'posnumeric' -> a positive numeric, zero not allowed
%        'special_posnumeric' -> a positive numeric or zero
%        'special_anyfloat' -> any float number, zero allowed
%        '01float' -> a float between 0 and 1, zero not allowed
%        'special_01float' -> a float between 0 and 1, zero allowed
%      (if you add more please describe them here)
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox


v=0;

if isnumeric(value) || iscell(value)
   
   if strcmp(domain,'boolean')
      if (value==1) || (value==0)   
         v=1;
      end
   
	elseif strcmp(domain,'special_posint')
   	if mod(value,1)==0 && value>=0 % if it's integer and >= 0
         v=1;
      end
      
   elseif strcmp(domain,'posint')
   	if mod(value,1)==0 && value>0 % if it's integer and > 0
         v=1;
      end
      
   elseif strcmp(domain,'posnumeric')
   	if value>0 % if it's > 0
         v=1;
    end

   elseif strcmp(domain,'special_posnumeric')
   	  if value>=0 % if it's >= 0
         v=1;
      end

	elseif strcmp(domain,'special_anyfloat')
   	v=1;
   
	elseif strcmp(domain,'special_01float')
   	if value>=0 && value<=1
      	v=1;
   	end
      
   elseif strcmp(domain,'01float')
   	if value>0 && value<=1
      	v=1;
   	end
   
   elseif ~isempty(findstr('no need for validation',char(domain)))
      v=1;
   else
      error(['ISVALID: unknown domain specification: ' domain])
   end
   
end % if isnumeric(value)