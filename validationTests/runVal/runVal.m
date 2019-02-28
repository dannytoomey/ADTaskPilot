
%==========================================================================
% function: runVal
% purpose: run validations tasks for AD Task and ensures proper
% counterbalancing
%==========================================================================

laptopDebug=0;

if laptopDebug==1
    Screen('Preference','SkipSyncTests',1)
    ANTfilePath='/Users/dannytoomey/Documents/Research/ADTask/Experiments/ADTaskPilot/validationTests/ANT/';
    KfilePath='/Users/dannytoomey/Documents/Research/ADTask/Experiments/ADTaskPilot/validationTests/kTest/';
    DIVfilePath='/Users/dannytoomey/Documents/Research/ADTask/Experiments/ADTaskPilot/validationTests/dividedTest/';
else
    ANTfilePath='/Users/labadmin/Documents/Experiments/ADTask/ADTaskPilot/validationTests/ANT/';
    KfilePath='/Users/labadmin/Documents/Experiments/ADTask/ADTaskPilot/validationTests/kTest/';
    DIVfilePath='/Users/labadmin/Documents/Experiments/ADTask/ADTaskPilot/validationTests/dividedTest/';  
end

testCBO=[1	1   1   1	1   1   2	2   2   2   2	2   3	3   3   3   3   3
         2	2   2   3	3   3   1	1   1   3   3	3   1	1   1   2   2   2
         3	3   3   2	2   2   3	3   3   1   1  	1   2	2   2   1   1   1];

sjNum=input('Input Subject Number ');

if sjNum==199
    
    age=22;
    gender=0;
    handedness=1;
    sjCBO=testCBO(:,1);
    
else
    
    age=input('Type age and press enter ');
    gender=input('Type gender (0 = M, 1 = F) and press enter ');
    handedness=input('Type handedness (0 = L, 1 = R) and press enter ');    
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

saveFile=['sj' sprintf('%02d',sjNum) 'Info.mat'];
save(saveFile,'age','gender','handedness','sjCBO')

if sjNum==199
    
    %runANT(sjNum,laptopDebug,ANTfilePath)
    exp=0;   %1 for experiment, 0 for testing/debugging
    v2runK(sjNum,laptopDebug,KfilePath,exp)
    %runDivTask(sjNum,laptopDebug,DIVfilePath)
    
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
            runANT(sjNum,laptopDebug,ANTfilePath)
        elseif thisTask==2
            exp=1;   %1 for experiment, 0 for testing/debugging
            v2runK(sjNum,laptopDebug,KfilePath,exp)
        elseif thisTask==3
            runDivTask(sjNum,laptopDebug,DIVfilePath)
        end
    end
end



