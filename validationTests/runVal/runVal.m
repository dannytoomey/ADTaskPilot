
%==========================================================================
% function: runVal
% purpose: run validations tasks for AD Task and ensures proper
% counterbalancing
%==========================================================================

laptopDebug=1;

if laptopDebug==1
    Screen('Preference','SkipSyncTests',1)
    ANTfilePath='/Users/dannytoomey/Documents/Research/ADTask/Experiments/testData/';
    KfilePath='/Users/dannytoomey/Documents/Research/ADTask/Experiments/testData/';
    DIVfilePath='/Users/dannytoomey/Documents/Research/ADTask/Experiments/testData/';
    backup='/Users/dannytoomey/Documents/Research/ADTask/Experiments/testData/';
else
    ANTfilePath='/Users/labadmin/Documents/Experiments/ADTask/ADTaskPilot/validationTests/ANT/';
    KfilePath='/Users/labadmin/Documents/Experiments/ADTask/ADTaskPilot/validationTests/kTest/';
    DIVfilePath='/Users/labadmin/Documents/Experiments/ADTask/ADTaskPilot/validationTests/dividedTest/';
    backup='/Users/labadmin/Documents/Experiments/ADTask/backup/';
end

testCBO=[1	1   1   1	1   1   2	2   2   2   2	2   3	3   3   3   3   3
         2	2   2   3	3   3   1	1   1   3   3	3   1	1   1   2   2   2
         3	3   3   2	2   2   3	3   3   1   1  	1   2	2   2   1   1   1];

sjNum=input('Input Subject Number ');

if sjNum==199
    
    sjCBO=testCBO(:,1);
    
else
    
    if sjNum<=size(testCBO,2)
        sjCBO=testCBO(:,sjNum);
    else
        cycle=floor(sjNum/size(testCBO,2));
        if sjNum-(size(testCBO,2)*cycle)~=0
            sjCBO=testCBO(:,sjNum-(size(testCBO,2)*cycle));
        else
            sjCBO=testCBO(:,size(testCBO,2));
        end
    end
end

saveFile=['sj' sprintf('%02d',sjNum) 'ValInfo.mat'];

if sjNum~=199   %add b/c idc if it overwrites the files if i'm debugging
    if exist(saveFile,'file')
        sca;
        msgbox('File already exists!', 'modal')
        return;
    end
end

save(saveFile,'sjCBO')

if sjNum==199
    
<<<<<<< HEAD
    %runANT(sjNum,laptopDebug,ANTfilePath,backup)
    exp=0;   %1 for experiment, 0 for testing/debugging
    %v2runK(sjNum,laptopDebug,KfilePath,exp,backup)
=======
    runANT(sjNum,laptopDebug,ANTfilePath,backup)
    exp=1;   %1 for experiment, 0 for testing/debugging
    v2runK(sjNum,laptopDebug,KfilePath,exp,backup)
>>>>>>> fa150399bc9f902e56e9480f382f360f45b083fb
    runDivTask(sjNum,laptopDebug,DIVfilePath,backup)
    
else
    
    skipTask=input('Skip Task? ');
    if skipTask==0
        taskCBO=sjCBO;
    elseif skipTask==1
        taskCBO=sjCBO(2:3,1);
    elseif skipTask==2
        taskCBO=sjCBO(3,1);
    end
    
    for task=1:size(taskCBO,1)
        
        thisTask=taskCBO(task,1);
        
        if thisTask==1
            runANT(sjNum,laptopDebug,ANTfilePath,backup)
        elseif thisTask==2
            exp=1;   %1 for experiment, 0 for testing/debugging
            v2runK(sjNum,laptopDebug,KfilePath,exp,backup)
        elseif thisTask==3
            runDivTask(sjNum,laptopDebug,DIVfilePath,backup)
        end
    end
end



