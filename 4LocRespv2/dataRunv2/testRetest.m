
function testRetest(sjRange)

load('aDataStruct.mat')
load('bDataStruct.mat')

numCond=3;
numTask=2;
numCue=2;

aCor=[];
bCor=[];

count=1;
for sub=1:size(sjRange,2)
    sj=sjRange(1,sub);
    for cond=1:numCond
        for task=1:numTask
            for cue=1:numCue
                aCor(count,1)=aDataStruct(cond).task(task).cue(cue).accuracyWM(sj);
                bCor(count,1)=bDataStruct(cond).task(task).cue(cue).accuracyWM(sj);
                aCor(count,2)=aDataStruct(cond).task(task).cue(cue).visMeanRT(sj);
                bCor(count,2)=bDataStruct(cond).task(task).cue(cue).visMeanRT(sj);
                aCor(count,3)=aDataStruct(cond).task(task).cue(cue).visAccuracy(sj);
                bCor(count,3)=bDataStruct(cond).task(task).cue(cue).visAccuracy(sj);
                aCor(count,4)=aDataStruct(cond).task(task).cue(cue).audAccuracy(sj);
                bCor(count,4)=bDataStruct(cond).task(task).cue(cue).audAccuracy(sj);
                aCor(count,5)=aDataStruct(cond).task(task).cue(cue).oriEf(sj);
                bCor(count,5)=bDataStruct(cond).task(task).cue(cue).oriEf(sj);
                count=count+1;
            end
        end
    end
end

save('aCor.mat','aCor')
save('bCor.mat','bCor')
aDual=aCor(:,4);
aDual=aDual(aDual~=0);
bDual=bCor(:,4);
bDual=bDual(bDual~=0);

return
