
%high cond data analysis

function v2highAn4Loc(sjNum,highTaskOrder,highLoad,numTask,numCue,blockTrials,saveFile)

load(highLoad);
load('allDataStruct.mat')
load('aDataStruct.mat')
load('bDataStruct.mat')

for run=1:3
    for task=1:numTask
        for cue=1:numCue
            if highTaskOrder==1
                if task==1
                    taskCond=1;
                elseif task==2
                    taskCond=2;
                end
            elseif highTaskOrder==2
                if task==1
                    taskCond=2;
                elseif task==2
                    taskCond=1;
                end
            end 

            block1=allHighTask(task).thisTaskData(cue).thisCueCondData(1).thisBlockTrials(blockTrials).thisTrialData;
            block2=allHighTask(task).thisTaskData(cue).thisCueCondData(2).thisBlockTrials(blockTrials).thisTrialData;
            block3=allHighTask(task).thisTaskData(cue).thisCueCondData(3).thisBlockTrials(blockTrials).thisTrialData;
            block4=allHighTask(task).thisTaskData(cue).thisCueCondData(4).thisBlockTrials(blockTrials).thisTrialData;
            block5=allHighTask(task).thisTaskData(cue).thisCueCondData(5).thisBlockTrials(blockTrials).thisTrialData;
            block6=allHighTask(task).thisTaskData(cue).thisCueCondData(6).thisBlockTrials(blockTrials).thisTrialData;

            data=[block1,block2,block3,block4,block5,block6];
            aData=data(:,[1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,35]);
            bData=data(:,[2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34]);
            
            if run==2
                data=aData;
            elseif run==3
                data=bData;
            end

            wmData=allHighTask(task).thisTaskData(cue).thisCueCondData(6).thisBlockWM;

            cueCond=allHighTask(task).thisTaskData(cue).thisCueCond;

            cueOrder=2;
            cueLocRow=3;
            targetLocRow=4;
            stimLocRow=5;
            toneRow=6;
            audRespRow=7;
            targetRow=9;
            visRespRow=10;
            rtRow=11;

            numTrials=size(data,2);
            
            visErrorOm=0;
            audErrorOm=0;
            audAccuracy=0;

            wmLoad=wmData(1:5,:);
            wmProbe=wmData(6:10,:);
            numLetter=5;
            correctWM=0;
            numBlocks=6;
            useBlocks=0;
            for block=1:numBlocks
                if run==1           %include all blocks
                    for letter=1:numLetter
                        if wmLoad(letter,block)==wmProbe(letter,block)
                            correctWM=correctWM+1;
                        end
                    end
                    useBlocks=useBlocks+1;
                elseif run==2
                    if floor(block/2)==block/2      %use even blocks for aData
                        for letter=1:numLetter
                            if wmLoad(letter,block)==wmProbe(letter,block)
                                correctWM=correctWM+1;
                            end
                        end
                        useBlocks=useBlocks+1;
                    end
                elseif run==3
                    if floor(block/2)~=block/2      %use odd blocks for bData
                        for letter=1:numLetter
                            if wmLoad(letter,block)==wmProbe(letter,block)
                                correctWM=correctWM+1;
                            end
                        end
                        useBlocks=useBlocks+1;
                    end
                end
            end
            
            accuracyWM=(correctWM/(useBlocks*numLetter))*100;

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
    
            %exclude scores <= 2 standard deviations away
            correctTrials=correctTrials(abs(useTrials(:)-mean(useTrials))<=(2*std(useTrials)));
            useTrials=useTrials(abs(useTrials(:)-mean(useTrials))<=(2*std(useTrials)));
            visMeanRT=(mean(useTrials))*1000;
            visAccuracy=(size(useTrials,2)/numTrials)*100;

            if taskCond==2
                audCorrect=zeros(1,numTrials);
                for trial=1:numTrials
                    if data(toneRow,trial)==300&&data(audRespRow,trial)==1||...
                            data(toneRow,trial)==600&&data(audRespRow,trial)==2
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

            adjColRT=[];
            adjRowRT=[];
            diagRT=[];

            for trial=1:size(useTrials,2)
                if data(cueLocRow,correctTrials(1,trial))<600   %this is 600 b/c boxCenX is 533.33 if it's on the left and 746.66 if it's on the right
                    if data(cueOrder,correctTrials(1,trial))<=thres
                        if data(targetLocRow,correctTrials(1,trial))<=50
                            if data(stimLocRow,correctTrials(1,trial))<=33
                                adjColRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            elseif 33<data(stimLocRow,correctTrials(1,trial))<=66
                                adjRowRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            elseif 66<data(stimLocRow,correctTrials(1,trial))
                                diagRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            end
                        elseif 50<data(targetLocRow,correctTrials(1,trial))
                            if data(stimLocRow,correctTrials(1,trial))<=33
                                adjColRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            elseif 33<data(stimLocRow,correctTrials(1,trial))<=66
                                diagRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            elseif 66<data(stimLocRow,correctTrials(1,trial))
                                adjRowRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            end
                        end
                    elseif thres<data(cueOrder,correctTrials(1,trial))
                        if data(targetLocRow,correctTrials(1,trial))<=50
                            if data(stimLocRow,correctTrials(1,trial))<=33
                                adjRowRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            elseif 33<data(stimLocRow,correctTrials(1,trial))<=66
                                diagRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            elseif 66<data(stimLocRow,correctTrials(1,trial))
                                adjColRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            end
                        elseif 50<data(targetLocRow,correctTrials(1,trial))
                            if data(stimLocRow,correctTrials(1,trial))<=33
                                diagRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            elseif 33<data(stimLocRow,correctTrials(1,trial))<=66
                                adjRowRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            elseif 66<data(stimLocRow,correctTrials(1,trial))
                                adjColRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            end
                        end
                    end
                elseif 600<data(cueLocRow,correctTrials(1,trial))   %this is 600 b/c boxCenX is 533.33 if it's on the left and 746.66 if it's on the right
                    if data(cueOrder,correctTrials(1,trial))<=thres
                        if data(targetLocRow,correctTrials(1,trial))<=50
                            if data(stimLocRow,correctTrials(1,trial))<=33
                                adjRowRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            elseif 33<data(stimLocRow,correctTrials(1,trial))<=66
                                diagRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            elseif 66<data(stimLocRow,correctTrials(1,trial))
                                adjColRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            end
                        elseif 50<data(targetLocRow,correctTrials(1,trial))
                            if data(stimLocRow,correctTrials(1,trial))<=33
                                diagRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            elseif 33<data(stimLocRow,correctTrials(1,trial))<=66
                                adjRowRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            elseif 66<data(stimLocRow,correctTrials(1,trial))
                                adjColRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            end
                        end
                    elseif thres<data(cueOrder,correctTrials(1,trial))
                        if data(targetLocRow,correctTrials(1,trial))<=50
                            if data(stimLocRow,correctTrials(1,trial))<=33
                                adjColRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            elseif 33<data(stimLocRow,correctTrials(1,trial))<=66
                                adjRowRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            elseif 66<data(stimLocRow,correctTrials(1,trial))
                                diagRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            end
                        elseif 50<data(targetLocRow,correctTrials(1,trial))
                            if data(stimLocRow,correctTrials(1,trial))<=33
                                adjColRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            elseif 33<data(stimLocRow,correctTrials(1,trial))<=66
                                diagRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            elseif 66<data(stimLocRow,correctTrials(1,trial))
                                adjRowRT(1,trial)=data(rtRow,correctTrials(1,trial));
                            end
                        end
                    end
                end
            end

            adjColRT=adjColRT(adjColRT~=0);            
            adjRowRT=adjRowRT(adjRowRT~=0);
            diagRT=diagRT(diagRT~=0);

            meanColRT=(mean(adjColRT))*1000;
            meanRowRT=(mean(adjRowRT))*1000;
            meanDiagRT=(mean(diagRT))*1000;
            
            if run==1
                allDataStruct(3).task(taskCond).cue(cueCond).accuracyWM(sjNum)=accuracyWM;
                allDataStruct(3).task(taskCond).cue(cueCond).visMeanRT(sjNum)=visMeanRT;
                allDataStruct(3).task(taskCond).cue(cueCond).visAccuracy(sjNum)=visAccuracy;
                allDataStruct(3).task(taskCond).cue(cueCond).audAccuracy(sjNum)=audAccuracy;
                allDataStruct(3).task(taskCond).cue(cueCond).oriEf(sjNum)=oriEf;
                allDataStruct(3).task(taskCond).cue(cueCond).meanColRT(sjNum)=meanColRT;
                allDataStruct(3).task(taskCond).cue(cueCond).meanRowRT(sjNum)=meanRowRT;
                allDataStruct(3).task(taskCond).cue(cueCond).meanDiagRT(sjNum)=meanDiagRT;
                save([saveFile 'allDataStruct.mat'],'allDataStruct');
            elseif run==2
                aDataStruct(3).task(taskCond).cue(cueCond).accuracyWM(sjNum)=accuracyWM;
                aDataStruct(3).task(taskCond).cue(cueCond).visMeanRT(sjNum)=visMeanRT;
                aDataStruct(3).task(taskCond).cue(cueCond).visAccuracy(sjNum)=visAccuracy;
                aDataStruct(3).task(taskCond).cue(cueCond).audAccuracy(sjNum)=audAccuracy;
                aDataStruct(3).task(taskCond).cue(cueCond).oriEf(sjNum)=oriEf;
                aDataStruct(3).task(taskCond).cue(cueCond).meanColRT(sjNum)=meanColRT;
                aDataStruct(3).task(taskCond).cue(cueCond).meanRowRT(sjNum)=meanRowRT;
                aDataStruct(3).task(taskCond).cue(cueCond).meanDiagRT(sjNum)=meanDiagRT;
                save([saveFile 'aDataStruct.mat'],'aDataStruct');
            elseif run==3
                bDataStruct(3).task(taskCond).cue(cueCond).accuracyWM(sjNum)=accuracyWM;
                bDataStruct(3).task(taskCond).cue(cueCond).visMeanRT(sjNum)=visMeanRT;
                bDataStruct(3).task(taskCond).cue(cueCond).visAccuracy(sjNum)=visAccuracy;
                bDataStruct(3).task(taskCond).cue(cueCond).audAccuracy(sjNum)=audAccuracy;
                bDataStruct(3).task(taskCond).cue(cueCond).oriEf(sjNum)=oriEf;
                bDataStruct(3).task(taskCond).cue(cueCond).meanColRT(sjNum)=meanColRT;
                bDataStruct(3).task(taskCond).cue(cueCond).meanRowRT(sjNum)=meanRowRT;
                bDataStruct(3).task(taskCond).cue(cueCond).meanDiagRT(sjNum)=meanDiagRT;
                save([saveFile 'bDataStruct.mat'],'bDataStruct');
            end
        end
    end
end

return
