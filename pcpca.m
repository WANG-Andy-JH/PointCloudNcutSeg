function [normE,n] = pcpca(pcdata)
%PCA特征
%法向量（特征向量）提取
kdtree = KDTreeSearcher(pcdata);%default 'euclidean' distance      
normE=[];
n=[];
for i=1:length(pcdata)
    p_cur = pcdata(i,:);
    [index, ~] = knnsearch(kdtree, p_cur, 'K', 10);    %寻找当前点最近的10个点
    p_neighbour = pcdata(index,:);
    p_cent = mean(p_neighbour);     %得到局部点云平均值，便于计算法向量长度和方向
    
    %最小二乘估计平面
    X=p_neighbour(:,1);
    Y=p_neighbour(:,2);
    Z=p_neighbour(:,3);
    %得到平面法向量 refer to https://blog.csdn.net/qq_36686437/article/details/109521404
    XY=X'*Y;
    X2=X'*X;
    XX=sum(X);
    Y2=Y'*Y;
    YY=sum(Y);
    XZ=X'*Z;
    YZ=Y'*Z;
    ZZ=sum(Z);
    tmp=[X2,XY,XX;XY,Y2,YY;XX,YY,10];
    a=inv(tmp)*[XZ;YZ;ZZ];
    %局部平面指向局部质心的向量
    dir1 = p_cent-p_cur';
    %局部平面法向量
    dir2=[a(1) a(2) -1];
    
    %计算两个向量的夹角
    ang = sum(dir1.*dir2) / (sqrt(dir1(1)^2 +dir2(1)^2) + sqrt(dir1(2)^2 +dir2(2)^2)+sqrt(dir1(3)^2 +dir2(3)^2) );
    
    %根据夹角判断法向量正确的指向
    flag = acos(ang);
    dis = norm(dir1);
    if flag<0
        dis = -dis;
    end
    
    %画出当前点的表面法向量
    t=(0:dis/10000:dis/100)';
    x = p_cur(1) + a(1)*t;
    y = p_cur(2) + a(2)*t;
    z = p_cur(3) + (-1)*t;
    normE =[normE;x,y,z];
    t=dis;
    xt=p_cur(1) + a(1)*t;
    yt=p_cur(2) + a(2)*t;
    zt=p_cur(3) + a(3)*t;
    nt=[xt,yt,zt];
    dt=sqrt(dot(nt,nt));
    xt=xt./dt;
    yt=yt./dt;
    zt=zt./dt;
    n=[n;xt,yt,zt];
end

