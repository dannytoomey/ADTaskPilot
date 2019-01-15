
%loop used to create data files for different subjects
%aDT(n) = n task, tTD(n) = 50/100% cue validity, tCD(n) = block, tBT = 8
%every time because (8).thisTrialData has the complete trial data

function dotAL2(sjNum)

load('dataInfo.mat');
load(dotLoad);

for task=1:numTask
    for cue=1:numCue
        if taskOrder==1
            if task==1
                taskCond=1;
            elseif task==2
                taskCond=2;
            end
        elseif taskOrder==2
            if task==1
                taskCond=2;
            elseif task==2
                taskCond=1;
            end
        elseif taskOrder==3
            if task==1
                taskCond=2;
            elseif task==2
                taskCond=1;
            end
        elseif taskOrder==4
            if task==1
                taskCond=2;
            elseif task==2
                taskCond=1;
            end
        elseif taskOrder==5
            if task==1
                taskCond=1;
            elseif task==2
                taskCond=2;
            end
        elseif taskOrder==6
            if task==1
                taskCond=1;
            elseif task==2
                taskCond=2;
            end
        end
        
        block1=allDotTask(task).thisTaskData(cue).thisCondData(1).thisBlockTrials(8).thisTrialData;
        block2=allDotTask(task).thisTaskData(cue).thisCondData(2).thisBlockTrials(8).thisTrialData;
        block3=allDotTask(task).thisTaskData(cue).thisCondData(3).thisBlockTrials(8).thisTrialData;
        block4=allDotTask(task).thisTaskData(cue).thisCondData(4).thisBlockTrials(8).thisTrialData;
        block5=allDotTask(task).thisTaskData(cue).thisCondData(5).thisBlockTrials(8).thisTrialData;
        block6=allDotTask(task).thisTaskData(cue).thisCondData(6).thisBlockTrials(8).thisTrialData;
        block7=allDotTask(task).thisTaskData(cue).thisCondData(7).thisBlockTrials(8).thisTrialData;
        block8=allDotTask(task).thisTaskData(cue).thisCondData(8).thisBlockTrials(8).thisTrialData;
        data = [block1,block2,block3,block4,block5,block6,block7,block8];
        blockWM=allDotTask(task).thisTaskData(cue).thisCondData(8).thisBlockWM;
        blockWMload=blockWM(1:5,:);
        blockWMprobe=blockWM(6:10,:);
        trials = size(data,2);
        
        %determine cueCond==1 or 2
        
        cueCond=allDotTask(task).thisTaskData(cue).thisCueCond;
        
        %determine blockID
        
        if taskCond==1
            if cueCond==1
                blockID = 'dotsi50';
            elseif cueCond==2
                blockID = 'dotsi100';
            end
        elseif taskCond==2
            if cueCond==1
                blockID = 'dotdu50';
            elseif cueCond==2
                blockID = 'dotdu100';
            end
        end
        
        errorCom = 0;
        errorOm = 0;
        oriEf = 0;

        if taskCond==1
            resp = find(data(8,:)>0);
            numResp = numel(resp);
            errorOm = trials-numResp;
            %get accuracy
            ac = zeros(1,trials-errorOm);
            for count=1:trials-errorOm
                if data(8,resp(1,count))==1
                    if data(1,resp(1,count))==1
                        ac(1,count)=1;
                    elseif data(2,resp(1,count))==1
                        ac(1,count)=1;
                    end
                elseif data(8,resp(1,count))==2
                    if data(3,resp(1,count))==1
                        ac(1,count)=1;
                    elseif data(4,resp(1,count))==1
                        ac(1,count)=1;
                    end
                end
            end
            %get RT for correct trials
            correct = find(ac==1);
            rt=zeros(1,numel(correct));
            for count=1:numel(correct)
                rt(1,count)=data(9,resp(1,correct(1,count)));
            end
            
            numCorrect = numel(correct);
            accuracy = numCorrect/numResp;
            meanRT = mean(rt);

        end

        if taskCond==2
            for count=1:trials
                if data(7,count)==600
                    if data(8,count)>0
                        errorCom=errorCom+1;
                    end
                elseif data(7,count)==300
                    if data(8,count)==0
                        errorOm=errorOm+1;
                    end
                end
            end

            lowToneResp=find(data(7,:)==300&data(8,:)~=0);
            highToneResp=find(data(7,:)==600&data(8,:)==0);
            numResp=numel(lowToneResp)+numel(highToneResp);
            sortResps=[lowToneResp,highToneResp];
            resps=sort(sortResps);
            times=zeros(1,numel(lowToneResp));

            for resp=1:numel(lowToneResp)
                if (data(1,lowToneResp(1,resp))==1&&data(8,lowToneResp(1,resp))==1)||(data(2,lowToneResp(1,resp))==1&&data(8,lowToneResp(1,resp))==1)
                    times(1,resp)=data(9,lowToneResp(1,resp));
                elseif (data(3,lowToneResp(1,resp))==1&&data(8,lowToneResp(1,resp))==2)||(data(4,lowToneResp(1,resp))==1&&data(8,lowToneResp(1,resp))==2)
                    times(1,resp)=data(9,lowToneResp(1,resp));
                end
            end

            correct=find(times~=0);
            rt=zeros(1,numel(correct));
            for count=1:numel(correct)
                rt(1,count)=times(1,correct(1,count));
            end

            numCorrect = 0;
            for count=1:numResp
                if data(7,resps(1,count))==300
                    if data(8,resps(1,count))==1
                        if data(1,resps(1,count))==1
                            numCorrect=numCorrect+1;
                        elseif data(2,resps(1,count))==1
                            numCorrect=numCorrect+1;
                        end
                    elseif data(8,resps(1,count))==2
                        if data(3,resps(1,count))==1
                            numCorrect=numCorrect+1;
                        elseif data(4,resps(1,count))==1
                            numCorrect=numCorrect+1;
                        end
                    end
                elseif data(7,resps(1,count))==600
                    if data(8,resps(1,count))==0
                        numCorrect=numCorrect+1;
                    end
                end
            end

            accuracy = numCorrect/numResp;
            meanRT = mean(rt);

        end

        %determine WMC

        WMorder=zeros(size(blockWMload,1),size(blockWM,2));
        for block=1:size(blockWM,2)
            for letter=1:size(blockWMload,1)
                if blockWMload(letter,block)==blockWMprobe(letter,block)
                    WMorder(letter,block)=1;
                end
            end
        end

        acWMorder=numel(find(WMorder==1))/numel(WMorder);
        meanWMletter=zeros(1,size(blockWM,2));

        for block=1:size(blockWM,2)
            letterInLoad=0;
            thisBlockWM=blockWMload(:,block);
            for letter=1:size(blockWMload,1)
                thisLet=find(blockWMprobe(letter,block)==thisBlockWM);
                if thisLet~=0
                    letterInLoad=letterInLoad+1;
                end
                acLetter=letterInLoad/size(blockWMload,1);
            end
            meanWMletter(1,block)=acLetter;
        end

        acWMletter=mean(meanWMletter);

        %find orienting effect

        numValid=0;
        numInvalid=0;
        if taskCond==1
            valTrials=zeros(1,numel(resp));
            invalTrials=zeros(1,numel(resp));
            useResp=resp;
        end
        if taskCond==2
            valTrials=zeros(1,numel(lowToneResp));
            invalTrials=zeros(1,numel(lowToneResp));
            useResp=lowToneResp;
        end

        if cueCond==1
            for count=1:numel(correct)
                if (data(6,useResp(1,correct(1,count)))<600)&&(data(1,useResp(1,correct(1,count)))==1)...
                        ||(data(6,useResp(1,correct(1,count)))<600)&&(data(2,useResp(1,correct(1,count)))==1)
                    numValid=numValid+1;
                    valTrials(1,count)=data(9,useResp(1,correct(1,count)));
                elseif (600<data(6,useResp(1,correct(1,count)))&&(data(3,useResp(1,correct(1,count)))==1)...
                        ||(600<data(6,useResp(1,correct(1,count)))&&(data(4,useResp(1,correct(1,count)))==1)))
                    numValid=numValid+1;
                    valTrials(1,count)=data(9,useResp(1,correct(1,count)));
                elseif (data(6,useResp(1,correct(1,count)))<600)&&(data(1,useResp(1,correct(1,count)))==0)...
                        &&(data(2,useResp(1,correct(1,count)))==0)
                    numInvalid=numInvalid+1;
                    invalTrials(1,count)=data(9,useResp(1,correct(1,count)));
                elseif (600<data(6,useResp(1,correct(1,count)))&&(data(3,useResp(1,correct(1,count)))==0) ...
                        &&(data(4,useResp(1,correct(1,count)))==0))
                    numInvalid=numInvalid+1;
                    invalTrials(1,count)=data(9,useResp(1,correct(1,count)));
                end
            end
            valTimes=find(valTrials~=0);
            invalTimes=find(invalTrials~=0);
            valRT=zeros(1,numel(valTimes));
            invalRT=zeros(1,numel(invalTimes));
            for count=1:numel(valTimes)
                valRT(1,count)=valTrials(1,valTimes(1,count));
            end
            for count=1:numel(invalTimes)
                invalRT(1,count)=invalTrials(1,invalTimes(1,count));
            end

            valTrialsRT=sum(valTrials)/sum(valTrials~=0,2);
            invalTrialsRT=sum(invalTrials)/sum(invalTrials~=0,2);
            oriEf=invalTrialsRT-valTrialsRT;

        end

        save([filePath '/' sprintf('sj%02d_%s.mat',sjNum,blockID)],'trials','errorCom','errorOm','numCorrect','accuracy','meanRT','acWMorder','acWMletter','oriEf');
            
    end
end
 
return
