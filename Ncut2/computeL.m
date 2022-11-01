function [L,D] = computeL(W)
%计算归一化拉普拉斯矩阵L
if max(max(abs(W-W'))) > 1e-10 %voir (-12) 
    %disp(max(max(abs(W-W'))));
    error('W not symmetric');
end
n=size(W,1);
dataNcut.offset = 5e-1;
dataNcut.verbose = 0;
dataNcut.maxiterations = 300;
dataNcut.eigsErrorTolerance = 1e-8;
dataNcut.valeurMin=1e-6;
W = sparsifyc(W,dataNcut.valeurMin);
%度矩阵D
d = sum(abs(W),2);
D=spdiags(d,0,n,n);
D2=spdiags(1./sqrt(d),0,n,n);
%拉普拉斯矩阵
Lsub=D-W;

%归一化拉普拉斯矩阵
L=D2*Lsub*D2;
% full(L(1:5,1:5))
end