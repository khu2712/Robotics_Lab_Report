function final_soln = findOptimalsoln(x,y,z,phi,theta_5)
    solns = JointAngles_of_arm(x,y,z,phi)
    solns(1,:) = real(solns(1,:));
    solns(2,:) = real(solns(2,:));
    solns(3,:) = real(solns(3,:));
    solns(4,:) = real(solns(4,:));
  
    for i=1:4
        solns(1,i) = mod(solns(1,i)+pi,2*pi)-pi;
        solns(2,i) = mod(solns(2,i)+pi,2*pi)-pi;
        solns(3,i) = mod(solns(3,i)+pi,2*pi)-pi;
        solns(4,i) = mod(solns(4,i)+pi,2*pi)-pi;
    end
    arb = Arbotix('port', 'COM21', 'nservos', 5);

    actual_loc = arb.getpos();
    actual_loc(1) = actual_loc(1) + pi/2;
    actual_loc(2) = actual_loc(2) + pi/2;

    variation_sum = 0;
    var_lst = [];
    
    for i=1:4
        variation_sum=abs(solns(i,1)-actual_loc(1))+ abs(solns(i,2)-actual_loc(2)) + abs(solns(i,3)-actual_loc(3)) + abs(solns(i,4)-actual_loc(4));
        var_lst(i)=variation_sum;
        variation_sum=0;
    end
    
    final_soln_pos = find(min(var_lst));
    final_soln = solns(final_soln_pos,:)
    
end