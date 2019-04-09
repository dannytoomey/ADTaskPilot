% for sub = [1 2 3 4 5 6 7 8 9 10 12 13 14 15 16 17 18 19];
subList = [8];
for sub = 1:length(subList)
    subid = subList(:,sub);
    fid = sprintf('%d_ColorK1.mat',subid);
    load(fid)
    data = [stim.setSize;stim.change;stim.accuracy];
    fid = sprintf('%d_ColorK2.mat',subid);
    load(fid)
    data2 = [stim.setSize;stim.change;stim.accuracy];

    alldata = [data data2]';

    setsize8present = [];
    setsize8absent = [];
    for i = 1:length(alldata)
        if alldata(i,1) == 8 && alldata(i,2) == 1
            setsize8present = [setsize8present;alldata(i,3)];
        elseif alldata(i,1) == 8 && alldata(i,2) == 2
            setsize8absent = [setsize8absent;alldata(i,3)];
        end
    end

    hits = mean(setsize8present);
    FA = 1 - mean(setsize8absent);
    k = 8*(hits-FA)/1-FA;

    if sub == 1
        allK = zeros(length(subList), 1);
    end
    allK(sub,1) = k;

end