function margin_error = find_error(actual_angles,motor_angles) 
    margin_error = false;
    for k = 1:5
        if (abs(motor_angles(k) - actual_angles(k))) < 0.05
            margin_error = false;
        
        else
            margin_error = true;
        end
    end
end