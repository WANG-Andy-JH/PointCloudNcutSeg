function [h] = computeH(D)
%Ncut求解指标向量
volA = diag(D);
h=1./sqrt(volA);
end