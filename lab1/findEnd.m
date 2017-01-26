function [ P_out ] = findEnd( T, P_in )

P_out = P_in;

s = size(T);
for i = s(3):-1:1
    P_out = T(:,:,i)*P_out;
end

end

