function ncutClustering(data)
% 3D归一化切割算法

%% 计算相似（权重）矩阵
W = compute_relation(data);

%% 图分割
nbCluster = 3; %特征向量个数
[NcutDiscrete,~,~] = ncutW(W,nbCluster);

% figure;
% plot(NcutEigenvectors);
% title('Ncut特征向量离散图')

%% 结果可视化
cluster_color = ['rgbmyc'];
figure;
for j=1:size(NcutDiscrete,2)
    id = find(NcutDiscrete(:,j));
    plot3(data(1,id),data(2,id),data(3,id),[cluster_color(j),'s'], 'MarkerFaceColor',cluster_color(j),'MarkerSize',3); 
    hold on; 
end
string=strcat('归一化切割成果图，共计：',num2str(size(NcutDiscrete,2)),'类');
title(string);
hold off; axis image;

