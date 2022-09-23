function [data,ptcloud,color,type] = pcdataread(fpath,n)
%LAS&LAZ&PCD&PLY point cloud read
%包含Intensity，在data第四维度
try
    lasReader = lasFileReader(fpath); %读入数据 
    ptcloud = readPointCloud(lasReader);
    data(:,1)= double(ptcloud.Location(1:n:end,1));   %根据图中Location参数 提取所有点的三维坐标 步长n
    data(:,2)= double(ptcloud.Location(1:n:end,2));
    data(:,3)= double(ptcloud.Location(1:n:end,3)); 
    try 
        data(:,4)=double(ptcloud.Intensity(1:n:end));
    catch
        disp('无强度参数')
        data(:,4)=1;
    end
    try
        color(:,1)=double(ptcloud.Color(1:n:end,1));
        color(:,2)=double(ptcloud.Color(1:n:end,2));
        color(:,3)=double(ptcloud.Color(1:n:end,3));
        color=stretch(color,0,1);
    catch
        color=1;
    end
    type=1;
catch
    ptcloud = pcread(fpath); %读入数据 
    data(:,1)= double(ptcloud.Location(1:5:end,1));   %根据图中Location参数 提取所有点的三维坐标 步长5
    data(:,2)= double(ptcloud.Location(1:5:end,2));
    data(:,3)= double(ptcloud.Location(1:5:end,3)); 
    try 
        data(:,4)=double(ptcloud.Intensity(1:n:end));
    catch
        data(:,4)=1;
    end
    try
        color(:,1)=double(ptcloud.Color(1:5:end,1));
        color(:,2)=double(ptcloud.Color(1:5:end,2));
        color(:,3)=double(ptcloud.Color(1:5:end,3));
        color=stretch(color,0,1);
    catch
        color=1;
    end
    type=1;
end

