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
    
    if(type(I)~=1) then //Not numerical matrix
        error("Invalid image type.");
    end
    
    if(~isscalar(d) | d<0) then
        error("Invalid distance.");
    end
endfunction
