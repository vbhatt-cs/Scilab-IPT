function res = imfindcircles(varargin)
	select length(varargin)
		case 03 then
			res = il2mat(raw_imfindcircles(mat2il(varargin(01)),varargin(02),varargin(03)))
		else
			error(39)
	end
endfunction
