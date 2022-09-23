function [data] = txtdataread(fpath)
%TXT 有序点云读取
fmactxt = '/Users/wangjinhong/Desktop/tmp/ALS/ALS-on_BR04_2019-07-05_trajectory.txt';
fpath = fmactxt;
fidin=fopen(fpath,'r');
nline=0;
while ~feof(fidin) % 判断是否为文件末尾
    tline=fgetl(fidin); % 从文件读行
    nline=nline+1;
end

fclose(fidin);
end