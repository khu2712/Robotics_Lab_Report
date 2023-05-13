function determineIntrinsics()
    % Make Pipeline object to manage streaming
    pipe = realsense.pipeline();
    
    % Start streaming on an arbitrary camera with default settings
    profile = pipe.start();

    % Extract the color stream
    color_stream = profile.get_stream(realsense.stream.color).as('video_stream_profile');
    
    % Get and display the intrinsics
    color_intrinsics = color_stream.get_intrinsics()

    % Make Pipeline object to manage streaming
    pipe = realsense.pipeline();
    
    % Start streaming on an arbitrary camera with default settings
    profile = pipe.start();
    
    % Extract the IR stream
    IR_stream = profile.get_stream(realsense.stream.depth).as('video_stream_profile');
    
    % Get and display the intrinsic parameters of the IR stream
    IR_intrinsics = IR_stream.get_intrinsics()


end