%loop to be used to create data files for different subjects
%aDT(n) = n task, tTD(n) = 50/100% cue validity, tCD(n) = block, tBT = 8
%every time because (8).thisTrialData has the complete trial data

function stroopAL(sjNum)

load('dataInfo.mat')
load(stroopLoad);

for task=1:numTask
    for cue=1:numCue
        if task==1
            if cue==1
                blockID = 'stsi50';
            elseif cue==2
                blockID = 'stsi100';
            end
        elseif task==2
            if cue==1
                blockID = 'stdu50';
            elseif cue==2
                blockID = 'stdu100';
            end
        end
        block1=allStroopTask(task).thisTaskData(cue).thisCondData(1).thisBlockTrials(4).thisTrialData;
        block2=allStroopTask(task).thisTaskData(cue).thisCondData(2).thisBlockTrials(4).thisTrialData;
%         block3=allDotTask(task).thisTaskData(cue).thisCondData(3).thisBlockTrials(8).thisTrialData;
%         block4=allDotTask(task).thisTaskData(cue).thisCondData(4).thisBlockTrials(8).thisTrialData;
%         block5=allDotTask(task).thisTaskData(cue).thisCondData(5).thisBlockTrials(8).thisTrialData;
%         block6=allDotTask(task).thisTaskData(cue).thisCondData(6).thisBlockTrials(8).thisTrialData;
%         block7=allDotTask(task).thisTaskData(cue).thisCondData(7).thisBlockTrials(8).thisTrialData;
%         block8=allDotTask(task).thisTaskData(cue).thisCondData(8).thisBlockTrials(8).thisTrialData;
%         data = [block1,block2,block3,block4,block5,block6,block7,block8];
        data=[block1,block2];
        if task==1
            resp = find(data(7,:)>0);
            numResp = numel(resp);
            trials = size(data,2);
            errorOm = trials-numResp;
            rt = zeros(1,trials-errorOm);
            for count=1:trials-errorOm
                rt(1,count)=data(8,resp(1,count));
            end
            ac = zeros(1,trials-errorOm);
            for count=1:trials-errorOm
                if data(7,count)==1
                    if data(1,count)==1
                        ac(1,count)=1;
                    elseif data(3,count)==1
                        ac(1,count)=1;
                    end
                elseif data(7,count)==2
                    if data(2,count)==1
                        ac(1,count)=1;
                    elseif data(4,count)==1
                        ac(4,count)=1;
                    end
                end
            end
            correct = find(ac==1);
            numCorrect = numel(correct);
            accuracy = numCorrect/trials;
            meanRT = mean(rt);

            save([filePath '/' sprintf('sj%02d_%s.mat',sjNum,blockID)],'trials','errorOm','numCorrect','accuracy','meanRT');
            
        end
        if task==2
            errorCom = 0;
            errorOm = 0;
            for count=1:trials
                if data(6,count)==600
                    if data(7,count)>0
                        errorCom=errorCom+1;
                    end
                elseif data(6,count)==300
                    if data(7,count)==0
                        errorOm=errorOm+1;
                    end
                end
            end
            nonComResp=find(data(6,:)==300&data(7,:)~=0);
            numResp=numel(nonComResp);
            respFA=zeros(1,numResp);
            for count=1:numResp
                if data(7,nonComResp(1,count))~=0
                    respFA(1,count)=data(8,nonComResp(1,count));
                end
            end
            ac = zeros(1,trials-errorCom-errorOm);
            for count=1:trials-errorCom-errorOm
                if data(7,count)==1
                    if data(1,count)==1
                        ac(1,count)=1;
                    elseif data(3,count)==1
                        ac(1,count)=1;
                    end
                elseif data(7,count)==2
                    if data(2,count)==1
                        ac(1,count)=1;
                    elseif data(4,count)==1
                        ac(1,count)=1;
                    end
                elseif data(6,count)==600
                    if data(7,count)==0
                        ac(1,count)=1;
                    end
                end
            end
            correct = find(ac==1);
            numCorrect = numel(correct);
            accuracy = numCorrect/trials;
            meanRT = mean(respFA);

            save([filePath '/' sprintf('sj%02d_%s.mat',sjNum,blockID)],'trials','errorCom','errorOm','numCorrect','accuracy','meanRT');
            
        end

    end
end

return
    
