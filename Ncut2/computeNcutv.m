function [ncut,nbCluster] = computeNcutv(data, nbCluster)
%计算单次Ncut值  弃用！！！ 错误算法
%   nbCluster=2
W = compute_relation(data);
[NcutDiscrete,~,~] = ncutW(W,2);
for i=1:size(W,1)
    W(i,i)=0;
end
[L,~] = computeL(W);
% h=computeH(D);
L=full(L);
[V,D] = eig(L);
%寻找第二小特征值
[~,ind]=sort(diag(D));
h=V(:,ind(2));
ncut=h'*L*h;
%判定是否继续切
if ncut<0.05
    %% A
    nbCluster = nbCluster+1;
    ida = find(NcutDiscrete(:,1));
    idb = find(NcutDiscrete(:,2));
    if length(ida)>length(idb)
        id=ida;
    else
        id=idb;
    end
    A=[data(1,id);data(2,id);data(3,id);ones(1,length(id))];
    [~,nbCluster] = computeNcutv(A,nbCluster);
    % WA = compute_relation(A);
    % %归一化
    % WA = stretch(WA,0,1);
    % [L,D] = computeL(WA);
    % h=computeH(D);
    % ncutA=h'*L*h;
    % if ncutA>2
    %     a=1
    %     [A,~] = computeNcutv(A);
    % end
    %% B
    % ida = find(NcutDiscrete(:,1));
    % idb = find(NcutDiscrete(:,2));
    if length(ida)<length(idb)
        id=ida;
    else
        id=idb;
    end
    % id = find(NcutDiscrete(:,2));
    B=[data(1,id);data(2,id);data(3,id);ones(1,length(id))];
    [~,nbCluster] = computeNcutv(B,nbCluster);
    % WB = compute_relation(B);
    % WB = stretch(WB,0,1);
    % [L,D] = computeL(WB);
    % h=computeH(D);
    % ncutB=h'*L*h
    % % if ncutB>2
    % %     a=1
    % %     [B,~] = computeNcutv(B);
    % % end
%     LA=length(A)
%     LB=length(B)
%     disp('----------------------')
% else
%     disp('---------end----------')
end
end