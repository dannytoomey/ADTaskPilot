
%data analyis runfile

sjNum = input('Input sjNum ');
taskOrder = input('Input sj task order ');
cbOrder = input('Input sj CBO ');

fileLoad = ['sj' sprintf('%d',sjNum) '_' 'SubjectInfo.mat'];
load(fileLoad);

file = '/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/data/';
fileName = ['sj' sprintf('%d',sjNum)];
filePath = [file sprintf('%s',fileName)];
dotLoad = [sprintf('%s',fileName) '_' 'allDotTaskFile.mat'];
neutralLoad = [sprintf('%s',fileName) '_' 'allNeutralTaskFile.mat'];
stroopLoad = [sprintf('%s',fileName) '_' 'allStroopTaskFile.mat'];

numTask = 2;
numCue = 2;

save('dataInfo','sjNum','numTask','numCue','taskOrder','cbOrder','filePath','fileName','dotLoad','neutralLoad','stroopLoad');

dotAL(sjNum)
neutralAL(sjNum)
stroopAL2(sjNum)

