
%runfile for 4LocTaskv2
%approx run time = 50mins

laptopDebug=1;     

sjNum = input('Input Subject Number ');

counterBal=[1	2	3	4	5	6	1	2	3	4	5	6	1	2	3	4	5	6	1	2	3	4	5	6	1	2	3	4	5	6	1	2	3	4	5	6
            1	2	3	4	5	6	2	3	4	5	6	1	3	4	5	6	1	2	4	5	6	1	2	3	5	6	1	2	3	4	6	1	2	3	4	5];

if sjNum==199
    
    %set some parameters to use if we're debugging
    numBlocks=1;
    age=22;
    gender=0;
    handedness=1;
    lowTaskOrder=1;
    medTaskOrder=1;
    highTaskOrder=1;
    condCBOrder=1;
    taskCBOrder=1;
    
else
    
    numBlocks=7;    %was 8, had to cut down for time
    
    %record sj info
    age = input('Input Age ');
    gender = input('Input Gender (0 = M, 1 = F) ');
    handedness = input('Input Handedness (0 = L, 1 = R) ');
    
    %counterbalancing is determined by sjNum to reduce the number of inputs
    %the experimenter has to make 
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

%1 = single task first, 2 = dual task first
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

%this is for laptop compatability. turns off sync tests and sets filepath
%to the laptop filepath, so we don't have to worry about messing up the
%behavior room filepath by mistake

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
audRespDur=2;

numChannels = 1;
soundRep = 1;
soundDur = 0.25;
waitForDeviceStart = 0;

%sets the task counterbalancing determined above by sjNum. these
%functions have a ton of inputs but it's just ensure all the parameters are
%the same for each intf condition (i.e. it would suck to find out that
%numTrials was accidentally set to a different number for one condition
%after collecting a bunch of data)

conds=  [1  1   1   1   1   1
         2  2   3   3   4   4    
         3  4   2   4   2   3
         4  3   4   2   3   2];
         
skipTask=input('Skip a task? ');
if skipTask==0
    thisConds=conds(:,condCBOrder);
elseif skipTask==1
    thisConds=conds(2:4,condCBOrder);
elseif skipTask==2
    thisConds=conds(3:4,condCBOrder);
elseif skipTask==3
    thisConds=conds(4,condCBOrder);
end
     
for task=1:size(thisConds,1)
    
    thisTask=thisConds(task,1);
    
    if thisTask==1
        v2_4locPrac(numTask,numCue,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    elseif thisTask==2
        v2_4locLowIntf(filePath,sjNum,lowTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    elseif thisTask==3
        v2_4locMedIntf(filePath,sjNum,medTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    elseif thisTask==4
        v2_4locHighIntf(filePath,sjNum,highTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
    end
end

%below is old, messier way of this doing this^ 
%keeping for reference just in case

% if condCBOrder==0
%     v2_4locPrac(numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locLowIntf(filePath,sjNum,lowTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locMedIntf(filePath,sjNum,medTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locHighIntf(filePath,sjNum,highTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
% end
% if condCBOrder==1
%     v2_4locPrac(numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locLowIntf(filePath,sjNum,lowTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locMedIntf(filePath,sjNum,medTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locHighIntf(filePath,sjNum,highTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
% elseif condCBOrder==2
%     v2_4locPrac(numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locLowIntf(filePath,sjNum,lowTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locHighIntf(filePath,sjNum,highTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locMedIntf(filePath,sjNum,medTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
% elseif condCBOrder==3
%     v2_4locPrac(numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locMedIntf(filePath,sjNum,medTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locLowIntf(filePath,sjNum,lowTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locHighIntf(filePath,sjNum,highTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
% elseif condCBOrder==4
%     v2_4locPrac(numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locMedIntf(filePath,sjNum,medTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locHighIntf(filePath,sjNum,highTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locLowIntf(filePath,sjNum,lowTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
% elseif condCBOrder==5
%     v2_4locPrac(numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locHighIntf(filePath,sjNum,highTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locLowIntf(filePath,sjNum,lowTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locMedIntf(filePath,sjNum,medTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
% elseif condCBOrder==6
%     v2_4locPrac(numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locHighIntf(filePath,sjNum,highTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locMedIntf(filePath,sjNum,medTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
%     v2_4locLowIntf(filePath,sjNum,lowTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)
% end
