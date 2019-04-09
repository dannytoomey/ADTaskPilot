
%what does this do???? maybe write something that shows accuracy and rt
%with different set sizes? can be used to calculate one measure of wm?

subList = [11,13,15:22,24:28,31,32];
numBlocks = 1:5;
for sub = 1:length(subList)
    for block = 1:length(numBlocks)
    subid = subList(:,sub);
    load(['sj' sprintf('%d_AllKTaskData.mat',subid)]);
    data = [allData(block).stim.setSize;allData(block).stim.change;allData(block).stim.accuracy];
        if block ==1
            alldata = data;
        else
            alldata = [alldata data];
        end
    end

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
