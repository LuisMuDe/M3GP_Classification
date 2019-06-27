function y=mypower2(x1)
%Protected power function for square power.


y=x1.^2;
y(find(isnan(y) | isinf(y) | imag(y)))=0;
% y(find(isnan(y) || isinf(y) || ~isreal(y)))=0;