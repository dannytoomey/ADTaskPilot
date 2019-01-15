%data for sj102
%aDT(n) = n task, tTD(n) = 50/100% cue validity, tCD(n) = block, tBT = 8
%every time because (8).thisTrialData has the complete trial data

task = 1;
cue = 1;
blockID = 's102dsesi50';

block1=allDotTask(task).thisTaskData(cue).thisCondData(1).thisBlockTrials(8).thisTrialData;
block2=allDotTask(task).thisTaskData(cue).thisCondData(2).thisBlockTrials(8).thisTrialData;
block3=allDotTask(task).thisTaskData(cue).thisCondData(3).thisBlockTrials(8).thisTrialData;
block4=allDotTask(task).thisTaskData(cue).thisCondData(4).thisBlockTrials(8).thisTrialData;
block5=allDotTask(task).thisTaskData(cue).thisCondData(5).thisBlockTrials(8).thisTrialData;
block6=allDotTask(task).thisTaskData(cue).thisCondData(6).thisBlockTrials(8).thisTrialData;
block7=allDotTask(task).thisTaskData(cue).thisCondData(7).thisBlockTrials(8).thisTrialData;
block8=allDotTask(task).thisTaskData(cue).thisCondData(8).thisBlockTrials(8).thisTrialData;
data = [block1,block2,block3,block4,block5,block6,block7,block8];
el = find(data(8,:));
resps = numel(el);
trials = size(data,2);
errorOm = trials-resps;
rt = zeros(1,trials-errorOm);
for count=1:trials-errorOm
    if data(7,count)==1
        rt(1,count)=data(8,count);
    elseif data(7,count)==2
        rt(1,count)=data(8,count);
    end
end
ac = zeros(1,trials);
for count=1:trials
    if data(7,count)==1
        if data(1,count)==0
            ac(1,count)=1;
        elseif data(2,count)==0
            ac(1,count)=1;
        end
    elseif data(7,count)==2
        if data(3,count)==0
            ac(1,count)=1;
        elseif data(4,count)==0
            ac(1,count)=1;
        end
    else
        ac(1,count)=0;
    end
end
correct = ac == 1;
numCorrect = numel(correct);
accuracy = numCorrect/trials;
meanRT = mean(rt);

save(blockID,'trials','errorOm','numCorrect','accuracy','meanRT');

task = 1;
cue = 2;
blockID = 's102dsesi100';

block1=allDotTask(task).thisTaskData(cue).thisCondData(1).thisBlockTrials(8).thisTrialData;
block2=allDotTask(task).thisTaskData(cue).thisCondData(2).thisBlockTrials(8).thisTrialData;
block3=allDotTask(task).thisTaskData(cue).thisCondData(3).thisBlockTrials(8).thisTrialData;
block4=allDotTask(task).thisTaskData(cue).thisCondData(4).thisBlockTrials(8).thisTrialData;
block5=allDotTask(task).thisTaskData(cue).thisCondData(5).thisBlockTrials(8).thisTrialData;
block6=allDotTask(task).thisTaskData(cue).thisCondData(6).thisBlockTrials(8).thisTrialData;
block7=allDotTask(task).thisTaskData(cue).thisCondData(7).thisBlockTrials(8).thisTrialData;
block8=allDotTask(task).thisTaskData(cue).thisCondData(8).thisBlockTrials(8).thisTrialData;
data = [block1,block2,block3,block4,block5,block6,block7,block8];
el = find(data(8,:));
resps = numel(el);
trials = size(data,2);
errorOm = trials-resps;
rt = zeros(1,trials-errorOm);
for count=1:trials-errorOm
    if data(7,count)==1
        rt(1,count)=data(8,count);
    elseif data(7,count)==2
        rt(1,count)=data(8,count);
    end
end
ac = zeros(1,trials);
for count=1:trials
    if data(7,count)==1
        if data(1,count)==0
            ac(1,count)=1;
        elseif data(2,count)==0
            ac(1,count)=1;
        end
    elseif data(7,count)==2
        if data(3,count)==0
            ac(1,count)=1;
        elseif data(4,count)==0
            ac(1,count)=1;
        end
    else
        ac(1,count)=0;
    end
end
correct = ac == 1;
numCorrect = numel(correct);
accuracy = numCorrect/trials;
meanRT = mean(rt);

save(blockID,'trials','errorOm','numCorrect','accuracy','meanRT');

task = 2;
cue = 1;
blockID = 's102dsedu50';

block1=allDotTask(task).thisTaskData(cue).thisCondData(1).thisBlockTrials(8).thisTrialData;
block2=allDotTask(task).thisTaskData(cue).thisCondData(2).thisBlockTrials(8).thisTrialData;
block3=allDotTask(task).thisTaskData(cue).thisCondData(3).thisBlockTrials(8).thisTrialData;
block4=allDotTask(task).thisTaskData(cue).thisCondData(4).thisBlockTrials(8).thisTrialData;
block5=allDotTask(task).thisTaskData(cue).thisCondData(5).thisBlockTrials(8).thisTrialData;
block6=allDotTask(task).thisTaskData(cue).thisCondData(6).thisBlockTrials(8).thisTrialData;
block7=allDotTask(task).thisTaskData(cue).thisCondData(7).thisBlockTrials(8).thisTrialData;
block8=allDotTask(task).thisTaskData(cue).thisCondData(8).thisBlockTrials(8).thisTrialData;
data = [block1,block2,block3,block4,block5,block6,block7,block8];
el = find(data(8,:));
resps = numel(el);
trials = size(data,2);
errorOm = trials-resps;
rt = zeros(1,trials-errorOm);
for count=1:trials-errorOm
    if data(7,count)==1
        rt(1,count)=data(8,count);
    elseif data(7,count)==2
        rt(1,count)=data(8,count);
    end
end
ac = zeros(1,trials);
for count=1:trials
    if data(7,count)==1
        if data(1,count)==0
            ac(1,count)=1;
        elseif data(2,count)==0
            ac(1,count)=1;
        end
    elseif data(7,count)==2
        if data(3,count)==0
            ac(1,count)=1;
        elseif data(4,count)==0
            ac(1,count)=1;
        end
    else
        ac(1,count)=0;
    end
end
correct = ac == 1;
numCorrect = numel(correct);
accuracy = numCorrect/trials;
meanRT = mean(rt);

save(blockID,'trials','errorOm','numCorrect','accuracy','meanRT');

task = 2;
cue = 2;
blockID = 's102dsedu100';

block1=allDotTask(task).thisTaskData(cue).thisCondData(1).thisBlockTrials(8).thisTrialData;
block2=allDotTask(task).thisTaskData(cue).thisCondData(2).thisBlockTrials(8).thisTrialData;
block3=allDotTask(task).thisTaskData(cue).thisCondData(3).thisBlockTrials(8).thisTrialData;
block4=allDotTask(task).thisTaskData(cue).thisCondData(4).thisBlockTrials(8).thisTrialData;
block5=allDotTask(task).thisTaskData(cue).thisCondData(5).thisBlockTrials(8).thisTrialData;
block6=allDotTask(task).thisTaskData(cue).thisCondData(6).thisBlockTrials(8).thisTrialData;
block7=allDotTask(task).thisTaskData(cue).thisCondData(7).thisBlockTrials(8).thisTrialData;
block8=allDotTask(task).thisTaskData(cue).thisCondData(8).thisBlockTrials(8).thisTrialData;
data = [block1,block2,block3,block4,block5,block6,block7,block8];
el = find(data(8,:));
resps = numel(el);
trials = size(data,2);
errorOm = trials-resps;
rt = zeros(1,trials-errorOm);
for count=1:trials-errorOm
    if data(7,count)==1
        rt(1,count)=data(8,count);
    elseif data(7,count)==2
        rt(1,count)=data(8,count);
    end
end
ac = zeros(1,trials);
for count=1:trials
    if data(7,count)==1
        if data(1,count)==0
            ac(1,count)=1;
        elseif data(2,count)==0
            ac(1,count)=1;
        end
    elseif data(7,count)==2
        if data(3,count)==0
            ac(1,count)=1;
        elseif data(4,count)==0
            ac(1,count)=1;
        end
    else
        ac(1,count)=0;
    end
end
correct = ac == 1;
numCorrect = numel(correct);
accuracy = numCorrect/trials;
meanRT = mean(rt);

save(blockID,'trials','errorOm','numCorrect','accuracy','meanRT');
