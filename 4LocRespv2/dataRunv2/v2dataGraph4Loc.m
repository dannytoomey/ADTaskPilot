
%graph! the! data!

function v2dataGraph4Loc(sjRange)

load('allDataStruct.mat')

numCond=3;
numTask=2;
numCue=2;
numVar=5;

dataMat=nan(numVar,numCond,numTask,numCue,size(sjRange,2));

for var=1:numVar
    for cond=1:numCond
        for task=1:numTask
            for cue=1:numCue
                for sub=1:size(sjRange,2)
                    if var==1
                        dataMat(var,cond,task,cue,sub)=allDataStruct(cond).task(task).cue(cue).visMeanRT(sjRange(1,sub));
                    elseif var==2
                        dataMat(var,cond,task,cue,sub)=allDataStruct(cond).task(task).cue(cue).visAccuracy(sjRange(1,sub));
                    elseif var==3
                        dataMat(var,cond,task,cue,sub)=allDataStruct(cond).task(task).cue(cue).audAccuracy(sjRange(1,sub));
                    elseif var==4
                        dataMat(var,cond,task,cue,sub)=allDataStruct(cond).task(task).cue(cue).oriEf(sjRange(1,sub));
                    elseif var==5
                        dataMat(var,cond,task,cue,sub)=allDataStruct(cond).task(task).cue(cue).accuracyWM(sjRange(1,sub));
                    end
                end
            end
        end
    end   

    numBins=numCond*numTask*numCue;
    varBins=zeros(1,numBins);
    varSEM=zeros(1,numBins);
    count=1;
    
    for cond=1:numCond
        for task=1:numTask
            for cue=1:numCue
                useScores=(~isnan(dataMat(var,cond,task,cue,:)));
                thisScores=find(useScores~=0);
                graphScores=zeros(1,size(thisScores,1));
                for score=1:size(thisScores,1)
                    graphScores(1,score)=dataMat(var,cond,task,cue,thisScores(score,1));
                end
                meanVar=mean(graphScores);
                sqDev=(graphScores-meanVar).^2;
                SS=sum(sqDev);
                numScores=size(graphScores,2);
                standDev=sqrt(SS/(numScores-1));
                normScores=nan(1,numScores);
                for x=1:numScores
                    if abs(graphScores(1,x)-meanVar)<=(2*standDev)
                        normScores(1,x)=graphScores(1,x);
                    end
                end
                normGraph=normScores(~isnan(normScores));
                varBins(1,count)=mean(normGraph);
                varSEM(1,count)=std(normGraph)/sqrt(size(sjRange,2));
                count=count+1;
            end
        end
    end
    
    if var==1
        thisVar='Selective Attention RT';
    elseif var==2
        thisVar='Selective Attention Accuracy';
    elseif var==3
        thisVar='Dual Task Accuracy';
    elseif var==4
        thisVar='Orienting Effect';
    elseif var==5
        thisVar='Working Memory Accuracy';
    end
    
    graphLabel=[thisVar ', N = ' sprintf('%d',size(sjRange,2))];
    newplot
    hold
    bar(varBins);
    ylabel(graphLabel,'FontSize',12);
    errorbar(varBins,varSEM,'.');
    file=['/Users/dannytoomey/Documents/Research/ADTask/Experiments/ADTaskPilot/4LocRespv2/dataRunv2/' sprintf('%s',thisVar)];
    saveas(gcf,file,'png'); 
    hold off
    
end

numVar=6;
useConds=[2,3];
uniDist=NaN;

for var=1:numVar
    count=1;
    for cond=1:size(useConds,2)
        for task=1:numTask
            for cue=1:numCue
                for sub=1:size(sjRange,2)
                    if var==1
                        uniDist(var,count)=allDataStruct(useConds(1,cond)).task(task).cue(cue).meanColRT(sjRange(1,sub));
                    elseif var==2
                        uniDist(var,count)=allDataStruct(useConds(1,cond)).task(task).cue(cue).meanRowRT(sjRange(1,sub));
                    elseif var==3
                        uniDist(var,count)=allDataStruct(useConds(1,cond)).task(task).cue(cue).meanDiagRT(sjRange(1,sub));
                    elseif var==4
                        uniDist(var,count)=allDataStruct(useConds(1,cond)).task(task).cue(cue).meanColRT(sjRange(1,sub));
                    elseif var==5
                        uniDist(var,count)=allDataStruct(useConds(1,cond)).task(task).cue(cue).meanRowRT(sjRange(1,sub));
                    elseif var==6
                        uniDist(var,count)=allDataStruct(useConds(1,cond)).task(task).cue(cue).meanDiagRT(sjRange(1,sub));
                    end
                    count=count+1;
                end
            end
        end     
    end
end

varBins=zeros(1,numVar);
varSEM=zeros(1,numVar);    

for var=1:numVar
   
    useScores=(~isnan(uniDist(var,:)));
    thisScores=find(useScores~=0);
    graphScores=zeros(1,size(thisScores,2));
    for score=1:size(thisScores,2)
        graphScores(1,score)=uniDist(var,thisScores(1,score));
    end
    meanVar=mean(graphScores);
    sqDev=(graphScores-meanVar).^2;
    SS=sum(sqDev);
    numScores=size(graphScores,2);
    standDev=sqrt(SS/(numScores-1));
    normScores=nan(1,numScores);
    for x=1:numScores
        if abs(graphScores(1,x)-meanVar)<=(2*standDev)
            normScores(1,x)=graphScores(1,x);
        end
    end
    normGraph=normScores(~isnan(normScores));
    varBins(1,var)=mean(normGraph);
    varSEM(1,var)=std(normGraph)/sqrt(size(sjRange,2));
    
end

thisVar='Unique Distractor RT';
graphLabel=[thisVar ', N = ' sprintf('%d',size(sjRange,2))];
newplot
hold
bar(varBins);
ylabel(graphLabel,'FontSize',12);
errorbar(varBins,varSEM,'.');
file=['/Users/dannytoomey/Documents/Research/ADTask/Experiments/ADTaskPilot/4LocRespv2/dataRunv2/' sprintf('%s',thisVar)];
saveas(gcf,file,'png'); 
hold off

return

