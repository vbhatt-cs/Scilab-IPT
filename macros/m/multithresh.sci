//Function migration (image list to matrix) for: multithresh
//Generated by migrate.cpp
//Author: Anirudh Katoch
function res = multithresh(varargin)
	select length(varargin)
		case 01 then
			res = raw_multithresh(mat2il(varargin(01)))
		case 02 then
			res = raw_multithresh(mat2il(varargin(01)), varargin(02))
		else
			error(39)
	end
endfunction