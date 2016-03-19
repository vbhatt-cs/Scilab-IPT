//Author: Varun Bhatt
//
//IFanbeam function does an inverse fanbeam transform.
//
//Input parameters:
//F - Fanbeam projection data. Should be numeric matrix.
//D - Distance from fan-beam vertex to the center of rotation that was used to obtain
//    projections (in pixels)
//    (type - positive scalar)
//    
//Optional input parameters: These should be same as the ones used to obtain F.
//FanSensorGeometry - Sensor position
//                    "Arc" places sensors equally along an arc.
//                    "Line" places sensors equally along a line which makes an angle
//                    with the x-axis equal to the current rotation angle.
//                    (default value is "arc")
//
//FanSensorSpacing - Spacing of fan-beam sensors. Its interpretation is based on 
//                   FanSensorGeometry.
//                   For "arc" it is the angle (in degrees) between two sensors.
//                   For "line" it is the linear distance.
//                   (default value is 1)
//                   (type - positive scalar)
//
//FanCoverage - Range of rotation angles used to calculate fan-beam projection data.
//              Should be "cycle" (0 to 360 degrees) or "minimal" (minimum necessary)
//              (default value is "cycle")
//
//FanRotationIncrement - Increment in the rotation angle (in degrees) of fan-beam 
//                       projections.
//                       (default value is 1)
//                       (type - positive scalar)
//              
//Interpolation - Type of interpolation used
//                "nearest" - nearest neighbor
//                "linear" - linear
//                "spline" - piecewise cubic spline
//                (default value is "linear")
//
//Filter, FrequencyScaling, OutputSize - Parameters for iradon function.
//
//Output:
//I - Reconstructed image.
//H - Frequency response of the filter.

function [I,H]=ifanbeam(varargin)
    narg=argn(2);
    if(narg<2 | narg>18) then
        error("Invalid input. 2 to 18 parameters required.");
    end
    
    if(modulo(narg,2)~=0) then
        error("Invalid number of arguments.");
    end
        
    F=varargin(1);
    d=varargin(2);
    
    if(type(F)~=1) then //Not numerical matrix
        error("Invalid fan-beam data.");
    end
    
    if(~isscalar(d) | d<0) then
        error("Invalid distance.");
    end
    
    //Default values of the optional parameters.
    fanSensorGeometry="arc";
    fanSensorSpacing=1;
    fanCoverage="cycle";
    fanRotationIncrement=1;
    interpolation=[];
    rhoFilter=[];
    frequencyScaling=[];
    outputSize=[];
    
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
            
        case "FanCoverage" then
            if(varargin(i+1)=="cycle") then
                fanCoverage="cycle";
            elseif(varargin(i+1)=="minimal") then
                fanCoverage="minimal";
            else
                error("Invalid fan coverage. Should be cycle or minimal.");
            end
            
        case "FanRotationIncrement" then
            if(isscalar(varargin(i+1))) then
                fanRotationIncrement=varargin(i+1);
            else
                error("Invalid value of fan rotation increment. Should be a scalar.");
            end

        case "Interpolation" then
            if(varargin(i+1)=="nearest") then
                interpolation="nearest";
            elseif(varargin(i+1)=="linear") then
                interpolation="linear";
            elseif(varargin(i+1)=="spline") then
                interpolation="spline";
            else
                error("Invalid interpolation argument. Should be nearest, linear, spline or cubic.");
            end
        
        case "Filter" then
            if(varargin(i+1)=="Ram-Lak") then
                rhoFilter="Ram-Lak";
            elseif(varargin(i+1)=="Shepp-Logan") then
                rhoFilter="Shepp-Logan";
            elseif(varargin(i+1)=="Cosine") then
                rhoFilter="Cosine";
            elseif(varargin(i+1)=="Hamming") then
                rhoFilter="Hamming";
            elseif(varargin(i+1)=="Hann") then
                rhoFilter="Hann";
            else
                error("Invalid filter argument. Should be Ram-Lak, Shepp-Logan, Cosine, Hamming or Hann.");
            end
            
        case "FrequencyScaling" then
            if(isscalar(varargin(i+1))) then
                frequencyScaling=varargin(i+1);
            else
                error("Invalid value of frequency scaling. Should be a scalar.");
            end
            
        case "OutputSize" then
            if(isscalar(varargin(i+1))) then
                outputSize=varargin(i+1);
            else
                error("Invalid value of output size. Should be a scalar.");
            end
        end
    end
    
    if(fanCoverage=="minimal" & isempty(fanRotationIncrement)) then
        error("Fan rotation increment is required.");
    end
    
    [P,oploc,optheta]=fan2para(F,d,"FanSensorSpacing",fanSensorSpacing,...
                                "ParallelSensorSpacing",1,...
                                "FanSensorGeometry",fanSensorGeometry,...
                                "Interpolation","spline","FanCoverage",fanCoverage,...
                                "FanRotationIncrement",fanRotationIncrement);
                                
    arg=list(interpolation,rhoFilter,frequencyScaling,outputSize);
    [I,H] = iradon(P,optheta,arg(:));
endfunction
