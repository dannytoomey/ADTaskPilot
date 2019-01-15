
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

%% Practice Condition

%uses hIntf v2

function v2_4locPrac(sjNum)

sca;
PsychDefaultSetup(2);
InitializePsychSound(1);
ListenChar(0);
HideCursor;
screenNumber = max(Screen('Screens'));
white = [255 255 255];
grey = white./2;
red=[255 0 0];
green=[0 255 0];
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
[keyboardIndices, ~, ~] = GetKeyboardIndices('Apple Internal Keyboard / Trackpad');
KbName('UnifyKeyNames');
upLeftResp = KbName('e');
downLeftResp = KbName('c');
upRightResp = KbName('i');
downRightResp = KbName('n');
lowResp=KbName('f');
highResp=KbName('j');
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
stimX = x - x1/2;
stimY = y - y1/2;
yScale = stimY(1,2);
xScale = stimX(1,2);
numChannels = 1;
soundRep = 1;
soundDur = 0.25;
waitForDeviceStart = 0;

numCond=3;
numTask = 2;
numCue = 1;

numBlocks = 2;
numTrials = 6;
valCueThres=2/3;
invalCueThres=1/3;

for cond=1:numCond
    
    cond=3;
    
    if cond==1
        
        %low intf practice
    
        for task=1:numTask

            Screen('TextSize',window,40);
            Screen('TextFont',window,'Courier');
            ignoreTones=['Respond to the location of the \n'...
                'red circle with the E, C, I, and N keys \n'...
                '(E = upper left, I = upper right \n'...
                'C = lower left, and N = lower right) \n'...
                'and ignore the tones.'];
            respTones=['Respond to the location of the \n'...
                'red circle with the E, C, I, and N keys. \n'...
                '(E = upper left, I = upper right \n'...
                'C = lower left, and N = lower right) \n'...
                'Respond to the pitch of the tone \n'...
                'with the F and J keys. \n' ...
                '(F = low and J = high)'];

            if task==1
                DrawFormattedText(window,ignoreTones,'center','center',white);
            elseif task==2
                DrawFormattedText(window,respTones,'center','center',white);
            end

            Screen('Flip',window);
            KbStrokeWait;

            cueCondOrder=randperm(2);

            for cue=1:numCue

                if cue==1
                    cueCond=cueCondOrder(1,1);
                elseif cue==2
                    cueCond=cueCondOrder(1,2);
                end

                if cueCond==1
                    cueInst=['\n The box is more likely to give \n the location of the target. \n' ...
                        'Use this information.'];
                elseif cueCond==2
                    cueInst=['\n The box is less likely to give \n the location of the target. \n' ...
                        'Use this information.'];
                end

                for block=1:numBlocks

                    singleTaskInst = ['You are about to see a sequence of letters. \n' ...
                        'Remember these letters in order. \n \n' ... 
                        'Remember to respond to the location \n' ... 
                        'of the red circle and ignore the tones. \n \n' ...
                        sprintf('%s',cueInst) '\n \n' ... 
                        'Press space when you are ready \n' ... 
                        'to see the letters.'];
                    dualTaskInst = ['You are about to see a sequence of letters. \n'... 
                        'Remember these letters in order. \n \n'...
                        'Remember to respond to the \n' ... 
                        'location of the red circle \n' ... 
                        'and the pitch of the tone. \n'...
                        sprintf('%s',cueInst) '\n \n' ... 
                        'Press space when you are ready \n' ... 
                        'to see the letters.'];

                    Screen('TextSize', window, 30);

                    if task==1
                        DrawFormattedText(window,singleTaskInst,'center','center', white);
                        thisTask=1;
                    elseif task==2
                        DrawFormattedText(window,dualTaskInst,'center','center', white);
                        thisTask=2;
                    end

                    Screen('Flip',window);
                    KbStrokeWait
                    WaitSecs(.2)

                    %load WM

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
                    WaitSecs(2);

                    Screen('FillRect',window,grey,[]);
                    Screen('Flip',window);
                    WaitSecs(0.5);

                    toneOrder=randperm(numTrials);
                    cueOrder=randperm(numTrials);

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

                        %draw fixation cross
                        
                        Screen('FillRect',window,grey);

                        stimRect = [0 0 50 50];
                        maxDiameter = max(stimRect);

                        fixCrossDimPix = 20;
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
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('FrameRect',window,rectColor,centeredRect,1);
                        Screen('Flip', window);
                        WaitSecs(0.5);
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('TextSize', window, crossSize);
                        Screen('DrawLines',window,allCoords,lineWidthPix,white,[xCenter yCenter], 2);
                        Screen('Flip', window,[],1);
                        WaitSecs(0.25);

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

                        if boxLctn<=50
                            if cueOrder(1,trial)<=thres
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
                            audTar=1;
                        elseif numTrials*(1/2)<toneNum
                            tone = 600;
                            audTar=2;
                        end
                        pahandle = PsychPortAudio('Open', [], 1, 1, 48000, numChannels);
                        PsychPortAudio('Volume', pahandle, 0.5);
                        beep = MakeBeep(tone, soundDur, 48000);
                        PsychPortAudio('FillBuffer', pahandle, beep);

                        %present stimuli

                        numSecs = 1;

                        visResp=0;

                        visTStart = Screen('Flip', window);
                        PsychPortAudio('Start', pahandle, soundRep, 0, waitForDeviceStart);

                        %record visual response

                        while GetSecs<=visTStart+numSecs
                            if visResp==0
                            [keyIsDown, visTEnd, keyCode, ~] = KbCheck(keyboardIndices);
                                if keyIsDown == 1
                                    ind = find(keyCode ~=0);
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
                        
                        PsychPortAudio('Stop',pahandle,1,1);
                        PsychPortAudio('Close', pahandle);

                        %record auditory resp if dual-task, show fixation if single

                        audRespDur=1;
                        audResp=0;
                        
                        Screen('FillRect',window,grey);
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('TextSize', window, crossSize);
                        if target==visResp
                                Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                            else
                                Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                        end
                        Screen('Flip', window,[],1);

                        if thisTask==1
                            WaitSecs(audRespDur);
                        elseif thisTask==2
                            Screen('FillRect',window,grey);
                            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                            Screen('TextSize', window, crossSize);
                            if target==visResp
                                    Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                else
                                    Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                            end
                            Screen('TextSize',window,35);
                            audInst=['Low or High tone? \n' ...
                                     '(F = low, J = high)'];
                            DrawFormattedText(window,audInst,'center',yCenter+stimY(1,1),red);
                            audTStart=Screen('Flip',window,[],1);
                            while GetSecs<=audTStart+audRespDur
                                if audResp==0
                                    [keyIsDown,~,keyCode,~]=KbCheck(keyboardIndices);
                                    if keyIsDown==1
                                        ind=find(keyCode~=0);
                                        if size(ind,2)==1
                                            if ind==lowResp
                                                audResp=1;
                                            elseif ind==highResp
                                                audResp=2;
                                            end
                                        end
                                        if audTar==audResp
                                            DrawFormattedText(window,audInst,'center',yCenter+stimY(1,1),green);
                                            Screen('Flip',window);
                                        end
                                    end
                                end
                            end
                        end
                    end

                    %probe wm

                    Screen('FillRect',window,grey);
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
                    WaitSecs(0.25);
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
                    Screen('FillRect',window,grey);
                end
            end
        end
    end
    
    if cond==2

        %med intf practice

        for task=1:numTask

            Screen('TextSize',window,40);
            Screen('TextFont',window,'Courier');
            ignoreTones=['Respond to the location of the \n'...
                'red square with the E, C, I, and N keys \n'...
                '(E = upper left, I = upper right \n'...
                'C = lower left, and N = lower right) \n'...
                'and ignore the tones.'];
            respTones=['Respond to the location of the \n'...
                'red square with the E, C, I, and N keys. \n'...
                '(E = upper left, I = upper right \n'...
                'C = lower left, and N = lower right) \n'...
                'Respond to the pitch of the tone \n'...
                'with the F and J keys. \n' ...
                '(F = low and J = high)'];

            if task==1
                DrawFormattedText(window,respTones,'center','center',white);
            elseif task==2
                DrawFormattedText(window,ignoreTones,'center','center',white);
            end

            Screen('Flip',window);
            KbStrokeWait;

            cueCondOrder=randperm(2);

            for cue=1:numCue

                if cue==1
                    cueCond=cueCondOrder(1,1);
                elseif cue==2
                    cueCond=cueCondOrder(1,2);
                end

                if cueCond==1
                    cueInst=['\n The box is more likely to give \n the location of the target. \n' ...
                        'Use this information.'];
                elseif cueCond==2
                    cueInst=['\n The box is less likely to give \n the location of the target. \n' ...
                        'Use this information.'];
                end
                
                for block=1:numBlocks

                    singleTaskInst = ['You are about to see a sequence of letters. \n' ...
                        'Remember these letters in order. \n \n' ... 
                        'Remember to respond to the location \n' ... 
                        'of the red square and ignore the tones. \n \n'...
                        sprintf('%s',cueInst) '\n \n' ... 
                        'Press space when you are ready \n' ... 
                        'to see the letters.'];
                    dualTaskInst = ['You are about to see a sequence of letters. \n'... 
                        'Remember these letters in order. \n \n'...
                        'Remember to respond to the \n' ... 
                        'location of the red square \n' ... 
                        'and the pitch of the tone.\n'...
                        sprintf('%s',cueInst) '\n \n' ... 
                        'Press space when you are ready \n' ... 
                        'to see the letters.'];

                    Screen('TextSize', window, 30);

                    if task==1
                        DrawFormattedText(window,dualTaskInst,'center','center', white);
                        thisTask=2;
                    elseif task==2
                        DrawFormattedText(window,singleTaskInst,'center','center', white);
                        thisTask=1;
                    end

                    Screen('Flip',window);
                    KbStrokeWait
                    WaitSecs(.2)

                    %load WM

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
                    WaitSecs(2);

                    Screen('FillRect',window,grey,[]);
                    Screen('Flip',window);
                    WaitSecs(0.5);

                    toneOrder=randperm(numTrials);
                    cueOrder=randperm(numTrials);

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

                        %draw fixation cross
                        
                        Screen('FillRect',window,grey);

                        stimRect = [0 0 50 50];
                        maxDiameter = max(stimRect);

                        fixCrossDimPix = 20;
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
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('FrameRect',window,rectColor,centeredRect,1);
                        Screen('Flip', window);
                        WaitSecs(0.5);
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('TextSize', window, crossSize);
                        Screen('DrawLines',window,allCoords,lineWidthPix,white,[xCenter yCenter], 2);
                        Screen('Flip', window,[],1);
                        WaitSecs(0.25);

                        centeredRect1 = CenterRectOnPointd(stimRect, xCenter+stimX(1,1), yCenter+stimY(1,1));
                        centeredRect2 = CenterRectOnPointd(stimRect, xCenter+stimX(2,1), yCenter+stimY(2,1));
                        centeredRect3 = CenterRectOnPointd(stimRect, xCenter+stimX(1,2), yCenter+stimY(1,2));
                        centeredRect4 = CenterRectOnPointd(stimRect, xCenter+stimX(2,2), yCenter+stimY(2,2));

                        if cueCond == 1
                            thres=numTrials*valCueThres;
                        elseif cueCond==2
                            thres=numTrials*invalCueThres;
                        end

                        RGB1=[0 0 255];
                        RGB2=[0 0 255];
                        RGB3=[0 0 255];
                        RGB4=[0 0 255];

                        rng('shuffle');
                        targetLoc=randi(100);

                        rng('shuffle');
                        stimLoc=randi(100);

                        if boxLctn<=50
                            if cueOrder(1,trial)<=thres
                                if targetLoc<=50
                                    RGB1(1,1)=255;
                                    RGB1(1,3)=0;
                                    target=1;
                                    Screen('FillRect', window, RGB1, centeredRect1);
                                    if stimLoc<=33
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                    elseif 33<stimLoc&&stimLoc<=66
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                    elseif 66<stimLoc
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    end
                                elseif 50<targetLoc
                                    RGB2(1,1)=255;
                                    RGB2(1,3)=0;
                                    target=2;
                                    Screen('FillRect', window, RGB2, centeredRect2);
                                    if stimLoc<=33
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                    elseif 33<stimLoc&&stimLoc<=66
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                    elseif 66<stimLoc
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    end
                                end
                            elseif thres<cueOrder(1,trial)
                                if targetLoc<=50
                                    RGB3(1,1)=255;
                                    RGB3(1,3)=0;
                                    target=3;
                                    Screen('FillRect', window, RGB3, centeredRect3);
                                    if stimLoc<=33
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                    elseif 33<stimLoc&&stimLoc<=66
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                    elseif 66<stimLoc
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    end
                                elseif 50<targetLoc
                                    RGB4(1,1)=255;
                                    RGB4(1,3)=0;
                                    target=4;
                                    Screen('FillRect', window, RGB4, centeredRect4);
                                    if stimLoc<=33
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                    elseif 33<stimLoc&&stimLoc<=66
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                    elseif 66<stimLoc
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                    end
                                end
                            end
                        elseif 50<boxLctn
                            if cueOrder(1,trial)<=thres
                                if targetLoc<=50
                                    RGB3(1,1)=255;
                                    RGB3(1,3)=0;
                                    target=3;
                                    Screen('FillRect', window, RGB3, centeredRect3);
                                    if stimLoc<=33
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                    elseif 33<stimLoc&&stimLoc<=66
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                    elseif 66<stimLoc
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    end
                                elseif 50<targetLoc
                                    RGB4(1,1)=255;
                                    RGB4(1,3)=0;
                                    target=4;
                                    Screen('FillRect', window, RGB4, centeredRect4);
                                    if stimLoc<=33
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                    elseif 33<stimLoc&&stimLoc<=66
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                    elseif 66<stimLoc
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                    end
                                end
                            elseif thres<cueOrder(1,trial)
                                if targetLoc<=50
                                    RGB1(1,1)=255;
                                    RGB1(1,3)=0;
                                    target=1;
                                    Screen('FillRect', window, RGB1, centeredRect1);
                                    if stimLoc<=33
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                    elseif 33<stimLoc&&stimLoc<=66
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                    elseif 66<stimLoc
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    end
                                elseif 50<targetLoc
                                    RGB2(1,1)=255;
                                    RGB2(1,3)=0;
                                    target=2;
                                    Screen('FillRect', window, RGB2, centeredRect2);
                                    if stimLoc<=33
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                    elseif 33<stimLoc&&stimLoc<=66
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                    elseif 66<stimLoc
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    end
                                end
                            end
                        end

                        %play tone. 1/2 low tones, 1/2 high tone

                        toneNum = toneOrder(1,trial);
                        if toneNum<=numTrials*(1/2)
                            tone = 300;
                            audTar=1;
                        elseif numTrials*(1/2)<toneNum
                            tone = 600;
                            audTar=2;
                        end
                        pahandle = PsychPortAudio('Open', [], 1, 1, 48000, numChannels);
                        PsychPortAudio('Volume', pahandle, 0.5);
                        beep = MakeBeep(tone, soundDur, 48000);
                        PsychPortAudio('FillBuffer', pahandle, beep);

                        %present stimuli

                        numSecs = 1;

                        visResp=0;

                        visTStart = Screen('Flip', window);
                        PsychPortAudio('Start', pahandle, soundRep, 0, waitForDeviceStart);

                        %record visual response

                        while GetSecs<=visTStart+numSecs
                            if visResp==0
                            [keyIsDown, visTEnd, keyCode, ~] = KbCheck(keyboardIndices);
                                if keyIsDown == 1
                                    ind = find(keyCode ~=0);
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
                        
                        PsychPortAudio('Stop',pahandle,1,1);
                        PsychPortAudio('Close', pahandle);

                        %record auditory resp if dual-task, show fixation if single

                        audRespDur=1;
                        audResp=0;
                        
                        Screen('FillRect',window,grey);
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('TextSize', window, crossSize);
                        if target==visResp
                                Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                            else
                                Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                        end
                        Screen('Flip', window,[],1);

                        if thisTask==1
                            WaitSecs(audRespDur);
                        elseif thisTask==2
                            Screen('FillRect',window,grey);
                            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                            Screen('TextSize', window, crossSize);
                            if target==visResp
                                    Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                else
                                    Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                            end
                            Screen('TextSize',window,35);
                            audInst=['Low or High tone? \n' ...
                                     '(F = low, J = high)'];
                            DrawFormattedText(window,audInst,'center',yCenter+stimY(1,1),red);
                            audTStart=Screen('Flip',window,[],1);
                            while GetSecs<=audTStart+audRespDur
                                if audResp==0
                                    [keyIsDown,~,keyCode,~]=KbCheck(keyboardIndices);
                                    if keyIsDown==1
                                        ind=find(keyCode~=0);
                                        if size(ind,2)==1
                                            if ind==lowResp
                                                audResp=1;
                                            elseif ind==highResp
                                                audResp=2;
                                            end
                                        end
                                        if audTar==audResp
                                            DrawFormattedText(window,audInst,'center',yCenter+stimY(1,1),green);
                                            Screen('Flip',window);
                                        end
                                    end
                                end
                            end
                        end
                    end

                    %probe wm
                    
                    Screen('FillRect',window,grey);
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
                    WaitSecs(0.25);
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
                    Screen('FillRect',window,grey);
                end
            end
        end
    end
    
    if cond==3

        %high intf practice

        for task=1:numTask

            Screen('TextSize',window,40);
            Screen('TextFont',window,'Courier');
            ignoreTones=['Respond to the location of the \n'...
                'red circle with the E, C, I, and N keys \n'...
                '(E = upper left, I = upper right \n'...
                'C = lower left, and N = lower right) \n'...
                'and ignore the tones.'];
            respTones=['Respond to the location of the \n'...
                'red circle with the E, C, I, and N keys. \n'...
                '(E = upper left, I = upper right \n'...
                'C = lower left, and N = lower right) \n'...
                'Respond to the pitch of the tone \n'...
                'with the F and J keys. \n' ...
                '(F = low and J = high)'];

            if task==1
                DrawFormattedText(window,ignoreTones,'center','center',white);
            elseif task==2
                DrawFormattedText(window,respTones,'center','center',white);
            end

            Screen('Flip',window);
            KbStrokeWait;

            cueCondOrder=randperm(2);

            for cue=1:numCue

                if cue==1
                    cueCond=cueCondOrder(1,1);
                elseif cue==2
                    cueCond=cueCondOrder(1,2);
                end

                if cueCond==1
                    cueInst=['\n The box is more likely to give \n the location of the target. \n' ...
                        'Use this information.'];
                elseif cueCond==2
                    cueInst=['\n The box is less likely to give \n the location of the target. \n' ...
                        'Use this information.'];
                end

                for block=1:numBlocks

                    singleTaskInst = ['You are about to see a sequence of letters. \n' ...
                        'Remember these letters in order. \n \n' ... 
                        'Remember to respond to the location \n' ... 
                        'of the red circle and ignore the tones. \n \n' ...
                        sprintf('%s',cueInst) '\n \n' ... 
                        'Press space when you are ready \n' ... 
                        'to see the letters.'];
                    dualTaskInst = ['You are about to see a sequence of letters. \n'... 
                        'Remember these letters in order. \n \n'...
                        'Remember to respond to the \n' ... 
                        'location of the red circle \n' ... 
                        'and the pitch of the tone. \n'...
                        sprintf('%s',cueInst) '\n \n' ... 
                        'Press space when you are ready \n' ... 
                        'to see the letters.'];

                    Screen('TextSize', window, 30);

                    if task==1
                        DrawFormattedText(window,singleTaskInst,'center','center', white);
                        thisTask=1;
                    elseif task==2
                        DrawFormattedText(window,dualTaskInst,'center','center', white);
                        thisTask=2;
                    end

                    Screen('Flip',window);
                    KbStrokeWait
                    WaitSecs(.2)

                    %load WM

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
                    WaitSecs(2);

                    Screen('FillRect',window,grey,[]);
                    Screen('Flip',window);
                    WaitSecs(0.5);

                    toneOrder=randperm(numTrials);
                    cueOrder=randperm(numTrials);

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

                        %draw fixation cross
                        
                        Screen('FillRect',window,grey);

                        stimRect = [0 0 50 50];
                        maxDiameter = max(stimRect);

                        fixCrossDimPix = 20;
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
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('FrameRect',window,rectColor,centeredRect,1);
                        Screen('Flip', window);
                        WaitSecs(0.5);
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('TextSize', window, crossSize);
                        Screen('DrawLines',window,allCoords,lineWidthPix,white,[xCenter yCenter], 2);
                        Screen('Flip', window,[],1);
                        WaitSecs(0.25);

                        centeredRect1 = CenterRectOnPointd(stimRect, xCenter+stimX(1,1), yCenter+stimY(1,1));
                        centeredRect2 = CenterRectOnPointd(stimRect, xCenter+stimX(2,1), yCenter+stimY(2,1));
                        centeredRect3 = CenterRectOnPointd(stimRect, xCenter+stimX(1,2), yCenter+stimY(1,2));
                        centeredRect4 = CenterRectOnPointd(stimRect, xCenter+stimX(2,2), yCenter+stimY(2,2));

                        if cueCond == 1
                            thres=numTrials*valCueThres;
                        elseif cueCond==2
                            thres=numTrials*invalCueThres;
                        end

                        RGB1=[0 0 255];
                        RGB2=[0 0 255];
                        RGB3=[0 0 255];
                        RGB4=[0 0 255];

                        rng('shuffle');
                        targetLoc=randi(100);

                        rng('shuffle');
                        stimLoc=randi(100);

                        if boxLctn<=50
                            if cueOrder(1,trial)<=thres
                                if targetLoc<=50
                                    RGB1=[255 0 0];
                                    Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                    target=1;
                                    if stimLoc<=33
                                        RGB2=[255 0 0];
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    elseif 33<stimLoc&&stimLoc<=66
                                        RGB3=[255 0 0];
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    elseif 66<stimLoc
                                        RGB4=[255 0 0];
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                    end
                                elseif 50<targetLoc
                                    RGB2=[255 0 0];
                                    Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                    target=2;
                                    if stimLoc<=33
                                        RGB1=[255 0 0];
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    elseif 33<stimLoc&&stimLoc<=66
                                        RGB3=[255 0 0];
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    elseif 66<stimLoc
                                        RGB4=[255 0 0];
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                    end
                                end
                            elseif thres<cueOrder(1,trial)
                                if targetLoc<=50
                                    RGB3=[255 0 0];
                                    Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                    target=3;
                                    if stimLoc<=33
                                        RGB1=[255 0 0];
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    elseif 33<stimLoc&&stimLoc<=66
                                        RGB2=[255 0 0];
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    elseif 66<stimLoc
                                        RGB4=[255 0 0];
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                    end
                                elseif 50<targetLoc
                                    RGB4=[255 0 0];
                                    Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    target=4;
                                    if stimLoc<=33
                                        RGB1=[255 0 0];
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                    elseif 33<stimLoc&&stimLoc<=66
                                        RGB2=[255 0 0];
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                    elseif 66<stimLoc
                                        RGB3=[255 0 0];
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                    end
                                end
                            end
                        elseif 50<boxLctn
                            if cueOrder(1,trial)<=thres
                                if targetLoc<=50
                                    RGB3=[255 0 0];
                                    Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                    target=3;
                                    if stimLoc<=33
                                        RGB1=[255 0 0];
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    elseif 33<stimLoc&&stimLoc<=66
                                        RGB2=[255 0 0];
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    elseif 66<stimLoc
                                        RGB4=[255 0 0];
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                    end
                                elseif 50<targetLoc
                                    RGB4=[255 0 0];
                                    Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    target=4;
                                    if stimLoc<=33
                                        RGB1=[255 0 0];
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                    elseif 33<stimLoc&&stimLoc<=66
                                        RGB2=[255 0 0];
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                    elseif 66<stimLoc
                                        RGB3=[255 0 0];
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                    end
                                end
                            elseif thres<cueOrder(1,trial)
                                if targetLoc<=50
                                    RGB1=[255 0 0];
                                    Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                    target=1;
                                    if stimLoc<=33
                                        RGB2=[255 0 0];
                                        Screen('FillRect', window, RGB2, centeredRect2);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    elseif 33<stimLoc&&stimLoc<=66
                                        RGB3=[255 0 0];
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    elseif 66<stimLoc
                                        RGB4=[255 0 0];
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                        Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                    end
                                elseif 50<targetLoc
                                    RGB2=[255 0 0];
                                    Screen('FillOval', window, RGB2, centeredRect2, maxDiameter);
                                    target=2;
                                    if stimLoc<=33
                                        RGB1=[255 0 0];
                                        Screen('FillRect', window, RGB1, centeredRect1);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    elseif 33<stimLoc&&stimLoc<=66
                                        RGB3=[255 0 0];
                                        Screen('FillRect', window, RGB3, centeredRect3);
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillOval', window, RGB4, centeredRect4, maxDiameter);
                                    elseif 66<stimLoc
                                        RGB4=[255 0 0];
                                        Screen('FillRect', window, RGB4, centeredRect4);
                                        Screen('FillOval', window, RGB1, centeredRect1, maxDiameter);
                                        Screen('FillOval', window, RGB3, centeredRect3, maxDiameter);
                                    end
                                end
                            end
                        end

                        %play tone. 1/2 low tones, 1/2 high tone

                        toneNum = toneOrder(1,trial);
                        if toneNum<=numTrials*(1/2)
                            tone = 300;
                            audTar=1;
                        elseif numTrials*(1/2)<toneNum
                            tone = 600;
                            audTar=2;
                        end
                        pahandle = PsychPortAudio('Open', [], 1, 1, 48000, numChannels);
                        PsychPortAudio('Volume', pahandle, 0.5);
                        beep = MakeBeep(tone, soundDur, 48000);
                        PsychPortAudio('FillBuffer', pahandle, beep);

                        %present stimuli

                        numSecs = 1;

                        visResp=0;

                        visTStart = Screen('Flip', window);
                        PsychPortAudio('Start', pahandle, soundRep, 0, waitForDeviceStart);

                        %record visual response

                        while GetSecs<=visTStart+numSecs
                            if visResp==0
                            [keyIsDown, visTEnd, keyCode, ~] = KbCheck(keyboardIndices);
                                if keyIsDown == 1
                                    ind = find(keyCode ~=0);
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
                        
                        PsychPortAudio('Stop',pahandle,1,1);
                        PsychPortAudio('Close', pahandle);

                        %record auditory resp if dual-task, show fixation if single

                        audRespDur=1;
                        audResp=0;
                        
                        Screen('FillRect',window,grey);
                        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                        Screen('TextSize', window, crossSize);
                        if target==visResp
                                Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                            else
                                Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                        end
                        Screen('Flip', window,[],1);

                        if thisTask==1
                            WaitSecs(audRespDur);
                        elseif thisTask==2
                            Screen('FillRect',window,grey);
                            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                            Screen('TextSize', window, crossSize);
                            if target==visResp
                                    Screen('DrawLines',window,allCoords,lineWidthPix,green,[xCenter yCenter], 2);
                                else
                                    Screen('DrawLines',window,allCoords,lineWidthPix,red,[xCenter yCenter], 2);
                            end
                            Screen('TextSize',window,35);
                            audInst=['Low or High tone? \n' ...
                                     '(F = low, J = high)'];
                            DrawFormattedText(window,audInst,'center',yCenter+stimY(1,1),red);
                            audTStart=Screen('Flip',window,[],1);
                            while GetSecs<=audTStart+audRespDur
                                if audResp==0
                                    [keyIsDown,~,keyCode,~]=KbCheck(keyboardIndices);
                                    if keyIsDown==1
                                        ind=find(keyCode~=0);
                                        if size(ind,2)==1
                                            if ind==lowResp
                                                audResp=1;
                                            elseif ind==highResp
                                                audResp=2;
                                            end
                                        end
                                        if audTar==audResp
                                            DrawFormattedText(window,audInst,'center',yCenter+stimY(1,1),green);
                                            Screen('Flip',window);
                                        end
                                    end
                                end
                            end
                        end
                    end

                    %probe wm
                    
                    Screen('FillRect',window,grey);

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
                    WaitSecs(0.25);
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
                    Screen('FillRect',window,grey);

                end
            end
        end
    end
end

Screen('TextSize',window,50);
DrawFormattedText(window,['Any questions before \n' ... 
    'the experiment begins? \n \n' ...
    'Remember to respond as \n'...
    'quickly and accurately \n'...
    'as possible.'],'center','center',white);
Screen('Flip',window);

KbStrokeWait;
KbStrokeWait;

ListenChar(2);
ShowCursor;
sca;

return

