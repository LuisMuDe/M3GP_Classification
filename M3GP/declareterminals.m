function declareterminals(X,Y,path)
%DECLARETERMINALS Declare terminals from dataset
% according with its partitions.
%
%   DECLARETERMINALS(DATA,NAME,PATH)
%
%   Input arguments:
%      DATA - Training Dataset
%      NAME  - Validation Dataset
%      PATH  - Test Dataset
%
%   Output arguments:
% 
%
%  @authors: Enrique Naredo and Leonardo Trujillo
%  @university: Instituto Tecnol�gico de Tijuana
%  @date: November-2013

% build terminals from X matrix
for k=1:size(X,2)
  % declare terminals (X1,...,Xn)
  eval(strcat('X',num2str(k),'=X(:,k);'))
end
% clear unnecessary variables
clear X k
% save on path
save(strcat(path,'terminals.mat'))
