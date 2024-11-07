function moveFromP1toP2(P1,P2)
%A function for moving a Dobot magician to a specific location, picking up
%and then dropping off. 
    dobot = DobotMagicianRealMove();

    rot = [0,0,0]; %rotation matrix for rotation of end effector (ignore if using suction cup); 
    dobot.PublishEndEffectorPose([P1(1),P1(2),P1(3)+0.1],rot);
    pause(3);
    dobot.PublishEndEffectorPose(P1,rot);

    pause(3);
    onOff = 1;
    openClose = 1;
    dobot.PublishToolState(onOff,openClose);
    pause(0.3);
    dobot.PublishEndEffectorPose([P1(1),P1(2),P1(3)+0.1],rot);
    pause(3);
    dobot.PublishEndEffectorPose([P2(1),P2(2),P2(3)+0.1],rot);
    pause(3);

    dobot.PublishEndEffectorPose(P2,rot);
    pause(3);
    onOff = 0;
    openClose = 0;
    dobot.PublishToolState(onOff,openClose);
    pause(0.3);
    dobot.PublishEndEffectorPose([P2(1),P2(2),P2(3)+0.1],rot);


end