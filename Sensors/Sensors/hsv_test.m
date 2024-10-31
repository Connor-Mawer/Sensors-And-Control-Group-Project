clear all
close all

% Load the ROS bag (remember to update the file path as necessary)
bag = rosbag('C:\Users\lachr\OneDrive - UTS (1)\UTS 2024 Sem2 Spring\41014 Sensors and Control for Mechatronics Systems\Project\color_image.bag');

% Read the first depth image message
depthImg = select(bag, 'Topic', '/camera/depth/image_rect_raw');
first_depth_img = readMessages(depthImg, 1);

% Read the first RGB image message
img = select(bag, 'Topic', '/camera/color/image_raw/compressed');
first_rgb_img = readMessages(img, 5);

% Convert messages to image matrices
img = readImage(first_rgb_img{1});
d_img = double(readImage(first_depth_img{1})); % Convert depth image to double for processing

% Convert RGB image to HSV for red masking
hsvImg = rgb2hsv(img);

% Define thresholds for red hue, saturation, and brightness
hueLow = 0.0;
hueHigh = 0.05;
hueHigh2 = 1.0;
hueLow2 = 0.95;
satLow = 0.5;
valLow = 0.2;

% Create a binary mask for red regions
mask1 = (hsvImg(:,:,1) >= hueLow & hsvImg(:,:,1) <= hueHigh);
mask2 = (hsvImg(:,:,1) >= hueLow2 & hsvImg(:,:,1) <= hueHigh2);
mask = (mask1 | mask2) & (hsvImg(:,:,2) >= satLow) & (hsvImg(:,:,3) >= valLow);

% Apply the mask to the depth image
masked_depth = d_img;
masked_depth(~mask) = NaN; % Set non-red areas to NaN to ignore them

% Determine the approximate depth of the top face
min_depth = nanmin(masked_depth(:)); % Minimum depth value within the masked region
depth_range = 0.02; % Adjust this value as needed to capture the full top face

% Create a mask for the top face within the depth range
top_face_mask = masked_depth >= (min_depth - depth_range) & masked_depth <= (min_depth + depth_range);

% Find the centroid of the top face region
top_stats = regionprops(top_face_mask, 'Area', 'Centroid');
if isempty(top_stats)
    error('No top region detected');
end

% Select the largest connected component as the top face
[~, idx] = max([top_stats.Area]);
center = top_stats(idx).Centroid;

% Convert the centroid to integer pixel values
x = round(center(1));
y = round(center(2));
depth = d_img(y, x); %ISSUE HERE --- NAN or 0 error


%https://github.com/IntelRealSense/realsense-ros/issues/709
% RealSense D435i camera intrinsic parameters
fx = 611.82763671875; % Focal length in pixels
fy = 611.438232421875; % Focal length in pixels
cx = 323.9910583496094; % Principal point x-coordinate
cy =  232.9442901611328; % Principal point y-coordinate

% Calculate 3D coordinates in the camera frame - from quiz 1
X = (x - cx) * depth / fx;
Y = (y - cy) * depth / fy;
Z = depth; % Z-coordinate corresponds to depth

% Display the 2D and 3D coordinates
disp(['Center of top face (2D): (', num2str(x), ', ', num2str(y), ')']);
disp(['3D coordinates of top face in the camera frame: (', num2str(X), ', ', num2str(Y), ', ', num2str(Z), ')']);

% Draw a marker on the RGB image at the detected top face center
img_with_marker = insertMarker(img, [x, y], 'x', 'Color', 'red', 'Size', 10);

% Normalize depth image to displayable range (0 to 255) for visualization
depth_display = uint8((d_img / max(d_img(:))) * 255);

% Draw the same marker on the depth image at the detected point
depth_with_marker = insertMarker(depth_display, [x, y], 'x', 'Color', 'red', 'Size', 10);

% Display the RGB image with the marker
figure;
subplot(1, 2, 1);
imshow(img_with_marker);
title('RGB Image with Center of Top Face Marked');

% Display the Depth image with the marker
subplot(1, 2, 2);
imshow(depth_with_marker);
title('Depth Image with Center of Top Face Marked');
