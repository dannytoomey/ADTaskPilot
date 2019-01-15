
%organize data and make it presentable

function dataGraph

sjRange=input('Input subjects ');

numCue=2;
numTask=2;
numVis=3;
numVar=9;
dataMat=nan(size(sjRange,2),numVar,numCue,numTask,numVis);

for sj=1:size(sjRange,2)
    
    sjNum=sjRange(1,sj);
    
    if sjNum<=9
        filePath=['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/ADTaskv2/data/dataRun/sj0' sprintf('%d',sjNum)];
    else
        filePath=['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/ADTaskv2/data/dataRun/sj' sprintf('%d',sjNum)];
    end
    
    if 1<sjNum
        load('dataStruct.mat');
    end

    for vis=1:numVis
        if vis==1
            visCond='low';
        elseif vis==2
            visCond='med';
        elseif vis==3
            visCond='high';
        end
        for task=1:numTask
            if task==1
                taskCond='si';
            elseif task==2
                taskCond='du';
            end
            %label higher cue validity first
            for cue=1:numCue
                if cue==1
                    cueCond='66';
                elseif cue==2
                    cueCond='33';
                end

                file=['_' sprintf('%s',visCond) sprintf('%s',taskCond) sprintf('%s',cueCond) '.mat'];
                fileLoad=[sprintf('%s', filePath) sprintf('%s',file)];
                load(fileLoad);

                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).trials=numTrials;
                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).errorC=errorCom;
                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).errorO=errorOm;
                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).oriEff=oriEf;
                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).numCor=numCorrect;
                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).accrcy=accuracy;
                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).meanRT=meanRT;
                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).acWMor=acWMorder;
                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).acWMlt=acWMletter;

            end
        end
    end

    save('dataStruct.mat','dataStruct');

    load('dataStruct.mat');

    fieldNames=['trials' 'errorC' 'errorO' 'oriEff' 'numCor' 'accrcy' 'meanRT' 'acWMor' 'acWMlt'];
    
    for vis=1:numVis
        for task=1:numTask
            for cue=1:numCue
                thisVar=1;
                for var=1:numVar
                    varName=fieldNames(thisVar:thisVar+5);
                    thisData=dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).(varName);
                    dataMat(sj,var,cue,task,vis)=thisData;
                    thisVar=thisVar+6;
                end
            end
        end
    end
end

vars2graph=1:9;
graphMat=nan(numCue,numTask,numVis,size(vars2graph,2));

for var=1:size(vars2graph,2)
    for vis=1:numVis
        for task=1:numTask
            for cue=1:numCue
                meanVar=mean(dataMat(:,vars2graph(1,var),cue,task,vis));
                graphMat(cue,task,vis,var)=meanVar;
            end
        end
    end
end

numBins=12;
bins=zeros(1,numBins);
numVars=size(vars2graph,2);

for var=1:numVars
    count=1;
    for vis=1:numVis
        for task=1:numTask
            for cue=1:numCue
                bins(1,count)=graphMat(cue,task,vis,var);
                count=count+1;
            end
        end
    end

    if vars2graph(1,var)==1
        varName='Trials';
    elseif vars2graph(1,var)==2
        varName='Errors of Comission';
    elseif vars2graph(1,var)==3
        varName='Errors of Omission';
    elseif vars2graph(1,var)==4
        varName='Orienting Effect';
    elseif vars2graph(1,var)==5
        varName='Number Correct';
    elseif vars2graph(1,var)==6
        varName='Accuracy';
    elseif vars2graph(1,var)==7
        varName='Response Time';
    elseif vars2graph(1,var)==8
        varName='Working Memory Accuracy (letters in order)';
    elseif vars2graph(1,var)==9
        varName='Working Memory Accuracy (letters in any order)';
    end

    bar(bins);
    xlabel='Experimental Condition';
    ylabel(varName,'FontSize',12);
    fileSave=['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/ADTaskv2/data/graphs/' sprintf('%s',varName)];
    saveas(gcf,fileSave,'png');
    
end

return

