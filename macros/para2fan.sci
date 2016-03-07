//Author: Varun Bhatt
//
//Para2fan function converts parallel-beam projects to fan-beam.
//    
//Input parameters:
//P - Parallel-beam data. Should be numeric or boolean matrix.
//D - Distance from fan-beam vertex to the center of rotation that was used to obtain
//    projections (in pixels)
//    (type - positive scalar)
//    
//Optional input parameters:
//ParallelSensorSpacing - Spacing of parallel-beam sensors (in pixels)
//                        (default value is 1)
//                        (type - positive scalar)
//
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
//                   (default value is set based on ParallelSensorSpacing)
//                   (type - positive scalar)
//                   
//FanRotationIncrement - Increment in the rotation angle (in degrees) of fan-beam 
//                       projections.
//                       For "cycle" FanCoverage, 360 should be its multiple. 
//                       (default value is equal to parallel-beam rotation angles)
//                       (type - positive scalar)
//                       
//ParallelCoverage - Range of rotation angle of parallel-beam projection data.
//                   Should be "cycle" (360 degrees) or "halfcycle" (180 degrees)
//                   (default value is "halfcycle")
//
//FanCoverage - Range of rotation angles used to calculate fan-beam projection data.
//              Should be "cycle" (0 to 360 degrees) or "minimal" (minimum necessary)
//              (default value is "cycle")
//              
//Interpolation - Type of interpolation used
//                "nearest" - nearest neighbor
//                "linear" - linear
//                "spline" - piecewise cubic spline
//                (default value is "linear")
//                
//Output:
//F - Fan-beam data.
//obeta - Location of fan-beam sensors.
//        For "arc" it is the angles at which sensors are placed.
//        For "line" it is the postion on line corresponding to the rotation angle.
//otheta - Rotation angles.

function [F,ogamma,otheta]=para2fan(varargin)
    narg=argn(2);
    if(narg<2 | narg>16) then
        error("Invalid input. 2 to 16 parameters required.");
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
    parallelSensorSpacing=1;
    fanSensorSpacing=[];
    fanRotationIncrement=[];
    parallelCoverage="halfcycle";
    fanSensorGeometry="arc";
    fanCoverage="cycle";
    interpolation="linear";
    
    //Parse the optional arguments if present.
    for i=3:2:(narg-1)
        select varargin(i)
        case "ParallelSensorSpacing" then
            if(isscalar(varargin(i+1))) then
                parallelSensorSpacing=varargin(i+1);
            else
                error("Invalid value of parallel sensor spacing. Should be a scalar.");
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
            
        case "ParallelCoverage" then
            if(varargin(i+1)=="cycle") then
                parallelCoverage="cycle";
            elseif(varargin(i+1)=="halfcycle") then
                parallelCoverage="halfcycle";
            else
                error("Invalid parallel coverage. Should be cycle or halfcycle.");
            end
            
        case "FanSensorGeometry" then
            if(varargin(i+1)=="arc") then
                fanSensorGeometry="arc";
            elseif(varargin(i+1)=="line") then
                fanSensorGeometry="line";
            else
                error("Invalid fan sensor geometry. Should be line or arc.");
            end
            
        case "FanCoverage" then
            if(varargin(i+1)=="cycle") then
                fanCoverage="cycle";
            elseif(varargin(i+1)=="minimal") then
                fanCoverage="minimal";
            else
                error("Invalid fan coverage. Should be cycle or minimal.");
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
        end
    end
    
    //Checking if d is large enough
    m=size(P,1);
    maxPloc=parallelSensorSpacing*(m-1)/2;
    if(d<maxPloc) then
        error("d is too small");
    end
    
    //Default value of fan sensor spacing
    if(isempty(fanSensorSpacing)) then
        if(fanSensorGeometry=="line") then
            fanSensorSpacing=d*sin(parallelSensorSpacing/d);
        else
            fanSensorSpacing=asin(parallelSensorSpacing/d)*180/%pi;
        end
    end
    
    [m,n]=size(P);
    if(modulo(m,2)==0) then
        P=[zeros(1,n); P];
    end
    
    P=[zeros(1,n); P; zeros(1,n)];
    [m,n]=size(P);
    
    //Making ploc vector
    m2cn=floor((m-1)/2);
    m2cp=floor(m/2);
    ploc=parallelSensorSpacing*(-m2cn:m2cp);
    
    //Making gamma vector
    plocMax=max(ploc);
    plocMin=min(ploc);
    
    if(fanSensorGeometry=="line") then
        //Linear spacing so atan used.
        floc=[plocMin:fanSensorSpacing:plocMax];
        gammaRad=atan(floc/d);
    else
        //Arc spacing so asin used.
        floc=[];
        gammaRad=[asin(plocMin/d):fanSensorSpacing*%pi/180:asin(plocMax/d)];
    end
    gammaDeg=gammaRad*180/%pi;
    
    //Making ptheta vector
    if(parallelCoverage=="cycle") then
        dpthetaDeg=360/n;
    else //Half cycle
        dpthetaDeg=180/n;
    end
    ptheta=dpthetaDeg*(0:n-1);
    
    //Default value of fan rotation increment
    if(isempty(fanRotationIncrement)) then
        fanRotationIncrement=dpthetaDeg;
    end
    
    gammaMax=max(gammaDeg);
    gammaMin=min(gammaDeg);
    
    if(fanCoverage=="minimal") then
        fudge=n*180*%eps;
        thetaDeg=[-gammaMax+fudge:dthetaDeg:180-gammaMin-fudge];
        thetaDegMin=min(thetaDeg);
        thetaDegMax=max(thetaDeg);
        thetaDeg=[thetaDegMin-dthetaDeg thetaDeg thetaDegMax+dthetaDeg];
    else
        if(modulo(360,dthetaDeg)~=0) then
            error("360 should be a multiple of dthetaDeg");
        end
        thetaDeg=0:dthetaDeg:(360-dthetaDeg);
    end
    
    numelGamma=prod(size(gammaDeg));
    
    //Interpolation to get sample locations
    Pint=zeros(numelGamma,n);
    t=d*sin(gammaRad);
    for i=1:prod(size(pthetaDeg))
        Pint(:,i)=interp1(ploc,P(:,i)',t,interpolation)';
    end
    
    //Pad Pint
    if(parallelCoverage=="cycle") then
        Ppad=Pint;
        pthetapad=pthetaDeg;
    else //Extend to make half cycle full cycle
        Ppad=[Pint Pint($:-1:1,:)];
        pthetapad=[pthetaDeg pthetaDeg+180];
    end
    
    gammaRange=gammaMax-gammaMin;
    pthetamask=pthetapad>=(360-gammaRange);
    pthetamask2=pthetapad<=gammaRange;
    Ppad=[Ppad(:,pthetamask) Ppad Ppad(:,pthetamask2)];
    pthetapad=[pthetapad(pthetamask)-360 pthetapad pthetapad(pthetamask2)+360];
    
    //Shift and Interpolate rotation angles
    numelThetaDeg=prod(size(thetaDeg));
    F=zeros(numelGamma,numelThetaDeg);
    for i=1:numelGamma
        F(i,:)=interp1(pthetapad+gammaDeg(i),Ppad(i,:),thetaDeg,interpolation);
    end
    
    if(parallelCoverage=="cycle") then         
        Ppad2=Ppad($:-1:1,:);
        pthetapad2=pthetapad-180;
        theta2=modulo(thetaDeg+180,360)-180;
        
        numelTheta2=prod(size(theta2));
        F2=zeros(numelGamma,numelTheta2);
        for i=1:numelGamma
            F2(i,:)=interp1(pthetapad2+gammaDeg(i),Ppad2(i,:),theta2,interpolation);
        end
        
        F=(F+F2)/2;
    end
    
    otheta=thetaDeg;
    
    if(fanSensorGeometry=="line")
        ogamma=floc;
    else
        ogamma=gammaDeg;
    end
    ogamma=ogamma';
    
    //Set NaN as 0.
    F(isnan(F))=0;
endfunction
