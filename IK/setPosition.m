% task 8
function errorCode = setPosition(jointAngles)
    %creating a 1's vector to store the thea_scaled values 
    theta_scaled = ones(1,4);
    % points to no error condition
    errorCode = 0;
    % loopong through the inputted joint angles and inserting it to 
    % the theta_scaled vector
    for i=1:4
        % mapping the values between pi and -pi
        theta_scaled(i) = mod(jointAngles(i)+pi, 2*pi) - pi;
        % if the bounds of the inputted theta are exceeded, errorcode=1
        % the program generates the alert of errorcode
        if (theta_scaled(i) < -pi || theta_scaled(i) > pi)
            errorCode = 1;
            disp(errorCode)
            break
        end
    end
    % if the angles inputted are vald
    % removing the offset values as discovered from table 4.2
    if errorCode == 0
        theta_final = ones(1,5);%for final theta without offsets
        theta_final(1) = jointAngles(1) - pi/2; 
        theta_final(2) = jointAngles(2) - pi/2; 
        theta_final(3) = jointAngles(3); 
        theta_final(4) = jointAngles(4);
        % connecting the arm to the laptop
        arb = Arbotix('port', 'COM17', 'nservos', 5);
        % passing the final thetas to the arm with a speed of 120 
        % for each dc motor actuator
        arb.setpos(theta_final, [50, 50, 50, 50, 50]); 
    end
end
