function [ T ] = getTransFromQ( q , T_end )

l1 = 55; %thigh length in cm
l2 = 48; %

DH_list = [ [0      0       pi/2    0]
            [0      pi/2    -pi/2   0]
            [0      -pi/2   0       0]
            [l1     pi/2    0       0]];

for i = 1:4
    DH_list(i,3) = DH_list(i,3) + q(i);
end

T_list = getTrans(DH_list, T_end);
s = size(T_list);

T = eye(4);
for i = s(3):-1:1
    T = T_list(:,:,i)*T;
end

end

