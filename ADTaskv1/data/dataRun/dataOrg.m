
%organize data and make it presentable

function dataOrg

sjStart = input('Input first subject ');
sjEnd = input('Input last subject ');
sjRange = sjStart:sjEnd;
numCue=2;
numTask=2;
numVis=3;
numVar=10;
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
            for cue=1:numCue
                if cue==1
                    cueCond='50';
                elseif cue==2
                    cueCond='100';
                end

                file=['sj' sprintf('%d',sjNum) '_' sprintf('%s',visCond) sprintf('%s',taskCond) sprintf('%s',cueCond) '.mat'];
                fileLoad=['' sprintf('%s', filePath) '/' sprintf('%s',file)];
                load(fileLoad);

                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).trials=trials;
                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).errorCom=errorCom;
                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).errorOm=errorOm;
                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).oriEf=oriEf;
                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).numCorrect=numCorrect;
                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).accuracy=accuracy;
                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).meanRT=meanRT;
                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).acWMorder=acWMorder;
                dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).acWMletter=acWMletter;

            end
        end
    end

    save('dataStruct.mat','dataStruct');

    load('dataStruct.mat');

    filePath='/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/data/dataRun/allOrg';

    allTrials=zeros(1,size(sjRange,2));
    allErrorCom=zeros(1,size(sjRange,2));
    allErrorOm=zeros(1,size(sjRange,2));
    allOriEf=zeros(1,size(sjRange,2));
    allNumCorrect=zeros(1,size(sjRange,2));
    allAccuracy=zeros(1,size(sjRange,2));
    allMeanRT=zeros(1,size(sjRange,2));
    allACWMOrder=zeros(1,size(sjRange,2));
    allACWMLetter=zeros(1,size(sjRange,2));
     
    var1='trials';
    var2='errorCom';
    var3='errorOm'; 
    var4='errorOm'; 
    var5='oriEf';
    var6='numCorrect'; 
    var7='accuracy';
    var8='meanRT'; 
    var9='acWMorder'; 
    var10='acWMletter';
    vars=[var1,var2,var3];
    
    for vis=1:numVis
        for task=1:numTask
            for cue=1:numCue
                for var=1:numVar
                    
                    thisTrials=dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).trials;
                    thisErrorCom=dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).errorCom;
                    thisErrorOm=dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).errorOm;
                    thisOriEf=dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).oriEf;
                    thisNumCorrect=dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).numCorrect;
                    thisAccuracy=dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).accuracy;
                    thisMeanRT=dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).meanRT;
                    thisACWMOrder=dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).acWMorder;
                    thisACWMLetter=dataStruct.visCond(vis).taskCond(task).cueCond(cue).allSj(sjNum).acWMletter;

                    dataMat(var,sj,cue,task,vis)

                    if size(thisTrials,2)==1
                        allTrials(1,sub)=thisTrials;
                    end
                    if size(thisErrorCom,2)==1
                        allErrorCom(1,sub)=thisErrorCom;
                    end
                    if size(thisErrorOm,2)==1
                        allErrorOm(1,sub)=thisErrorOm;
                    end
                    if size(thisOriEf,2)==1
                        allOriEf(1,sub)=thisOriEf;
                    end
                    if size(thisNumCorrect,2)==1
                        allNumCorrect(1,sub)=thisNumCorrect;
                    end
                    if size(thisAccuracy,2)==1
                        allAccuracy(1,sub)=thisAccuracy;
                    end
                    if size(thisMeanRT,2)==1
                        allMeanRT(1,sub)=thisMeanRT;
                    end
                    if size(thisACWMOrder,2)==1
                        allACWMOrder(1,sub)=thisACWMOrder;
                    end
                    if size(thisACWMLetter,2)==1
                        allACWMLetter(1,sub)=thisACWMLetter;
                    end



                    save([filePath '/' 'allSjData.' sprintf('%d',vis) '.' sprintf('%d',task) '.' sprintf('%d',cue) '.mat'], ...
                        'allTrials','allErrorCom','allErrorOm','allOriEf','allNumCorrect','allAccuracy','allMeanRT', ...
                        'allACWMOrder','allACWMLetter');

                end
            end
        end
    end
end


return

