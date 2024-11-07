clear all;
clc;
close all;
rosshutdown;
% Start Dobot Magician Node
rosinit('192.168.27.1');

% Start Dobot ROS
dobot = DobotMagicianRealMove();

% Test Motion


poseA = [0.22,0.01,-0.062];
poseB= [0.17,-0.15,-0.06];
rot = [0,0,0];
%dobot.PublishEndEffectorPose(poseA,rot);
moveFromP1toP2(poseA,poseB);
