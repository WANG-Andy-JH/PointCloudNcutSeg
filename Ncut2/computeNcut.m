function [ncutNum] = computeNcut(L)
%计算ncut值，解算h，为eig(L)特征向量 ncut=h'Lh  弃用，错误算法！！！
%   ncut=h'Lh
L=full(L);
[V,D] = eig(L);
%寻找第二小特征值
[~,ind]=sort(diag(D));
%h为第二小特征对应向量
for i=1:size(diag(D))
    h=V(:,ind(i));
    ncut(i)=h'*L*h;
end
t=2.5;
[ind]=find(ncut<t);
ncutNum=size(ind,2) - 1;
ncut(1:10)
max(ncut)
size(ncut)
end