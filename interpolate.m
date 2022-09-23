function [Xj,Nchmx,Nchmy,Nchmz,NRPtcXs,NRPtcYs,NRPtcXm,NRPtcYm] = interpolate(Nx,Ny,NRHp,NRGp,mode)
%双线性/线性插值网格
%   Nchm=Nx*Ny网格
[a,b,~]=size(NRHp);
NRHp2=zeros(0,3);
NRGp2=zeros(0,3);
for i=1:a
    for j=1:b
        NRHp2=[NRHp2;NRHp(i,j,1),NRHp(i,j,2),NRHp(i,j,3)];
        NRGp2=[NRGp2;NRGp(i,j,1),NRGp(i,j,2),NRGp(i,j,3)];
    end
end

Xj=NRHp2;
%Xj(:,3)=Xj(:,3)-NRGp2(:,3);
% [~,idx]=max(Xj(:,1));
% for i=1:a
%     if Xj(a,1)==0
%         Xj(a,:)=Xj(idx,:);
%     end
% end
tx=sort(Xj(:,1));
ty=sort(Xj(:,2));
NRPtcXs = tx(4);
NRPtcYs = ty(4);
NRPtcXm = max(Xj(:,1));
NRPtcYm = max(Xj(:,2));
stridex = (NRPtcXm - NRPtcXs)/Nx;
stridey = (NRPtcYm - NRPtcYs)/Ny;
%     F = griddedInterpolant(Xj(:,1),Xj(:,2),Xj(:,3));
% Xj(:,3)=NRHp2(:,3)-NRGp2(:,3);
if mode==0

    [Nchmx,Nchmy] = meshgrid(NRPtcXs:stridex:NRPtcXm,NRPtcYs:stridey:NRPtcYm);
    Nchmz=griddata(Xj(:,1),Xj(:,2),Xj(:,3),Nchmx,Nchmy);
%     XIntCHM = F(Nchmx,Nchmy);
%     figure;
%     mesh(Nchmx,Nchmy,Nchmz);
%     hold on
%     plot3(Xj(:,1),Xj(:,2),Xj(:,3))
%     xlim([NRPtcXs,NRPtcXm])
%     ylim([NRPtcYs,NRPtcYm])
else 
    mode=0;
end
end