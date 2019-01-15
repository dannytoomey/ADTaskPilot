
%graph! the! data!

function dataGraph2

load('dataAnFile.mat');

numCond=3;
numTask=2;
numCue=2;
numSub=size(sjRange,2);
numVar=6;

dataMat=nan(numVar,numCond,numTask,numCue,numSub);

for var=1:numVar
    for cond=1:numCond
        if cond==1
            thisCond='low';
        elseif cond==2
            thisCond='med';
        elseif cond==3
            thisCond='high';
        end
        for task=1:numTask
            if task==1
                thisTask='si';
            elseif task==2
                thisTask='du';
            end
            for cue=1:numCue
                if cue==1
                    thisCue='33';
                elseif cue==2
                    thisCue='66';
                end
                for sub=1:numSub
                    sjNum=sjRange(1,sub);
                    if sjNum<=9
                        thisSj=['sj0' sprintf('%d',sjNum)];
                    elseif 9<sjNum
                        thisSj=['sj' sprintf('%d',sjNum)];
                    end
                    fileLoad=[thisSj '_' thisCond thisTask thisCue '.mat'];
                    load(fileLoad);
                    if var==1
                        dataMat(var,cond,task,cue,sub)=errorOm;
                    elseif var==2
                        dataMat(var,cond,task,cue,sub)=errorCom;
                    elseif var==3
                        dataMat(var,cond,task,cue,sub)=accuracyWM;
                    elseif var==4
                        dataMat(var,cond,task,cue,sub)=meanRT;
                    elseif var==5
                        dataMat(var,cond,task,cue,sub)=accuracy;
                    elseif var==6
                        dataMat(var,cond,task,cue,sub)=oriEf;
                    end
                end
            end
        end
    end   

    numBins=12;
    varBins=zeros(1,numBins);
    count=1;
    
    for cond=1:numCond
        for task=1:numTask
            for cue=1:numCue
                meanVar=mean(dataMat(var,cond,task,cue,:));
                sqDev=(dataMat(var,cond,task,cue,:)-meanVar).^2;
                SS=sum(sqDev);
                standDev=sqrt(SS/(numSub-1));
                normScores=zeros(1,numSub);
                for sub=1:numSub
                    if abs(dataMat(var,cond,task,cue,sub)-meanVar)<=(2*standDev)
                        normScores(1,sub)=dataMat(var,cond,task,cue,sub);
                    end
                end
                useScores=find(normScores~=0);
                graphScores=size(useScores,2);
                for score=1:size(useScores,2)
                    graphScores(1,score)=normScores(useScores(1,score));
                end
                varBins(1,count)=mean(graphScores);
                count=count+1;
            end
        end
    end

    if var==1
        thisVar='Errors of Omission';
    elseif var==2
        thisVar='Errors of Comission';
    elseif var==3
        thisVar='Working Memory Accuracy';
    elseif var==4
        thisVar='Mean Response Time';
    elseif var==5
        thisVar='Accuracy';
    elseif var==6
        thisVar='Orienting Effect';
    end

    bar(varBins);
    ylabel(thisVar,'FontSize',12);
    file=['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/ADTaskv2/data/graphs/' sprintf('%s',thisVar)];
    saveas(gcf,file,'png');
    
end


numCond=2;
numTask=2;
numCue=2;
numSub=size(sjRange,2);
numVar=3;

locRespMat=nan(numVar,numCond,numTask,numCue,numSub);

for var=1:numVar
    for cond=1:numCond
        if cond==1
            thisCond='med';
        elseif cond==2
            thisCond='high';
        end
        for task=1:numTask
            if task==1
                thisTask='si';
            elseif task==2
                thisTask='du';
            end
            for cue=1:numCue
                if cue==1
                    thisCue='33';
                elseif cue==2
                    thisCue='66';
                end
                for sub=1:numSub
                    sjNum=sjRange(1,sub);
                    if sjNum<=9
                        thisSj=['sj0' sprintf('%d',sjNum)];
                    elseif 9<sjNum
                        thisSj=['sj' sprintf('%d',sjNum)];
                    end
                    fileLoad=[thisSj '_' thisCond thisTask thisCue '.mat'];
                    load(fileLoad);
                    if var==1
                        locRespMat(var,cond,task,cue,sub)=colRT;
                    elseif var==2
                        locRespMat(var,cond,task,cue,sub)=rowRT;
                    elseif var==3
                        locRespMat(var,cond,task,cue,sub)=diagRT;
                    end
                end
                
            end
        end
    end 
end

varBins=zeros(1,numVar*numCond);
normScores=nan(numVar,numCond,numTask,numCue,numSub);
count=1;

for var=1:numVar
    for cond=1:numCond
        for task=1:numTask
            for cue=1:numCue
                meanVar=mean(locRespMat(var,cond,task,cue,:));
                sqDev=(locRespMat(var,cond,task,cue,:)-meanVar).^2;
                SS=sum(sqDev);
                standDev=sqrt(SS/(numSub-1));
                for sub=1:numSub
                    if abs(locRespMat(var,cond,task,cue,sub)-meanVar)<=(2*standDev)
                        normScores(var,cond,task,cue,sub)=locRespMat(var,cond,task,cue,sub);
                    end
                end
            end
        end
        varBins(1,count)=mean(reshape(normScores(var,cond,:,:,:),1,[]),'omitnan');
        count=count+1;
    end
end

binOrder=zeros(1,numVar*numCond);
binOrder(1,1)=varBins(1,1);
binOrder(1,2)=varBins(1,3);
binOrder(1,3)=varBins(1,5);
binOrder(1,4)=varBins(1,2);
binOrder(1,5)=varBins(1,4);
binOrder(1,6)=varBins(1,6);

thisVar='Unique Distractor Locations';

bar(binOrder);
ylabel(thisVar,'FontSize',12);
file=['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/ADTaskv2/data/graphs/' sprintf('%s',thisVar)];
saveas(gcf,file,'png');    

return
