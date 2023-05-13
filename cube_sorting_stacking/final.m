red_place = [10, 14, -3]
disp('dekho ye red pixels hone chahiye')
pixelsred = colour_object_detection(1)
pixelsblue = colour_object_detection(2)
pixelsgreen = colour_object_detection(3)
pixelsyellow = colour_object_detection(4)
% pixels = [pixelsred;pixelsblue;pixelsgreen;pixelsyellow]
pixels = pixelsred;
disp('ye size hai')
sizeee= size(pixels)
sizeee(1)
% size of cube is 2.8
for i = 1:sizeee(1)
    real_coo = pixel_coo_to_real([pixels(i,1), pixels(i,2)])
    x = real_coo(1)/10;
    y = real_coo(2)/10; 
    xy_fake = error_fixing(x,y); 
    x1 = xy_fake(1)
    y1 = xy_fake(2)
     
    PickandPlace(x1,y1,-2, -18,0,-3.5+(i)*2.8)
end
pixels = pixelsblue
sizeee= size(pixels)
for i = 1:sizeee(1)
    real_coo = pixel_coo_to_real([pixels(i,1), pixels(i,2)])
    x = real_coo(1)/10;
    y = real_coo(2)/10; 
    xy_fake = error_fixing(x,y); 
    x1 = xy_fake(1)
    y1 = xy_fake(2)
     
    PickandPlace(x1,y1,-2, 0,18,-3.5+(i)*2.8)
end

pixels = pixelsgreen
sizeee= size(pixels)
for i = 1:sizeee(1)
    real_coo = pixel_coo_to_real([pixels(i,1), pixels(i,2)])
    x = real_coo(1)/10;
    y = real_coo(2)/10; 
    xy_fake = error_fixing(x,y); 
    x1 = xy_fake(1)
    y1 = xy_fake(2)
     
    PickandPlace(x1,y1,-2, 0,-18,-3.5+(i)*2.8)
end

pixels = pixelsyellow
sizeee= size(pixels)
for i = 1:sizeee(1)
    real_coo = pixel_coo_to_real([pixels(i,1), pixels(i,2)])
    x = real_coo(1)/10;
    y = real_coo(2)/10; 
    xy_fake = error_fixing(x,y); 
    x1 = xy_fake(1)
    y1 = xy_fake(2) 
    PickandPlace(x1,y1,-2, 18,0,-3.5+(i)*2.8)
end