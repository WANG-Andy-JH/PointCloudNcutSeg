function normalizedCutSegmentation(ROI6,ROI15)
%3D正则化切割 参考Jitendra Malik, Jianbo Shi UC Berkeley,Normalized-Cuts-and-Image-Segmentation
% 归一化切割分割由几个参数控制，这些参数的值已经在灵敏度分析中优化(见实际应用，分割章节)。
% 首先，将体素的大小vp设为0.5 m。定义计算w(i,j)的最大水平距离的阈值r_XY设为4.5 m。
% 最重要的参数NCut thres控制图G的细分(= cut)，设置为0.16。
% 此外，如果图G的体素数量低于40体素的限制，那么图G就不再细分。
% 采用σ_xy  = 1.35 m、σ_z  = 11.0 m、σ_f  = 0.5 m和σ_G=3.5 m的经验值，控制了影响因子X(i,j)，Z(i,j)，F(i,j)，G(i,j)的影响。
% 当树高大于树冠直径时，σ_z的值大于σ_xy。

% 测试单元
addpath(genpath('.\Ncut2'));
fwincroplaz = "C:\Users\andy wong\Desktop\论文复现\Cropped2.las"; %35*35 Cropped
fpath='ROI6.ply';
[ROI6,~,~,~] = pcdataread(fpath,1);

%% 体素化预处理
vp=0.5;
lengthX = max(ROI6(:,1)) - min(ROI6(:,1));
lengthY = max(ROI6(:,2)) - min(ROI6(:,2));
lengthZ = max(ROI6(:,3)) - min(ROI6(:,3));

NVX = floor(lengthX/vp)+1;
NVY = floor(lengthY/vp)+1;
NVZ = floor(lengthZ/vp)+1;

NV = NVX*NVY*NVZ;
NVXY = NVX*NVY;

dataTree = ROI6(:,1:2);
NRTree = KDTreeSearcher(dataTree);
data=zeros(0,3);

% 体素矩阵，存放体素中心点，使用Kdtree，横向采样率89%，纵向100%
Voxel = zeros(0,3); 
for i=1:NVXY
    r = 0.0429;
    l = r+vp/2;
    pointY = min(ROI6(:,2)) + (floor(i/NVX)+1)*vp - vp/2;
    pointX = min(ROI6(:,1)) + (i - NVX * floor(i/NVX) + 1)*vp - vp/2;
    point = [pointX,pointY];
    point = [point;pointX+l,pointY+l;pointX+l,pointY-l;pointX-l,pointY+l;pointX-l,pointY-l];
    IdxKDT = rangesearch(NRTree,point,vp/2);
    %合并项 
    Idx1 = cell2mat(IdxKDT(1));
    Idx2 = cell2mat(IdxKDT(2));
    Idx3 = cell2mat(IdxKDT(3));
    Idx4 = cell2mat(IdxKDT(4));
    Idx5 = cell2mat(IdxKDT(5));
    Idx = [Idx1,Idx2,Idx3,Idx4,Idx5];

    [~,c]=size(Idx);
    %保存z轴点数量
    count = zeros(1,NVZ);
    if c>0
        % 从(1,1)开始
        for j=1:c
            z = floor(ROI6(Idx(j),3)-min(ROI6(:,3)))/vp+1;
            count(z)=count(z)+1;
            NVPtc(z,count(z),:)=ROI6(Idx(j),:);
        end
        idxz=find(count>0);
        % 求体素均值
        for j=1:length(idxz)
            tmp=zeros(0,3);
            for k=1:count(idxz(j))
                tx=NVPtc(idxz(j),k,1);
                ty=NVPtc(idxz(j),k,2);
                tz=NVPtc(idxz(j),k,3);
                ti=NVPtc(idxz(j),k,4);
                tmp=[tmp;tx,ty,tz,ti];
            end
            if size(tmp,1)==1
                data=[data;tmp];
            else
                data=[data;mean(tmp)];
            end
        end
    end
end

%% 调用
ncutClustering(data');
% ncutClustering(ROI15');
end