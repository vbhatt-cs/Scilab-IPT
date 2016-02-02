//Author Priyanka Hiranandani NIT Surat 
 function[x] = ifft2_ip(A, y, m, n)
         if y==0 then
             [p q z]=size(A); 
         else
             z=size(A);  
         end 
         for i=1:z        
            if y==1 then
              B=double(A(i));
            else
            B=double(A(:,:,i));
            end  
            B=resize_matrix(B,m,n);      
            x(:,:,i)=ifft(B);
         end
endfunction
