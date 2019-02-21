
% runfile for 4LocTaskv2

sjNum = input('Input Subject Number ');

counterBal=[1	2	3	4	5	6	1	2	3	4	5	6	1	2	3	4	5	6	1	2	3	4	5	6	1	2	3	4	5	6	1	2	3	4	5	6
            1	2	3	4	5	6	2	3	4	5	6	1	3	4	5	6	1	2	4	5	6	1	2	3	5	6	1	2	3	4	6	1	2	3	4	5];

if sjNum==199
    
    numBlocks=1;
    
    age=22;
    gender=0;
    handedness=1;
    lowTaskOrder=1;
    medTaskOrder=1;
    highTaskOrder=1;
    condCBOrder=0;
    taskCBOrder=0;
    
else
    
    numBlocks=8;
    
    age = input('Input Age ');
    gender = input('Input Gender (0 = M, 1 = F) ');
    handedness = input('Input Handedness (0 = L, 1 = R) ');
    if sjNum<=36
        taskCBOrder=counterBal(1,sjNum);
        condCBOrder=counterBal(2,sjNum);
    else
        cycle=floor(sjNum/36);
        orderNum=sjNum-(36*cycle);    
        if orderNum==0
            taskCBOrder=6;
            condCBOrder=5;
        else
            taskCBOrder=counterBal(1,orderNum);
            condCBOrder=counterBal(2,orderNum);
        end
    end
end

if taskCBOrder==1
    lowTaskOrder = 1;
    medTaskOrder = 1;
    highTaskOrder = 1;
elseif taskCBOrder==2
    lowTaskOrder = 2;
    medTaskOrder = 1;
    highTaskOrder = 1;
elseif taskCBOrder==3
    lowTaskOrder = 2;
    medTaskOrder = 2;
    highTaskOrder = 1;
elseif taskCBOrder==4
    lowTaskOrder = 2;
    medTaskOrder = 2;
    highTaskOrder = 2;
elseif taskCBOrder==5
    lowTaskOrder = 1;
    medTaskOrder = 2;
    highTaskOrder = 2;
elseif taskCBOrder==6
    lowTaskOrder = 1;
    medTaskOrder = 1;
    highTaskOrder = 2;
end

laptopDebug=0;

if laptopDebug==1
    Screen('Preference','SkipSyncTests',1)
    filePath='/Users/dannytoomey/Documents/Research/ADTask/Experiments/ADTaskPilot/4LocRespv2/4LocRespv2Files';
else
    filePath = '/Users/labadmin/Documents/Experiments/ADTask/ADTaskPilot/4LocRespv2/4LocRespv2Data';
    save([filePath '/' sprintf('sj%02d_SubjectInfo.mat',sjNum)],'age','gender','handedness','condCBOrder','taskCBOrder');
end

numTask = 2;
numCue = 2;

numTrials = 6;
valCueThres=2/3;
invalCueThres=1/3;

wmLoadDur=3;
visRespDur=1;
audRespDur=2.5;

numChannels = 1;
soundRep = 1;
soundDur = 0.25;
waitForDeviceStart = 0;

if condCBOrder==0
    v2_4locPrac(numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locLowIntf(filePath,sjNum,lowTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locMedIntf(filePath,sjNum,medTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locHighIntf(filePath,sjNum,highTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
end
if condCBOrder==1
    v2_4locPrac(numTask,numCue,numBlocks,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locLowIntf(filePath,sjNum,lowTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locMedIntf(filePath,sjNum,medTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locHighIntf(filePath,sjNum,highTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
elseif condCBOrder==2
    v2_4locPrac(numTask,numCue,numBlocks,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locLowIntf(filePath,sjNum,lowTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locHighIntf(filePath,sjNum,highTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locMedIntf(filePath,sjNum,medTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
elseif condCBOrder==3
    v2_4locPrac(numTask,numCue,numBlocks,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locMedIntf(filePath,sjNum,medTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locLowIntf(filePath,sjNum,lowTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locHighIntf(filePath,sjNum,highTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
elseif condCBOrder==4
    v2_4locPrac(numTask,numCue,numBlocks,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locMedIntf(filePath,sjNum,medTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locHighIntf(filePath,sjNum,highTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locLowIntf(filePath,sjNum,lowTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
elseif condCBOrder==5
    v2_4locPrac(numTask,numCue,numBlocks,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locHighIntf(filePath,sjNum,highTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locLowIntf(filePath,sjNum,lowTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locMedIntf(filePath,sjNum,medTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
elseif condCBOrder==6
    v2_4locPrac(numTask,numCue,numBlocks,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locHighIntf(filePath,sjNum,highTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locMedIntf(filePath,sjNum,medTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    v2_4locLowIntf(filePath,sjNum,lowTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
end
