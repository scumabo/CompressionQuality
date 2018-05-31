function ranks = nnz2ranks_tucker(I1,I2,I3,nnz)
    k = I1+I2+I3;
    nnz;
    sqrt(27*nnz^2+4*k^3)/(2*3^(3/2));
    ranks = (sqrt(27*nnz^2+4*k^3)/(2*3^(3/2))+nnz/2)^(1/3)-k/(3*(sqrt(27*nnz^2+4*k^3)/(2*3^(3/2))+nnz/2)^(1/3));
end