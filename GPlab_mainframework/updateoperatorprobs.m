function state=updateoperatorprobs(params,state)
%UPDATEOPERATORPROBS    Updates GPLAB genetic operator probabilities.
%   UPDATEOPERATORPROBS(PARAMS,STATE) returns the updated state of
%   the algorithm where the operator probabilities have been updated
%   according to the procedure in Davis 89.
%
%   Input arguments:
%      PARAMS - the running parameters of the algorithm (struct)
%      STATE - the current state of the algorithm (struct)
%   Output arguments:
%      STATE - the updated state with new operator probabilities (struct)
%
%   References:
%      Davis, L. Adapting operator probabilities in genetic algorithms.
%      Third International Con-ference on Genetic Algorithms (1989).
%
%   See also AUTOMATICOPERATORPROBS
%
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

% the interval for mapping credit:
minamount=0;
maxamount=100;
nochildrenamount=200;

% initialize credit list:
numops=length(params.operatornames);
credit.amount=zeros(1,numops);
credit.nchildren=zeros(1,numops);

% fill credit list:
for i=1:length(state.adaptwindow)
   opnum=isoperator(params.operatornames,state.adaptwindow(i).op);
   if opnum
      credit.nchildren(opnum)=credit.nchildren(opnum)+1;
      credit.amount(opnum)=credit.amount(opnum)+state.adaptwindow(i).credit;
      % it is possible to sum -Inf credit, so deal with it:
      if (isinf(credit.amount(opnum)) || (isnan(credit.amount(opnum))))
         %'Inf or NaN credit - corrected'
         if params.lowerisbetter
            credit.amount(opnum)=exp(709); % highest integer exponential before Inf
         else
            credit.amount(opnum)=-exp(709); % highest integer exponential before Inf
         end
      end % if isinf || isnan
   end % if opnum
end

% calculate new probabilities:
if sum(credit.amount)~=0

   % first divide credit of each operator by number of children produced by it:
   credit.amount(find(credit.nchildren~=0))=credit.amount(find(credit.nchildren~=0))./credit.nchildren(find(credit.nchildren~=0));
   
   % scale credit amounts so we don't have negatives:
	if min(credit.amount(find(credit.nchildren~=0)))==max(credit.amount(find(credit.nchildren~=0)))
      credit.amount=ones(1,length(credit.amount))*nochildrenamount; % we don't want scale to issue an error...
	else
      credit.amount(find(credit.nchildren~=0))=scale(credit.amount(find(credit.nchildren~=0)),[min(credit.amount(find(credit.nchildren~=0))),max(credit.amount(find(credit.nchildren~=0)))],[minamount,maxamount]);
      credit.amount(find(credit.nchildren==0))=ones(1,length(credit.amount(find(credit.nchildren==0))))*nochildrenamount;
	end
   
   % calculate new probabilities:
   sumcredit=sum(credit.amount);
   sumprobs=sum(state.operatorprobs);
   baseprob=(1-params.percentchange).*(state.operatorprobs./sumprobs);   
   probadapt=params.percentchange.*(credit.amount./sumcredit);
   newprob=(baseprob+probadapt).*sumprobs;
   
   % replace old with new probabilities:
   % (making sure the lowest is not lower than minprob/numops of sum(newprob))
   
   indlower=find(newprob<params.minprob*sum(newprob));
   % (the indices where the probability is lower than it should)
   indgood=find(newprob>=params.minprob*sum(newprob));
   % (the other indices)
   sumindgood=sum(newprob(indgood));
   % (sum of the elements which are not lower than they should)
   nindlower=length(indlower);
   % (number of elements which are lower than they should)
   newprob(indlower)=(params.minprob*sumindgood)/(numops-(params.minprob*nindlower));
   % all the lower probabilities were set to x, where
   % x/(sumindgood+nindlower*x)=minprob/numops
   
   state.operatorprobs=normalize(newprob,1); % normalizing
   
end


