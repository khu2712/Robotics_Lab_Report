function final_soln = findOptimalsoln(x,y,z,phi)
    solns = JointAngles_of_arm(x,y,z,phi)
    arb = Arbotix('port', 'COM17', 'nservos', 5);

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
    setPosition(final_soln);
end