
%==========================================================================
%PTB3 version of Nebel et al 2005 divided task
%==========================================================================
%Purpose: validate results of divided attention component of AD Task
%Author: Danny, Feb 2019
%==========================================================================

%% key components
%   -center fixation cross throughout task, subs instructed to hold fixation
%   throughout entire experiment 
%   -left and right streams of information center to sj's visual field
%       series of letters on the left
%       series of pictures on the right
%   -subs perform one-back tests in parallel (jeez..). so if they see
%
%               A + circle -> B + square -> B + cicle -> B + cirlce 
%   
%   they would press a button on the second B + circle
%                  
%   -offset stream timing. faster stream had stim due 1s, ISI 1s. slower
%   stream had stim dur 1.5s, ISI 1.5s. letters or pictures faster was
%   counterbalanced
%   -"25 trials/session"
%       what constitutes one trial? since the streams are offset
%       since offset is 3:2, every 6 secs they'll align. that should be one, right?   
%       if this is the case, they it would be 3 presentations of the fast
%       and two presentations of the slow stim. let's call that one trial.
%       dual - 2 conditions (shape stream or letter stream faster) x 25 trials = 50 trials
%       single - 4 conditions (respond to fast shape, slow shape, fast
%       letter, or slow letter) X 25 trials = 100 trials. 
%       (50+100 trials)*6sec each = 15min 
%   -How many letter/picture combos should there be? should be medium
%   difficulty. Let's play around with it and ask Tom once it seems right

%% main functions

%==========================================================================
%function: runDivTask
%purpose: runfile for divided attention validation task
%==========================================================================
function runDivTask(sjNum,laptopDebug,DIVfilePath,backup)

practice=1;
[numTask,numTrials,taskOrder,dualOrder,singleOrder]=setup_divTask(sjNum,practice);
divTask(sjNum,practice,numTask,numTrials,taskOrder,dualOrder,singleOrder,DIVfilePath,laptopDebug,backup)

practice=0;
[numTask,numTrials,taskOrder,dualOrder,singleOrder]=setup_divTask(sjNum,practice);
saveFile=[DIVfilePath 'sj' sprintf('%02d',sjNum) '_DivInfo.mat'];
save(saveFile,'taskOrder','dualOrder','singleOrder')
divTask(sjNum,practice,numTask,numTrials,taskOrder,dualOrder,singleOrder,DIVfilePath,laptopDebug,backup)


return
%==========================================================================
%function: setup_divTask
%purpose: set parameters for the experiment/set things up for debugging
%inputs: laptopDebug
%outputs: sjNum,numTask,numTrials,taskOrder,dualOrder,singleOrder,DIVfilePath
%==========================================================================
function [numTask,numTrials,taskOrder,dualOrder,singleOrder]=setup_divTask(sjNum,practice)


taskCBO=        [1  2       %1=single first, 2=dual first
                 2  1];
dualRespCBO=    [1  2       %determines letter or shape stream speed for dual task
                 2  1];
singleRespCBO=  [1	2	3	4	4	3	2	1	1	3	2	4	4	2	3	1       %determines single task resp order
                 2	3	4	1	3	2	1	4	3	2	4	1	2	3	1	4       
                 3	4	1	2	2	1	4	3	2	4	1	3	3	1	4	2
                 4	1	2	3	1	4	3	2	4	1	3	2	1	4	2	3];

if sjNum==199
    
    numTask=2;
    numTrials=18;
    taskOrder=taskCBO(:,1);
    dualOrder=dualRespCBO(:,1);
    singleOrder=singleRespCBO(:,1);
    
else
    
    numTask=2;
    numTrials=18; %was, 25 cut for time
    if practice==1
        taskOrder=taskCBO(:,1);
        dualOrder=dualRespCBO(:,1);
        singleOrder=singleRespCBO(:,1);
    else
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
    end
end 

return
%==========================================================================
%function: divTask
%purpose: show stim, collect responses
%inputs: sjNum,practice,numTask,numTrials,taskOrder,dualOrder,singleOrder,DIVfilePath,laptopDebug
%outputs: none, data saved in a struct
%==========================================================================
function divTask(sjNum,practice,numTask,numTrials,taskOrder,dualOrder,singleOrder,DIVfilePath,laptopDebug,backup)


%setup the screen

sca;
PsychDefaultSetup(2);
ListenChar(0);
HideCursor;
screenNumber = max(Screen('Screens'));
white = [255 255 255];
grey = white./2;
if laptopDebug==0
    ctr = 0;
    error_ctr = 0;
    while error_ctr == ctr
        try
            [window,rect] = Screen('OpenWindow',screenNumber,grey);
        catch
            error_ctr = error_ctr+1;
        end
        ctr = ctr+1;
    end
else
    [window,rect] = Screen('OpenWindow',screenNumber,grey);
end

PsychImaging('PrepareConfiguration');
[centerX, centerY] = RectCenter(rect);

%setup the response

KbName('UnifyKeyNames');
resp=KbName('space');

%don't forget to add counterbalancing for participants

blockNum=1;

load('sj1-sj150StimStruct.mat')

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
    
    if practice==1
        numBlock=2;
        numTrials=6;
    end    
   
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

        %manually ensure that everyone gets the same practice run
        if practice==1
            if streamCond==1
                shapeOrder= [1     1     1     1     3     3     1     1     1     1     1     1     1     2     2  1   1   2];
                letterOrder=[2     2     2     1     1     1     1     1     1     2     2     1];
            else
                letterOrder= [1     1     1     1     3     3     1     1     1     1     1     1     1     2     2 1   1   2];
                shapeOrder=  [2     2     2     1     1     1     1     1     1     2     2     1];
            end
        else
            
            letterOrder=Sj(sjNum).Task(task).Block(block).letters;
            shapeOrder=Sj(sjNum).Task(task).Block(block).shapes;
            
        end

        %draw the streams of shapes and letters to be shown during this block
        [shapeWins]=drawShapeStream(window,centerX,centerY,shapeOrder);
        [letWins]=drawLetStream(window,centerX,centerY,letterOrder);

        %set parameters for on stream windows
        shapeCenterX=centerX+150;
        letCenterX=centerX-150;
        winSize=100;
        shapeRect=[shapeCenterX-winSize,centerY-winSize,shapeCenterX+winSize,centerY+winSize];
        letRect=[letCenterX-winSize,centerY-winSize,letCenterX+winSize,centerY+winSize];

        blankWin=Screen('OpenOffScreenWindow',window,grey);


        %use off screen windows b/c two streams with different flip
        %timings would be tough in one window. this might be easier to
        %work with

        %the a stream is the quicker stream and the b stream is the
        %slower stream. 
        %---OLD IDEA---resps will be given when both stims are on
        %streen at once at any time, so there will be two oppotunites
        %to respond during one trial. at the first, the streams will
        %overlap for 1 sec and participants will have 1.5 sec (duration of
        %the b stream stim) to respond. at the second, the streams will
        %overlap for 0.5 and participants will have 1.5 sec to resp (to
        %be consistent with first resp---
        %---NEW IDEA--- resps shoud be collected during whole trial so
        %false alarms can be measured. any time an A stream stim is
        %presented (since there is a part of the trial where only A is on
        %the screen), a correct response could be given b/c even though B
        %might not be on screen, the last two B's and A's could match

        if streamCond==1                        %if shapes are faster
            aWins=shapeWins;
            aRect=shapeRect;
            bWins=letWins;
            bRect=letRect;
            aCheck=shapeOrder;
            bCheck=letterOrder;
            if thisTask==1                      %and condition is single task
                if condOrder(block,1)==1        %resp is either
                    respCheck=aCheck;           %fast shapes or
                    respTo=1;
                elseif condOrder(block,1)==3
                    respCheck=bCheck;           %slow letters
                    respTo=2;
                end
            end
        elseif streamCond==2                    %if letters are faster
            aWins=letWins;
            aRect=letRect;
            bWins=shapeWins;
            bRect=shapeRect;
            aCheck=letterOrder;
            bCheck=shapeOrder;
            if thisTask==1                      %and condition is single task
                if condOrder(block,1)==2        %resp is either
                    respCheck=aCheck;           %fast letters or
                    respTo=1;
                elseif condOrder(block,1)==4
                    respCheck=bCheck;           %slow shapes
                    respTo=2;
                end
            end
        end 

        Screen('TextSize',window,40)

        if thisTask==1
            if condOrder(block,1)==1||condOrder(block,1)==4
                inst=['Press the space bar when \n'...
                    'a SHAPE is repeated. \n \n'...
                    'Press any key to begin.'];
            elseif condOrder(block,1)==2||condOrder(block,1)==3
                inst=['Press the space bar when \n'...
                    'a LETTER is repeated. \n \n'...
                    'Press any key to begin.'];
            end
            
        elseif thisTask==2
            inst=['Press the space bar when a\n'...
                'LETTER AND a SHAPE are both repeated.\n \n'...
                'Press any key to begin.'];
        end

        %give block instructions

        if practice==1

            Screen('FillRect',window,grey)
            text=['This is ' sprintf('%d of 4 practice blocks.',blockNum) '\n \n'...
                  sprintf('%s',inst)];
            DrawFormattedText(window,text,'center','center',[255 255 255])
            Screen('Flip',window)
            WaitSecs(2)
            KbStrokeWait
            Screen('FillRect',window,grey)
            blockNum=blockNum+1;

        else

            Screen('FillRect',window,grey)
            text=['This is ' sprintf('%d of 6 blocks.',blockNum) '\n \n'...
                  sprintf('%s',inst)];
            DrawFormattedText(window,text,'center','center',[255 255 255])
            Screen('Flip',window)
            WaitSecs(2)
            KbStrokeWait
            Screen('FillRect',window,grey)
            blockNum=blockNum+1;

        end
        
        aFlips=0;
        bFlips=0;

        for trial=1:numTrials
            
            rt1=0;          %resp between 0-2sec
            isTarget1=0;    %record if flip contained target for easier data analysis
            rt2=0;          %resp between 2-3sec
            isTarget2=0;
            rt3=0;          %resp between 3-4sec
            isTarget3=0;
            rt4=0;          %resp between 4-6sec
            isTarget4=0;

            drawFixation(window,centerX,centerY,[0 0 0])
            aFlips=aFlips+1;
            Screen('CopyWindow',aWins(1,aFlips),window,[],aRect)  
            bFlips=bFlips+1;
            Screen('CopyWindow',bWins(1,bFlips),window,[],bRect)
            resp1On=Screen('Flip',window,[],1);             %get resp here
            if thisTask==1
                if respTo==1
                    respFlips=aFlips;
                elseif respTo==2
                    respFlips=bFlips;
                end
            end
            aClear=0;
            bClear=0;
            ind=0;
            keepChecking=1;
            while GetSecs<=resp1On+2                        %give them 2sec (time to next flip) to respond
                [keyIsDown,resp1Off,keyCode]=KbCheck;
                if keyIsDown==1
                    ind=find(keyCode~=0);
                    if size(ind,2)==1
                        if ind==resp
                            rt1=resp1Off-resp1On;
                        end
                    end
                end
                if resp1On+1<=GetSecs                       %clear aRect after 1sec
                    if aClear==0
                        Screen('CopyWindow',blankWin,window,[],aRect)
                        Screen('Flip',window,[],1)
                        aClear=1;
                    end
                end
                if resp1On+1.5<=GetSecs                     %clear bRect after 1.5sec
                    if bClear==0
                        Screen('CopyWindow',blankWin,window,[],bRect)
                        Screen('Flip',window,[],1)
                        bClear=1;
                    end
                end

                %give practice feedback/record if target was
                %presented or not

                if thisTask==1
                    if 1<respFlips
                        if practice==1
                            if respCheck(1,respFlips)==respCheck(1,respFlips-1)&&keepChecking==1
                                if ind~=0
                                    drawFixation(window,centerX,centerY,[0 255 0])
                                    Screen('Flip',window,[],1)
                                    keepChecking=0;
                                else
                                    drawFixation(window,centerX,centerY,[255 0 0])
                                    Screen('Flip',window,[],1)
                                end
                            elseif ind~=0
                                if respCheck(1,respFlips)~=respCheck(1,respFlips-1)
                                    drawFixation(window,centerX,centerY,[255 0 0])
                                    Screen('Flip',window,[],1)
                                end
                            end
                        elseif practice==0
                            if respCheck(1,respFlips)==respCheck(1,respFlips-1)
                                isTarget1=1;
                            end
                        end
                    end
                end

                if thisTask==2
                    if 1<aFlips&&1<bFlips
                        if practice==1
                            if aCheck(1,aFlips)==aCheck(1,aFlips-1)&&bCheck(1,bFlips)==bCheck(1,bFlips-1)&&keepChecking==1
                                if ind~=0
                                    drawFixation(window,centerX,centerY,[0 255 0])
                                    Screen('Flip',window,[],1)
                                    keepChecking=0;
                                else
                                    drawFixation(window,centerX,centerY,[255 0 0])
                                    Screen('Flip',window,[],1)
                                end
                            elseif ind~=0
                                if aCheck(1,aFlips)~=aCheck(1,aFlips-1)||bCheck(1,bFlips)~=bCheck(1,bFlips-1)
                                    drawFixation(window,centerX,centerY,[255 0 0])
                                    Screen('Flip',window,[],1)
                                end
                            end
                        elseif practice==0
                            if aCheck(1,aFlips)==aCheck(1,aFlips-1)&&bCheck(1,bFlips)==bCheck(1,bFlips-1)
                                isTarget1=1;
                            end
                        end
                    end
                end
            end 
            
            drawFixation(window,centerX,centerY,[0 0 0])        %clear fixation color incase practice 
            aFlips=aFlips+1;
            Screen('CopyWindow',aWins(1,aFlips),window,[],aRect)    %aRect w/o bRect
            resp2On=Screen('Flip',window,[],1);                 %get resp here
            if thisTask==1
                if respTo==1
                    respFlips=aFlips;
                elseif respTo==2
                    respFlips=bFlips;
                end
            end
            ind=0;
            keepChecking=1;
            while GetSecs<=resp2On+1                          %give them 1sec (time to next flip) to respond
                [keyIsDown,resp2Off,keyCode]=KbCheck;
                if keyIsDown==1
                    ind=find(keyCode~=0);
                    if size(ind,2)==1
                        if ind==resp
                            rt2=resp2Off-resp2On;
                        end
                    end
                end

                %give practice feedback/record if if target was
                %presented or not

                if thisTask==1
                    if 1<respFlips
                        if respTo==1
                            if practice==1
                                if respCheck(1,respFlips)==respCheck(1,respFlips-1)&&keepChecking==1
                                    isTarget2=1;
                                    if ind~=0
                                        drawFixation(window,centerX,centerY,[0 255 0])
                                        Screen('Flip',window,[],1)
                                        keepChecking=0;
                                    else
                                        drawFixation(window,centerX,centerY,[255 0 0])
                                        Screen('Flip',window,[],1)
                                    end
                                elseif ind~=0
                                    if respCheck(1,respFlips)~=respCheck(1,respFlips-1)
                                        drawFixation(window,centerX,centerY,[255 0 0])
                                        Screen('Flip',window,[],1)
                                    end
                                end
                            elseif practice==0
                                if respCheck(1,respFlips)==respCheck(1,respFlips-1)
                                    isTarget2=1;
                                end
                            end
                        end
                    end
                end

                if thisTask==2
                    if 1<aFlips&&1<bFlips
                        if practice==1
                            if aCheck(1,aFlips)==aCheck(1,aFlips-1)&&bCheck(1,bFlips)==bCheck(1,bFlips-1)&&keepChecking==1
                                isTarget2=1;
                                if ind~=0
                                    drawFixation(window,centerX,centerY,[0 255 0])
                                    Screen('Flip',window,[],1)
                                    keepChecking=0;
                                else
                                    drawFixation(window,centerX,centerY,[255 0 0])
                                    Screen('Flip',window,[],1)
                                end
                            elseif ind~=0
                                if aCheck(1,aFlips)~=aCheck(1,aFlips-1)||bCheck(1,bFlips)~=bCheck(1,bFlips-1)
                                    drawFixation(window,centerX,centerY,[255 0 0])
                                    Screen('Flip',window,[],1)
                                end
                            end
                        elseif practice==0
                            if aCheck(1,aFlips)==aCheck(1,aFlips-1)&&bCheck(1,bFlips)==bCheck(1,bFlips-1)
                                isTarget2=1;
                            end
                        end
                    end
                end
            end
            
            drawFixation(window,centerX,centerY,[0 0 0])        %clear fixation color incase practice 
            Screen('CopyWindow',blankWin,window,[],aRect)       %clear aRect
            bFlips=bFlips+1;
            Screen('CopyWindow',bWins(1,bFlips),window,[],bRect)    %bRect w/o aRect for 1sec
            resp3On=Screen('Flip',window,[],1);                 %get resp here
            if thisTask==1
                if respTo==1
                    respFlips=aFlips;
                elseif respTo==2
                    respFlips=bFlips;
                end
            end
            ind=0;
            keepChecking=1;
            while GetSecs<=resp3On+1                          %give them 1sec (time to next flip) to respond
                [keyIsDown,resp3Off,keyCode]=KbCheck;
                if keyIsDown==1
                    ind=find(keyCode~=0);
                    if size(ind,2)==1
                        if ind==resp
                            rt3=resp3Off-resp3On;
                        end
                    end
                end

                %give practice feedback/record if if target was
                %presented or not
                if thisTask==1
                    if 1<respFlips
                        if respTo==2
                            if practice==1
                                if respCheck(1,respFlips)==respCheck(1,respFlips-1)&&keepChecking==1
                                    isTarget3=1;
                                    if ind~=0
                                        drawFixation(window,centerX,centerY,[0 255 0])
                                        Screen('Flip',window,[],1)
                                        keepChecking=0;
                                    else
                                        drawFixation(window,centerX,centerY,[255 0 0])
                                        Screen('Flip',window,[],1)
                                    end
                                elseif ind~=0
                                    if respCheck(1,respFlips)~=respCheck(1,respFlips-1)
                                        drawFixation(window,centerX,centerY,[255 0 0])
                                        Screen('Flip',window,[],1)
                                    end
                                end
                            elseif practice==0
                                if respCheck(1,respFlips)==respCheck(1,respFlips-1)
                                    isTarget3=1;
                                end
                            end
                        end
                    end
                end

                if thisTask==2
                    if 1<aFlips&&1<bFlips
                        if practice==1
                            if aCheck(1,aFlips)==aCheck(1,aFlips-1)&&bCheck(1,bFlips)==bCheck(1,bFlips-1)&&keepChecking==1
                                isTarget3=1;
                                if ind~=0
                                    drawFixation(window,centerX,centerY,[0 255 0])
                                    Screen('Flip',window,[],1)
                                    keepChecking=0;
                                else
                                    drawFixation(window,centerX,centerY,[255 0 0])
                                    Screen('Flip',window,[],1)
                                end
                            elseif ind~=0
                                if aCheck(1,aFlips)~=aCheck(1,aFlips-1)||bCheck(1,bFlips)~=bCheck(1,bFlips-1)
                                    drawFixation(window,centerX,centerY,[255 0 0])
                                    Screen('Flip',window,[],1)
                                end
                            end
                        elseif practice==0
                            if aCheck(1,aFlips)==aCheck(1,aFlips-1)&&bCheck(1,bFlips)==bCheck(1,bFlips-1)
                                isTarget3=1;
                            end
                        end
                    end
                end
            end

            drawFixation(window,centerX,centerY,[0 0 0])            %clear fix color incase practice
            aFlips=aFlips+1;
            Screen('CopyWindow',aWins(1,aFlips),window,[],aRect)    %give aRect   
            resp4On=Screen('Flip',window,[],1);                 %get resp here
            if thisTask==1
                if respTo==1
                    respFlips=aFlips;
                elseif respTo==2
                    respFlips=bFlips;
                end
            end
            ind=0;
            aClear=0;
            bClear=0;
            keepChecking=1;
            while GetSecs<=resp4On+2          %give them 2sec (time to next flip) to respond
                [keyIsDown,resp4Off,keyCode]=KbCheck;
                if keyIsDown==1
                    ind=find(keyCode~=0);
                    if size(ind,2)==1
                        if ind==resp
                            rt4=resp4Off-resp4On;
                        end
                    end
                end
                if resp4On+0.5<=GetSecs       %clear bRect after 0.5sec
                    if bClear==0
                        Screen('CopyWindow',blankWin,window,[],bRect)
                        Screen('Flip',window,[],1)
                        bClear=1;
                    end
                end
                if resp4On+1<=GetSecs         %clear aRect after 1sec
                    if aClear==0
                        Screen('CopyWindow',blankWin,window,[],aRect)
                        Screen('Flip',window,[],1)
                        aClear=1;
                    end
                end

                %give practice feedback/record if if target was
                %presented or not
                if thisTask==1
                    if 1<respFlips
                        if respTo==1
                            if practice==1
                                if respCheck(1,respFlips)==respCheck(1,respFlips-1)&&keepChecking==1
                                    isTarget4=1;
                                    if ind~=0
                                        drawFixation(window,centerX,centerY,[0 255 0])
                                        Screen('Flip',window,[],1)
                                        keepChecking=0;
                                    else
                                        drawFixation(window,centerX,centerY,[255 0 0])
                                        Screen('Flip',window,[],1)
                                    end
                                elseif ind~=0
                                    if respCheck(1,respFlips)~=respCheck(1,respFlips-1)
                                        drawFixation(window,centerX,centerY,[255 0 0])
                                        Screen('Flip',window,[],1)
                                    end
                                end
                            elseif practice==0
                                if respCheck(1,respFlips)==respCheck(1,respFlips-1)
                                    isTarget4=1;
                                end
                            end
                        end
                    end
                end

                if thisTask==2
                    if 1<aFlips&&1<bFlips
                        if practice==1
                            if aCheck(1,aFlips)==aCheck(1,aFlips-1)&&bCheck(1,bFlips)==bCheck(1,bFlips-1)&&keepChecking==1
                                isTarget4=1;
                                if ind~=0
                                    drawFixation(window,centerX,centerY,[0 255 0])
                                    Screen('Flip',window,[],1)
                                    keepChecking=0;
                                else
                                    drawFixation(window,centerX,centerY,[255 0 0])
                                    Screen('Flip',window,[],1)
                                end
                            elseif ind~=0
                                if aCheck(1,aFlips)~=aCheck(1,aFlips-1)||bCheck(1,bFlips)~=bCheck(1,bFlips-1)
                                    drawFixation(window,centerX,centerY,[255 0 0])
                                    Screen('Flip',window,[],1)
                                end
                            end
                        elseif practice==0
                            if aCheck(1,aFlips)==aCheck(1,aFlips-1)&&bCheck(1,bFlips)==bCheck(1,bFlips-1)
                                isTarget4=1;
                            end
                        end
                    end
                end
            end
            
            trialData(trial).resp1=rt1;
            trialData(trial).target1=isTarget1;
            trialData(trial).resp2=rt2;
            trialData(trial).target2=isTarget2;
            trialData(trial).resp3=rt3;
            trialData(trial).target3=isTarget3;
            trialData(trial).resp4=rt4;
            trialData(trial).target4=isTarget4;
           
        end

        blockData(block).blockTrials=trialData;
        blockData(block).thisCond=condOrder(block,1);
        blockData(block).shapeOrder=shapeOrder;
        blockData(block).letterOrder=letterOrder;

        save([backup 'DIVblockDataBackup.mat'],'blockData')

    end
    
    allData(task).condData=blockData;
    allData(task).thisTask=thisTask;
    
    saveFile=[DIVfilePath sprintf('sj%02d_allDivData.mat',sjNum)];
    save(saveFile,'allData')
    backupFile=[backup sprintf('sj%02d_allDivData.mat',sjNum)];
    save(backupFile,'allData')
    
end

if practice==1
    Screen('FillRect',window,grey)
    DrawFormattedText(window,'Please wait for the administrator''s cue to start','center','center',[255 255 255])
    Screen('Flip',window)
    KbStrokeWait
end

sca

return

%% subfunctions
%==========================================================================
% function: drawFixation
% purpose: draw a fixation point in a given window
%==========================================================================
function drawFixation(thisWin,centerX,centerY,color)
    
Screen('TextSize',thisWin,50);
Screen('TextFont',thisWin,'Arial');
fix='+';
[fixBounds]=Screen('TextBounds',thisWin,'+');
xFix=centerX-round(fixBounds(3)/2);
yFix=centerY-round(fixBounds(4)/2);
Screen('DrawText',thisWin,fix,xFix,yFix,color);

return
%==========================================================================
% function: drawShapeStream
% purpose: draw the stream of shapes to be shown during the block
% inputs: window, centerX, centerY, and shapeOrder
% outputs: shapeWins, the offscreen windows with the shapes that will be
% presented during the block
%==========================================================================
function [shapeWins]=drawShapeStream(window,centerX,centerY,shapeOrder)

shapeWins=zeros(1,size(shapeOrder,2));

for flip=1:size(shapeOrder,2)
    shapeWins(1,flip)=Screen('OpenOffScreenWindow',window,[127.5 127.5 127.5]);
end

for flip=1:size(shapeOrder,2)
    
    lineWidth=7;    %is 7 the highest it will go? yep
    stimWidth=350;
    numShells=20;
    
    if shapeOrder(1,flip)==1
        
        Screen('DrawLine',shapeWins(1,flip),[0 0 0],centerX-stimWidth,centerY-stimWidth,centerX+stimWidth,centerY-stimWidth,lineWidth)
        Screen('DrawLine',shapeWins(1,flip),[0 0 0],centerX-stimWidth,centerY-stimWidth,centerX,centerY+stimWidth,lineWidth)
        Screen('DrawLine',shapeWins(1,flip),[0 0 0],centerX+stimWidth,centerY-stimWidth,centerX,centerY+stimWidth,lineWidth)

        for shell=1:numShells
            
            %adding these to increase the thickness of the shapes. maybe
            %there's a better way? 
            
            %line 1 shells
            Screen('DrawLine',shapeWins(1,flip),[0 0 0],centerX-stimWidth-shell,centerY-stimWidth,centerX+stimWidth-shell,centerY-stimWidth,lineWidth)
            Screen('DrawLine',shapeWins(1,flip),[0 0 0],centerX-stimWidth,centerY-stimWidth-shell,centerX+stimWidth,centerY-stimWidth-shell,lineWidth)
            Screen('DrawLine',shapeWins(1,flip),[0 0 0],centerX-stimWidth+shell,centerY-stimWidth,centerX+stimWidth+shell,centerY-stimWidth,lineWidth)
            Screen('DrawLine',shapeWins(1,flip),[0 0 0],centerX-stimWidth,centerY-stimWidth+shell,centerX+stimWidth,centerY-stimWidth+shell,lineWidth)
            %line 2 shells
            Screen('DrawLine',shapeWins(1,flip),[0 0 0],centerX-stimWidth-shell,centerY-stimWidth,centerX-shell,centerY+stimWidth,lineWidth)
            Screen('DrawLine',shapeWins(1,flip),[0 0 0],centerX-stimWidth,centerY-stimWidth-shell,centerX,centerY+stimWidth-shell,lineWidth)
            Screen('DrawLine',shapeWins(1,flip),[0 0 0],centerX-stimWidth+shell,centerY-stimWidth,centerX+shell,centerY+stimWidth,lineWidth)
            Screen('DrawLine',shapeWins(1,flip),[0 0 0],centerX-stimWidth,centerY-stimWidth+shell,centerX,centerY+stimWidth+shell,lineWidth)
            %line 3 shells
            Screen('DrawLine',shapeWins(1,flip),[0 0 0],centerX+stimWidth-shell,centerY-stimWidth,centerX-shell,centerY+stimWidth,lineWidth)
            Screen('DrawLine',shapeWins(1,flip),[0 0 0],centerX+stimWidth,centerY-stimWidth-shell,centerX,centerY+stimWidth-shell,lineWidth)
            Screen('DrawLine',shapeWins(1,flip),[0 0 0],centerX+stimWidth+shell,centerY-stimWidth,centerX+shell,centerY+stimWidth,lineWidth)
            Screen('DrawLine',shapeWins(1,flip),[0 0 0],centerX+stimWidth,centerY-stimWidth+shell,centerX,centerY+stimWidth+shell,lineWidth)
        
        end
       
    elseif shapeOrder(1,flip)==2
        
        Screen('FrameRect',shapeWins(1,flip),[0 0 0],[centerX-stimWidth centerX+stimWidth;
                                                       centerY-stimWidth centerY+stimWidth],lineWidth)
                                                   
        for shell=1:numShells
            
            Screen('FrameRect',shapeWins(1,flip),[0 0 0],[centerX-stimWidth-shell centerX+stimWidth-shell; centerY-stimWidth centerY+stimWidth],lineWidth)
            Screen('FrameRect',shapeWins(1,flip),[0 0 0],[centerX-stimWidth centerX+stimWidth; centerY-stimWidth-shell centerY+stimWidth-shell],lineWidth)
            Screen('FrameRect',shapeWins(1,flip),[0 0 0],[centerX-stimWidth+shell centerX+stimWidth+shell; centerY-stimWidth centerY+stimWidth],lineWidth)
            Screen('FrameRect',shapeWins(1,flip),[0 0 0],[centerX-stimWidth centerX+stimWidth; centerY-stimWidth+shell centerY+stimWidth+shell],lineWidth)
            
        end
         
    elseif shapeOrder(1,flip)==3
        
        Screen('FrameOval',shapeWins(1,flip),[0 0 0],[centerX-stimWidth centerX+stimWidth;
                                                       centerY-stimWidth centerY+stimWidth],lineWidth)

        for shell=1:numShells
            
            Screen('FrameOval',shapeWins(1,flip),[0 0 0],[centerX-stimWidth-shell centerX+stimWidth-shell; centerY-stimWidth centerY+stimWidth],lineWidth)
            Screen('FrameOval',shapeWins(1,flip),[0 0 0],[centerX-stimWidth centerX+stimWidth; centerY-stimWidth-shell centerY+stimWidth-shell],lineWidth)
            Screen('FrameOval',shapeWins(1,flip),[0 0 0],[centerX-stimWidth+shell centerX+stimWidth+shell; centerY-stimWidth centerY+stimWidth],lineWidth)
            Screen('FrameOval',shapeWins(1,flip),[0 0 0],[centerX-stimWidth centerX+stimWidth; centerY-stimWidth+shell centerY+stimWidth+shell],lineWidth)
            
        end
        
    end
end

return
%==========================================================================
% function: drawLetStream
% purpose: draw the stream of letters to be shown during the block
% inputs: window, centerX, centerY, and letterOrder
% outputs: letWins, the off screen windows with the letters that will be
% presented during the block
%==========================================================================
function [letWins]=drawLetStream(window,centerX,centerY,letterOrder)

letWins=zeros(1,size(letterOrder,2));

for flip=1:size(letterOrder,2)
    letWins(1,flip)=Screen('OpenOffScreenWindow',window,[127.5 127.5 127.5]);
end

for flip=1:size(letterOrder,2)
    
    if letterOrder(1,flip)==1
        drawLetter='A';
    elseif letterOrder(1,flip)==2
        drawLetter='B';
    elseif letterOrder(1,flip)==3
        drawLetter='C';
    end
    
    Screen('TextSize',letWins(1,flip),1000)
    [bounds]=Screen('TextBounds',letWins(1,flip),drawLetter);
    Screen('DrawText',letWins(1,flip),drawLetter,centerX-(bounds(3)/2),centerY-(bounds(4)/2),[0 0 0])
    
end
       
return

