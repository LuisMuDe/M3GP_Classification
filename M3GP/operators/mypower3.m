function y=mypower3(x1)
%Protected power function for cubic power.


y=x1.^3;
y(find(isnan(y) | isinf(y) | imag(y)))=0;
% y(find(isnan(y) || isinf(y) || ~isreal(y)))=0;