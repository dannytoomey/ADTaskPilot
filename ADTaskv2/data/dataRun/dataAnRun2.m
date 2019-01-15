
%let's try this again

function dataAnRun2

sjRange=input('Input Subjects ');

for sj=1:size(sjRange,2)
    
    sjNum=sjRange(1,sj);
    
    if sjNum<10
        loadFile=['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/ADTaskv2/data/ADTaskv2Data/sj0' sprintf('%d',sjNum)];
        saveFile=['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/ADTaskv2/data/dataRun/sj0' sprintf('%d',sjNum)];
    else
        loadFile=['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/ADTaskv2/data/ADTaskv2Data/sj' sprintf('%d',sjNum)];
        saveFile=['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/ADTaskv2/data/dataRun/sj' sprintf('%d',sjNum)];
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
    
    lowAn2;
    medAn2;
    highAn2;
    
end

dataGraph2;

return