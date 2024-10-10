
r =DobotMagician();

q = r.model.getpos();
            T1 = r.model.fkine(q)
Obj = [0.1, 0.1,0.1]; 
steps = 100; 

            %-----BRICK NINE MOVEMENT ----- 
            T2 = transl(Obj); %rotate around X axis so that the point of refrence is on the top face (avoids endeffector going "UNDER")                                                      
            q2 = r.model.ikcon(T2);  
            qMatrix = jtraj(q,q2,steps);
            
            for i = 1:steps
                r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end
            q = r.model.getpos();
            disp('Desired Position (end-effector):');
          
            T1 = r.model.fkine(q)