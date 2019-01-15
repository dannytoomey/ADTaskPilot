
%loop used to create data files for different subjects
%aDT(n) = n task, tTD(n) = 50/100% cue validity, tCD(n) = block, tBT = 8
%every time because (8).thisTrialData has the complete trial data

function dotAL(sjNum)

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
        
% %         % TOM
% %         for i=1:8
% %             data2(i,:,:) = allDotTask(task).thisTaskData(cue).thisCondData(i).thisBlockTrials(8).thisTrialData;
% %         end
% %         % this is an inefficient way to do it...use reshape or permute
% %         % instead..!
% %         data2 =[squeeze(data2(1,:,:)),squeeze(data2(2,:,:)),squeeze(data2(3,:,:)),squeeze(data2(4,:,:)),...
% %             squeeze(data2(5,:,:)),squeeze(data2(6,:,:)),squeeze(data2(7,:,:)),squeeze(data2(8,:,:))];
        
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
        cueValid=zeros(1,trials);
        
        %determine cueCond==1 or 2
        
        for trial=1:trials
            if data(5,trial)<600
                if data(1,trial)==0
                    cueValid(1,trial)=1;
                elseif data(2,trial)==0
                    cueValid(1,trial)=1;
                end
            elseif data(5,trial)>600
                if data(3,trial)==0
                    cueValid(1,trial)=1;
                elseif data(4,trial)==0
                    cueValid(1,trial)=1;
                end
            end
        end
        numVal=find(cueValid==1);
        if numel(numVal)<64
            cueCond=1;
        elseif numel(numVal)==64
            cueCond=2;
        end
        
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
            resp = find(data(7,:)>0);
            numResp = numel(resp);
            errorOm = trials-numResp;
            rt = zeros(1,trials-errorOm);
            %get RT for resp trials
            for count=1:trials-errorOm
                rt(1,count)=data(8,resp(1,count));
            end
            %get accuracy
            ac = zeros(1,trials-errorOm);
            for count=1:trials-errorOm
                if data(7,resp(1,count))==1
                    if data(1,resp(1,count))==0
                        ac(1,count)=1;
                    elseif data(2,resp(1,count))==0
                        ac(1,count)=1;
                    end
                elseif data(7,resp(1,count))==2
                    if data(3,resp(1,count))==0
                        ac(1,count)=1;
                    elseif data(4,resp(1,count))==0
                        ac(1,count)=1;
                    end
                end
            end
            
            correct = find(ac==1);
            numCorrect = numel(correct);
            accuracy = numCorrect/trials;
            meanRT = mean(rt);
            
        end
        
        if taskCond==2
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
            lowToneResp=find(data(6,:)==300&data(7,:)~=0);
            highToneResp=find(data(6,:)==600);
            numResp=numel(lowToneResp)+numel(highToneResp);
            sortResps=[lowToneResp,highToneResp];
            resps=sort(sortResps);
            rt=zeros(1,numel(lowToneResp));
            for count=1:numel(lowToneResp)
                if data(7,lowToneResp(1,count))~=0
                    rt(1,count)=data(8,lowToneResp(1,count));
                end
            end
            ac = zeros(1,numResp);
            for count=1:numResp
                if data(6,resps(1,count))==300
                    if data(7,resps(1,count))==1
                        if data(1,resps(1,count))==0
                            ac(1,count)=1;
                        elseif data(2,resps(1,count))==0
                            ac(1,count)=1;
                        end
                    elseif data(7,resps(1,count))==2
                        if data(3,resps(1,count))==0
                            ac(1,count)=1;
                        elseif data(4,resps(1,count))==0
                            ac(1,count)=1;
                        end
                    end
                elseif data(6,resps(1,count))==600
                    if data(7,resps(1,count))==0
                        ac(1,count)=1;
                    end
                end
            end
            
            correct = find(ac==1);
            numCorrect = numel(correct);
            accuracy = numCorrect/trials;
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
                resp=find(blockWMprobe(letter,block)==thisBlockWM);
                if resp~=0
                    letterInLoad=letterInLoad+1;
                end
                acLetter=letterInLoad/size(blockWMload,1);
            end
            meanWMletter(1,block)=acLetter;
        end
        
        acWMletter=sum(meanWMletter)/numel(meanWMletter);
        
        %find orienting effect
        
        numValid=0;
        numInvalid=0;
        valTrials=zeros(1,trials);
        invalTrials=zeros(1,trials);
        if cueCond==1
            for count=1:trials
                if data(5,count)<600&&data(1,count)==0||data(2,count)==0
                    numValid=numValid+1;
                    valTrials(1,count)=data(8,count);
                elseif 600<data(5,count)&&data(3,count)==0||data(4,count)==0
                    numValid=numValid+1;
                    valTrials(1,count)=data(8,count);
                elseif data(5,count)<600&&data(1,count)==1&&data(2,count)==1
                    numInvalid=numInvalid+1;
                    invalTrials(1,count)=data(8,count);
                elseif 600<data(5,count)&&data(3,count)==1&&data(4,count)==1
                    numInvalid=numInvalid+1;
                    invalTrials(1,count)=data(8,count);
                end
            end
            valTrialsRT=sum(valTrials)/sum(valTrials~=0,2);
            invalTrialsRT=sum(invalTrials)/sum(invalTrials~=0,2);
            oriEf=invalTrialsRT-valTrialsRT;
        end
         
% %         if task==1 &&& cue==1 && cueCond==1
% %             dotdu50=trials;
% %         elseif task==2 &&& cue==1 && cueCond==1
% %             dotdu100=trials;
% %         end
        
        save([filePath '/' sprintf('sj%02d_%s.mat',sjNum,blockID)],'trials','errorCom','errorOm','numCorrect','accuracy','meanRT','acWMorder','acWMletter','oriEf');
            
    end
end

% % masterStruct.dotdu50 =dotdu50;
% % masterStruct.dotdu100 = dotdu100; % etc....

    
return
