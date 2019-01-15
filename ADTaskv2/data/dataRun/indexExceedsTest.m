
load('/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/ADTaskv2/data/ADTaskv2Data/sj01_allLowTaskFile.mat');

numTask=2;
numCue=2;
numTrials=6;

for task=1:numTask
    for cue=1:numCue
        block1=allLowTask(task).thisTaskData(cue).thisCueCondData(1).thisBlockTrials(numTrials).thisTrialData;
        block2=allLowTask(task).thisTaskData(cue).thisCueCondData(2).thisBlockTrials(numTrials).thisTrialData;
        block3=allLowTask(task).thisTaskData(cue).thisCueCondData(3).thisBlockTrials(numTrials).thisTrialData;
        block4=allLowTask(task).thisTaskData(cue).thisCueCondData(4).thisBlockTrials(numTrials).thisTrialData;
        block5=allLowTask(task).thisTaskData(cue).thisCueCondData(5).thisBlockTrials(numTrials).thisTrialData;
        block6=allLowTask(task).thisTaskData(cue).thisCueCondData(6).thisBlockTrials(numTrials).thisTrialData;
        block7=allLowTask(task).thisTaskData(cue).thisCueCondData(7).thisBlockTrials(numTrials).thisTrialData;
        block8=allLowTask(task).thisTaskData(cue).thisCueCondData(8).thisBlockTrials(numTrials).thisTrialData;
        data = [block1,block2,block3,block4,block5,block6,block7,block8];
        blockWM=allLowTask(task).thisTaskData(cue).thisCueCondData(8).thisBlockWM;
        blockWMload=blockWM(1:5,:);
        blockWMprobe=blockWM(6:10,:);
    end
end