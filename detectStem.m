function [ROI6,ROI6Stem,ROI15,ROI15Stem] = detectStem(cp,step,treePtc,Nchmx,Nchmy,PStemCHM,Lrange)
%分水岭切割检测树干算法
%% 切割6号15号标签点 FOR EXAMPLE
%使用kdtree实现快速切割，阈值设定为0.5m CP
%% 预处理
data(:,1)= double(treePtc.Location(1:step:end,1));   %根据图中Location参数 提取所有点的三维坐标 步长n
data(:,2)= double(treePtc.Location(1:step:end,2));
data(:,3)= double(treePtc.Location(1:step:end,3)); 
try 
    data(:,4)=double(treePtc.Intensity(1:step:end));
catch
    data(:,4)=1;
end
treePtc=data;
[rps,~]=size(PStemCHM);
%% 6号区域  ROI6
[rc,cc]=find(Lrange==6);
[n,~]=size(rc);
dataTree=zeros(0,2);
for i=1:n
    dataTree=[dataTree;Nchmx(rc(i),cc(i)),Nchmy(rc(i),cc(i))];
end
detTree=KDTreeSearcher(dataTree);
[rtreePtc,~]=size(treePtc);
ROI6=zeros(0,4);
for i=1:rtreePtc
    point=[treePtc(i,1),treePtc(i,2)];
    [~,dis] = knnsearch(detTree,point,'K',1);
    if dis<cp*2
        ROI6=[ROI6;treePtc(i,:)];
    end
end
ROI6Stem=zeros(0,3);
for i=1:rps
    point=[PStemCHM(i,1),PStemCHM(i,2)];
    [~,dis] = knnsearch(detTree,point,'K',1);
    if dis<cp*2
        ROI6Stem=[ROI6Stem;PStemCHM(i,:)];
    end
end
%% 15号区域  ROI15
[rc,cc]=find(Lrange==15);
[n,~]=size(rc);
dataTree=zeros(0,2);
for i=1:n
    dataTree=[dataTree;Nchmx(rc(i),cc(i)),Nchmy(rc(i),cc(i))];
end
detTree=KDTreeSearcher(dataTree);
[rtreePtc,~]=size(treePtc);
ROI15=zeros(0,4);
for i=1:rtreePtc
    point=[treePtc(i,1),treePtc(i,2)];
    [~,dis] = knnsearch(detTree,point,'K',1);
    if dis<cp*2
        ROI15=[ROI15;treePtc(i,:)];
    end
end
ROI15Stem=zeros(0,3);
for i=1:rps
    point=[PStemCHM(i,1),PStemCHM(i,2)];
    [~,dis] = knnsearch(detTree,point,'K',1);
    if dis<cp*2
        ROI15Stem=[ROI15Stem;PStemCHM(i,:)];
    end
end
end