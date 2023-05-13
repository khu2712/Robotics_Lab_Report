syms theta_1(t) theta_2(t) theta_3(t) theta_4(t)
a = {0 ,11 ,11, 7};
alpha = {pi/2, 0, 0, 0};
d = {4, 0, 0, 0};
thetas = {theta_1, theta_2, theta_3, theta_4};

%Link offset and Link length in cm;
T_01 =[cos(thetas{1}) -sin(thetas{1})*cos(alpha{1}) sin(thetas{1})*sin(alpha{1}) a{1}*cos(thetas{1});
        sin(thetas{1}) cos(thetas{1})*cos(alpha{1}) -cos(thetas{1})*sin(alpha{1}) a{1}*sin(thetas{1});
        0 sin(alpha{1}) cos(alpha{1}) d{1};
        0 0 0 1];

T_12 = [cos(thetas{2}) -sin(thetas{2})*cos(alpha{2}) sin(thetas{2})*sin(alpha{2}) a{2}*cos(thetas{2});
        sin(thetas{2}) cos(thetas{2})*cos(alpha{2}) -cos(thetas{2})*sin(alpha{2}) a{2}*sin(thetas{2});
        0 sin(alpha{2}) cos(alpha{2}) d{2};
        0 0 0 1];

T_23 =  [cos(thetas{3})  -sin(thetas{3})*cos(alpha{3})  sin(thetas{3})*sin(alpha{3})  a{3}*cos(thetas{3});
        sin(thetas{3})  cos(thetas{3})*cos(alpha{3})  -cos(thetas{3})*sin(alpha{3})  a{3}*sin(thetas{3});
        0 sin(alpha{3}) cos(alpha{3}) d{3};
        0 0 0 1];

T_34 = [cos(thetas{4})  -sin(thetas{4})*cos(alpha{4})  sin(thetas{4})*sin(alpha{4})  a{4}*cos(thetas{4});
        sin(thetas{4})  cos(thetas{4})*cos(alpha{4})  -cos(thetas{4})*sin(alpha{4})  a{4}*sin(thetas{4});
        0 sin(alpha{4}) cos(alpha{4}) d{4};
        0 0 0 1];

T_04 = T_01*T_12*T_23*T_34
tempvar = T_04(t);
position = tempvar(1:3, 4)
% To get the Jacobian, take the final position of T04 and differentiate it
% wrt the thetas
Jv = simplify(expand([diff(position,theta1) diff(position,theta2) diff(position,theta3) diff(position,theta4)]))
