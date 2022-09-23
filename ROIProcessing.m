function [hBase6,hBase15,gNp6,gNp15,lR6,lR15,nR6,nR15] = ROIProcessing(ROI6,ROI15)
%分水岭ROI区域分层以及获取hBase
%% 将树点分割为高度l=0.5米的层，计算每层点数nR
l=0.5;
lengthR6=max(ROI6(:,3))-min(ROI6(:,3));
lengthR15=max(ROI15(:,3))-min(ROI15(:,3));
%层数
numR6=floor(lengthR6/0.5)+1;
numR15=floor(lengthR15/0.5)+1;
%创建每层数据集数组 行列层
lR6=zeros(0,3,numR6);
lR15=zeros(0,3,numR15);
%创建储存每层点数数组
nR6=[];
nR15=[];

for i=1:numR6
    tmp=zeros(0,3);
    for j=1:length(ROI6)
        if ROI6(j,3)>=min(ROI6(:,3))+(i-1)*0.5 && ROI6(j,3)<i*0.5+min(ROI6(:,3))
            tmp=[tmp;ROI6(j,:)];
        end
    end
    [c1,~]=size(tmp);
    nR6=[nR6;c1];
    if c1>0
        for k=1:c1
            try
                lR6(k,:,i)=tmp(k,1:3);
            catch
                disp('ROI获取hBase可能出现问题')
            end
        end
    end
end
for i=1:numR15
    tmp=zeros(0,3);
    for j=1:length(ROI15)
        if ROI15(j,3)>=min(ROI15(:,3))+(i-1)*0.5 && ROI15(j,3)<i*0.5+min(ROI15(:,3))
            tmp=[tmp;ROI15(j,:)];
        end
    end
    [c1,~]=size(tmp);
    nR15=[nR15;c1];
    if c1>0
        for k=1:c1
            try
                lR15(k,:,i)=tmp(k,1:3);
            catch
                disp('ROI获取hBase可能出现问题')
            end
        end
    end
end

%% 生成向量Np
Np6=[];
Np15=[];
for i=1:numR6
    Npi6=nR6(i)/length(ROI6);
    Np6=[Np6;Npi6];
end
for i=1:numR15
    Npi15=nR15(i)/length(ROI15);
    Np15=[Np15;Npi15];
end
%% 3*1高斯滤波器平滑
sigma = 1;
gausFilter = fspecial('gaussian', [3,1], sigma);
gNp6= imfilter(Np6, gausFilter, 'replicate');
gNp15= imfilter(Np15, gausFilter, 'replicate');
%% 计算hBase
hIdx6=floor(length(ROI6)*0.015);
hIdx15=floor(length(ROI15)*0.015);
s6=sort(ROI6(:,3));
s15=sort(ROI15(:,3));
hBase6=s6(hIdx6);
hBase15=s15(hIdx15);
end

