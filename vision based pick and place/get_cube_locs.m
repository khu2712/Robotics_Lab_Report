function coords = get_cubs_locs()
    %% Create all objects to be used in this file
    % Make Pipeline object to manage streaming
    pipe = realsense.pipeline();
    % Make Colorizer object to prettify depth output
    colorizer = realsense.colorizer();
    % Create a config object to specify configuration of pipeline
    cfg = realsense.config();
    
    
    %% Set configuration and start streaming with configuration
    % Stream options are in stream.m
    streamType = realsense.stream('depth');
    % Format options are in format.m
    formatType = realsense.format('Distance');
    % Enable default depth
    cfg.enable_stream(streamType,formatType);
    % Enable color stream
    streamType = realsense.stream('color');
    formatType = realsense.format('rgb8');
    cfg.enable_stream(streamType,formatType);
    
    % Start streaming on an arbitrary camera with chosen settings
    profile = pipe.start();
    
    %% Acquire and Set device parameters 
    % Get streaming device's name
    dev = profile.get_device();    
    name = dev.get_info(realsense.camera_info.name);
    
    % Access Depth Sensor
    depth_sensor = dev.first('depth_sensor');
    
    % Access RGB Sensor
    rgb_sensor = dev.first('roi_sensor');
    
    % Find the mapping from 1 depth unit to meters, i.e. 1 depth unit =
    % depth_scaling meters.
    depth_scaling = depth_sensor.get_depth_scale();
    
    % Set the control parameters for the depth sensor
    % See the option.m file for different settable options that are visible
    % to you in the viewer. 
    optionType = realsense.option('visual_preset');
    % Set parameters to the midrange preset. See for options:
    % https://intelrealsense.github.io/librealsense/doxygen/rs__option_8h.html#a07402b9eb861d1defe57dbab8befa3ad
    depth_sensor.set_option(optionType,9);
    
    % Set autoexposure for RGB sensor
    optionType = realsense.option('enable_auto_exposure');
    rgb_sensor.set_option(optionType,1);
    optionType = realsense.option('enable_auto_white_balance');
    rgb_sensor.set_option(optionType,1);    
    
    %% Align the color frame to the depth frame and then get the frames
    % Get frames. We discard the first couple to allow
    % the camera time to settle
    for i = 1:5
        fs = pipe.wait_for_frames();
    end
    
    % Alignment
    align_to_depth = realsense.align(realsense.stream.depth);
    fs = align_to_depth.process(fs);
    
    % Stop streaming
    pipe.stop();
    
    %% Depth Post-processing
    % Select depth frame
    depth = fs.get_depth_frame();
    width = depth.get_width();
    height = depth.get_height();
    
    % Decimation filter of magnitude 2
    %     dec = realsense.decimation_filter(2);
    %     depth = dec.process(depth);
    
    % Spatial Filtering
    % spatial_filter(smooth_alpha, smooth_delta, magnitude, hole_fill)
    spatial = realsense.spatial_filter(.5,20,2,0);
    depth_p = spatial.process(depth);
    
    % Temporal Filtering
    % temporal_filter(smooth_alpha, smooth_delta, persistence_control)
    temporal = realsense.temporal_filter(.13,20,3);
    depth_p = temporal.process(depth_p);
    
    %% Color Post-processing
    % Select color frame
    color = fs.get_color_frame();    
    
    %% Colorize and display depth frame
    % Colorize depth frame
    depth_color = colorizer.colorize(depth_p);
    
    % Get actual data and convert into a format imshow can use
    % (Color data arrives as [R, G, B, R, G, B, ...] vector)fs
    data = depth_color.get_data();
    img = permute(reshape(data',[3,depth_color.get_width(),depth_color.get_height()]),[3 2 1]);
    
    % Display image
    %imshow(img);
    %title(sprintf("Colorized depth frame from %s", name));
    
    %% Depth frame without colorizing    
    % Convert depth values to meters
    data3 = depth_scaling * single(depth_p.get_data());
    
    %Arrange data in the right image format
    ig = permute(reshape(data3',[width,height]),[2 1]);
    
    % Scale depth values to [0 1] for display
    %figure;
    %imshow(mat2gray(ig)); 
    %% Display RGB frame
    % Get actual data and convert into a format imshow can use
    % (Color data arrives as [R, G, B, R, G, B, ...] vector)fs
    data2 = color.get_data();
    im = permute(reshape(data2',[3,color.get_width(),color.get_height()]),[3 2 1]);
    
    % Display image
    % findng the rgb in binary format
    BW = imbinarize(im);
    
    figure
    imshowpair(im,BW,'montage')
    title("Imbinarize method")
    
    %inverting the colors i.e. white for cubes
    % black for back ground
    
    tmp_img = ~(BW(:,:,1) & BW(:,:,2) & BW(:,:,3));
    
    % finding the blocks with identification of the collection of 1s
    cc4 = bwconncomp(tmp_img,4);
    L4 = labelmatrix(cc4());
    RGB_label = label2rgb(L4,@copper,"c","shuffle");
    
    siz_ = size(cc4.PixelIdxList{1});
    
    % removing the arm
    % looping thru the pixel no in cc4 identified cubes
    % setting threholds to remove unwanted shapes like arm
    % handwriting on the board 
    % the cubes are made white, the rest gets 0 -> blacked
    for k = 1:cc4.NumObjects
        siz_ = size(cc4.PixelIdxList{k});
        if siz_(1) < 500 || siz_(1) > 800
            tmp_img(cc4.PixelIdxList{k}) = 0;
        end
    end
    % displaying the cubes 
    figure;
    imshow(tmp_img)
    title('ONLY BLAKs!')
    
    % finding the color of the blocks
    cc4_ = bwconncomp(tmp_img,4)
    
    % color identify
    % creating arrays for RGB
    red_col = zeros(1,cc4_.NumObjects);
    green_col = zeros(1,cc4_.NumObjects);
    blue_col = zeros(1,cc4_.NumObjects);
    % assigning orig RGB imag to vars
    red_im = im(:,:,1);
    green_im = im(:,:,2);
    blue_im = im(:,:,3);
    % looping thru cubes
    for k = 1:cc4_.NumObjects
        % finding mean threshold of blocks
        % finding R,G,B means of identified blocks
        mean_red_pix = mean(red_im(cc4_.PixelIdxList{k}))
        mean_green_pix = mean(green_im(cc4_.PixelIdxList{k}))
        mean_blue_pix = mean(blue_im(cc4_.PixelIdxList{k}))
        % setting thresholds to seperate cubes by their color comboss
        if mean_red_pix > 65
            red_col(k) = 1;
        end
        if mean_green_pix > 65
            green_col(k) = 1;
        end
        if mean_blue_pix > 67
            blue_col(k) = 1;
        end
    end
    % displaying RGB contents in every block
    red_col
    green_col
    blue_col
    % top face detection
    % depth image form depth code
%     load ig.mat
    % convering distance into cm's
    new_ig = ig*100;
    blank_img = tmp_img;
    blank_img(:,:) = 0;
    % finding max depths of objects from camera
    % neglecting 0 depths which occurs due to noise
    z_val = zeros(1,cc4_.NumObjects);
    for k = 1:cc4_.NumObjects
        non_zero_pix = [];% used for creating histogram
        for j = 1 : length(cc4_.PixelIdxList{k})
            if new_ig(cc4_.PixelIdxList{k}(j)) ~= 0
                non_zero_pix(end + 1) = new_ig(cc4_.PixelIdxList{k}(j));
            end
        end
        % finding histogram to determie the max height from cam to cubes
        non_zero_his = histogram(non_zero_pix,5)
        [maxx_pixels, idx] = max(non_zero_his.Values);
        % setting theshold for the max heights aka depths
        if idx + 2 <= length(non_zero_his.BinEdges)
        max_threshold = non_zero_his.BinEdges(idx+2);
        else
        max_threshold = non_zero_his.BinEdges(idx+1);
        end
        z_val(k) = max_threshold;
        % if the max_threshold height or lesser is met -> top face part
        % thus, that position in the blank_img is turned white
        for j = 1 : length(cc4_.PixelIdxList{k})
            if(new_ig(cc4_.PixelIdxList{k}(j)) <= max_threshold)
                blank_img(cc4_.PixelIdxList{k}(j)) = 1;
            end
        end
    end
    % checking the diff between the top face and the last cubes detected
    % image
    figure;
    imshowpair(tmp_img,blank_img,'montage');
    
    % finding the centroid
    % connected components are discovered using cc4
    cc4_for_cen = bwconncomp(blank_img);
    coords_centroids = zeros(2,cc4_for_cen.NumObjects);% used to store (x,y)
    % iterating thru no of cubess
    for i = 1:cc4_for_cen.NumObjects 
       % formulae to detect col no
       col_ = mod(cc4_for_cen.PixelIdxList{i},480);
       % formulae to detect row no
       row_ = ceil(cc4_for_cen.PixelIdxList{i}/480);
       row_fin = ceil(mean(row_));% taking the max vakue of the mean of the
       % row val
       col_fin = ceil(mean(col_));% taking the max vakue of the mean of the
       % col val
       coords_centroids([1,2],i) = [row_fin,col_fin]; % storing the coords
       % assgning that coord to be as black dot to identify the point on top
       % face
       blank_img(row_fin,col_fin) = 0; 
    end
    % checking the output
    figure;
    imshow(blank_img)
    coords_centroids'
    save tmp1
    
    %% finding real world coords
    X=292;Y=238;
    len = size(coords_centroids)
    for k = 1:len(2)
        coords_centroids(1,k) = coords_centroids(1,k) - X;
        coords_centroids(2,k) = coords_centroids(2,k) - Y;
    end
    coords_centroids
    coords_ = [];
    tmp = coords_centroids'
    for k = 1:len(2)
        coords_{k} = [coords_centroids(1,k),coords_centroids(2,k), z_val(k)*10];
    end

    coords = coords_';
end