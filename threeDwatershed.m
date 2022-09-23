function [PStemCHM,Lrange] = threeDwatershed(Nchmx,Nchmy,ZIntCHM)
%3D分水岭算法
%% 制作深度图像
ZIntCHM(find(isnan(ZIntCHM)==1)) = 270;
rangeImg=ZIntCHM; %stretch(ZIntCHM,0,1);
%% 分水岭算法
Lrange = watershed(rangeImg);
% figure;imshow(Lrange);
%% 提取类
NC=max(max(Lrange));
PStemCHM=zeros(0,3);
for i=1:NC
    [r,c]=find(Lrange==i);
    n=size(r);
    for j=1:n
        zptr(j)=ZIntCHM(r(j),c(j));
    end
    [~,idx]=max(zptr);
    [r,c]=find(ZIntCHM==zptr(idx));
    PStemCHM(i,:)=[Nchmx(r,c),Nchmy(r,c),ZIntCHM(r,c)];
end
end