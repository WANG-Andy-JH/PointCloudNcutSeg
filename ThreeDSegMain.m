function ThreeDSegMain
%% BRIEF
%纯CPU程序，处理176704样本点分割单木
%耗时状况：35s
%% 程序流程
% getCHMj
% interpolate
% smooth
% threeDwatershed
% detectStem
%% 预设定
format long g
addpath(genpath('.\Ncut2'));
addpath(genpath('./Ncut2'));
%% ROI显示模块
fwinlaz = "C:\Users\andy wong\Desktop\论文复现\ALS\ALS-on_BR04_2019-07-05_140m.laz";
fmaclaz = '/Users/wangjinhong/Desktop/tmp/ALS/ALS-on_BR04_2019-07-05_140m.laz'; %if macOS&Linux
fmactxt = '/Users/wangjinhong/Desktop/tmp/ALS/ALS-on_BR04_2019-07-05_trajectory.txt';
fwincroplaz = "C:\Users\andy wong\Desktop\论文复现\Cropped.las"; %35*35 Cropped
fpath = fwincroplaz;
%点云格式读取
step=1;
[data,ptcloud,~,~] = pcdataread(fpath,step);
%txt格式读取有序点云mac
% pcshow(data);
disp('ROI显示模块：完成')
%% getCHMj树冠高程模型模块
cp = 0.5;
[NR,NRX,NRY,NRPtc,NRHp,NRGp,groundPtc,treePtc] = getCHMj(ptcloud,data,cp);
disp('getCHMj树冠高程模型模块：完成')
%% interpolate网格插值模块
mode=0;
Nx=NRX*4;
Ny=NRY*2;
[Xj,Nchmx,Nchmy,Nchmz,NRPtcXs,NRPtcYs,NRPtcXm,NRPtcYm] = interpolate(Nx,Ny,NRHp,NRGp,mode);
disp('interpolate网格插值模块：完成')
%% smooth高程模型平滑模块
[ZIntCHM] = smooth(Nchmz,NR);
% figure;
% mesh(Nchmx,Nchmy,ZIntCHM);
% hold on
% plot3(Xj(:,1),Xj(:,2),Xj(:,3))
% xlim([NRPtcXs,NRPtcXm])
% ylim([NRPtcYs,NRPtcYm])
disp('smooth高程模型平滑模块：完成')
%% threeDwatershed点云分水岭处理模块
[PStemCHM,Lrange] = threeDwatershed(Nchmx,Nchmy,ZIntCHM);
% figure;
% pcshow(PStemCHM,'black','BackgroundColor',[1,1,1])
% hold on
% pcshow(data,'g','BackgroundColor',[1,1,1]);
% hold off
disp('threeDwatershed点云分水岭处理模块：完成')
%% detectStem裁剪分水岭分类区域并提取树模块
[ROI6,ROI6Stem,ROI15,ROI15Stem] = detectStem(cp,step,treePtc,Nchmx,Nchmy,PStemCHM,Lrange);
% figure;
% pcshow(ROI6,'g','BackgroundColor',[1,1,1])
% hold on
% pcshow(ROI15,'yellow','BackgroundColor',[1,1,1])
% hold on
% pcshow(ROI6Stem,'black','BackgroundColor',[1,1,1])
% hold on
% pcshow(ROI15Stem,'black','BackgroundColor',[1,1,1])
% hold off
% 输出ROI模块
% a=pointCloud(ROI6);
% pcwrite(a,'ROI6.ply','Encoding','binary');
disp('detectStem裁剪分水岭分类区域并提取树模块：完成')
%% ROIProcessing获取分层及hBase参数模块
[hBase6,hBase15,gNp6,gNp15,lR6,lR15,nR6,nR15] = ROIProcessing(ROI6,ROI15);
disp('ROIProcessing获取分层及hBase参数模块：完成')
%% kmeansByLayer分层聚类模块
% [Dstem6,Dstem15,Ncluster6,Ncluster15] = kmeansByLayer(hBase6,hBase15,lR6,lR15,nR6,nR15);
disp('kmeansByLayer分层聚类模块：未完成编辑')
%% normalizedCutSegmentation正则化切割模块 
normalizedCutSegmentation(ROI6,ROI15);
disp('normalizedCutSegmentation正则化切割模块：完成')
end