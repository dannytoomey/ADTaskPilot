
%data analyis runfile

sjRange=input('Input Subjects ');

for sj=1:size(sjRange,2)

    sjNum = sjRange(1,sj);
    
    loadPath='/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/ADTaskv2/data/ADTaskv2Data/';
    savePath='/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/ADTaskv2/data/dataRun/';
    
    if sjNum<10
        fileLoad = [loadPath 'sj0' sprintf('%d',sjNum) '_' 'SubjectInfo.mat'];
        fileName = ['sj0' sprintf('%d',sjNum)];
    else
        fileLoad = [loadPath 'sj' sprintf('%d',sjNum) '_' 'SubjectInfo.mat'];
        fileName = ['sj' sprintf('%d',sjNum)];
    end
    load(fileLoad);

    taskOrder = condCBOrder;
    cbOrder = taskCBOrder;

    lowLoad = [loadPath sprintf('%s',fileName) '_' 'allLowTaskFile.mat'];
    medLoad = [loadPath sprintf('%s',fileName) '_' 'allMedTaskFile.mat'];
    highLoad = [loadPath sprintf('%s',fileName) '_' 'allHighTaskFile.mat'];

    numTask=2;
    numCue=2;
    blockTrials=6;
    
    save('dataInfo.mat','sjNum','numTask','numCue','blockTrials','taskOrder','cbOrder','savePath','lowLoad','medLoad','highLoad');

    lowAn(sjNum)
    medAn(sjNum)
    highAn(sjNum)
    
end

