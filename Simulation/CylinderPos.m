classdef CylinderPos
    properties
        position      % 1x3 array storing the position of the cylinder
        objectHandle  % Handle to the 3D object in the simulation
    end
    
    methods
        function obj = CylinderPos(position)
            % Constructor: Initializes a cylinder at a specified position
            obj.position = position;
            obj.objectHandle = PlaceObject('RedCylinder.ply', position);
        end
        
        function moveTo(obj, newPosition)
            % Update position and move cylinder to new location
            delete(obj.objectHandle);  % Remove old object
            obj.position = newPosition;
            obj.objectHandle = PlaceObject('RedCylinder.ply', newPosition);
        end
        
        function deleteCylinder(obj)
            % Delete the cylinder from the environment
            delete(obj.objectHandle);
        end
    end
end
