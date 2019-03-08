
function [nt1Acc,nt2Acc,nt2AccGivenT1Acc,trialMatrix,targets] = ANT(sjNum,logFileName,mySOA,practice,laptopDebug,backupFile)
%[nt1Acc,nt2Acc,nt2AccGivenT1Acc,trialMatrix,targets]
%=========================================================
%=========================================================

%run 3 blocks during experiment

%Screen('Preference', 'EmulateOldPTB', 1)
    %PTB documentation says this is buggy so let's avoid it if possible

% rand('state',sum(100*clock));

%***********set up conditions and response matrices
nSOA = size(mySOA,2);   %3
nConCon = 2; %easy and hard
nCueCon = 7; % cue conditions no-cue,fix,4 valid, 1 invalid
if sjNum==199
    nBlocks = 3;
else
    nBlocks=3;  %moved this down to 3 to cut down on time. this is a lot less than  //  %can we move this down to 4 to save time? ~32min -> ~19
end             %the original exp (7 blocks), but it will still have 252 trials (84 trials/block * 3blocks)
                %which will give 84 measures/soa, 126 measures/difficulty
                %cond, and 36 measures/cue cond
                
nRepsPerBlock = 2;
nTotalTrials = nConCon*nCueCon*nSOA*nRepsPerBlock*nBlocks; %nTotal trials

nt1Acc = zeros(nConCon,nCueCon,nSOA);
nt2Acc = nt1Acc;
nt2AccGivenT1Acc = nt1Acc;
trialMatrix = nt1Acc;

% Open window
PsychDefaultSetup(2);
PsychImaging('PrepareConfiguration');

screen=max(Screen('Screens'));
ctr = 0;
error_ctr = 0;
while error_ctr == ctr
    try
        [window,rect] = Screen('OpenWindow',screen,[255 255 255]);
    catch
        error_ctr = error_ctr+1;
    end
    ctr = ctr+1;
end
HideCursor;

[centerX, centerY] = RectCenter(rect);
Screen('TextSize',window,24);
Screen('TextFont',window,'Arial');

fixWindow = Screen('OpenOffScreenWindow',window);
drawFixation(fixWindow,centerX,centerY,[0 0 0])

%make the blank ISI
isiWindow = Screen('OpenOffScreenWindow',window);
Screen('FillRect',isiWindow,[255 255 255],[centerX-20 centerY-20 centerX+20 centerY+20]);

%make the stream windows
myWindows = make_windows(5,window); %prime window, t1 window, t1 mask, t2, t2 mask.

for i=2:5
    Screen('TextSize',myWindows(i),24);
    Screen('TextFont',myWindows(i),'Arial');
end

messageWindow = Screen('OpenOffScreenWindow',window);

if practice == 0
    %open logfile and backupfile
    fid = fopen(logFileName,'w');
    bid=fopen(backupFile,'w');

    %write some header information
    fprintf(fid,'ANT\t Experiment ID\n');
    fprintf(fid,'%d\t Subject\n',sjNum);
    fprintf(fid,'%s\t Run Time\n',datestr(now));
    fprintf(fid,'%d\tnCongruency conditions (congruent = 1, incongruent = 2)\n',nConCon);
    fprintf(fid,'%d\tnCue conditions (1=no cue, 2 = fixation cue, 3-6=valid, 7 = invalid\n',nCueCon);
    fprintf(fid,'%d\t nRepsPerBlock\n',nRepsPerBlock);
    fprintf(fid,'%d\t nBlocks\n',nBlocks);
    fprintf(fid,'%f\t FrameRate\n',FrameRate(window));
    fprintf(fid,'%d\t CueDur in frames\n',round(.1*FrameRate(window)));
    %prepare the backup file (there's probably a better way to do this)
    fprintf(bid,'ANT\t Experiment ID\n');
    fprintf(bid,'%d\t Subject\n',sjNum);
    fprintf(bid,'%s\t Run Time\n',datestr(now));
    fprintf(bid,'%d\tnCongruency conditions (congruent = 1, incongruent = 2)\n',nConCon);
    fprintf(bid,'%d\tnCue conditions (1=no cue, 2 = fixation cue, 3-6=valid, 7 = invalid\n',nCueCon);
    fprintf(bid,'%d\t nRepsPerBlock\n',nRepsPerBlock);
    fprintf(bid,'%d\t nBlocks\n',nBlocks);
    fprintf(bid,'%f\t FrameRate\n',FrameRate(window));
    fprintf(bid,'%d\t CueDur in frames\n',round(.1*FrameRate(window)));
    
    for i = 1:nSOA
        fprintf(fid,'%d\t',round((mySOA(i)/1000)*FrameRate(window)));
        fprintf(bid,'%d\t',round((mySOA(i)/1000)*FrameRate(window)));
    end
    fprintf(fid,'cue-target SOAs\n');
    fprintf(bid,'cue-target SOAs\n');
    thisBlock = 1;
    while thisBlock <= nBlocks
        
        trialSequence = randomize_trial_sequence(mySOA,nConCon,nCueCon,nRepsPerBlock);

        %ok let's shuffle this matrix  7 times
        for i = 1:7
            newOrder = randperm(size(trialSequence,1));
            trialSequence = trialSequence(newOrder,:);
        end
        
        nTrials = size(trialSequence,1);

        blockMessage = sprintf('This is %d of %d blocks. \n Press space bar to continue.',thisBlock,nBlocks);
        Screen('TextSize',messageWindow,32);
        Screen('TextFont',messageWindow,'Arial');
        DrawFormattedText(messageWindow,blockMessage,'center','center',[0 0 0]);
        Screen('CopyWindow',messageWindow,window,[centerX-200,centerY-150,centerX+200,centerY+150],[centerX-200,centerY-150,centerX+200,centerY+150])
        Screen('Flip',window)

        KbStrokeWait;

        Screen('FillRect',messageWindow,[255 255 255]);
        Screen('FillRect',window,[255 255 255]);
        
        go=' ';
        
        if go==' '
            
            for trial = 1:nTrials
                
                Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');                 
                Screen('CopyWindow',fixWindow,window);
                Screen('Flip',window)
                FlushEvents('KeyDown');
                
                tarLoc = trialSequence(trial,1);
                thisCon = trialSequence(trial,2);
                thisCue = trialSequence(trial,3);
                SOAidx = trialSequence(trial,4);

                lag = mySOA(SOAidx);

                %make the stream
                [myWindows,arrowDir,CueCode] = make_stream(myWindows,thisCon,thisCue,tarLoc,centerX,centerY,window,laptopDebug);

                %Show the stream
                [Resp,D,t1On,t1off, RT, nsr] = show_stream(myWindows,window,fixWindow,isiWindow,centerX,centerY,lag,practice,arrowDir);                %end
                
                %code the response
                Acc = code_response(Resp,arrowDir);
                
                if trial == 1 && thisBlock == 1
                    fprintf(fid,'thisBlock\ttrial\tSOAidx\tthisCue\tthisCon\tarrowDir\tResp\tAcc\tRT\tfixation\tlagFrames\n');
                    fprintf(bid,'thisBlock\ttrial\tSOAidx\tthisCue\tthisCon\tarrowDir\tResp\tAcc\tRT\tfixation\tlagFrames\n');
                end

                fprintf(fid,'%d\t%d\t%d\t%c\t%d\t%c\t%c\t%d\t%7.2f\t%d\t%d\n',...
                    thisBlock,trial,SOAidx,CueCode,thisCon,arrowDir,Resp,Acc,RT*1000,D,nsr);
                fprintf(bid,'%d\t%d\t%d\t%c\t%d\t%c\t%c\t%d\t%7.2f\t%d\t%d\n',...
                    thisBlock,trial,SOAidx,CueCode,thisCon,arrowDir,Resp,Acc,RT*1000,D,nsr);
                
                %clear windows for next trial
                myWindows = clear_stream(myWindows,5,centerX,centerY);
                
            end
            
            thisBlock = thisBlock +1;

        else
            thisBlock = nBlocks+1;
            break;
        end
        
    end %end block loop
    
    fclose(fid);
    fclose(bid);
    
elseif practice ==1
    
    Screen('TextSize',window,35)
    inst='Press F if the center arrow points left \n and J if the center arrow points right';
    DrawFormattedText(window,inst,'center','center',[0 0 0])
    Screen('Flip',window)
    KbStrokeWait
    
    blockMessage = 'This is a practice block';
    Screen('TextSize',messageWindow,24);
    Screen('TextFont',messageWindow,'Arial');
    [bounds]=Screen('TextBounds',messageWindow,blockMessage);
    Screen('DrawText',messageWindow,blockMessage,centerX-round(bounds(3)/2),centerY-round(bounds(4)/2),[0 0 0]);
    Screen('TextSize',messageWindow,16);
    [bounds]=Screen('TextBounds',messageWindow,'Press space bar to continue');
    Screen('DrawText',messageWindow,'Press space bar to continue',centerX-round(bounds(3)/2),centerY-round(bounds(4)/2)+50,[0 0 0]);
    Screen('CopyWindow',messageWindow,window,[centerX-200,centerY-150,centerX+200,centerY+150],[centerX-200,centerY-150,centerX+200,centerY+150])
    Screen('Flip',window)

    KbStrokeWait;
    
    Screen('FillRect',messageWindow,[255 255 255])
    Screen('FillRect',window,[255 255 255]);

    trialSequence = randomize_trial_sequence(mySOA,nConCon,nCueCon,nRepsPerBlock);
    nTrials = 10;
    
    go = ' ';
    
    if go ==' '
        
        for trial = 1:nTrials
            
            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');                 
            
            %get Conditions, prime and target
            tarLoc = trialSequence(trial,1);
            thisCon = trialSequence(trial,2);
            thisCue = trialSequence(trial,3);
            SOAidx = trialSequence(trial,4);

            lag = mySOA(SOAidx);

            %make the stream
            [myWindows,arrowDir, CueCode] = make_stream(myWindows,thisCon,thisCue,tarLoc,centerX,centerY,window,laptopDebug);

            %Show the stream
            [Resp,D,t1On,t1off, RT, nsr] = show_stream(myWindows,window,fixWindow,isiWindow,centerX,centerY,lag,practice,arrowDir);
            
            %clear the windows for the next trial
            myWindows = clear_stream(myWindows,5,centerX,centerY);
            
        end
        
    end

    %Close gracefully
    WaitSecs(1);
    Screen('TextSize',window,24);
    Screen('TextFont',window,'Arial');
    DrawFormattedText(window,'Please wait for the administrator''s cue to start','center','center',[0 0 0]);
    Screen('Flip',window)
    KbStrokeWait;
   
end

sca;

end

%***********************************************
%           Sub-functions
%***********************************************

%===============================================
% function: drawFixation
% purpose: draw a fixation point in a 
%   given window
%===============================================
function drawFixation(thisWin,centerX,centerY,color)
    
Screen('TextSize',thisWin,30);
Screen('TextFont',thisWin,'Arial');
fix='+';
[fixBounds]=Screen('TextBounds',thisWin,'+');
xFix=centerX-round(fixBounds(3)/2);
yFix=centerY-round(fixBounds(4)/2);
Screen('DrawText',thisWin,fix,xFix,yFix,color);

end
%===============================================
% function: drawCue
% purpose: draw a cue at upper or lower location
%===============================================
function drawCue(thisWin,loc,centerX,centerY,color,laptopDebug)

Screen('TextSize',thisWin,50);
Screen('TextFont',thisWin,'Arial');
cue='*';
[cueBounds]=Screen('TextBounds',thisWin,cue);
if laptopDebug==1
    Screen('DrawText',thisWin,cue,centerX-round(cueBounds(3)/2),(centerY-round(cueBounds(4)/2))+loc,color);     %cues are in correct place on laptop
else    
    Screen('DrawText',thisWin,cue,centerX-round(cueBounds(3)/2),(centerY-round(cueBounds(4)/2))+loc+10,color);  %but need to be offset by 10 to work on BR compuers?
end   

end
%===============================================
% function: make_windows
% purpose: opens a series of offScreen windows
%          for the stream
%===============================================
function myWindows = make_windows(maxStreamLength,window)

myWindows = zeros(1,maxStreamLength);
for thisFrame=1:maxStreamLength
    myWindows(1,thisFrame) = Screen('OpenOffScreenWindow',window);
end

end
%===============================================
% function: randomize_trial_sequence
% purpose: randomizes the order of lags and the
%           presentation of the consistent target
%           pairs within a block. ensures that
%           lags are presented the appropriate
%           number of times and the pairs are
%           not repeated too closely together
%           returns a 2xnTrials matrix of indices
%           to the lag and the target pair
%           Note that pick_stream_items will ignore
%           the pairSequence part if the blockType
%           is varied.
%===============================================
function trialSequence = randomize_trial_sequence(mySOA,nConCon,nCueCon,nRepsPerBlock)

nSOA = size(mySOA,2);

trialSequence = make_trialTypeMatrix(nRepsPerBlock,4,[2 nConCon nCueCon nSOA]);

end
%===============================================
% function: make_streams
% purpose: given the selected stream items this
%          function makes a series of off-Screen
%          windows corresponding to the particular
%          frame of the stream and the blank ISI
%          the function returns all the pointers
%          to the offScreen windows so that they
%          can be copied to the Screen quickly
%          in the show_stream function
%===============================================
function [myWindows,arrowDir,CueCode] = make_stream(myWindows,thisCon,thisCue,tarLoc,centerX,centerY,window,laptopDebug)

tempOffset = 0;
Screen('TextFont',myWindows(3),'Arial');

upperLoc=-44;       
lowerLoc=44;

if thisCue == 1
    drawFixation(myWindows(3),centerX,centerY,[0 0 0])
    CueCode = 'N';
elseif thisCue == 2
    drawCue(myWindows(3),0,centerX,centerY,[0 0 0],laptopDebug)      
    CueCode = 'C';  %for 'center'
elseif thisCue== 7  %an invalid trial
    if tarLoc == 1
        drawCue(myWindows(3),lowerLoc,centerX,centerY,[0 0 0],laptopDebug)  %loc was lowerLoc
        drawFixation(myWindows(3),centerX,centerY,[0 0 0])
        CueCode = 'I';
    else
        drawCue(myWindows(3),upperLoc,centerX,centerY,[0 0 0],laptopDebug)  %loc was upperLoc
        drawFixation(myWindows(3),centerX,centerY,[0 0 0])
        CueCode = 'I';
    end
else
    if tarLoc == 1
        drawCue(myWindows(3),upperLoc,centerX,centerY,[0 0 0],laptopDebug)  %loc was upperLoc
        drawFixation(myWindows(3),centerX,centerY,[0 0 0])
        CueCode = 'V';
    else
        drawCue(myWindows(3),lowerLoc,centerX,centerY,[0 0 0],laptopDebug)
        drawFixation(myWindows(3),centerX,centerY,[0 0 0])
        CueCode = 'V';
    end
end

%second frame is the t1 task word
Screen('TextSize',myWindows(2),40);
Screen('TextFont',myWindows(2),'Arial');

if thisCon == 1         %difficult task
    %pick direction of arrow
    tmp = randperm(2,1);
    if tmp == 1
        t1Task = '>><>>';
        arrowDir = 'L';
    else
        t1Task = '<<><<';
        arrowDir = 'R';
    end
elseif thisCon == 2     %easy task
    %pick direction of arrow
    tmp = randperm(2,1);
    if tmp == 1
        t1Task = '<<<<<';
        arrowDir = 'L';
    else
        t1Task = '>>>>>';
        arrowDir = 'R';
    end
end

[t1TaskBounds]=Screen('TextBounds',myWindows(2),t1Task);
t1TaskX=centerX-round(t1TaskBounds(3)/2);
t1TaskY=centerY-round(t1TaskBounds(4)/2);

if tarLoc == 1
    Screen('DrawText',myWindows(2),t1Task,t1TaskX,t1TaskY+upperLoc,[0 0 0]);       %upperLoc (used to) = -34
    drawFixation(myWindows(2),centerX,centerY,[0 0 0])
else
    Screen('DrawText',myWindows(2),t1Task,t1TaskX,t1TaskY+lowerLoc,[0 0 0]);       %lowerLoc = 44
    drawFixation(myWindows(2),centerX,centerY,[0 0 0])
end

test = 0;

if test == 1
    
    myOffset = 150;
    rect=[centerX-myOffset,centerY-myOffset,centerX+myOffset,centerY+myOffset];
    testLoc = Screen('OpenOffScreenWindow',window);
    drawFixation(testLoc,centerX,centerY,[0 0 0])
    
    drawCue(testLoc,upperLoc,centerX,centerY,[0 0 0],laptopDebug)
%     Screen('TextSize',testLoc,50)
%     Screen('TextFont',testLoc,'Arial')
%     [cueBounds]=Screen('TextBounds',testLoc,'*');
%     Screen('DrawText',testLoc,'*',centerX-round(cueBounds(3)/2),centerY-round(cueBounds(4)/2)-34,[0 0 0])
    
    drawCue(testLoc,0,centerX,centerY,[0 0 0],laptopDebug);
    drawCue(testLoc,lowerLoc,centerX,centerY,[0 0 0],laptopDebug);
    Screen('TextSize',testLoc,40);
    Screen('TextFont',testLoc,'Arial');
    t1Task = '<<<<<';
    [t1TaskBounds]=Screen('TextBounds',testLoc,t1Task);
    t1TaskX=centerX-round(t1TaskBounds(3)/2);
    t1TaskY=centerY-round(t1TaskBounds(4)/2);
    Screen('DrawText',testLoc,t1Task,t1TaskX,t1TaskY+upperLoc,[0 0 0]);
    Screen('DrawText',testLoc,t1Task,t1TaskX,t1TaskY+lowerLoc,[0 0 0]);

    Screen('CopyWindow',testLoc,window,rect,rect);
    Screen('Flip',window)
    Screen('WaitBlanking',window,100);
    
end

end
%===============================================
% function: show_stream
% purpose: takes the pointers to the offScreen
%          windows generated by make_stream and
%          shows them for the specified number of
%          Screen refreshes.
%===============================================
function [Resp,D,t1On,t1off, RT, nsr] = show_stream(myWindows,window,fixWindow,isiWindow,centerX,centerY,lag,practice,arrowDir)

Screen('FillRect',window,[255 255 255])

frmrate=FrameRate(window);

tmp1 = round(.4/(1/frmrate));
tmp2 = round(1.6/(1/frmrate));

myOffset = 150;
%Alter SOA

nsr=round((lag/1000)*frmrate-round(.15*frmrate));

%D = random_range(tmp1,tmp2);    % number of Screen refreshes for initial fixation

%not sure what D is doing here, gonna randomly pick 1 b/c can't find
%equivalent of random_range

c=randperm(2,1);
if c==1
    D=tmp1;
elseif c==2
    D=tmp2;
end

fromScrnRect=[centerX-myOffset,centerY-myOffset,centerX+myOffset,centerY+myOffset];
toScrnRect=[centerX-myOffset,centerY-myOffset,centerX+myOffset,centerY+myOffset];

%show fixation, fix/cue, fixation, target
start=GetSecs;
%clear window
Screen('FillRect',window,[255 255 255])
Screen('Flip',window)
%show fixation for D amount of frames
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');                 
Screen('CopyWindow',fixWindow,window,fromScrnRect,toScrnRect);  %was +- 150
Screen('Flip',window)
Screen('WaitBlanking',window,D);
%show cue and fix
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');                 
Screen('CopyWindow',myWindows(3),window,fromScrnRect,toScrnRect);
Screen('Flip',window)
Screen('WaitBlanking',window,round(.15*frmrate));
%show fixation
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');                 
Screen('CopyWindow',fixWindow,window,fromScrnRect,toScrnRect);  %was +- 150
Screen('Flip',window)
Screen('WaitBlanking',window,nsr);
%show stim and wait for resp
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');                 
Screen('CopyWindow',myWindows(2),window,fromScrnRect,toScrnRect);
Screen('Flip',window)
t1On=GetSecs;

FlushEvents('KeyDown');

%Rush(char(streamLoop1),priorityLevel); 
    %doesn't integrate well into PTB, try to avoid
keepChecking = 1;
timedOut = 0;
%get response
while keepChecking==1             
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown==1||(secs-t1On)>=1.7
        keepChecking = 0;       
        if (secs-t1On)>=1.7
            timedOut = 1;
        end
    end
end
if timedOut==0
    resp = find(keyCode~=0);
    if resp == KbName('f') %add this instructions, f=left, j=right
        Resp='L';
    elseif resp == KbName('j')
        Resp='R'; 
    else
        Resp='Q';
    end
    RT=secs-t1On;
    t1off = secs;
else
    Resp = 'N';
    RT = secs-t1On;
    t1off = 000;
end


%calculate final fixation (approx. 3500msec - inital fixation time - Reaction Time +/- Alteration due to SOA)

% alt = lag-400; %difference in time due to soa differences are taken out
% of final fixation

%give practice feedback

if practice==1
    if Resp==arrowDir
        drawFixation(fixWindow,centerX,centerY,[0 255 0 255])       %green fixation for correct
    else
        drawFixation(fixWindow,centerX,centerY,[255 0 0 255])       %red fixation for incorrect
    end
end

%show final fixation
Screen('CopyWindow',fixWindow,window,[centerX-150,centerY-150,centerX+150,centerY+150],[centerX-150,centerY-150,centerX+150,centerY+150]);
Screen('Flip',window)
Screen('WaitBlanking',window,tmp1);

end
%===============================================
% function: clear_stream
% purpose: opens a series of offScreen windows
%          for the stream
%===============================================
function myWindows = clear_stream(myWindows,streamLength,centerX,centerY, conScreen)

for thisFrame=1:streamLength
    Screen('FillRect',myWindows(thisFrame),[255 255 255])%,[centerX-200 centerY-200 centerX+200 centerY+200]);
end

end
%===============================================
% function: code_response
% purpose: determine if t1 and t2 are correct
%===============================================
function Acc = code_response(Resp,arrowDir)

Acc = -1;
WaitSecs(.100);
codesForThisTrial = zeros(3,1);

if Resp == arrowDir
    Acc = 1;
else
    Acc = 0;
end

end

