
%low cond data analysis

function v2lowAn4loc(sjNum,lowTaskOrder,lowLoad,numTask,numCue,blockTrials,saveFile)

load(lowLoad);
load('allDataStruct.mat')
load('aDataStruct.mat')
load('bDataStruct.mat')

for run=1:3
    for task=1:numTask
        for cue=1:numCue
            if lowTaskOrder==1
                if task==1
                    taskCond=1;
                elseif task==2
                    taskCond=2;
                end
            elseif lowTaskOrder==2
                if task==1
                    taskCond=2;
                elseif task==2
                    taskCond=1;
                end
            end

            block1=allLowTask(task).thisTaskData(cue).thisCueCondData(1).thisBlockTrials(blockTrials).thisTrialData;
            block2=allLowTask(task).thisTaskData(cue).thisCueCondData(2).thisBlockTrials(blockTrials).thisTrialData;
            block3=allLowTask(task).thisTaskData(cue).thisCueCondData(3).thisBlockTrials(blockTrials).thisTrialData;
            block4=allLowTask(task).thisTaskData(cue).thisCueCondData(4).thisBlockTrials(blockTrials).thisTrialData;
            block5=allLowTask(task).thisTaskData(cue).thisCueCondData(5).thisBlockTrials(blockTrials).thisTrialData;
            block6=allLowTask(task).thisTaskData(cue).thisCueCondData(6).thisBlockTrials(blockTrials).thisTrialData;

            data=[block1,block2,block3,block4,block5,block6];
            aData=data(:,[1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,35]);
            bData=data(:,[2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34]);
            
            if run==2
                data=aData;
            elseif run==3
                data=bData;
            end

            wmData=allLowTask(task).thisTaskData(cue).thisCueCondData(6).thisBlockWM;

            cueCond=allLowTask(task).thisTaskData(cue).thisCueCond;

            cueOrder=2;
            toneRow=5;
            audRespRow=6;
            targetRow=8;
            visRespRow=9;
            rtRow=10;

            numTrials=size(data,2);
            numBlocks=6;

            visErrorOm=0;
            audErrorOm=0;
            audAccuracy=0;

            wmLoad=wmData(1:5,:);
            wmProbe=wmData(6:10,:);
            numLetter=5;
            correctWM=0;

            for block=1:numBlocks
                for letter=1:numLetter
                    if wmLoad(letter,block)==wmProbe(letter,block)
                        correctWM=correctWM+1;
                    end
                end
            end

            accuracyWM=(correctWM/(numBlocks*numLetter))*100;

            visCorrect=[];
            for trial=1:numTrials
                if data(targetRow,trial)==data(visRespRow,trial)
                    visCorrect(1,trial)=data(rtRow,trial);
                elseif data(visRespRow,trial)==0
                    visErrorOm=visErrorOm+1;
                end
            end

            correctTrials=find(visCorrect~=0);
            useTrials=visCorrect(visCorrect~=0);
            
            correctTrials=correctTrials(abs(useTrials(:)-mean(useTrials))<=(2*std(useTrials)));
            useTrials=useTrials(abs(useTrials(:)-mean(useTrials))<=(2*std(useTrials)));
            visMeanRT=(mean(useTrials))*1000;
            visAccuracy=(size(useTrials,2)/numTrials)*100;

            if taskCond==2
                audCorrect=zeros(1,numTrials);
                for trial=1:numTrials
                    if data(toneRow,trial)==300&&data(audRespRow,trial)==1||data(toneRow,trial)==600&&data(audRespRow,trial)==2
                        audCorrect(1,trial)=1;
                    elseif data(audRespRow,trial)==0
                        audErrorOm=audErrorOm+1;
                    end
                end
                useAud=find(audCorrect~=0);
                audAccuracy=((size(useAud,2))/numTrials)*100;
            end

            if cueCond==1
                thres=blockTrials*(2/3);
            elseif cueCond==2
                thres=blockTrials*(1/3);
            end
            
            valTrials=[];
            invalTrials=[];
            for trial=1:size(correctTrials,2)
                if data(cueOrder,correctTrials(1,trial))<=thres
                    valTrials(1,trial)=data(rtRow,correctTrials(1,trial));
                elseif thres<data(cueOrder,correctTrials(1,trial))
                    invalTrials(1,trial)=data(rtRow,correctTrials(1,trial));
                end
            end

            valTrialTimes=valTrials(valTrials~=0);
            invalTrialTimes=invalTrials(invalTrials~=0);

            invalTrialTimes=invalTrialTimes(abs(invalTrialTimes(:)-mean(invalTrialTimes))<=(2*std(invalTrialTimes)));
            valTrialTimes=valTrialTimes(abs(valTrialTimes(:)-mean(valTrialTimes))<=(2*std(valTrialTimes)));
            oriEf=(mean(invalTrialTimes)-mean(valTrialTimes))*1000;
            
            if run==1
                allDataStruct(1).task(taskCond).cue(cueCond).accuracyWM(sjNum)=accuracyWM;
                allDataStruct(1).task(taskCond).cue(cueCond).visMeanRT(sjNum)=visMeanRT;
                allDataStruct(1).task(taskCond).cue(cueCond).visAccuracy(sjNum)=visAccuracy;
                allDataStruct(1).task(taskCond).cue(cueCond).audAccuracy(sjNum)=audAccuracy;
                allDataStruct(1).task(taskCond).cue(cueCond).oriEf(sjNum)=oriEf;
                save([saveFile 'allDataStruct.mat'],'allDataStruct');
            elseif run==2
                aDataStruct(1).task(taskCond).cue(cueCond).accuracyWM(sjNum)=accuracyWM;
                aDataStruct(1).task(taskCond).cue(cueCond).visMeanRT(sjNum)=visMeanRT;
                aDataStruct(1).task(taskCond).cue(cueCond).visAccuracy(sjNum)=visAccuracy;
                aDataStruct(1).task(taskCond).cue(cueCond).audAccuracy(sjNum)=audAccuracy;
                aDataStruct(1).task(taskCond).cue(cueCond).oriEf(sjNum)=oriEf;
                save([saveFile 'aDataStruct.mat'],'aDataStruct');
            elseif run==3
                bDataStruct(1).task(taskCond).cue(cueCond).accuracyWM(sjNum)=accuracyWM;
                bDataStruct(1).task(taskCond).cue(cueCond).visMeanRT(sjNum)=visMeanRT;
                bDataStruct(1).task(taskCond).cue(cueCond).visAccuracy(sjNum)=visAccuracy;
                bDataStruct(1).task(taskCond).cue(cueCond).audAccuracy(sjNum)=audAccuracy;
                bDataStruct(1).task(taskCond).cue(cueCond).oriEf(sjNum)=oriEf;
                save([saveFile 'bDataStruct.mat'],'bDataStruct');
            end
        end
    end
end
    
return
