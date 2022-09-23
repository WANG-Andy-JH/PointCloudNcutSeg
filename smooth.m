function [ZIntCHM] = smooth(Nchmz,NR)
%观测方程最小二乘平差步骤
%   得到相关矩阵A和B，平滑和正则化
%% Test
% [NR,NRX,NRY,NRPtc,NRHp,NRGp] = getCHMj;
%% getZIntCHMNR
for i=1:NR
    ZIntCHMNR(i)=Nchmz(i);
end
%% 矩阵正则化
ZIntCHM=smoothdata(ZIntCHMNR);
ZIntCHM=smoothdata(Nchmz,'lowess');

end