function res = viscircles(varargin)
	select length(varargin)
		case 02 then
			res = il2mat(raw_viscircles(mat2il(varargin(01)),varargin(02)))
		else
			error(39)
	end
endfunction
