
%high cond data analysis

function highAn2

load('dataAnFile.mat');
load(highLoad);

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
        block7=allHighTask(task).thisTaskData(cue).thisCueCondData(7).thisBlockTrials(blockTrials).thisTrialData;
        block8=allHighTask(task).thisTaskData(cue).thisCueCondData(8).thisBlockTrials(blockTrials).thisTrialData;
        
        data=[block1,block2,block3,block4,block5,block6,block7,block8];
        
        wmData=allHighTask(task).thisTaskData(cue).thisCueCondData(8).thisBlockWM;
        
        cueCond=allHighTask(task).thisTaskData(cue).thisCueCond;
        
        if taskCond==1
            if cueCond==1
                blockID='highsi66.mat';
            elseif cueCond==2
                blockID='highsi33.mat';
            end
        elseif taskCond==2
            if cueCond==1
                blockID='highdu66.mat';
            elseif cueCond==2
                blockID='highdu33.mat';
            end
        end
        
        cueOrder=2;
        stimLocRow=5;
        toneRow=6;
        targetRow=7;
        respRow=8;
        rtRow=9;
        
        numTrials=size(data,2);
        numBlocks=8;
        
        errorOm=0;
        errorCom=0;
        
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
        
        if taskCond==1

            correct=zeros(1,numTrials);

            for trial=1:numTrials
                if data(targetRow,trial)<=2&&data(respRow,trial)==1||...
                        2<data(targetRow,trial)&&data(respRow,trial)==2
                    correct(1,trial)=data(rtRow,trial);
                elseif data(respRow,trial)==0
                    errorOm=errorOm+1;
                end
            end

            correctTrials=find(correct~=0);
            useTrials=zeros(1,size(correctTrials,2));
            for trial=1:size(useTrials,2)
                useTrials(1,trial)=data(rtRow,correctTrials(1,trial));
            end    

            meanRT=mean(useTrials);
            accuracy=size(useTrials,2)/numTrials;

        end

        if taskCond==2

            lowToneCorrect=zeros(1,numTrials*(2/3));
            highToneCorrect=zeros(1,numTrials*(1/3));
            for trial=1:numTrials
                if data(toneRow,trial)==300&&data(targetRow,trial)<=2&&data(respRow,trial)==1||...
                    data(toneRow,trial)==300&&2<data(targetRow,trial)&&data(respRow,trial)==2
                    lowToneCorrect(1,trial)=1;
                elseif data(toneRow,trial)==300&&data(respRow,trial)==0
                    errorOm=errorOm+1;
                elseif data(toneRow,trial)==600&&data(respRow,trial)==0
                    highToneCorrect(1,trial)=1;
                elseif data(toneRow,trial)==600&&data(respRow,trial)~=0
                    errorCom=errorCom+1;
                end
            end

            correctTrials=find(lowToneCorrect~=0);
            correctHighTrials=find(highToneCorrect~=0);
            useTrials=zeros(1,size(correctTrials,2));
            for trial=1:size(useTrials,2)
                useTrials(1,trial)=data(rtRow,correctTrials(1,trial));
            end

            meanRT=mean(useTrials);
            accuracy=(size(correctTrials,2)+size(correctHighTrials,2))/numTrials;

        end

        if cueCond==1
            thres=blockTrials*(2/3);
        elseif cueCond==2
            thres=blockTrials*(1/3);
        end

        valTrials=zeros(1,thres);
        invalTrials=zeros(1,numTrials-thres);

        for trial=1:size(correctTrials,2)
            if data(cueOrder,correctTrials(1,trial))<=thres&&data(targetRow,correctTrials(1,trial))<=2&&data(respRow,correctTrials(1,trial))==1||...
                data(cueOrder,correctTrials(1,trial))<=thres&&2<data(targetRow,correctTrials(1,trial))&&data(respRow,correctTrials(1,trial))==2
                valTrials(1,trial)=data(rtRow,correctTrials(1,trial));
            elseif thres<data(cueOrder,correctTrials(1,trial))&&data(targetRow,correctTrials(1,trial))<=2&&data(respRow,correctTrials(1,trial))==1||...
                thres<data(cueOrder,correctTrials(1,trial))&&2<data(targetRow,correctTrials(1,trial))&&data(respRow,correctTrials(1,trial))==2
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
        
        adjColRT=zeros(1,numTrials);
        adjRowRT=zeros(1,numTrials);
        diagRT=zeros(1,numTrials);
        
        for trial=1:numTrials
            if data(targetRow,trial)==1
                if data(stimLocRow,trial)<=33
                    circleLoc=2;
                elseif 33<data(stimLocRow,trial)<=66
                    circleLoc=3;
                elseif 66<data(stimLocRow,trial)
                    circleLoc=4;
                end
                adjCol=2;
                adjRow=3;
                diag=4;
            elseif data(targetRow,trial)==2
                if data(stimLocRow,trial)<=33
                    circleLoc=1;
                elseif 33<data(stimLocRow,trial)<=66
                    circleLoc=3;
                elseif 66<data(stimLocRow,trial)
                    circleLoc=4;
                end
                adjCol=1;
                adjRow=4;
                diag=3;
            elseif data(targetRow,trial)==3
                if data(stimLocRow,trial)<=33
                    circleLoc=1;
                elseif 33<data(stimLocRow,trial)<=66
                    circleLoc=2;
                elseif 66<data(stimLocRow,trial)
                    circleLoc=4;
                end
                adjCol=4;
                adjRow=1;
                diag=2;
            elseif data(targetRow,trial)==4
                if data(stimLocRow,trial)<=33
                    circleLoc=1;
                elseif 33<data(stimLocRow,trial)<=66
                    circleLoc=2;
                elseif 66<data(stimLocRow,trial)
                    circleLoc=3;
                end
                adjCol=3;
                adjRow=2;
                diag=1;
            end
            
            if circleLoc==adjCol
                adjColRT(1,trial)=data(rtRow,trial);
            elseif circleLoc==adjRow
                adjRowRT(1,trial)=data(rtRow,trial);
            elseif circleLoc==diag
                diagRT(1,trial)=data(rtRow,trial);
            end
            
        end
        
        useAC=find(adjColRT~=0);
        useAR=find(adjRowRT~=0);
        useD=find(diagRT~=0);
        useCol=zeros(1,numel(useAC));
        useRow=zeros(1,numel(useAR));
        useDiag=zeros(1,numel(useD));
        
        for trial=1:numel(useCol)
            useCol(1,trial)=adjColRT(1,useAC(1,trial));
        end
        for trial=1:numel(useRow)
            useRow(1,trial)=adjRowRT(1,useAR(1,trial));
        end
        for trial=1:numel(useDiag)
            useDiag(1,trial)=diagRT(1,useD(1,trial));
        end
        
        colRT=mean(useCol);
        rowRT=mean(useRow);
        diagRT=mean(useDiag);

        save([saveFile '_' sprintf('%s',blockID)],'accuracyWM','meanRT','errorOm','errorCom','accuracy','oriEf','colRT','rowRT','diagRT');
        
    end
    
end
    
return