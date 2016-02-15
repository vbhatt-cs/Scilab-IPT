//Author: Varun Bhatt
//
//This function generates head phantom image that can be used to test numerical accuracy of 
//2D reconstruction algorithms. P generally contains one large ellipse and several smaller 
//ellipses of different intensities.
//
//Input parameters:
//def - Specifies the default phantom ("shepp-logan" or "modified shepp-logan") to be used.
//n - A number specifying rows and columns of the image (256x256 by default) 
//E - Custom ellipses that should be used to generate phantom.
//    It should have 6 columns corresponding to intensity, semi major and semi minor axis,
//    x, y offset and rotation angle.
//    
//Output:
//p - The generated phantom image
//ellipse - Ellipses used to generate the phantom.
//
//Examples:
//Modified shepp logan of size 256:
//
//    P=phantom();
//    imshow(P);
//
//Shepp logan of size 400:
//
//    P=phantom("shepp-logan",400);
//    imshow(P);
//    
//Custom ellipse:
//
//    e=[1 0.8 0.6 0 0 0];
//    P=phantom(e,256);
//    imshow(P);
//
//References:
//1) Shepp, Larry; B. F. Logan (1974). "The Fourier Reconstruction of a Head Section". IEEE Transactions on Nuclear Science. NS-21 (3): 21–43.
//2) P. A. Toft, "The Radon Transform, Theory and Implementation", p. 201

endfunction
function [p,ellipse]=phantom(varargin)
    narg=argn(2);
    
    if(narg>2) then
        error("Invalid input. At most 2 parameters required.");
    end
    
    //Default phantoms (taken from references):
    //             A    a     b    x0    y0    phi
    //            ---------------------------------
    shepp_logan=[  1   .69   .92    0     0     0   ;
                 -.98 .6624 .8740   0  -.0184   0   ;
                 -.02 .1100 .3100  .22    0    -18  ;
                 -.02 .1600 .4100 -.22    0     18  ;
                  .01 .2100 .2500   0    .35    0   ;
                  .01 .0460 .0460   0    .1     0   ;
                  .01 .0460 .0460   0   -.1     0   ;
                  .01 .0460 .0230 -.08  -.605   0   ;
                  .01 .0230 .0230   0   -.606   0   ;
                  .01 .0230 .0460  .06  -.605   0   ];
                  
    //                        A    a     b    x0    y0    phi
    //                       ---------------------------------
    modified_shepp_logan = [  1   .69   .92    0     0     0   ;
                            -.8  .6624 .8740   0  -.0184   0   ;
                            -.2  .1100 .3100  .22    0    -18  ;
                            -.2  .1600 .4100 -.22    0     18  ;
                             .1  .2100 .2500   0    .35    0   ;
                             .1  .0460 .0460   0    .1     0   ;
                             .1  .0460 .0460   0   -.1     0   ;
                             .1  .0460 .0230 -.08  -.605   0   ;
                             .1  .0230 .0230   0   -.606   0   ;
                             .1  .0230 .0460  .06  -.605   0   ];

    ellipse=modified_shepp_logan;   //Default phantom
    if(narg==1) then
        arg1=varargin(1);        
        
        if(type(arg1)==10) then //if arg1 is a string
            convstr(arg1,"l");
            if(arg1=="shepp-logan") then
                ellipse=shepp_logan;
            elseif(arg1=="modified shepp-logan") then
                ellipse=modified_shepp_logan;
            else
                error("Wrong type of phantom. It should be Shepp-Logan or Modified Shepp-Logan");
            end
        elseif(size(size(arg1),"*")==2) then //if arg1 is 2D matrix
            if(size(arg1,2)==6) then
                ellipse=arg1;
            else
                error("6 columns should be present in the phantom");
            end
        else
            error("Invalid first input argument");
        end
    end
    
    n=256   //Default n
    if(narg==2) then
        arg2=varargin(2);
        if(isscalar(arg2))
            n=arg2;
        else
            error("Second parameter should be a scalar.")
        end
    end
    
    p=zeros(n,n);
    
    x_sym=((0:n-1)-(n-1)/2)/((n-1)/2);
    x_rel=repmat(x_sym,n,1);  
    y_sym=(x_sym').*(-1);
    y_rel=repmat(y_sym,1,n);  
    
    for i=1:size(ellipse,1)
        A=ellipse(i,1); //Intensity addition
        
        //a,b of ellipse
        a=ellipse(i,2);
        b=ellipse(i,3);
        
        //Offset
        x0=ellipse(i,4);
        y0=ellipse(i,5);
        
        phi=ellipse(i,6)*3.14/180;    //Rotation angle
        
        x=x_rel-x0;
        y=y_rel-y0;
        
        e=((x.*cos(phi)+y.*sin(phi)).^2)./(a^2) + ((y.*cos(phi)-x.*sin(phi)).^2)./(b^2);    //Ellipse equation
        ind=find(e<=1);
        p(ind)=p(ind)+A;    //Adding intensity to the ellipse
    end
    p=p';
endfunction
