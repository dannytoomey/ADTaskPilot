
%low cond data analysis

function v2lowAn4loc(sjNum,lowTaskOrder,lowLoad,numTask,numCue,blockTrials,saveFile)

load(lowLoad);
load('allDataStruct.mat')

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
        audMeanRT=0;
        
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
        
        accuracyWM=correctWM/(numBlocks*numLetter);

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

        visMeanRT=mean(useTrials);
        visAccuracy=size(useTrials,2)/numTrials;

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
            audAccuracy=(size(useAud,2))/numTrials;

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

        oriEf=mean(invalTrialTimes)-mean(valTrialTimes);
        
        allDataStruct(1).task(taskCond).cue(cueCond).accuracyWM(sjNum)=accuracyWM;
        allDataStruct(1).task(taskCond).cue(cueCond).visMeanRT(sjNum)=visMeanRT;
        allDataStruct(1).task(taskCond).cue(cueCond).visAccuracy(sjNum)=visAccuracy;
        allDataStruct(1).task(taskCond).cue(cueCond).audAccuracy(sjNum)=audAccuracy;
        allDataStruct(1).task(taskCond).cue(cueCond).oriEf(sjNum)=oriEf;
        
        save([saveFile 'allDataStruct.mat'],'allDataStruct');
        
    end
    
end
    
return
