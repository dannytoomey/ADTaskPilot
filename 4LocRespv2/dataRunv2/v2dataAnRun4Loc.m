
%let's try this again

function v2dataAnRun4Loc

sjRange=input('Input Subjects ');

for sj=1:size(sjRange,2)
    
    sjNum=sjRange(1,sj);
    
    if sjNum<10
        loadFile=['/Users/dannytoomey/Documents/Research/ADTask/Experiments/ADTaskPilot/4LocRespv2/4LocRespv2Data/sj0' sprintf('%d',sjNum)];
        saveFile=['/Users/dannytoomey/Documents/Research/ADTask/Experiments/ADTaskPilot/4LocRespv2/dataRunv2/sj0' sprintf('%d',sjNum)];
    else
        loadFile=['/Users/dannytoomey/Documents/Research/ADTask/Experiments/ADTaskPilot/4LocRespv2/4LocRespv2Data/sj' sprintf('%d',sjNum)];
        saveFile=['/Users/dannytoomey/Documents/Research/ADTask/Experiments/ADTaskPilot/4LocRespv2/dataRunv2/sj' sprintf('%d',sjNum)];
    end
    
    sjInfo=[loadFile '_SubjectInfo.mat'];
    load(sjInfo);
    
    lowLoad=[loadFile '_allLowTaskFile.mat'];
    medLoad=[loadFile '_allMedTaskFile.mat'];
    highLoad=[loadFile '_allHighTaskFile.mat'];
    
    numTask=2;
    numCue=2;
    blockTrials=6;
    
    if taskCBOrder==1
        lowTaskOrder = 1;
        medTaskOrder = 1;
        highTaskOrder = 1;
    elseif taskCBOrder==2
        lowTaskOrder = 2;
        medTaskOrder = 1;
        highTaskOrder = 1;
    elseif taskCBOrder==3
        lowTaskOrder = 2;
        medTaskOrder = 2;
        highTaskOrder = 1;
    elseif taskCBOrder==4
        lowTaskOrder = 2;
        medTaskOrder = 2;
        highTaskOrder = 2;
    elseif taskCBOrder==5
        lowTaskOrder = 1;
        medTaskOrder = 2;
        highTaskOrder = 2;
    elseif taskCBOrder==6
        lowTaskOrder = 1;
        medTaskOrder = 1;
        highTaskOrder = 2;
    end
    
    save('dataAnFile.mat','sjNum','sjRange','lowTaskOrder','medTaskOrder','highTaskOrder','lowLoad','medLoad','highLoad','loadFile','saveFile','numTask','numCue','blockTrials');
    
    v2lowAn4loc;
    v2medAn4Loc;
    v2highAn4Loc;
    
end

v2dataGraph4Loc;

return