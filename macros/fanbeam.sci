//Author: Varun Bhatt
//
//Fanbeam function produces fanbeam data (sinogram) from an image.
//
//Input parameters:
//I - Input image. Should be numeric or boolean matrix.
//D - Distance (pixels) from the fanbeam vertex to centre of rotation (which is centre pixel of the image).
//    It should be such that the vertex remains outside when the image is rotated.
//    
//Optional input parameters:
//FanSensorGeometry - Should be "arc" or "line". 
//                    "Arc" places sensors equally along an arc. (default)
//                    "Line" places sensors equally along a line which makes an angle
//                    with the x-axis equal to the current rotation angle.
//                    
//FanSensorSpacing - Scalar specifying the distance between sensors (default value 1)
//                   For "arc" it is the angle (in degrees) between two sensors.
//                   For "line" it is the linear distance.
//                   
//FanRotationIncrement - Scalar specifying the increment in the rotation angle (in degrees) per step.
//                       (Default value is 1).
//    
//Output:
//F - Each column contains fanbeam sensor data at a particular angle. The columns span 360 degrees.
//    Each row corresponds to a particular sensor. Number of sensors is such that the whole image 
//    is covered for all rotation angles. It depends on fan sensor geometry and spacing.
//    Accuracy in the values of F depends on the parameters used.
//obeta - Location of fanbeam sensors used.
//        For "arc" it is the angles at which sensors are placed.
//        For "line" it is the postion on line corresponding to the rotation angle.
//otheta - Rotation angles where sampling is done.

function [F,obeta,otheta]=fanbeam(varargin)
    narg=argn(2);
    if(narg<2 | narg>8) then
        error("Invalid input. 2 to 8 parameters required.");
    end
    
    if(modulo(narg,2)~=0) then
        error("Invalid number of arguments.");
    end
        
    I=varargin(1);
    d=varargin(2);
    
    if(type(I)~=1 & type(I)~=4) then //Not numerical or boolean matrix
        error("Invalid image type.");
    end
    
    if(~isscalar(d) | d<0) then
        error("Invalid distance.");
    end
    
    //Default values of the optional parameters.
    fanSensorGeometry="arc";
    fanSensorSpacing=1;
    fanRotationIncrement=1;
    
    //Parse the optional arguments if present.
    for i=3:2:(narg-1)
        select varargin(i)
        case "FanSensorGeometry" then
            if(varargin(i+1)=="arc") then
                fanSensorGeometry="arc";
            elseif(varargin(i+1)=="line") then
                fanSensorGeometry="line";
            else
                error("Invalid fan sensor geometry. Should be line or arc.");
            end
        case "FanSensorSpacing" then
            if(isscalar(varargin(i+1))) then
                fanSensorSpacing=varargin(i+1);
            else
                error("Invalid value of fan sensor spacing. Should be a scalar.");
            end
        case "FanRotationIncrement" then
            if(isscalar(varargin(i+1))) then
                fanRotationIncrement=varargin(i+1);
            else
                error("Invalid value of fan rotation increment. Should be a scalar.");
            end
        end
    end
    
    P=radon(I,0:0.5:179.5); //Radon transform of I.
    
    [F,obeta,otheta]=para2fan(P,d,"FanSensorGeometry",fanSensorGeometry,"FanSensorSpacing",fanSensorSpacing,"FanRotationIncrement",fanRotationIncrement);
endfunction
