classdef Movement
    properties
        dobot      % Instance of the DobotMagician class
        pauseTime  % Time delay between trajectory steps
        steps      % Number of steps for each trajectory
    end
    
    methods
        function obj = Movement(dobot, pauseTime, steps)
            obj.dobot = dobot;
            obj.pauseTime = pauseTime;
            obj.steps = steps;
        end
        
        function moveCylinder(obj, cylinder, finalPosition)
            % Moves a single cylinder from its current to a final position
            
            % Step 1: Move above the initial cylinder position
            qStart = obj.dobot.model.getpos;
            targetPosRaised = cylinder.position + [0, 0, 0.1]; % Access the position property
            T_targetRaised = transl(targetPosRaised) * troty(pi);
            qTargetRaised = obj.dobot.model.ikcon(T_targetRaised, qStart);
            qMatrixRaised = jtraj(qStart, qTargetRaised, obj.steps);
            obj.animateTrajectory(qMatrixRaised);

            % Step 2: Lower to pick up the cylinder
            T_target = transl(cylinder.position) * troty(pi); % Access the position property
            qTarget = obj.dobot.model.ikcon(T_target, qTargetRaised);
            qMatrix = jtraj(qMatrixRaised(end, :), qTarget, obj.steps);
            obj.animateTrajectory(qMatrix);
            
            % Simulate picking up by deleting the current cylinder position
            cylinder.deleteCylinder();

            % Step 3: Move to the raised final position
            finalPosRaised = finalPosition + [0, 0, 0.1];
            T_finalRaised = transl(finalPosRaised) * troty(pi);
            qTargetFinalRaised = obj.dobot.model.ikcon(T_finalRaised, qTarget);
            qMatrixFinalRaised = jtraj(qTarget, qTargetFinalRaised, obj.steps);
            obj.animateTrajectory(qMatrixFinalRaised);

            % Step 4: Lower to place the cylinder at the final position
            T_final = transl(finalPosition) * troty(pi);
            qTargetFinal = obj.dobot.model.ikcon(T_final, qTargetFinalRaised);
            qMatrixFinal = jtraj(qTargetFinalRaised, qTargetFinal, obj.steps);
            obj.animateTrajectory(qMatrixFinal);

            % Place the cylinder at the new position
            cylinder.moveTo(finalPosition);
        end
    end
    
    methods (Access = private)
        function animateTrajectory(obj, qTraj)
            for j = 1:size(qTraj, 1)
                obj.dobot.model.animate(qTraj(j, :));
                pause(obj.pauseTime);
            end
        end
    end
end
