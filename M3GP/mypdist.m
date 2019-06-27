% @ vijay
% This function is highly specifically written for the following 4 pdist operations:
% 1. pdist(X)
% 2. pdist2(X,Y) where Y X is Observation matrix and Y is a vector of mean values
% 3. pdist(X,'mahalanobis',M)
% 4. pdist2(X,Y,'mahalanobis',M)
function D = mypdist(X,Y,M,C)
[n,~] = size(X);

if nargin == 1 %Euclidean
	length = n*(n-1)/2;
	D = zeros(length,1);
	k=1;
	for i=1:n-1
		for j=i+1:n
			D(k) = sqrt((X(i,:)-X(j,:))*(X(i,:)-X(j,:))');
			k = k+1;
		end
	end
elseif nargin == 2 %Euclidean between a matrix and a vector
	D = zeros(n,1);
	for i = 1:n
		D(i) = sqrt((X(i,:)-Y)*(X(i,:)-Y)');
	end
elseif nargin == 3	%Mahalanobis
	length = n*(n-1)/2;
	D = zeros(length,1);
	k=1;
	for i=1:n-1
		for j=i+1:n
			D(k) = sqrt((X(i,:)-X(j,:))*inv(M)*(X(i,:)-X(j,:))');
			k = k+1;
		end
	end
elseif nargin == 4 %Mahalanobis	between a matrix and a vector
	D = zeros(n,1);
	for i = 1:n
		D(i) = sqrt((X(i,:)-Y)*inv(C)*(X(i,:)-Y)');
	end
end	
