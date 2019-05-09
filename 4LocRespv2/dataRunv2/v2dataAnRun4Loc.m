
%let's try this again

function v2dataAnRun4Loc

%skip sj 1, 2, 3, 5, 8

sjRange=[9,11,13,15:22,24:28,31,32,35,37:44,46,47,49,51:63,65:72,74:81,83,84,87,91,93:96,98,99];

dumpSub=1;

if dumpSub==1
    load('dumpSub.mat')
    for a=1:size(dumpSub,2)
    sjRange=sjRange(sjRange~=dumpSub(a));
    sjRange=sjRange;
    end
end

for sj=1:size(sjRange,2)
    
    sjNum=sjRange(1,sj);
    
    loadFile=['/Users/dannytoomey/Documents/Research/ADTask/Experiments/ADTaskPilot/4LocRespv2/4LocRespv2Data/sj' sprintf('%02d',sjNum)];
    saveFile='/Users/dannytoomey/Documents/Research/ADTask/Experiments/ADTaskPilot/4LocRespv2/dataRunv2/';

    sjInfo=[loadFile '_SubjectInfo.mat'];
    load(sjInfo);
    
    lowLoad=[loadFile '_allLowTaskFile.mat'];
    medLoad=[loadFile '_allMedTaskFile.mat'];
    highLoad=[loadFile '_allHighTaskFile.mat'];
    
    numTask=2;
    numCue=2;
    blockTrials=6;
    
    CBOrder=[1  2   2   2   1   1
             1  1   2   2   2   1
             1  1   1   2   2   2];
         
    
    lowTaskOrder=CBOrder(1,taskCBOrder);
    medTaskOrder=CBOrder(2,taskCBOrder);
    highTaskOrder=CBOrder(3,taskCBOrder);
    
    v2lowAn4loc(sjNum,lowTaskOrder,lowLoad,numTask,numCue,blockTrials,saveFile);
    v2medAn4Loc(sjNum,medTaskOrder,medLoad,numTask,numCue,blockTrials,saveFile);
    v2highAn4Loc(sjNum,highTaskOrder,highLoad,numTask,numCue,blockTrials,saveFile);
    
end

%v2dataGraph4Loc(sjRange);
v1Kanalysis3(sjRange)
analyzeDiv2(sjRange)
analyzeANT2(sjRange,['sj' sprintf('%d',min(sjRange)) '-sj' sprintf('%d',max(sjRange))])
correlate4loc(sjRange,dumpSub);

return