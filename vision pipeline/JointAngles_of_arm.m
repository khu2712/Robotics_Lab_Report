function solns = JointAngles_of_arm(x,y,z,phi)
    d_1 = 4.5;
    a_2 = 10.5;
    a_3 = 10.5;
    a_4 = 8.1;
   
    
    theta_1_a = atan2(y,x);
    theta_1_b = (pi+atan2(y,x));
    
    r = sqrt(x^2 + y^2);
    s = z - d_1;
    
    u = r - a_4*cos(phi);
    v = s - a_4*sin(phi);
    
    beta = acos((-(u^2 + v^2) + a_2^2 + a_3^2)/(2*a_2*a_3));
    d = (a_2^2 + v^2 + u^2 - a_3^2)/ (2 * a_2 * sqrt(v^2 + u^2))%the term in derivation

    alpha = acos(d);
    gamma = atan2(v,u);
    
    theta_2_a = (gamma - alpha);
    theta_2_b = (gamma + alpha);
    
    theta_3_a = (pi-beta);
    theta_3_b = (beta-pi);
    
    theta_4_a = (phi - theta_3_a - theta_2_a);
    theta_4_b = (phi - theta_3_b - theta_2_b);
    
    IK1 = [theta_1_a theta_2_a theta_3_a theta_4_a ];
    IK2 = [theta_1_a theta_2_b theta_3_b theta_4_b ];
    IK3 = [theta_1_b theta_2_a theta_3_a theta_4_a ];
    IK4 = [theta_1_b theta_2_b theta_3_b theta_4_b ];
    solns = [IK1; IK2; IK3; IK4];
end
