function [newClassLabel] = pcKmeans(layerData,iteration,m)
%针对层点云的水平距离高效k-means聚类算法
%   layerData：每层点云layerData：n*3*1
%   iteration：极大迭代次数
%   m：分类数量

%% 预处理以及种子点
[r,~,~]=size(layerData);
seed1 = zeros(m,2);%迭代前
seed2 = zeros(m,2);%迭代后
seedIdx=[];
for i=1:m
    idxi=round(rand()*r);
    judge = find(seedIdx == idxi);
    if idxi==0
        i = i-1;
        continue;
    end
    %如果已经有这个值了，那么重新循环取值
    if isempty(judge) == 0
        i = i-1;
        continue;
    end
    seedIdx(i)=idxi;
    seed1(i,:)=layerData(idxi,1:2,1);
end
%% 开始迭代
%如果本次分别所有类新得到的像元数目变化在changeThreshold内，则认为分类完毕
% layerTmp = layerData(:,1:2,1);
% layerTree = KDTreeSearcher(layerTmp);
n=1; %当前迭代次数
while 1
    %欧式距离计算 ||X-Mi||^2
    euDisMat=zeros(r,m);
%          [euIdx,euDis] = knnsearch(layerTree,point,'K',r);
    for i=1:r
        for j=1:m
            tmp=(layerData(i,1,1)-seed1(j,1))^2+(layerData(i,2,1)-seed1(j,2))^2;
            euDisMat(i,j)=sqrt(tmp);
        end
    end
    %给给各类别赋值类别标注
    for i=1:r
        currVector = euDisMat(i,:);
        currClass = find(currVector == min(currVector));
        newClassLabel(i) = currClass(1);%找到当前像元与m类中心距离最小的一类 范围是1-m的整数，当存在重复时取第一个
    end
    %计算新的各类别中心
    for i=1:m
        id = find(newClassLabel==i); %按类匹配相同类的元素，得出其在矩阵中坐标
        temp = layerData(id,1:2,1); %通过坐标得出其具体参数
        seed2(i,:)= mean(temp); %找到新的中心点x,y
    end    
    newClassPointNumber = zeros(1,m);
    for i=1:m
        newClassPointNumber(i) = length(find(newClassLabel==i));
    end

   changeThreshold=0.05; %ENVI default 
    if n == 1
        oldClassPointNumber = ones(1,m);
    end
    try
        if max(abs((newClassPointNumber-oldClassPointNumber)./oldClassPointNumber)) < changeThreshold || n>iteration
            break;
        end %结束迭代条件：changeThreshold变化阈值，ENVI中默认为0.05，计算得到的变化阈值小于ENVI标准或者超过迭代次数
    catch
        msgbox('未输入最大迭代次数');
        break;
    end
    n=n+1;
    if max(abs((newClassPointNumber-oldClassPointNumber)./oldClassPointNumber)) > changeThreshold
        oldClassPointNumber = newClassPointNumber;
        seed1 = seed2; %将得到的中心点参数seed2赋给seed1重新开始迭代
        continue;
    end 
end
end