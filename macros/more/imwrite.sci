//Function migration (image list to matrix) for: imwrite
//Generated by migrate.cpp
//Author: Anirudh Katoch
function res = imwrite(varargin)
	select length(varargin)
		case 02 then
			res = raw_imwrite(mat2il(varargin(01)), varargin(02))
		else
			error(39)
	end
endfunction