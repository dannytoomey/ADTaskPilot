
%organize data and make it presentable

%IDEA - do 16 trials per WM block because WM data is near ceiling.
   %pro - harder on WM, will decrease overall time is takes to do task
   %con - less WM data points (still 48 per participant), may be too
   %diffcult for AD

function dataOrg2

sjStart=input('Input first subject ');
sjEnd=input('Input last subject ');
sjRange=sjStart:sjEnd;

numCue=2;
numTask=2;
numVis=3;
numVar=9;
dataMat=nan(size(sjRange,2),numVar,numCue,numTask,numVis);

for sj=1:size(sjRange,2)
    sjNum=sjRange(1,sj);
    filePath = ['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/data/sj' sprintf('%d',sjNum)];
    
    load('dataStruct.mat');

    for vis=1:numVis
        if vis==1
            visCond='dot';
        elseif vis==2
            visCond='neu';
        elseif vis==3
            visCond='str';
        end
        for task=1:numTask
            if task==1
                taskCond='si';
            elseif task==2
                taskCond='du';
            end
            %label cue 1 as 100% so that the graph shows 100 before 50
            for cue=1:numCue
                if cue==1
                    cueCond='100';
                elseif cue==2
                    cueCond='50';
                end

                file=['sj' sprintf('%d',sjNum) '_' sprintf('%s',visCond) sprintf('%s',taskCond) sprintf('%s',cueCond) '.mat'];
                fileLoad=['' sprintf('%s', filePath) '/' sprintf('%s',file)];
                load(fileLoad);

                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).trials=trials;
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

dataFileName=['dataMat.sj' sprintf('%d',sjStart) '-sj' sprintf('%d',sjEnd) '.mat'];
save(dataFileName,'dataMat');

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

graphFileName=['graphMat.sj' sprintf('%d',sjStart) '-sj' sprintf('%d',sjEnd) '.mat'];
save(graphFileName,'graphMat');

%graph accuracy (var=6)

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
    file=['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/data/dataRun/graphs/' sprintf('%s',varName)];
    saveas(gcf,file,'png');
    
end

return

