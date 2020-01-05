function [output] = mfunction(x, h)
len_x = length(x);
len_h = length(h);
len = len_x + len_h -1;
temp = zeros(1,len_x);
temp(1:len_h) = h;
h = temp;
X = fft(x,len);
H = fft(h,len);
Y = X.*H;
y = ifft(Y);
output = y; 
end