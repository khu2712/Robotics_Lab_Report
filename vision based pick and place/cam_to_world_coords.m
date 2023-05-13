function [world_coords] = cam_to_world_coords(cam_coords) 
    cam_coords % for checking
    % defining camera parameters
    fx = 1400;fy = 1400;
    u0 = 932;
%     u0 = 1920/2;
     v0 = 526;
%     v0 = 1080/2;
    s = 0;

    Intrinsic_trans = [fx s u0 ; 0 fy v0 ; 0 0 1];
    % array to store (x,y) of world coords
    world_coords = zeros(2,length(cam_coords));
    Z_c = 660;
    % looping over cube (x,y) to transform the coordinates to real world
    for k = 1:length(cam_coords)
       pts_transformed_in_cam = inv(Intrinsic_trans)*[cam_coords{k}(1);cam_coords{k}(2);1]*660;
       pts_transformed_in_cam =[pts_transformed_in_cam;1];
       zc = 660;
       R_T_W = [1 0 0 0;
        0 -1 0 0;
        0 0 -1 zc;
        0 0 0 1];
       final_ = R_T_W*pts_transformed_in_cam;
       world_coords(1,k) = final_(1);
       world_coords(2,k) = final_(2);
   end

end

%     Trans_1 = [1.0000   -0.0033    0.0013    0.0257;
%         0.0033    1.0000   -0.0025    0.0013;
%         -0.0013    0.0025    1.0000    0.0041;
%         0         0         0    1.0000];
%     
%     Trans_2 = [1409 0 305.31;
%         0 1409 533.06;
%         0 0 1];
%     length(cam_coords)
%     Z_c = 660;
%     R_rw = [1, 0, 0; 
%         0, -1, 0; 
%         0, 0, -1];
%     
%     T_rw = [1, 0, 0, 0; 
%             0, -1, 0, 0; 
%             0, 0,-1, Z_c; 
%             0, 0, 0 1];
%     Transfomation = Trans_2*Trans_1*T_rw;
%     world_coords = zeros(2,length(cam_coords));
%     for k = 1:length(cam_coords)
%         P_CF = [cam_coords{k}(1); cam_coords{k}(2); Z_c;1];
%         P_RW = Transfomation*P_CF
%         world_coords(1,k) = P_RW(1,1);
%         world_coords(2,k) = P_RW(2,1)+15;
%     end