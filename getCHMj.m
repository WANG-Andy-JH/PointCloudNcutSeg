function [NR,NRX,NRY,NRPtc,NRHp,NRGp,groundPtc,treePtc] = getCHMj(ptcloud,data,cp)
%ROI细分模块 
%   format long g
%   单元最高点
%   NR单元大小cp^2的个数
%   NRX,NRY，单元行列数量
%   NRHp,NRGp，顶点和地面点
%   groundPtc,treePtc为地面点和树点，为pointCloud格式
%% 测试单元
% fmaclaz = '/Users/wangjinhong/Desktop/tmp/ALS/ALS-on_BR04_2019-07-05_140m.laz'; %if MACOS Linux
% fmactxt = '/Users/wangjinhong/Desktop/tmp/ALS/ALS-on_BR04_2019-07-05_trajectory.txt';
% fwincroplaz = "C:\Users\andy wong\Desktop\论文复现\Cropped.las";
% fpath = fwincroplaz;
% [data,~,~,~] = pcdataread(fpath,1);
% cp = 0.5;

%% 计算
lengthX = max(data(:,1)) - min(data(:,1));
lengthY = max(data(:,2)) - min(data(:,2));

NRX = floor(lengthX/cp)+1;
NRY = floor(lengthY/cp)+1;

NR = NRX*NRY;

%单元格填充装载点云NRPtc（cu版本八叉树sOctree2,radiusSearch）
NRPtc=zeros(0,0,0,3);

%每个单元格最高点NRHp
NRHp=zeros(0,0,3);
%每个单元格最低点NRGp
NRGp=zeros(0,0,3);
% 
% for i=1:NRX
%     for j=1:NRY
%         count=0;
%         NRHz=zeros(0);
%         for m=1:length(data)
%             if (((i-1)*cp+min(data(:,1))<=data(m,1) && data(m,1)<min(data(:,1))+i*cp) && ...
%                     ((j-1)*cp+min(data(:,2))<=data(m,2) && data(m,2)<min(data(:,2))+j*cp))
%                 count=count+1
%                 NRPtc(i,j,k,count)=m;
%                 NRHz(count)=data(m,3);
%             end
%         end
%         %NRHP
%         [zj,I]=max(NRHz);
%         try
%             NRHp(i,j,k,:)= data(NRPtc(i,j,k,I),:)
%         catch
%         end
%     end
%     status=i/NRX
% end
 
%根据效率问题使用KnnSearch
% size(data)        2638216  3
dataTree = data(:,1:2);
NRTree = KDTreeSearcher(dataTree);
% count = 0;
disp('采样率：89%');
for i=1:NR
    r = 0.0429;
    l = r+cp/2;
    pointY = min(data(:,2)) + (floor(i/NRX)+1)*cp - cp/2;
    pointX = min(data(:,1)) + (i - NRX * floor(i/NRX) + 1)*cp - cp/2;
    point = [pointX,pointY];
    point = [point;pointX+l,pointY+l;pointX+l,pointY-l;pointX-l,pointY+l;pointX-l,pointY-l];
    IdxKDT = rangesearch(NRTree,point,cp/2);
    %合并项 
    Idx1 = cell2mat(IdxKDT(1));
    Idx2 = cell2mat(IdxKDT(2));
    Idx3 = cell2mat(IdxKDT(3));
    Idx4 = cell2mat(IdxKDT(4));
    Idx5 = cell2mat(IdxKDT(5));
    Idx = [Idx1,Idx2,Idx3,Idx4,Idx5];

    [~,c]=size(Idx);
    if c>0
%         count = count +1;   
        % 从(1,1)开始
        for j=1:c
            NRPtc(floor(i/NRX)+1,i - NRX * floor(i/NRX) + 1,j,:)=data(Idx(j),1:3);
        end
        % NRHp
        [~,i1]=max(NRPtc(floor(i/NRX)+1,i - NRX * floor(i/NRX) + 1,:,3));
        NRHp(floor(i/NRX)+1,i - NRX * floor(i/NRX) + 1,:)=NRPtc(floor(i/NRX)+1,i - NRX * floor(i/NRX) + 1,i1,1:3);
        % NRGp
        [~,i2]=min(NRPtc(floor(i/NRX)+1,i - NRX * floor(i/NRX) + 1,:,3));
        NRGp(floor(i/NRX)+1,i - NRX * floor(i/NRX) + 1,:)=NRPtc(floor(i/NRX)+1,i - NRX * floor(i/NRX) + 1,i2,1:3);
    end
end
% s = size(NRHp(:,:,1))
% a=NRHp(:,:,1)
% ma=max(NRHp(:,:,1))
% mb=min(NRHp(:,:,1)) 输出71*71行列
% b=NRHp(:,:,2)
% a=NRPtc(1:10,1:10,1:10,1)
% b=NRPtc(:,:,:,2)
%% 地面点分离
referenceVector = [0,0,1];
maxAngularDistance = 15;
maxDistance = 0.15;
[~,inlierIndices,outlierIndices] = pcfitplane(ptcloud,...
            maxDistance,referenceVector,maxAngularDistance);
groundPtc = select(ptcloud,inlierIndices);
treePtc = select(ptcloud,outlierIndices);
% figure;
% pcshow(groundPtc)
% figure;
% pcshow(treePtc)

% 法向量重新估计
% [~,n] = pcpca(groundPtc.Location);
% [r,~]=find(n(:,3)==1);
% n2x=mean(n(r,1));
% n2y=mean(n(r,2));
% referenceVector = [n2x,n2y,1];
% [~,inlierIndices,outlierIndices] = pcfitplane(ptcloud,...
%             maxDistance,referenceVector,maxAngularDistance);
% groundPtc = select(ptcloud,inlierIndices);
% treePtc = select(ptcloud,outlierIndices);
% figure;
% pcshow(groundPtc)
% figure;
% pcshow(treePtc)
% nrgp=size(NRGp)
% nrptc=size(NRPtc)
end


% size(IdxKDT)
% data2=zeros(0,3);
% count = 0;
% for i=1:length(data)
%     if ( data(i,1) - min(ptCloud.Location(:,1))>20 && data(i,1) - min(ptCloud.Location(:,1))<30 && ...
%             data(i,2) - min(ptCloud.Location(:,2))>20 && data(i,2) - min(ptCloud.Location(:,2))<30 && ...
%             data(i,3) - min(ptCloud.Location(:,3))>20 && data(i,3) - min(ptCloud.Location(:,3))<30)
%         count=count+1;
%         data2(count,:)=data(i,:);
%     end
% end
% treeCutPtc=pointCloud(data2);
% 
% pcwrite(treeCutPtc,'treeCut','PLYFormat','binary');

