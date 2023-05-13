function [position_of_endeffector,orientation_of_endeffector] = findPincher(theta_1, theta_2, theta_3, theta_4)
    %Link offset and Link length in cm;
    alpha_1 = pi/2;d_1 = 4;a_1 = 0;
    T_01 = [cos(theta_1) -sin(theta_1)*cos(alpha_1) sin(theta_1)*sin(alpha_1) a_1*cos(theta_1)
        sin(theta_1) cos(theta_1)*cos(alpha_1) -cos(theta_1)*sin(alpha_1) a_1*sin(theta_1)
        0 sin(alpha_1) cos(alpha_1) d_1
        0 0 0 1];
    
    alpha_2 = 0;d_2 = 0;a_2 = 11;
    T_12 = [cos(theta_2) -sin(theta_2)*cos(alpha_2) sin(theta_2)*sin(alpha_2) a_2*cos(theta_2)
        sin(theta_2) cos(theta_2)*cos(alpha_2) -cos(theta_2)*sin(alpha_2) a_2*sin(theta_2)
        0 sin(alpha_2) cos(alpha_2) d_2
        0 0 0 1];
    
    alpha_3 = 0;d_3=0;a_3 = 11;
    T_23 = [cos(theta_3) -sin(theta_3)*cos(alpha_3) sin(theta_3)*sin(alpha_3) a_3*cos(theta_3)
        sin(theta_3) cos(theta_3)*cos(alpha_3) -cos(theta_3)*sin(alpha_3) a_3*sin(theta_3)
        0 sin(alpha_3) cos(alpha_3) d_3
        0 0 0 1];
    
    alpha_4=0;d_4=0;a_4=7;
    T_34 = [cos(theta_4) -sin(theta_4)*cos(alpha_4) sin(theta_4)*sin(alpha_4) a_4*cos(theta_4)
        sin(theta_4) cos(theta_4)*cos(alpha_4) -cos(theta_4)*sin(alpha_4) a_4*sin(theta_4)
        0 sin(alpha_4) cos(alpha_4) d_4
        0 0 0 1];
    T_04 = T_01*T_12*T_23*T_34;
    Final_Expression = vpa(T_04, 5);
    orientation_of_endeffector = round(vpa(Final_Expression(1:3, 1:3), 2));
    position_of_endeffector = round(vpa(Final_Expression(1:3, 4), 2));
end

