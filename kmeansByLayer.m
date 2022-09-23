function [Dstem6,Dstem15,Ncluster6,Ncluster15] = kmeansByLayer(hBase6,hBase15,lR6,lR15,nR6,nR15)
%分层聚类函数+RANSAC
%% 预处理
iteration = 4;
m = 3;
% a=rand(300,3,1);
% b=pcKmeans(a,iteration,m);
%% 6号区域  ROI6
%经验值
n=28;
classR6=zeros(0,n);
centerR6=zeros(1,3,m,n);
%高效聚类pcKmeans
%当该层的点数小于聚类数量m时center会出现NaN
for i=1:n
    layerData=lR6(1:nR6(i),:,i);
    [newClassLabel] = pcKmeans(layerData,iteration,m);
    for j=1:length(newClassLabel)
        classR6(j,i)=newClassLabel(j);
    end
    for j=1:m
        rc=find(newClassLabel==j);
        center=mean(layerData(rc,:));
        centerR6(:,:,j,i)=center;
    end
end
%逐层合并
mergeClass6=zeros(0,3,m);
preClass=[n-1,m];
for i=1:n-1
    centerBtn=centerR6(:,:,:,i);
    centerTop=centerR6(:,:,:,i+1);
    euDis=zeros(m,m);
    for j=1:m
        for k=1:m
            dis=(centerBtn(1,1,j)-centerTop(1,1,k))^2+(centerBtn(1,2,j)- ...
                centerTop(1,2,k))^2+(centerBtn(1,3,j)-centerTop(1,3,k))^2;
            euDis(j,k)=sqrt(dis);
        end
    end
    [~,idx]=min(euDis,[],2);
    %合并
%     for j=1:m
%         idx2=find(idx==j);
%         if ~isnan(idx2)
%             tmp=[centerBtn(:,:,idx2); centerTop(:,:,idx(j))];
%             mergeClass6()
%             preClass(i,j)=j;
%         end
%     end
end
%% 未完成部分
Dstem6=1;
Dstem15=1;
Ncluster6=1;
Ncluster15=1;
end
