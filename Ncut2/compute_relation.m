function W = compute_relation(data,scale_sig,height_sig,ins_sig,exp_sig,order)
%
%      [W,distances] = compute_relation(data,scale_sig) 
%       Input: data= Feature_dimension x Num_data
%       ouput: W = pair-wise data similarity matrix
%              Dist = pair-wise Euclidean distance
%
%
% Jianbo Shi, 1997 
%       添加Z方向权重，强度权重，可选择先验权重CHM未完善

% disp('开始计算权重W')
%% 水平权重 Sig=1.35
distances = zeros(length(data),length(data));
for j = 1:length(data)
  distances(j,:) = (sqrt((data(1,:)-data(1,j)).^2 +...
                (data(2,:)-data(2,j)).^2));
end

% distances = X2distances(data');

if (~exist('scale_sig'))
    scale_sig = 0.05*max(distances(:));
end
scale_sig = 1.35;

if (~exist('order'))
  order = 2;
end

tmp1 = (distances/scale_sig).^order;

clear distances

%% Z方向权重 Sig=11
distances = zeros(length(data),length(data));
for j = 1:length(data)
    distances(j,:)=abs(data(3,:)-data(3,j));
end

if (~exist('height_sig'))
    height_sig = 0.05*max(distances(:));
end
height_sig = 11;

if (exist('order'))
  order = 2;
end

tmp2 = (distances/height_sig).^order;
clear distances

%% Intensity权重 Sig=0.5
distances = zeros(length(data),length(data));
for j = 1:length(data)
    distances(j,:)=abs(data(4,:)-data(4,j));
end

if (~exist('ins_sig'))
    ins_sig = 0.5;
end

if (exist('order'))
  order = 2;
end

tmp3 = (distances/ins_sig).^order;
clear distances

%% G先验Stem位置权重 Sig=3.5
% distances = zeros(length(data),length(data));
% for i = 1:length(data)
%     for j = 1:length(data)
%         %计算到分水岭区域一个stem位置，若有两个stem，Sig=0.7
%     end
% end

%% W计算
W = exp(-tmp1-tmp2-tmp3);
% disp('权重W计算完成')
