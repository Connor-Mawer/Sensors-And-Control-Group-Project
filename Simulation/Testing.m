% Define initial positions and final positions
initialPositions = [
    0.1, 0.1, 0.75;
    0.2, 0.15, 0.75;
    0.3, 0.2, 0.75;
    0.4, 0.25, 0.75
];
finalPositions = [
    0.1, 0.3, 0.75;
    0.2, 0.35, 0.75;
    0.3, 0.4, 0.8;
    0.4, 0.45, 0.775
];

% Set workspace limits
xLimits = [-8, 8]; % X-axis limits
yLimits = [-8, 8]; % Y-axis limits
zLimits = [0, 3.5];  % Z-axis limits

axis([xLimits, yLimits, zLimits]);
% Example angles
azimuth = 45;  % View from 45 degrees around the z-axis
elevation = 30; % View from 30 degrees up from the x-y plane

% Set the view
view(azimuth, elevation);

% Instantiate DobotMagician object
dobot = DobotMagician();

% Instantiate Movement class with the Dobot, pause time, and steps
movement = Movement(dobot, 0.01, 50);

% Create Cylinder objects at initial positions
cylinders = arrayfun(@(i) CylinderPos(initialPositions(i, :)), 1:size(initialPositions, 1), 'UniformOutput', false);

% Move each cylinder to its respective final position
for i = 1:length(cylinders)
    movement.moveCylinder(cylinders{i}, finalPositions(i, :));
end
