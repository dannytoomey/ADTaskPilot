
%graph neutral red word position rts

sjRange=input('Input subjects ');
sjStart=min(sjRange);
sjEnd=max(sjRange);

numCue=2;
numTask=2;
numVar=4;

wordLocMat=nan(size(sjRange,2),numVar,numCue,numTask);

for sj=1:size(sjRange,2)
    sjNum=sjRange(1,sj);
    filePath = ['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/data/sj' sprintf('%d',sjNum)];
    
    load('dataStruct.mat');
    
    visCond='neu';
    
    if 1<sj
        load('wordLocStruct.mat');
    end
    
    for task=1:numTask
        if task==1
            taskCond='si';
        elseif task==2
            taskCond='du';
        end
        
        for cue=1:numCue
            if cue==1
                cueCond='100';
            elseif cue==2
                cueCond='50';
            end

            file=['sj' sprintf('%d',sjNum) '_' sprintf('%s',visCond) sprintf('%s',taskCond) sprintf('%s',cueCond) '.mat'];
            fileLoad=['' sprintf('%s', filePath) '/' sprintf('%s',file)];
            load(fileLoad);
            
            wordLocStruct.taskCond(task).cueCond(cue).allSj(sjNum).trgAvg=targetAvg;
            wordLocStruct.taskCond(task).cueCond(cue).allSj(sjNum).aClAvg=adjColAvg;
            wordLocStruct.taskCond(task).cueCond(cue).allSj(sjNum).aRwAvg=adjRowAvg;
            wordLocStruct.taskCond(task).cueCond(cue).allSj(sjNum).diaAvg=diagAvg;

        end
    end
    
    save('wordLocStruct.mat','wordLocStruct');
    
    fieldNames=['trgAvg' 'aClAvg' 'aRwAvg' 'diaAvg'];
    
    for task=1:numTask
        for cue=1:numCue
            thisVar=1;
            for var=1:numVar
                varName=fieldNames(thisVar:thisVar+5);                    
                thisData=wordLocStruct.taskCond(task).cueCond(cue).allSj(sjNum).(varName);
                wordLocMat(sj,var,cue,task)=thisData;
                thisVar=thisVar+6;
            end
        end
    end  
end

vars2graph=1:4;
graphMat=nan(numCue,numTask,size(vars2graph,2));

for var=1:size(vars2graph,2)
    for task=1:numTask
        for cue=1:numCue
            meanVar=mean(wordLocMat(:,vars2graph(1,var),cue,task));
            graphMat(cue,task,var)=meanVar;
        end
    end
end

graphFileName=['neuGraphMat.sj' sprintf('%d',sjStart) '-sj' sprintf('%d',sjEnd) '.mat'];
save(graphFileName,'graphMat');

%graph accuracy (var=6)

numBins=4;
bins=zeros(1,numBins);
numVar=size(vars2graph,2);

%present graph so that bins are the four locations for each cue/task cond

for var=1:numVar
    count=1;
    for task=1:numTask
        for cue=1:numCue
            
            bins(1,count)=graphMat(cue,task,var);
        
            if task==1
                if cue==1
                    varName='Neutral Single Task with 66% Valid Cues';
                elseif cue==2
                    varName='Neutral Single Task with 33% Valid Cues';
                end
            elseif task==2
                if cue==1
                    varName='Neutral Dual Task with 66% Valid Cues';
                elseif cue==2
                    varName='Neutral Dual Task with 33% Valid Cues';
                end
            end

            bar(bins);
            xlabel='Experimental Condition';
            ylabel(varName,'FontSize',12);
            file=['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/data/dataRun/graphs/' sprintf('%s',varName)];
            saveas(gcf,file,'png');
            
            count=count+1;
            
        end
    end
end
