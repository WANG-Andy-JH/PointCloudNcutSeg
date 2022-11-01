function [ncut,nbCluster] = computeNcutformula(data, nbCluster)
%根据Ncut公式求解二分Ncut值
%   nbCluster=2
W = compute_relation(data);
[NcutDiscrete,~,~] = ncutW(W,2);
%% A and B
ida = find(NcutDiscrete(:,1)==1);
idb = find(NcutDiscrete(:,2)==1);
A=[data(1,ida);data(2,ida);data(3,ida);ones(1,length(ida))];
B=[data(1,idb);data(2,idb);data(3,idb);ones(1,length(idb))];
%% Cut(A,B)
cutab = 0;
for i=1:length(ida)
    for j=1:length(idb)
        cutab = cutab+W(ida(i),idb(j));
    end
end
%% Assoc(A,V)
assocAV = 0;
for i=1:length(ida)
    for j=1:length(ida)
        if i~=j
            assocAV = assocAV+W(ida(i),ida(j));
        end
    end
end
assocAV = cutab+assocAV/2;
%% Assoc(B,V)
assocBV = 0;
for i=1:length(idb)
    for j=1:length(idb)
        if i~=j
            assocBV = assocBV+W(idb(i),idb(j));
        end
    end
end
assocBV = cutab+assocBV/2;
%% Ncut(A,B)
ncut=cutab/assocAV+cutab/assocBV
if ncut > 0.4 || ncut < 0.1
    nbCluster = nbCluster+1;
    [~,nbCluster] = computeNcutformula(A, nbCluster);
    [~,nbCluster] = computeNcutformula(B, nbCluster);
else
    disp('----------end------------')
end
end