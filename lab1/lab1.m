%setup

l1 = 55; %thigh length in cm
l2 = 48; %
n = 20;

R_end = [[roty(-90) zeros(3,1)] ; [0 0 0 1]];
D_end = [[eye(3) [l2;0;0]] ; [0 0 0 1] ];
T_end = D_end*R_end;

DH_list = [ [0      0       pi/2    0]
            [0      pi/2    -pi/2   0]
            [0      -pi/2   0       0]
            [l1     pi/2    0       0]];
%%
%forward kinematics
        
q1_fi = -pi/2;
q2_fi = 2.0*pi/3;
q4_fi = -2.0*pi/3;

qtrack = repmat(DH_list,[1 1 n]);    
for i = 2:n
    qtrack(2,3,i) = qtrack(2,3,i) + 1.0*(i-1)*q2_fi/(n-1);
    qtrack(1,3,i) = qtrack(1,3,i) + 1.0*(i-1)*q1_fi/(n-1);
end

for i = (n/2+1):n
    qtrack(4,3,i) = qtrack(4,3,i) + 1.0*(i-n/2)*q4_fi/(n/2);
end

K = zeros(4,n);
for i = 1:n
    K(:,i) = findEnd( getTrans(qtrack(:,:,i) , R_end),  [0;0;0;1] );
end

P = zeros(4,n);
for i = 1:n
    P(:,i) = findEnd( getTrans(qtrack(:,:,i) , T_end),  [0;0;0;1] );
end

%%
%inverse kinematics
%track to follow
npts = 71;

tx = linspace(0,70,npts);
ty = zeros(1,npts);
tz = linspace(-103,-40,npts);
pts = [tx;ty;tz];

Q_inversed = zeros(4,npts);
%Q_inversed(:,1) = [0.1;0.1;0.1;0.1]; 
for i = 2:npts
    q_temp = Q_inversed(:,i-1);
    s_temp = getTransFromQ(q_temp, T_end)*[0;0;0;1];
    s_diff = pts(:,i)-s_temp(1:3);
    while norm(s_diff) > 0.01
        J = getNormJacob4(q_temp);
        q_temp = q_temp+0.6*J'*s_diff;
        s_temp = getTransFromQ(q_temp, T_end)*[0;0;0;1];
        s_diff = pts(:,i)-s_temp(1:3);
    end
    Q_inversed(:,i) = q_temp;
end
Q_inversed(:,1) = zeros(4,1); 


pts_inv = zeros(4,npts);
for i = 1:npts
    pts_inv(:,i) = getTransFromQ(Q_inversed(:,i), T_end)*[0;0;0;1];
end

%%
%display

% Because that's what line() wants to see    
figure(1);
%plot3(K(1,:), K(2,:), K(3,:),'r'); hold on
% plot3(P(1,:), P(2,:), P(3,:),'b'); hold on
plot3(pts(1,:), pts(2,:), pts(3,:),'b'); hold on
plot3(pts_inv(1,:), pts_inv(2,:), pts_inv(3,:),'g'); hold on
xlabel('x');
ylabel('y');
zlabel('z');
%axis equal

figure(2);
plot(1:npts, pts(1,:)-pts_inv(1,:));