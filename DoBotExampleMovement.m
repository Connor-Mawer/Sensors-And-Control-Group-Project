clear all;
clc;
close all;
rosshutdown;
%% Start Dobot Magician Node
rosinit('192.168.27.1');

%% Start Dobot ROS
dobot = DobotMagicianRealMove();

%% Test Motion
%% Publish custom joint target
%Chip Pickup Code
pose = [-0.2,0.2,0.2]
rot = [0,0,0]
dobot.PublishEndEffectorPose(pose,rot);
