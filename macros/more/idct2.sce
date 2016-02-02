//Author Priyanka Hiranandani NIT Surat 
function[x] = idct2_ip(A, y, m, n)
         if y==0 then
             [p q z]=size(A); 
         else
             z=size(A); 
         end
         if z<=2 then
            if y==1 then
               A=A(1);
            end            
            A=resize_matrix(A,m,n);      
            x=idct(A);
         else
           disp("error matrix dimension is greater than 2");
         end    
endfunction
