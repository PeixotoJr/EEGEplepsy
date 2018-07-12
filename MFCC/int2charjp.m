function P = int2charjp(i)
%INT2CHARJP Summary of this function goes here
%   Detailed explanation goes here

%transforma em char e coloca um ZERO na frente caso seja menor que 10
if i>9     
     P= int2str(i);
     else
     P= char(strcat({'0'},{int2str(i)}));
end
end

