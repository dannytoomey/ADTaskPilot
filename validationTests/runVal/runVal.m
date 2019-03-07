
%==========================================================================
% function: runVal
% purpose: run validations tasks for AD Task and ensures proper
% counterbalancing
%==========================================================================

laptopDebug=0;

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

testCBO=    [1  1   2   2   3   3
             2  3   1   3   1   2
             3  2   3   1   2   1];

sessNum=input('Input Session Number ');
sjNum=input('Input Subject Number ');

if sessNum==199
    
    sjCBO=testCBO(:,1);
    
else
    
    if sessNum<=size(testCBO,2)
        sjCBO=testCBO(:,sessNum);
    else
        cycle=floor(sessNum/size(testCBO,2));
        if sessNum-(size(testCBO,2)*cycle)~=0
            sjCBO=testCBO(:,sessNum-(size(testCBO,2)*cycle));
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
    
    %runANT(sjNum,laptopDebug,ANTfilePath,backup)
    %v2runK(sjNum,laptopDebug,KfilePath,1,backup)  %1 for experiment, 0 for testing/debugging
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



