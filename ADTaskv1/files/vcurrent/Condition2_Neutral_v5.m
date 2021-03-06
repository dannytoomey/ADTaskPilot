%%tasks - working memory load/probe, visual selective attention task, and
%%auditory divided atention task

%%working memory load/probe - display array of letters at the start of
%%each block, probe by asking participants to remember as much of the array
%%in order as they can

%%selective attention task - search for incongruent stimulus in an 2x2 array of
%%distractor stimuli. respond to column of incongruent stimulus. cue the
%%column the target will appear in and manipulate validity of the cue -
%%50/100%

%%divided attention task - participant inhibits their response to the
%%selective attention ttask when they hear a high tone. the majority of
%%presented tones will be low tones. 

%%single vs dual taks conditions - participants will complete the visual
%%task while ignoring the tones in one condition vs attending to the tones
%%(inhibiting responses when a high tone is played) in another condition

function Condition2_Neutral_v5(sjNum)

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
arrayX = x - x1/2;
arrayY = y - y1/2;
yScale = arrayY(1,2);
xScale = arrayX(1,2);
numChannels = 1;
soundRep = 1;
soundDur = 0.25;
waitForDeviceStart = 1;
load('taskCBOrder.mat');

numTasks = 2;
numBlocks = 8;
numTrials = 8;

%%start block loop

for task = 1:numTasks
    if neutralTaskOrder==1
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
    end
    if neutralTaskOrder==2
        if task == 2
            Screen('TextSize', window, 50);
            Screen('TextFont', window, 'Courier');
            DrawFormattedText(window, 'Respond to the location of \n the red word with \n the F and J keys \n (F = left and J = right) \n and ignore the tones.', 'center', 'center', white);
            Screen('Flip',window);
            KbStrokeWait;
        end
        if task == 1
            Screen('TextSize', window, 50);
            Screen('TextFont', window, 'Courier');
            DrawFormattedText(window, 'Respond to the location of \n the red word with \n the F and J keys \n (F = left and J = right) \n unless you hear a high tone. \n Do not respond when you \n hear a high tone.', 'center', 'center', white);
            Screen('Flip',window);
            KbStrokeWait;
        end
    end
    
    numCueCond = 2;

    for cond = 1:numCueCond
        
        %ramdomize condition order for the visual cues
        
        condOrder = randperm(2);
        if cond == 1
            thisCueCond = condOrder(1,1);
        elseif cond == 2
            thisCueCond = condOrder(1,2);
        end
        
        %start block loop

        blockData = nan(10,numBlocks);
        trialData = nan(8,numTrials);
        
        for block = 1:numBlocks

            %present WM load
            
            ignoreTones = 'You are about to see a sequence of letters. \n Remember these letters in order. \n Press space when you are ready \n to see the letters.\n Ignore the tones.';
            respTones = 'You are about to see a sequence of letters. \n Remember these letters in order. \n Press space when you are ready \n to see the letters.\n Do not respond when you \n hear a high tone.';
            Screen('TextSize', window, 30);
            if neutralTaskOrder==1
                if task==1
                    DrawFormattedText(window,ignoreTones,'center','center', white);
                elseif task==2
                    DrawFormattedText(window,respTones,'center','center', white);
                end
            end
            if neutralTaskOrder==2
                if task==2
                    DrawFormattedText(window,ignoreTones,'center','center', white);
                elseif task==1
                    DrawFormattedText(window,respTones,'center','center', white);
                end
            end
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
                WaitSecs(0.5);
                
                %assign different cue validities to different conditions and draw the visual array
                %50/100
                
                If = 'If';
                then = 'Then';
                and = 'And';
                or = 'Or';
                rng('shuffle');
                stimOrder=randi([1,100],1,1);
                if stimOrder<=25
                    line1=If;
                    line2=then;
                    line3=and;
                    line4=or;
                elseif (25<stimOrder)&&(stimOrder<=50)
                    line2=If;
                    line3=then;
                    line4=and;
                    line1=or;
                elseif (50<stimOrder)&&(stimOrder<=75)
                    line3=If;
                    line4=then;
                    line1=and;
                    line2=or;
                elseif 75<stimOrder
                    line4=If;
                    line1=then;
                    line2=and;
                    line3=or;
                end
                RGB1=[0 0 1];
                RGB2=[0 0 1];
                RGB3=[0 0 1];
                RGB4=[0 0 1];
                rng('shuffle')
                num=randi([0,100],1,1);
                if thisCueCond == 1
                    if num<=25
                        RGB1(1,1)=1;
                        RGB1(1,3)=0;
                    elseif (25<num)&&(num<=50)
                        RGB2(1,1)=1;
                        RGB2(1,3)=0;
                    elseif (50<num)&&(num<=75)
                        RGB3(1,1)=1;
                        RGB3(1,3)=0;
                    elseif 75<num
                        RGB4(1,1)=1;
                        RGB4(1,3)=0;
                    end
                end
                if thisCueCond==2
                    if boxLctn<=50
                        if num<=50
                            RGB1(1,1)=1;
                            RGB1(1,3)=0;
                        elseif 50<num
                            RGB2(1,1)=1;
                            RGB2(1,3)=0;
                        end
                    elseif 50<boxLctn
                        if num<=50
                            RGB3(1,1)=1;
                            RGB3(1,3)=0;
                        elseif 50<num
                            RGB4(1,1)=1;
                            RGB4(1,3)=0;
                        end
                    end
                end
                
                color1=RGB1(1,1);
                color2=RGB2(1,1);
                color3=RGB3(1,1);
                color4=RGB4(1,1);
                
                Screen('TextSize', window, 35);
                Screen('DrawText',window,line1,xCenter-1.5*xScale,yCenter+yScale,RGB1);
                Screen('DrawText',window,line3,xCenter+.75*xScale,yCenter+yScale,RGB3);
                Screen('DrawText',window,line2,xCenter-1.5*xScale,yCenter-yScale,RGB2);
                Screen('DrawText',window,line4,xCenter+.75*xScale,yCenter-yScale,RGB4);        
        
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
                
                flipInt=Screen('GetFlipInterval',window);
                numflips=0;
                taskResp = 0;
                
                Screen('Flip',window)
                PsychPortAudio('Start', pahandle, soundRep, 0, waitForDeviceStart);
                tStart=GetSecs;
                
                %record response 
                
                while numflips<=15.7/flipInt
                    if taskResp==0
                    [keyIsDown, tEnd, keyCode, ~] = KbCheck(keyboardIndices);
                        if keyIsDown == 1
                            ind = find(keyCode ~=0);
                            if ind == leftResp
                                taskResp = 1;
                            elseif ind == rightResp
                                taskResp = 2;
                            end
                        end
                    end
                    numflips=numflips+1;
                end
                if tEnd==0
                    tEnd=GetSecs;
                end
                
                rt = tEnd - tStart;
                WaitSecs(1-rt);
                
                Screen('FillRect',window,grey);
                PsychPortAudio('Stop',pahandle,1,1);
                PsychPortAudio('Close', pahandle);
                
                trialData(1,trial) = color1;
                trialData(2,trial) = color2;
                trialData(3,trial) = color3;
                trialData(4,trial) = color4;
                trialData(5,trial) = boxCenX;
                trialData(6,trial) = tone;
                trialData(7,trial) = taskResp;
                trialData(8,trial) = rt;
                
                allNeutralTrials(trial).thisTrialData = trialData; 
                
            end
            
            save('allNeutralTrialsFile.mat','allNeutralTrials');
            
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
            
            blockData(1,block) = letters(1,LT1);
            blockData(2,block) = letters(1,LT2);
            blockData(3,block) = letters(1,LT3);
            blockData(4,block) = letters(1,LT4);
            blockData(5,block) = letters(1,LT5);
            blockData(6,block) = wmResp(1,1);
            blockData(7,block) = wmResp(1,2);
            blockData(8,block) = wmResp(1,3);
            blockData(9,block) = wmResp(1,4);
            blockData(10,block) = wmResp(1,5);

            allNeutralBlock(block).thisBlockTrials = allNeutralTrials;
            allNeutralBlock(block).thisblockWM = blockData;
            Screen('FillRect',window,grey);
            save('allNeutralBlockFile.mat','allNeutralBlock');

        end

        allNeutralCond(cond).thisCondData = allNeutralBlock;
        save('allNeutralCondFile.mat','allNeutralCond');

    end
    
    allNeutralTask(task).thisTaskData = allNeutralCond;
    save([filePath '/' sprintf('sj%02d_allNeutralTaskFile.mat',sjNum)],'allNeutralTask');
    
end

ListenChar(2);
KbStrokeWait;
sca

return
