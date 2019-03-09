
clearvars;

taskCBO=        [1  2       %1=single first, 2=dual first
                 2  1];
dualRespCBO=    [1  2       %determines letter or shape stream speed for dual task
                 2  1];
singleRespCBO=  [1	2	3	4	4	3	2	1	1	3	2	4	4	2	3	1       %determines single task resp order
                 2	3	4	1	3	2	1	4	3	2	4	1	2	3	1	4       
                 3	4	1	2	2	1	4	3	2	4	1	3	3	1	4	2
                 4	1	2	3	1	4	3	2	4	1	3	2	1	4	2	3];
numTask=2;
numTrials=18;
sjList=1:150;

thisSj=0;

for sj=1:size(sjList,2)
    
    sjNum=sjList(1,sj);

    order=0;
    breakLoop=0;
    for dual=1:2
        dualOrder=dualRespCBO(:,dual);
        for single=1:16
            singleOrder=singleRespCBO(:,single);
            for task=1:2
                taskOrder=taskCBO(:,task);
                order=order+1;
                if sjNum==order
                    breakLoop=1;
                    break
                end
            end
            if breakLoop==1
               break
            end
        end
        if breakLoop==1
           break
        end
    end
    
    Task={};

    for task=1:numTask
        
        if taskOrder(task,1)==1
            thisTask=1;     %do single task
            condOrder=singleOrder;
            numBlock=4;     %b/c resp to fast shape, slow shape, fast let, or slow let
        elseif taskOrder(task,1)==2
            thisTask=2;     %do dual task
            condOrder=dualOrder;
            numBlock=2;     %b/c resp to faster shape or letter stream
        end
        
        Block={};
        
        for block=1:numBlock
            
            %determine which stream will be faster for each block

            fastShapeStream=0;
            fastLetStream=0;

            if condOrder(block,1)==1||condOrder(block,1)==3
                fastShapeStream=1;
            else
                fastLetStream=1;
            end

            if fastShapeStream==1
                shapeDur=2;
                numShapes=3;
                letDur=3;
                numLets=2;
                streamCond=1;
            elseif fastLetStream==1
                shapeDur=3;
                numShapes=2;
                letDur=2;
                numLets=3;
                streamCond=2;
            end

            trialDur=6;
            numShapeFlips=trialDur/shapeDur;
            numLetFlips=trialDur/letDur;

            %this will shuffle the order of the shapes at the start of each
            %block. reshuffle if there are less than 25 valid dual targets per
            %block (4 resps/trial *18 trials = 76 possible resps, let's make
            %it 33%)


            rng('shuffle')

            while 1

                shapeOrder=randi([1,numShapes],1,numTrials*numShapeFlips);
                letterOrder=randi([1,numLets],1,numTrials*numLetFlips);

                blockStim=zeros(2,12*numTrials);
                shapestim=1;
                letstim=1;
                if fastShapeStream==1
                    shapeOffset=3;
                    letOffset=5;
                else
                    shapeOffset=5;
                    letOffset=3;
                end
                for shapeflip=1:numShapeFlips*numTrials
                    blockStim(1,shapestim:shapestim+shapeOffset)=shapeOrder(1,shapeflip);
                    shapestim=shapestim+shapeOffset+1;
                end
                for letflip=1:numLetFlips*numTrials
                    blockStim(2,letstim:letstim+letOffset)=letterOrder(1,letflip);
                    letstim=letstim+letOffset+1;
                end
                numtargetspace=0;
                if thisTask==1
                    if condOrder(block,1)<=2
                        startCheck=5;
                    else
                        startCheck=7;
                    end
                    for check=startCheck:size(blockStim,2)
                        if condOrder(block,1)==1||condOrder(block,1)==4     %single task, shape resp
                            if blockStim(1,check)==blockStim(1,check-(shapeOffset+1))
                                numtargetspace=numtargetspace+1;
                            end
                        elseif condOrder(block,1)==2||condOrder(block,1)==3 %single task, letter resp
                            if blockStim(1,check)==blockStim(1,check-(letOffset+1))
                                numtargetspace=numtargetspace+1;
                            end
                        end
                    end
                end
                if thisTask==2
                    for check=7:size(blockStim,2)
                        if blockStim(1,check)==blockStim(1,check-(shapeOffset+1))&&blockStim(2,check)==blockStim(2,check-(letOffset+1))
                            numtargetspace=numtargetspace+1;
                        end
                    end
                end
                numTargets=numtargetspace/4;

                if numTargets==(numTrials*4/3)  %ensure target given on 1/3 of all possible resps for all conditions
                    break
                end
            end
            Block(block).letters=letterOrder;
            Block(block).shapes=shapeOrder;
        end
        Task(task).Block=Block;
    end
    Sj(sj).Task=Task;
    thisSj=thisSj+1;
    disp(thisSj)
end

saveFile=sprintf('sj%d-sj%dStimStruct.mat',min(sjList),max(sjList));
if exist(saveFile,'file')
    sca;
    msgbox('File already exists!','modal')
    return
end
save(saveFile,'Sj')

