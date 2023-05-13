function pick_place_using_cam(place_coords)
    % finding the coords in cam_frame
    cam_coords = get_cube_locs();

    % finding real-world x,y
    real_world_coords = cam_to_world_coords(cam_coords);

    % now implementing the Pick n Place FSM
    pick_and_place_cube([real_world_coords(1),real_world_coords(2),0,-pi/2,0],place_coords);
end

