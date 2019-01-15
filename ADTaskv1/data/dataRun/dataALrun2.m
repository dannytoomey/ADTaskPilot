
%data analyis runfile

sjStart=input('Input first subject ');
sjEnd=input('Input last subject ');
sjRange=sjStart:sjEnd;

for sj=1:size(sjRange,2)

    sjNum = sjRange(1,sj);

    fileLoad = ['sj' sprintf('%d',sjNum) '_' 'SubjectInfo.mat'];
    load(fileLoad);

    taskOrder = condCBOrder;
    cbOrder = taskCBOrder;

    file = '/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/data/';
    fileName = ['sj' sprintf('%d',sjNum)];
    filePath = [file sprintf('%s',fileName)];
    dotLoad = [sprintf('%s',fileName) '_' 'allDotTaskFile.mat'];
    neutralLoad = [sprintf('%s',fileName) '_' 'allNeutralTaskFile.mat'];
    stroopLoad = [sprintf('%s',fileName) '_' 'allStroopTaskFile.mat'];

    numTask = 2;
    numCue = 2;

    save('dataInfo','sjNum','sjRange','numTask','numCue','taskOrder','cbOrder','filePath','fileName','dotLoad','neutralLoad','stroopLoad');

    dotAL2(sjNum)
    neutralAL2(sjNum)
    stroopAL2(sjNum)
    
end

