function [ T ] = getTrans( para_list , T_end )
% get (i-1)T_i list
s = size(para_list);
T = zeros(4,4,s(2)+1);
a = para_list(:,1);
alpha = para_list(:,2);
theta = para_list(:,3);
d = para_list(:,4);

for i = 1:s(2)
    T(:,:,i) = [[cos(theta(i))                  -sin(theta(i))              0               a(i)]
                [sin(theta(i))*cos(alpha(i))    cos(theta(i))*cos(alpha(i)) -sin(alpha(i))  -d(i)*sin(alpha(i))]
                [sin(theta(i))*sin(alpha(i))    cos(theta(i))*sin(alpha(i)) cos(alpha(i))   d(i)*cos(alpha(i))]
                [0                              0                           0               1]];
end

T(:,:,s(2)+1) = T_end;

end

