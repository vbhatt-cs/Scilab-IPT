// This file is released under the 3-clause BSD license. See COPYING-BSD.
// Generated by builder.sce : Please, do not edit this file
// ----------------------------------------------------------------------------
//
libskeleton_imagepr_path = get_absolute_file_path('loader.sce');
//
// ulink previous function with same name
[bOK, ilib] = c_link('libskeleton_imageprocessing');
if bOK then
  ulink(ilib);
end
//
list_functions = [ 'raw_dctmtx';
                   'raw_multithresh';
                   'raw_applycform';
                   'raw_blur';
                   'raw_boundingRect';
                   'raw_bwconvhull';
                   'raw_bwdistgeodesic';
                   'raw_bwlookup';
                   'raw_canny';
                   'raw_circle';
                   'raw_clipline';
                   'raw_convexhull';
                   'raw_convmtx2';
                   'raw_copymakeborder';
                   'raw_corner';
                   'raw_cornerEigenValsAndVecs';
                   'raw_cornerHarris';
                   'raw_cornerMinEigenVal';
                   'raw_cvtColor';
                   'raw_demosaic';
                   'raw_dilate';
                   'raw_ellipse';
                   'raw_ellipse2poly';
                   'raw_erode';
                   'raw_fftshift';
                   'raw_fillconvexpoly';
                   'raw_filter2D';
                   'raw_findContours';
                   'raw_fsamp2';
                   'raw_gabor';
                   'raw_gaussianblur';
                   'raw_getStructuringElement';
                   'raw_getTextSize';
                   'raw_getgaussiankernel';
                   'raw_getrectsubpix';
                   'raw_getrotationmatrix2D';
                   'raw_goodfeaturestotrack';
                   'raw_houghcircles';
                   'raw_houghlines';
                   'raw_houghlinesp';
                   'raw_ifftshift';
                   'raw_im2double';
                   'raw_imabsdiff';
                   'raw_imadd';
                   'raw_imattributes';
                   'raw_imboxfilt3';
                   'raw_imcomplement';
                   'raw_imcontour';
                   'raw_imcontrast';
                   'raw_imcrop';
                   'raw_imdivide';
                   'raw_imextendedmax';
                   'raw_imextendedmin';
                   'raw_imfill';
                   'raw_imfindcircles';
                   'raw_imfuse';
                   'raw_imgaborfilt';
                   'raw_imgaussfilt3';
                   'raw_imguidedfilter';
                   'raw_imhmax';
                   'raw_imhmin';
                   'raw_imimposemin';
                   'raw_imlincomb';
                   'raw_immultiply';
                   'raw_impixel';
                   'raw_impyramid';
                   'raw_imread';
                   'raw_imrect';
                   'raw_imresize';
                   'raw_imsharpen';
                   'raw_imshowpair';
                   'raw_imsubtract';
                   'raw_imwarp';
                   'raw_imwrite';
                   'raw_ind2gray';
                   'raw_ind2rgb';
                   'raw_lab2double';
                   'raw_lab2rgb';
                   'raw_lab2uint16';
                   'raw_lab2uint8';
                   'raw_lab2xyz';
                   'raw_laplacian';
                   'raw_line';
                   'raw_medianblur';
                   'raw_montage';
                   'raw_morphologyEx';
                   'raw_ntsc2rgb';
                   'raw_puttext';
                   'raw_pyrDown';
                   'raw_pyrUp';
                   'raw_rectangle';
                   'raw_regionfill';
                   'raw_rgb2lab';
                   'raw_rgb2ntsc';
                   'raw_rgb2xyz';
                   'raw_roifill';
                   'raw_roipoly';
                   'raw_scharr';
                   'raw_sepFilter2D';
                   'raw_sobel';
                   'raw_ssim';
                   'raw_threshold';
                   'raw_undistort';
                   'raw_viscircles';
                   'raw_watershed';
                   'raw_whitepoint';
                   'raw_wiener2';
                   'raw_xyz2double';
                   'raw_xyz2lab';
                   'raw_xyz2rgb';
                   'raw_xyz2uint16';
                   'deconvlucy';
                   'imhistmatch';
                   'graycoprops';
                   'graydiffweight';
                   'decorrstretch';
                   'adaptf';
                   'affine2d';
                   'approxpolyDP';
                   'arclenght';
                   'bilateralfilter';
                   'borderInterpolate';
                   'boxfilter';
                   'contourarea';
                   'boxfilter';
                   'fitellipse';
                   'histeq';
                   'imrotate';
                   'mean1';
                   'minAreaRect';
                   'minimumenclosingcirlce';
                   'pyrMeanShiftFiltering';
                   'rgb2gray';
                   'warpaffine';
];
addinter(libskeleton_imagepr_path + filesep() + 'libskeleton_imageprocessing' + getdynlibext(), 'libskeleton_imageprocessing', list_functions);
// remove temp. variables on stack
clear libskeleton_imagepr_path;
clear bOK;
clear ilib;
clear list_functions;
// ----------------------------------------------------------------------------
