
%practice 

%4 trials X 2 WM blocks X 2 task (single/dual) X 3 visual stimulus conditions

function Condition0_Practice(sjNum)

sca;
PsychDefaultSetup(2);
InitializePsychSound(1);

Screen('Preference', 'SkipSyncTests', 1);  %added for laptop delete later


ListenChar(0);
screenNumber = max(Screen('Screens'));
white = WhiteIndex(screenNumber);
grey = white/2;
[keyboardIndices, ~, ~] = GetKeyboardIndices('Apple Internal Keyboard / Trackpad');
KbName('UnifyKeyNames');
leftResp = KbName('f');
rightResp = KbName('j');
PsychImaging('PrepareConfiguration');
[window, rect] = PsychImaging('OpenWindow',screenNumber,grey,[]);
[xCenter, yCenter] = RectCenter(rect);
[~, screenYpixels] = Screen('WindowSize', window);
dim = 1;
[x, y] = meshgrid(dim-1:dim, dim-1:dim);
pixelScale = screenYpixels / (dim*2+2);
x = x .*pixelScale;
y = y .*pixelScale;
x1 = x(1,2);
y1 = y(2,1);
dotX = x - x1/2;
dotY = y - y1/2;
numDots = numel(dotX);
dotPositionMatrix = [reshape(dotX, 1, numDots); reshape(dotY, 1, numDots)];
dotCenter = [xCenter,yCenter];
arrayX = x - x1/2;
arrayY = y - y1/2;
yScale = arrayY(1,2);
xScale = arrayX(1,2);

numChannels = 1;
soundRep = 1;
soundDur = 0.25;
waitForDeviceStart = 1;

numBlocks = 2;
numTrials = 4;
numTasks = 2;

for task = 1:numTasks
    if task == 1
        Screen('TextSize', window, 50);
        Screen('TextFont', window, 'Courier');
        DrawFormattedText(window, 'Respond to the location of \n the black dot with \n the F and J keys \n (F = left and J = right) \n and ignore the tones.', 'center', 'center', white);
        Screen('Flip',window);
        KbStrokeWait;
    end
    if task == 2
        Screen('TextSize', window, 50);
        Screen('TextFont', window, 'Courier');
        DrawFormattedText(window, 'Respond to the location of \n the black dot with \n the F and J keys \n (F = left and J = right) \n unless you hear a high tone. \n Do not respond when you \n hear a high tone.', 'center', 'center', white);
        Screen('Flip',window);
        KbStrokeWait;
    end
    
    thisCond=1;

    %start block loop

    for block = 1:numBlocks

        %present WM load
        Screen('TextSize', window, 30);
        DrawFormattedText(window, 'You are about to see a sequence of letters. \n Remember these letters in order. \n Press space when you are ready \n to see the letters.', 'center','center', white);
        Screen('Flip',window);
        KbStrokeWait
        WaitSecs(.2)
        letters = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'];
        rng('shuffle');
        LTs = randperm(26,5);
        LT1 = LTs(1,1);
        LT2 = LTs(1,2);
        LT3 = LTs(1,3);
        LT4 = LTs(1,4);
        LT5 = LTs(1,5);
        letter1 = letters(1,LT1);
        letter2 = letters(1,LT2);
        letter3 = letters(1,LT3);
        letter4 = letters(1,LT4);
        letter5 = letters(1,LT5);
        Screen('TextSize', window, 35);
        Screen('DrawText',window,letter1,xCenter - 1.5*xScale,yCenter,white);
        Screen('DrawText',window,letter2,xCenter - .75*xScale,yCenter,white);
        Screen('DrawText',window,letter3,xCenter,yCenter,white);
        Screen('DrawText',window,letter4,xCenter + .75*xScale,yCenter,white);
        Screen('DrawText',window,letter5,xCenter + 1.5*xScale,yCenter,white);
        Screen('Flip',window);
        WaitSecs(3);
        Screen('FillRect',window,grey,[]);
        Screen('Flip',window);
        WaitSecs(0.5);

        for trial = 1:numTrials
            %assign cue location
            rng('shuffle');
            boxLctn = randi([0,100]);
            xLctn = max(dotX);
            if boxLctn < 50
                CenX = min(xLctn);
            elseif boxLctn >= 50
                CenX = max(xLctn);
            end
            %draw fixation cross and cue
            fixCrossDimPix = 20;
            xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
            yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
            allCoords = [xCoords; yCoords];
            lineWidthPix = 2;
            crossSize=18;
            baseRect = [0 0 x1 2*y1];
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
            %assign different cue validities to different conditions and draw the visual array
            %50%
            if thisCond == 1
                rng('shuffle');
                dotLctn = randi([0,100],1,1);
                if dotLctn<=25
                   dot1 = 0;
                   dot2 = 1;
                   dot3 = 1;
                   dot4 = 1;
                elseif (25<dotLctn)&&(dotLctn<=50)
                   dot1 = 1;
                   dot2 = 0;
                   dot3 = 1;
                   dot4 = 1;
                elseif (50<dotLctn)&&(dotLctn<=75)
                   dot1 = 1;
                   dot2 = 1;
                   dot3 = 0;
                   dot4 = 1;
                elseif (75<dotLctn)&&(dotLctn<=100)
                   dot1 = 1;
                   dot2 = 1;
                   dot3 = 1;
                   dot4 = 0;
                end
            end
            
            dotColors = [dot1,dot2,dot3,dot4;dot1,dot2,dot3,dot4;dot1,dot2,dot3,dot4];
            dotSizes = 100;   
            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            Screen('DrawDots',window,dotPositionMatrix,dotSizes,dotColors,dotCenter,1);
            %play tone. 80% low tone, 20% high tone
            rng('shuffle');
            toneNum = randi([0,100],1,1);
            if toneNum < 80
                tone = 300;
            elseif toneNum >= 80
                tone = 600;
            end
            pahandle = PsychPortAudio('Open', [], 1, 1, 48000, numChannels);
            PsychPortAudio('Volume', pahandle, 0.5);
            beep = MakeBeep(tone, soundDur, 48000);
            PsychPortAudio('FillBuffer', pahandle, beep);

            %present stimuli
            taskResp = 0;
            
            Screen('Flip',window);
            PsychPortAudio('Start', pahandle, soundRep, 0, waitForDeviceStart);
            tStart = GetSecs;

            %record response
            for flip=1:900
                if taskResp==0
                    [keyIsDown, ~, keyCode, ~] = KbCheck(keyboardIndices);
                    if keyIsDown == 1
                        ind = find(keyCode ~=0);
                        if ind == leftResp
                            taskResp = 1;
                        elseif ind == rightResp
                            taskResp = 2;
                        end
                    end
                end
                tEnd = GetSecs;
            end
            rt = tEnd - tStart;
            WaitSecs(1-rt);

            PsychPortAudio('Stop',pahandle,1,1);
            PsychPortAudio('Close', pahandle);
            
            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            Screen('TextSize', window, crossSize);
            Screen('DrawLines',window,allCoords,lineWidthPix,white,[xCenter yCenter], 2);
            Screen('Flip', window);
            WaitSecs(0.25);


        end

        %probe wm
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
        wmResp = zeros(1,5);
        numResp = 1;
        loc=[xCenter - 1.5*xScale,xCenter - .75*xScale,xCenter,xCenter + .75*xScale,xCenter + 1.5*xScale];
        while numResp <= 5
        thisLoc = loc(1,numResp);
        RestrictKeysForKbCheck([3:29]);
        [keyIsDown, ~, keyCode, ~] = KbCheck(keyboardIndices);
            if keyIsDown == 1
                ind = find(keyCode);
                Screen('TextSize', window, 35);
                Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                Screen('DrawText',window,letters(1,ind-3),thisLoc,yCenter,white);
                Screen('Flip',window,[],1);
                wmResp(1,numResp) = letters(1,ind-3);
                numResp = numResp+1;
                KbWait(keyboardIndices,1);
            end
        RestrictKeysForKbCheck([]);
        end
            
        KbStrokeWait;

        Screen('FillRect',window,grey);

    end

end

for task = 1:numTasks
    if task == 1
        Screen('TextSize', window, 50);
        Screen('TextFont', window, 'Courier');
        DrawFormattedText(window, 'Respond to the location of \n the red word with \n the F and J keys \n (F = left and J = right) \n and ignore the tones.', 'center', 'center', white);
        Screen('Flip',window);
        KbStrokeWait;
    end
    if task == 2
        Screen('TextSize', window, 50);
        Screen('TextFont', window, 'Courier');
        DrawFormattedText(window, 'Respond to the location of \n the red word with \n the F and J keys \n (F = left and J = right) \n unless you hear a high tone. \n Do not respond when you \n hear a high tone.', 'center', 'center', white);
        Screen('Flip',window);
        KbStrokeWait;
    end
    
    thisCond = 1;

    %start block loop

    for block = 1:numBlocks

        %present WM load
        Screen('TextSize', window, 30);
        DrawFormattedText(window, 'You are about to see a sequence of letters. \n Remember these letters in order. \n Press space when you are ready \n to see the letters.', 'center','center', white);
        Screen('Flip',window);
        KbStrokeWait
        WaitSecs(.2)
        letters = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'];
        rng('shuffle');
        LTs = randperm(26,5);
        LT1 = LTs(1,1);
        LT2 = LTs(1,2);
        LT3 = LTs(1,3);
        LT4 = LTs(1,4);
        LT5 = LTs(1,5);
        letter1 = letters(1,LT1);
        letter2 = letters(1,LT2);
        letter3 = letters(1,LT3);
        letter4 = letters(1,LT4);
        letter5 = letters(1,LT5);
        Screen('TextSize', window, 35);
        Screen('DrawText',window,letter1,xCenter - 1.5*xScale,yCenter,white);
        Screen('DrawText',window,letter2,xCenter - .75*xScale,yCenter,white);
        Screen('DrawText',window,letter3,xCenter,yCenter,white);
        Screen('DrawText',window,letter4,xCenter + .75*xScale,yCenter,white);
        Screen('DrawText',window,letter5,xCenter + 1.5*xScale,yCenter,white);
        Screen('Flip',window);
        WaitSecs(3);
        Screen('FillRect',window,grey,[]);
        Screen('Flip',window);
        WaitSecs(0.5);

        for trial = 1:numTrials
            %assign cue location
            rng('shuffle');
            boxLctn = randi([0,100]);
            xLctn = max(arrayX);
            if boxLctn < 50
                CenX = min(xLctn);
            elseif boxLctn >= 50
                CenX = max(xLctn);
            end
            %draw fixation cross and cue
            fixCrossDimPix = 20;
            xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
            yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
            allCoords = [xCoords; yCoords];
            lineWidthPix = 2;
            crossSize=18;
            baseRect = [0 0 x1 2*y1];
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
            %assign different cue validities to different conditions and draw the visual array
            %50%
            line1 = 'If';
            line2 = 'Then';
            line3 = 'And';
            line4 = 'Or';
            if thisCond == 1
                rng('shuffle')
                textColor=randi([0,100],1,4);
                color1=textColor(1,1);
                color2=textColor(1,2);
                color3=textColor(1,3);
                color4=textColor(1,4);
                colorTarget=min(textColor);
                if color1 == colorTarget
                   color1 = [1 0 0];       
                   color2 = [0 0 1];
                   color3 = [0 0 1];
                   color4 = [0 0 1];
                elseif color2 == colorTarget
                   color1 = [0 0 1];
                   color2 = [1 0 0];
                   color3 = [0 0 1];
                   color4 = [0 0 1];
                elseif color3 == colorTarget
                   color1 = [0 0 1];
                   color2 = [0 0 1];
                   color3 = [1 0 0];
                   color4 = [0 0 1];
                elseif color4 == colorTarget
                   color1 = [0 0 1];
                   color2 = [0 0 1];
                   color3 = [0 0 1];
                   color4 = [1 0 0];
                end
            end
            
            Screen('TextSize', window, 35);
            Screen('DrawText',window,line1,xCenter - 1.5*xScale,yCenter + yScale,color1);
            Screen('DrawText',window,line2,xCenter + .5*xScale,yCenter + yScale,color2);
            Screen('DrawText',window,line3,xCenter - 1.5*xScale,yCenter - yScale,color3);
            Screen('DrawText',window,line4,xCenter + .5*xScale,yCenter - yScale,color4);        

            %play tone. 80% low tone, 20% high tone
            rng('shuffle');
            toneNum = randi([0,100],1,1);
            if toneNum < 80
                tone = 300;
            elseif toneNum >= 80
                tone = 600;
            end
            pahandle = PsychPortAudio('Open', [], 1, 1, 48000, numChannels);
            PsychPortAudio('Volume', pahandle, 0.5);
            beep = MakeBeep(tone, soundDur, 48000);
            PsychPortAudio('FillBuffer', pahandle, beep);

            %present stimuli
            taskResp = 0;

            Screen('Flip',window);
            PsychPortAudio('Start', pahandle, soundRep, 0, waitForDeviceStart);
            tStart = GetSecs;

            %record response
            for flip=1:900
                if taskResp==0
                    [keyIsDown, ~, keyCode, ~] = KbCheck(keyboardIndices);
                    if keyIsDown == 1
                        ind = find(keyCode ~=0);
                        if ind == leftResp
                            taskResp = 1;
                        elseif ind == rightResp
                            taskResp = 2;
                        end
                    end
                end
                tEnd = GetSecs;
            end
            rt = tEnd - tStart;
            WaitSecs(1-rt);

            PsychPortAudio('Stop',pahandle,1,1);
            PsychPortAudio('Close', pahandle);
            
            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            Screen('TextSize', window, crossSize);
            Screen('DrawLines',window,allCoords,lineWidthPix,white,[xCenter yCenter], 2);
            Screen('Flip', window);
            WaitSecs(0.25);
 
        end
        
        %probe wm
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
        wmResp = zeros(1,5);
        numResp = 1;
        loc=[xCenter - 1.5*xScale,xCenter - .75*xScale,xCenter,xCenter + .75*xScale,xCenter + 1.5*xScale];
        while numResp <= 5
        thisLoc = loc(1,numResp);
        RestrictKeysForKbCheck([3:29]);
        [keyIsDown, ~, keyCode, ~] = KbCheck(keyboardIndices);
            if keyIsDown == 1
                ind = find(keyCode);
                Screen('TextSize', window, 35);
                Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                Screen('DrawText',window,letters(1,ind-3),thisLoc,yCenter,white);
                Screen('Flip',window,[],1);
                wmResp(1,numResp) = letters(1,ind-3);
                numResp = numResp+1;
                KbWait(keyboardIndices,1);
            end
        RestrictKeysForKbCheck([]);
        end
        
        KbStrokeWait;

        Screen('FillRect',window,grey);
        
    end

end

for task = 1:numTasks
    if task == 1
        Screen('TextSize', window, 50);
        Screen('TextFont', window, 'Courier');
        DrawFormattedText(window, 'Respond to the location of \n the incongruently colored word \n with the F and J keys \n (F = left and J = right) \n and ignore the tones.', 'center', 'center', white);
        Screen('Flip',window);
        KbStrokeWait;
    end
    if task == 2
        Screen('TextSize', window, 50);
        Screen('TextFont', window, 'Courier');
        DrawFormattedText(window, 'Respond to the location of \n the incongruently colored word \n with the F and J keys \n (F = left and J = right) \n unless you hear a high tone. \n Do not respond when you \n hear a high tone.', 'center', 'center', white);
        Screen('Flip',window);
        KbStrokeWait;
    end
    
    thisCond = 1;

    %start block loop

    for block = 1:numBlocks

        %present WM load
        Screen('TextSize', window, 30);
        DrawFormattedText(window, 'You are about to see a sequence of letters. \n Remember these letters in order. \n Press space when you are ready \n to see the letters.', 'center','center', white);
        Screen('Flip',window);
        KbStrokeWait
        WaitSecs(.2)
        letters = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'];
        rng('shuffle');
        LTs = randperm(26,5);
        LT1 = LTs(1,1);
        LT2 = LTs(1,2);
        LT3 = LTs(1,3);
        LT4 = LTs(1,4);
        LT5 = LTs(1,5);
        letter1 = letters(1,LT1);
        letter2 = letters(1,LT2);
        letter3 = letters(1,LT3);
        letter4 = letters(1,LT4);
        letter5 = letters(1,LT5);
        Screen('TextSize', window, 35);
        Screen('DrawText',window,letter1,xCenter - 1.5*xScale,yCenter,white);
        Screen('DrawText',window,letter2,xCenter - .75*xScale,yCenter,white);
        Screen('DrawText',window,letter3,xCenter,yCenter,white);
        Screen('DrawText',window,letter4,xCenter + .75*xScale,yCenter,white);
        Screen('DrawText',window,letter5,xCenter + 1.5*xScale,yCenter,white);
        Screen('Flip',window);
        WaitSecs(3);
        Screen('FillRect',window,grey,[]);
        Screen('Flip',window);
        WaitSecs(0.5);

        for trial = 1:numTrials
            %assign cue location
            rng('shuffle');
            boxLctn = randi([0,100]);
            xLctn = max(arrayX);
            if boxLctn < 50
                CenX = min(xLctn);
            elseif boxLctn >= 50
                CenX = max(xLctn);
            end
            %draw fixation cross and cue
            fixCrossDimPix = 20;
            xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
            yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
            allCoords = [xCoords; yCoords];
            lineWidthPix = 2;
            crossSize=18;
            baseRect = [0 0 x1 2*y1];
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
            %assign different cue validities to different conditions and draw the visual array
            %50/75/100
            line1 = 'Red';
            line2 = 'Blue';
            line3 = 'Red';
            line4 = 'Blue';
            if thisCond == 1
                rng('shuffle')
                textColor=randi([0,100],1,4);
                color1=textColor(1,1);
                color2=textColor(1,2);
                color3=textColor(1,3);
                color4=textColor(1,4);
                colorTarget=min(textColor);
                %colorRec = incongruent stim = 1
                if color1 == colorTarget
                   color1 = [0 0 1];       
                   color2 = [0 0 1];
                   color3 = [1 0 0];
                   color4 = [0 0 1];
                elseif color2 == colorTarget
                   color1 = [1 0 0];
                   color2 = [1 0 0];
                   color3 = [1 0 0];
                   color4 = [0 0 1];
                elseif color3 == colorTarget
                   color1 = [1 0 0];
                   color2 = [0 0 1];
                   color3 = [0 0 1];
                   color4 = [0 0 1];
                elseif color4 == colorTarget
                   color1 = [1 0 0];
                   color2 = [0 0 1];
                   color3 = [1 0 0];
                   color4 = [1 0 0];
                end
            end
            
            Screen('TextSize', window, 35);
            Screen('DrawText',window,line1,xCenter - 1.5*xScale,yCenter + yScale,color1);
            Screen('DrawText',window,line2,xCenter + .5*xScale,yCenter + yScale,color2);
            Screen('DrawText',window,line3,xCenter - 1.5*xScale,yCenter - yScale,color3);
            Screen('DrawText',window,line4,xCenter + .5*xScale,yCenter - yScale,color4);        

            %play tone. 80% low tone, 20% high tone
            rng('shuffle');
            toneNum = randi([0,100],1,1);
            if toneNum < 80
                tone = 300;
            elseif toneNum >= 80
                tone = 600;
            end
            pahandle = PsychPortAudio('Open', [], 1, 1, 48000, numChannels);
            PsychPortAudio('Volume', pahandle, 0.5);
            beep = MakeBeep(tone, soundDur, 48000);
            PsychPortAudio('FillBuffer', pahandle, beep);

            %present stimuli
            taskResp = 0;
            
            Screen('Flip',window);
            PsychPortAudio('Start', pahandle, soundRep, 0, waitForDeviceStart);
            tStart = GetSecs;

            %record response
            for flip=1:900
                if taskResp==0
                    [keyIsDown, ~, keyCode, ~] = KbCheck(keyboardIndices);
                    if keyIsDown == 1
                        ind = find(keyCode ~=0);
                        if ind == leftResp
                            taskResp = 1;
                        elseif ind == rightResp
                            taskResp = 2;
                        end
                    end
                end
                tEnd = GetSecs;
            end
            
            rt = tEnd - tStart;
            WaitSecs(1-rt);

            PsychPortAudio('Stop',pahandle,1,1);
            PsychPortAudio('Close', pahandle);
            
            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            Screen('TextSize', window, crossSize);
            Screen('DrawLines',window,allCoords,lineWidthPix,white,[xCenter yCenter], 2);
            Screen('Flip', window);
            WaitSecs(0.25);
 
        end
        %probe wm
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
        wmResp = zeros(1,5);
        numResp = 1;
        loc=[xCenter - 1.5*xScale,xCenter - .75*xScale,xCenter,xCenter + .75*xScale,xCenter + 1.5*xScale];
        while numResp <= 5
        thisLoc = loc(1,numResp);
        RestrictKeysForKbCheck([3:29]);
        [keyIsDown, ~, keyCode, ~] = KbCheck(keyboardIndices);
            if keyIsDown == 1
                ind = find(keyCode);
                Screen('TextSize', window, 35);
                Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                Screen('DrawText',window,letters(1,ind-3),thisLoc,yCenter,white);
                Screen('Flip',window,[],1);
                wmResp(1,numResp) = letters(1,ind-3);
                numResp = numResp+1;
                KbWait(keyboardIndices,1);
            end
        RestrictKeysForKbCheck([]);
        end
        
        KbStrokeWait;

        Screen('FillRect',window,grey);
        
    end

end

Screen('TextSize', window, 50);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, 'Any questions before you \n begin the experiment? \n Please wait for the \n administrator''s cue to start', 'center', 'center', white);
Screen('Flip',window);
KbStrokeWait;

ListenChar(2);
KbStrokeWait;
sca

return
