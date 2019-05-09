
%med cond data analysis

function v2medAn4Loc(sjNum,medTaskOrder,medLoad,numTask,numCue,blockTrials,saveFile)

load(medLoad);
load('allDataStruct.mat')

for task=1:numTask
    
    for cue=1:numCue
        
        if medTaskOrder==1
            if task==1
                taskCond=1;
            elseif task==2
                taskCond=2;
            end
        elseif medTaskOrder==2
            if task==1
                taskCond=2;
            elseif task==2
                taskCond=1;
            end
        end
       
        block1=allMedTask(task).thisTaskData(cue).thisCueCondData(1).thisBlockTrials(blockTrials).thisTrialData;
        block2=allMedTask(task).thisTaskData(cue).thisCueCondData(2).thisBlockTrials(blockTrials).thisTrialData;
        block3=allMedTask(task).thisTaskData(cue).thisCueCondData(3).thisBlockTrials(blockTrials).thisTrialData;
        block4=allMedTask(task).thisTaskData(cue).thisCueCondData(4).thisBlockTrials(blockTrials).thisTrialData;
        block5=allMedTask(task).thisTaskData(cue).thisCueCondData(5).thisBlockTrials(blockTrials).thisTrialData;
        block6=allMedTask(task).thisTaskData(cue).thisCueCondData(6).thisBlockTrials(blockTrials).thisTrialData;
        
        data=[block1,block2,block3,block4,block5,block6];
        
        wmData=allMedTask(task).thisTaskData(cue).thisCueCondData(6).thisBlockWM;
        
        cueCond=allMedTask(task).thisTaskData(cue).thisCueCond;
        
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

        visCorrect=zeros(1,numTrials);

        for trial=1:numTrials
            if data(targetRow,trial)==data(visRespRow,trial)
                visCorrect(1,trial)=data(rtRow,trial);
            elseif data(visRespRow,trial)==0
                visErrorOm=visErrorOm+1;
            end
        end

        correctTrials=find(visCorrect~=0);
        useTrials=zeros(1,size(correctTrials,2));
        for trial=1:size(useTrials,2)
            useTrials(1,trial)=data(rtRow,correctTrials(1,trial));
        end    
        
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
            valTrials=zeros(1,numTrials*(2/3));
            invalTrials=zeros(1,numTrials*(1/3));
        elseif cueCond==2
            thres=blockTrials*(1/3);
            valTrials=zeros(1,numTrials*(1/3));
            invalTrials=zeros(1,numTrials*(2/3));
        end

        for trial=1:size(correctTrials,2)
            if data(cueOrder,correctTrials(1,trial))<=thres
                valTrials(1,trial)=data(rtRow,correctTrials(1,trial));
            elseif thres<data(cueOrder,correctTrials(1,trial))
                invalTrials(1,trial)=data(rtRow,correctTrials(1,trial));
            end
        end

        useValTrials=find(valTrials~=0);
        valTrialTimes=zeros(1,size(useValTrials,2));
        for trial=1:size(useValTrials,2)
            valTrialTimes(1,trial)=valTrials(1,useValTrials(1,trial));
        end
        useInvalTrials=find(invalTrials~=0);
        invalTrialTimes=zeros(1,size(useInvalTrials,2));
        for trial=1:size(useInvalTrials,2)
            invalTrialTimes(1,trial)=invalTrials(1,useInvalTrials(1,trial));
        end
        
        invalTrialTimes=invalTrialTimes(abs(invalTrialTimes(:)-mean(invalTrialTimes))<=(2*std(invalTrialTimes)));
        valTrialTimes=valTrialTimes(abs(valTrialTimes(:)-mean(valTrialTimes))<=(2*std(valTrialTimes)));
        oriEf=(mean(invalTrialTimes)-mean(valTrialTimes))*1000;
        
        adjColRT=NaN;
        adjRowRT=NaN;
        diagRT=NaN;
        
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
        
        useCol=find(adjColRT~=0);
        for trial=1:size(useCol,2)
            useColRT(1,trial)=adjColRT(useCol(1,trial));
        end
            
        useRow=find(adjRowRT~=0);
        for trial=1:size(useRow,2)
            useRowRT(1,trial)=adjRowRT(useRow(1,trial));
        end
        
        useDiag=find(diagRT~=0);
        for trial=1:size(useDiag,2)
            useDiagRT(1,trial)=diagRT(useDiag(1,trial));
        end
        
        meanColRT=(mean(useColRT))*1000;
        meanRowRT=(mean(useRowRT))*1000;
        meanDiagRT=(mean(useDiagRT))*1000;
        
        allDataStruct(2).task(taskCond).cue(cueCond).accuracyWM(sjNum)=accuracyWM;
        allDataStruct(2).task(taskCond).cue(cueCond).visMeanRT(sjNum)=visMeanRT;
        allDataStruct(2).task(taskCond).cue(cueCond).visAccuracy(sjNum)=visAccuracy;
        allDataStruct(2).task(taskCond).cue(cueCond).audAccuracy(sjNum)=audAccuracy;
        allDataStruct(2).task(taskCond).cue(cueCond).oriEf(sjNum)=oriEf;
        allDataStruct(2).task(taskCond).cue(cueCond).meanColRT(sjNum)=meanColRT;
        allDataStruct(2).task(taskCond).cue(cueCond).meanRowRT(sjNum)=meanRowRT;
        allDataStruct(2).task(taskCond).cue(cueCond).meanDiagRT(sjNum)=meanDiagRT;
        
        save([saveFile 'allDataStruct.mat'],'allDataStruct');
        
    end
    
end
    
return
