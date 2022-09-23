function RGB = stretch(matrix,m,n)
%拉伸图像灰度级。m，n为拉伸范围
[row,column,band] = size(matrix);
RGB = zeros(row,column,band);
for i=1:band
    mat = matrix(:,:,i);
    themax = max(max(mat));
    themin = min(min(mat));
    increment = n/(themax-themin)-m/(themax-themin);
    for j=1:row
        for k = 1:column
            mat(j,k)= (mat(j,k)-themin)*increment;
        end
    end
    RGB(:,:,i) = mat;
end
