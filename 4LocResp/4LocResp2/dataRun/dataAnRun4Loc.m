
%let's try this again

function dataAnRun4Loc

%don't use sj's 1-3

sjRange=input('Input Subjects ');

for sj=1:size(sjRange,2)
    
    sjNum=sjRange(1,sj);
    
    if sjNum<10
        loadFile=['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/4LocResp/4LocResp/4LocRespData/sj0' sprintf('%d',sjNum)];
        saveFile=['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/4LocResp/4LocResp/dataRun/sj0' sprintf('%d',sjNum)];
    else
        loadFile=['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/4LocResp/4LocResp/4LocRespData/sj' sprintf('%d',sjNum)];
        saveFile=['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/4LocResp/4LocResp/dataRun/sj' sprintf('%d',sjNum)];
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
    
    lowAn4loc;
    medAn4Loc;
    highAn4Loc;
    
end

dataGraph4Loc;

return