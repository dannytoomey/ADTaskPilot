
%% Four Location Response version of ADTask

% the task will have three conditions - low, medium, and high interference.
% the amount of interference of each condition will be determined by the
% similarity of distractors to a target. in the low interference condition,
% the target will be a red circle among blue squares. in the medium
% interference condition, the target will be a red square among
% a blue cirlce and blue squares. in the high interference condition, the target will
% be a red circle among a red square and blue circles. the idea is:
%
%       low interference - target and distractors share no dimensions
%       medium interference - target/distractors share one dimension
%       high interference - target/distractors share two dimensions
%
% in ADTask, participants only respond left/right. In this, they respond to
% all four possible locations

%% Low Interference Condition

function v2_4locLowIntf(filePath,sjNum,lowTaskOrder,numTask,numCue,numBlocks,numTrials,valCueThres,invalCueThres,wmLoadDur,visRespDur,audRespDur,numChannels,soundRep,soundDur,waitForDeviceStart)

%set up the screen

sca;
PsychDefaultSetup(2);
InitializePsychSound(1);
ListenChar(0);
HideCursor;
screenNumber = max(Screen('Screens'));
white = [255 255 255];
grey = white./2;
red=[255 0 0];
blue=[0 0 255];
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

%set up the keys that will be used to respond

[keyboardIndices, ~, ~] = GetKeyboardIndices('Apple Internal Keyboard / Trackpad');
KbName('UnifyKeyNames');
upLeftResp = KbName('e');
downLeftResp = KbName('v');
upRightResp = KbName('i');
downRightResp = KbName('n');
lowResp=KbName('f');
highResp=KbName('j');

%set up the stimulus locations

PsychImaging('PrepareConfiguration');
[xCenter, yCenter] = RectCenter(rect);
[~, screenYpixels] = Screen('WindowSize', window);
dim = 1;
[x, y] = meshgrid(dim-1:dim, dim-1:dim);
pixelScale = screenYpixels / (dim*2+2);
x = x .*pixelScale;
y = y .*pixelScale;
x1 = x(1,2);
y1 = y(2,1);
stimX = (x - x1/2)/1.2;
stimY = (y - y1/2)/1.2;
yScale = stimY(1,2);
xScale = stimX(1,2);

for task=1:numTask
        
    %give task instructions
    
    Screen('TextSize',window,40);
    Screen('TextFont',window,'Courier');
    ignoreTones=['Respond to the location of the \n'...
        'RED CIRCLE with the E, V, I, and N keys \n'...
        '(E = upper left, I = upper right \n'...
        'V = lower left, and N = lower right) \n'...
        'and IGNORE the TONES.'];
    respTones=['Respond to the location of the \n'...
        'RED CIRCLE with the E, V, I, and N keys. \n'...
        '(E = upper left, I = upper right \n'...
        'V = lower left, and N = lower right) \n'...
        'RESPOND to the PITCH of the TONES \n'...
        'with the F and J keys. \n' ...
        '(F = low and J = high)'];
            
    if lowTaskOrder==1
        if task==1
            DrawFormattedText(window,ignoreTones,'center','center',white);
        elseif task==2
            DrawFormattedText(window,respTones,'center','center',white);
        end
    elseif lowTaskOrder==2
        if task==1
            DrawFormattedText(window,respTones,'center','center',white);
        elseif task==2
            DrawFormattedText(window,ignoreTones,'center','center',white);
        end
    end

    Screen('Flip',window);
    RestrictKeysForKbCheck(KbName('space'))
    KbStrokeWait
    RestrictKeysForKbCheck([])
    WaitSecs(.2)

    cueCondOrder=randperm(2);
        
    for cue=1:numCue
        
        if cue==1
            cueCond=cueCondOrder(1,1);
        elseif cue==2
            cueCond=cueCondOrder(1,2);
        end
        
        if cueCond==1
            cueInst=['\n The box is MORE likely to give \n the location of the target. \n' ...
                'Use this information.'];
        elseif cueCond==2
            cueInst=['\n The box is LESS likely to give \n the location of the target. \n' ...
                'Use this information.'];
        end
        
        WMData=nan(10,numBlocks);
        
        for block=1:numBlocks
            
            %give instructions for this block
            
            singleTaskInst = ['You are about to see a sequence of letters. \n' ...
                'Remember these letters in order. \n \n' ... 
                'Remember to respond to the location \n' ... 
                'of the RED CIRCLE and IGNORE the tones. \n \n' ...
                sprintf('%s',cueInst) '\n \n' ... 
                'Press space when you are ready \n' ... 
                'to see the letters.'];
            dualTaskInst = ['You are about to see a sequence of letters. \n'... 
                'Remember these letters in order. \n \n'...
                'Remember to respond to the \n' ... 
                'location of the RED CIRCLE \n' ... 
                'AND the PITCH of the TONES. \n'...
                sprintf('%s',cueInst) '\n \n' ... 
                'Press space when you are ready \n' ... 
                'to see the letters.'];
   
            Screen('TextSize', window, 30);
            
            if lowTaskOrder==1
                if task==1
                    DrawFormattedText(window,singleTaskInst,'center','center', white);
                    thisTask=1;
                elseif task==2
                    DrawFormattedText(window,dualTaskInst,'center','center', white);
                    thisTask=2;
                end
            end
            if lowTaskOrder==2
                if task==1
                    DrawFormattedText(window,dualTaskInst,'center','center', white);
                    thisTask=2;
                elseif task==2
                    DrawFormattedText(window,singleTaskInst,'center','center', white);
                    thisTask=1;
                end
            end
            
            Screen('Flip',window);
            RestrictKeysForKbCheck(KbName('space'))
            KbStrokeWait
            RestrictKeysForKbCheck([])
            WaitSecs(.2)

            %give WM load
            
            letters = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'];
            rng('shuffle');
            LTs = randperm(26,5);
            letter1 = letters(1,LTs(1,1));
            letter2 = letters(1,LTs(1,2));
            letter3 = letters(1,LTs(1,3));
            letter4 = letters(1,LTs(1,4));
            letter5 = letters(1,LTs(1,5));
            Screen('TextSize', window, 35);
            Screen('DrawText',window,letter1,xCenter - 1.5*xScale,yCenter,white);
            Screen('DrawText',window,letter2,xCenter - .75*xScale,yCenter,white);
            Screen('DrawText',window,letter3,xCenter,yCenter,white);
            Screen('DrawText',window,letter4,xCenter + .75*xScale,yCenter,white);
            Screen('DrawText',window,letter5,xCenter + 1.5*xScale,yCenter,white);
            Screen('Flip',window);
            WaitSecs(wmLoadDur);
            
            Screen('FillRect',window,grey,[]);
            Screen('Flip',window);
            WaitSecs(0.5);
            
            toneOrder=randperm(numTrials);
            cueOrder=randperm(numTrials);
            
            trialData = nan(10,numTrials);
                
            for trial=1:numTrials
                
                %cue the target
                
                rng('shuffle');
                boxLctn = randi([0,100]);
                xLctn = max(stimX);
                if boxLctn<=50
                    CenX = min(xLctn);
                elseif 50<boxLctn
                    CenX = max(xLctn);
                end
                
                %draw fixation cross and cue
                %(let it be for now but next time, a '+' will do just fine,
                %this is a little excessive)
                
                stimRect = [0 0 50 50];
                maxDiameter = max(stimRect);

                fixCrossDimPix = 10;
                xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
                yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
                allCoords = [xCoords; yCoords];
                lineWidthPix = 2;
                crossSize=18;
                baseRect = [0 0 1.5*stimRect(1,3) -stimY(1,1)+stimY(2,1)+1.5*stimRect(1,4)];
                boxCenX = xCenter + CenX;
                centeredRect = CenterRectOnPointd(baseRect, boxCenX, yCenter);
                rectColor = [0 0 0]; 
                Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                Screen('TextSize', window, crossSize);
                Screen('DrawLines',window,allCoords,lineWidthPix,white,[xCenter yCenter], 2);
                Screen('Flip', window,[],1);
                WaitSecs(0.3)       %show fix for 300ms
                Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                Screen('FrameRect',window,rectColor,centeredRect,6);
                Screen('Flip', window);
                WaitSecs(0.2)       %show cue and fix for 200ms
                Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                Screen('TextSize', window, crossSize);
                Screen('DrawLines',window,allCoords,lineWidthPix,white,[xCenter yCenter], 2);
                Screen('Flip', window,[],1);
                WaitSecs(0.2)      %show fix for 200ms

                %set the location of each stimulus
                
                centeredRect1 = CenterRectOnPointd(stimRect, xCenter+stimX(1,1), yCenter+stimY(1,1));
                centeredRect2 = CenterRectOnPointd(stimRect, xCenter+stimX(2,1), yCenter+stimY(2,1));
                centeredRect3 = CenterRectOnPointd(stimRect, xCenter+stimX(1,2), yCenter+stimY(1,2));
                centeredRect4 = CenterRectOnPointd(stimRect, xCenter+stimX(2,2), yCenter+stimY(2,2));
                
                if cueCond == 1
                    thres=numTrials*valCueThres;
                elseif cueCond==2
                    thres=numTrials*invalCueThres;
                end
                
                rng('shuffle');
                targetLoc=randi(100);
                
                %determine stimulus location and target
                %(make subfunctions for this kind of thing next time, this
                %is messy to read)
                
                if boxLctn<=50
                    if cueOrder(1,trial)<=thres
                        if targetLoc<=50
                            Screen('FillOval', window, red, centeredRect1, maxDiameter);    %one red circle
                            Screen('FillRect', window, blue, centeredRect2);                %three blue squares
                            Screen('FillRect', window, blue, centeredRect3);
                            Screen('FillRect', window, blue, centeredRect4);
                            target=1;
                        elseif 50<targetLoc
                            Screen('FillOval', window, red, centeredRect2, maxDiameter);
                            Screen('FillRect', window, blue, centeredRect1);
                            Screen('FillRect', window, blue, centeredRect3);
                            Screen('FillRect', window, blue, centeredRect4);
                            target=2;                        
                        end
                    elseif thres<cueOrder(1,trial)
                        if targetLoc<=50
                            Screen('FillOval', window, red, centeredRect3, maxDiameter);
                            Screen('FillRect', window, blue, centeredRect1);
                            Screen('FillRect', window, blue, centeredRect2);
                            Screen('FillRect', window, blue, centeredRect4);
                            target=3;
                        elseif 50<targetLoc
                            Screen('FillOval', window, red, centeredRect4, maxDiameter);
                            Screen('FillRect', window, blue, centeredRect1);
                            Screen('FillRect', window, blue, centeredRect2);
                            Screen('FillRect', window, blue, centeredRect3);
                            target=4;
                        end
                    end
                elseif 50<boxLctn
                    if cueOrder(1,trial)<=thres
                        if targetLoc<=50
                            Screen('FillOval', window, red, centeredRect3, maxDiameter);
                            Screen('FillRect', window, blue, centeredRect1);
                            Screen('FillRect', window, blue, centeredRect2);
                            Screen('FillRect', window, blue, centeredRect4);
                            target=3;
                        elseif 50<targetLoc
                            Screen('FillOval', window, red, centeredRect4, maxDiameter);
                            Screen('FillRect', window, blue, centeredRect1);
                            Screen('FillRect', window, blue, centeredRect2);
                            Screen('FillRect', window, blue, centeredRect3);
                            target=4;
                        end
                    elseif thres<cueOrder(1,trial)
                        if targetLoc<=50
                            Screen('FillOval', window, red, centeredRect1, maxDiameter);
                            Screen('FillRect', window, blue, centeredRect2);
                            Screen('FillRect', window, blue, centeredRect3);
                            Screen('FillRect', window, blue, centeredRect4);
                            target=1;
                        elseif 50<targetLoc
                            Screen('FillOval', window, red, centeredRect2, maxDiameter);
                            Screen('FillRect', window, blue, centeredRect1);
                            Screen('FillRect', window, blue, centeredRect3);
                            Screen('FillRect', window, blue, centeredRect4);
                            target=2;                        
                        end
                    end
                end
                
                %play tone. 1/2 low tones, 1/2 high tone
                
                toneNum = toneOrder(1,trial);
                if toneNum<=numTrials*(1/2)
                    tone = 300;
                elseif numTrials*(1/2)<toneNum
                    tone = 600;
                end
                pahandle = PsychPortAudio('Open', [], 1, 1, 48000, numChannels);
                PsychPortAudio('Volume', pahandle, 0.5);
                beep = MakeBeep(tone, soundDur, 48000);
                PsychPortAudio('FillBuffer', pahandle, beep);

                %present stimuli
                
                visResp=0;

                visTStart = Screen('Flip', window);
                PsychPortAudio('Start', pahandle, soundRep, 0, waitForDeviceStart);
                
                %record visual response
                
                while GetSecs<=visTStart+visRespDur
                    if visResp==0
                    [keyIsDown, visTEnd, keyCode, ~] = KbCheck(keyboardIndices);
                        if keyIsDown == 1
                            ind = find(keyCode~=0);
                            if size(ind,2)==1
                                if ind == upLeftResp
                                    visResp = 1;
                                elseif ind == downLeftResp
                                    visResp = 2;
                                elseif ind == downRightResp
                                    visResp = 4;
                                elseif ind == upRightResp
                                    visResp = 3;
                                end
                            end
                        end
                    end
                end
                if visTEnd==0
                    visTEnd=GetSecs;
                end
                visRT=visTEnd-visTStart;
                
                PsychPortAudio('Stop',pahandle,1,1);
                PsychPortAudio('Close', pahandle);
                
                %record auditory resp if dual-task, show fixation for duration of what would have been the
                %auditory response if single task
                
                audResp=0;
                audRT=0;
                
                Screen('FillRect',window,grey);
                Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                Screen('TextSize', window, crossSize);
                Screen('DrawLines',window,allCoords,lineWidthPix,white,[xCenter yCenter], 2);
                Screen('Flip', window,[],1);
                
                if thisTask==1
                    WaitSecs(audRespDur);
                elseif thisTask==2
                    Screen('TextSize',window,35);
                    audInst=['Low or High tone? \n' ...
                             '(F = low, J = high)'];
                    DrawFormattedText(window,audInst,'center',yCenter+stimY(1,1),white);
                    audTStart=Screen('Flip',window);
                    while GetSecs<=audTStart+audRespDur
                        if audResp==0
                            [keyIsDown,audTEnd,keyCode,~]=KbCheck(keyboardIndices);
                            if keyIsDown==1
                                ind=find(keyCode~=0);
                                if size(ind,2)==1
                                    if ind==lowResp
                                        audResp=1;
                                    elseif ind==highResp
                                        audResp=2;
                                    end
                                end
                            end
                        end
                    end
                    if audTEnd==0
                        audTEnd=GetSecs;
                    end
                    audRT=audTEnd-audTStart;
                end
                
                trialData(1,trial) = cueCond;               %whether cues are more or less valid on this block
                trialData(2,trial) = cueOrder(1,trial);     %cue val or inval on this trial    
                trialData(3,trial) = boxCenX;               %location of the cue
                trialData(4,trial) = targetLoc;             %recording so in case i need to double check that the target is being displayed in the correct location
                trialData(5,trial) = tone;                  %pitch of the tone
                trialData(6,trial) = audResp;               %low or high resp
                trialData(7,trial) = audRT;                 %rt for auditory response
                trialData(8,trial) = target;                %location of visual target
                trialData(9,trial) = visResp;               %upper/lower+left/right location resp
                trialData(10,trial) = visRT;                %rt for visual response
                
                allLowTrials(trial).thisTrialData=trialData;
                
            end
            
            save('allLowTrialsFile.mat','allLowTrials');
            
            %probe wm
            
            Screen('FillRect',window,grey)
            Screen('Flip',window)
            WaitSecs(0.25)   %purely cosmetic, but a break here feels nice in the flow of the task
            
            Screen('TextSize', window, 30);
            Screen('TextFont', window, 'Courier');
            DrawFormattedText(window, 'Type the letters', 'center', yCenter + .75*yScale, white);
            DrawFormattedText(window, 'Press any key to continue', 'center', yCenter - 1.5*yScale, white);
            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            Screen('TextSize', window, 35);
            Screen('DrawText',window,'_',xCenter - 1.5*xScale,yCenter,white);
            Screen('DrawText',window,'_',xCenter - .75*xScale,yCenter,white);
            Screen('DrawText',window,'_',xCenter,yCenter,white);
            Screen('DrawText',window,'_',xCenter + .75*xScale,yCenter,white);
            Screen('DrawText',window,'_',xCenter + 1.5*xScale,yCenter,white);
            Screen('Flip',window,[],1);
            %put this waitsecs here so if they're pressing a key from
            %visual resp it doesn't show up as a wm resp
            WaitSecs(0.5);
            wmResp = zeros(1,5);
            numResp = 1;
            loc=[xCenter - 1.5*xScale,xCenter - .75*xScale,xCenter,xCenter + .75*xScale,xCenter + 1.5*xScale];
            while numResp <= 5
                thisLoc = loc(1,numResp);
                RestrictKeysForKbCheck(3:29);
                [keyIsDown, ~, keyCode, ~] = KbCheck(keyboardIndices);
                    if keyIsDown == 1
                        ind = find(keyCode);
                        if size(ind,2)==1
                            wmResp(1,numResp) = letters(1,ind-3);
                            Screen('TextSize', window, 35);
                            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                            Screen('DrawText',window,letters(1,ind-3),thisLoc,yCenter-30,white);
                            Screen('Flip',window,[],1);
                            numResp = numResp+1;
                            KbWait(keyboardIndices,1);
                        end
                    end
                RestrictKeysForKbCheck([]);
            end
                        
            KbStrokeWait;

            %record wm data
            WMData(1,block) = letters(1,LTs(1,1));
            WMData(2,block) = letters(1,LTs(1,2));
            WMData(3,block) = letters(1,LTs(1,3));
            WMData(4,block) = letters(1,LTs(1,4));
            WMData(5,block) = letters(1,LTs(1,5));
            WMData(6,block) = wmResp(1,1);
            WMData(7,block) = wmResp(1,2);
            WMData(8,block) = wmResp(1,3);
            WMData(9,block) = wmResp(1,4);
            WMData(10,block) = wmResp(1,5);
            
            allLowBlock(block).thisBlockTrials=allLowTrials;
            allLowBlock(block).thisBlockWM=WMData;
            Screen('FillRect',window,grey);
            save('allLowBlockFile.mat','allLowBlock');      %save struct in case crash
            
        end
        
        allLowCueCond(cue).thisCueCondData=allLowBlock;
        allLowCueCond(cue).thisCueCond=cueCond;
        save('allLowCueCondFile.mat','allLowCueCond');      %save struct in case crash

    end
    
    allLowTask(task).thisTaskData=allLowCueCond;
    save([filePath '/' sprintf('sj%02d_allLowTaskFile.mat',sjNum)],'allLowTask');       %save struct to data repository
   
end

ListenChar(2);
ShowCursor;
sca;

return

