
function v1Kanalysis3(sjRange)

numBlocks = 1:5;
for sub = 1:length(sjRange)
    for block = 1:length(numBlocks)
    subid = sjRange(:,sub);
    load(['/Users/dannytoomey/Documents/Research/ADTask/Experiments/ADTaskPilot/validationTests/kTest/'...
        'sj' sprintf('%d_AllKTaskData.mat',subid)]);
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
        if alldata(1, i) == 3 && alldata(2, i) == 1             %alldata(1,i)=3 means SS 8, alldata(2,i)=1 means this trial is a change trial
            setsize8present = [setsize8present;alldata(3, i)];  %alldata(3,i)=1 means the response was correct on this trial
        elseif alldata(1, i) == 3 && alldata(2, i) == 2
            setsize8absent = [setsize8absent;alldata(3, i)];
        end
    end

    hits = mean(setsize8present);
    FA = 1 - mean(setsize8absent);
    k8 = 8*(hits-FA);   %single probe, so use k = N(h-f), where N is set size, h is hit rate, and f is false alarms   
    
    setsize6present = [];
    setsize6absent = [];
    for i = 1:length(alldata)
        if alldata(1, i) == 2 && alldata(2, i) == 1
            setsize6present = [setsize6present;alldata(3, i)];
        elseif alldata(1, i) == 2 && alldata(2, i) == 2
            setsize6absent = [setsize6absent;alldata(3, i)];
        end
    end

    hits = mean(setsize6present);
    FA = 1 - mean(setsize6absent);
    k6 = 6*(hits-FA); 
    
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
    k4 = 4*(hits-FA);

    avgK=mean([k4/4,k6/6,k8/8])*100;    %average the all scores by % correct so they can be correlated to novel task easier
    
    if subid==101
        avgK=mean([k4/4,k8/8])*100;     %sj 101 had no absent SS 6 for some reason    
    end
    
    allK(1,sub)=avgK;
    
    fname=['kDataSj' sprintf('%02d',min(sjRange)) '-Sj' sprintf('%02d',max(sjRange)) '.mat'];
    save(fname,'allK')
    
end

return
