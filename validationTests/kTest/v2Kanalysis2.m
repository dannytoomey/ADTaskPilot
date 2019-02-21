
%what does this do???? maybe write something that shows accuracy and rt
%with different set sizes? can be used to calculate one measure of wm?

subList = 99;
numBlocks = 1:2;
for sub = 1:length(subList)
    for block = 1:length(numBlocks)
    subid = subList(:,sub);
    fid = sprintf('%d_ColorK%d.mat',subid, numBlocks(block));
    load(fid)
    data = [stim.setSize;stim.change;stim.accuracy];
%     fid = sprintf('%d_ColorK2.mat',subid);
%     load(fid)
%     data2 = [stim.setSize;stim.change;stim.accuracy];
%     fid = sprintf('%d_ColorK3.mat',subid);
%     load(fid)
%     data3 = [stim.setSize;stim.change;stim.accuracy];
%     fid = sprintf('%d_ColorK4.mat',subid);
%     load(fid)
%     data4 = [stim.setSize;stim.change;stim.accuracy];
%     fid = sprintf('%d_ColorK5.mat',subid);
%     load(fid)
%     data5 = [stim.setSize;stim.change;stim.accuracy];
%     fid = sprintf('%d_ColorK6.mat',subid);
%     load(fid)
%     data6 = [stim.setSize;stim.change;stim.accuracy];
%     fid = sprintf('%d_ColorK7.mat',subid);
%     load(fid)
%     data7 = [stim.setSize;stim.change;stim.accuracy];
%     fid = sprintf('%d_ColorK8.mat',subid);
%     load(fid)
%     data8 = [stim.setSize;stim.change;stim.accuracy];
%     fid = sprintf('%d_ColorK9.mat',subid);
%     load(fid)
%     data9 = [stim.setSize;stim.change;stim.accuracy];
%     fid = sprintf('%d_ColorK10.mat',subid);
%     load(fid)
%     data10 = [stim.setSize;stim.change;stim.accuracy];
    if block ==1
        alldata = [data];
    else
        alldata = [alldata data];
    end
    end
   % alldata = [data data2 data3 data4 data5 data6 data7 data8 data9 data10]';

    setsize8present = [];
    setsize8absent = [];
    for i = 1:length(alldata)
        if alldata(1, i) == 2||3 && alldata(2, i) == 1
            setsize8present = [setsize8present;alldata(3, i)];
        elseif alldata(1, i) == 2||3 && alldata(2, i) == 2
            setsize8absent = [setsize8absent;alldata(3, i)];
        end
    end

    hits = mean(setsize8present);
    FA = 1 - mean(setsize8absent);
    k = 6*(hits-FA)/1-FA;

    if sub == 1
        allK = zeros(length(subList), 1);
    end
    allK(sub,1) = k;
    
    setsize4present = [];
    setsize4absent = [];
    for i = 1:length(alldata)
        if alldata(1, i) == 1 && alldata(2, i) == 1
            setsize4present = [setsize4present;alldata(3, i)];
        elseif alldata(1, i) == 1 && alldata(2, i) == 2
            setsize4absent = [setsize4absent;alldata(3, i)];
        end
    end

    hits = mean(setsize4present);
    FA = 1 - mean(setsize4absent);
    k4 = 4*(hits-FA)/1-FA;

    if sub == 1
        allK4 = zeros(length(subList), 1);
    end
    allK4(sub,1) = k4;

    
end