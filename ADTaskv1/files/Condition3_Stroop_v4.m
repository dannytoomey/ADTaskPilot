%%tasks - working memory load/probe, visual selective attention task, and
%%auditory divided atention task

%%working memory load/probe - display array of letters at the start of
%%each block, probe by asking participants to remember as much of the array
%%in order as they can

%%selective attention task - search for incongruent stimulus in an 2x2 array of
%%distractor stimuli. respond to column of incongruent stimulus. cue the
%%column the target will appear in and manipulate validity of the cue -
%%50/75/100

%%divided attention task - participant inhibits their response to the
%%selective attention ttask when they hear a high tone. the majority of
%%presented tones will be low tones. 

%%single vs dual taks conditions - participants will complete the visual
%%task while ignoring the tones in one condition vs attending to the tones
%%(inhibiting responses when a high tone is played) in another condition
function Condition3_Stroop_v4(sjNum)

sca;
PsychDefaultSetup(2);
InitializePsychSound(1);



Screen('Preference', 'SkipSyncTests', 1);  %added for laptop delete later


ListenChar(0);
screenNumber = max(Screen('Screens'));
white = WhiteIndex(screenNumber);
grey = white/2;
black = BlackIndex(screenNumber);
[keyboardIndices, productNames, allInfos] = GetKeyboardIndices('Apple Internal Keyboard / Trackpad');
KbName('UnifyKeyNames');
escape = KbName('ESCAPE');
leftResp = KbName('f');
rightResp = KbName('j');
downResp = KbName('DownArrow');
upResp = KbName('UpArrow');
oneResp = KbName('1');
twoResp = KbName('2');
threeResp = KbName('3');
fourResp = KbName('4');
space = KbName('space');
PsychImaging('PrepareConfiguration');
[window, rect] = PsychImaging('OpenWindow',screenNumber,grey,[]);
[xCenter, yCenter] = RectCenter(rect);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
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
startCue = 0;
waitForDeviceStart = 1;
load('taskCBOrder.mat');

%%start block loop
numTasks = 2;
for task = 1:numTasks
    if stroopTaskOrder==1
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
    end
    if stroopTaskOrder==2
        if task == 2
            Screen('TextSize', window, 50);
            Screen('TextFont', window, 'Courier');
            DrawFormattedText(window, 'Respond to the location of \n the incongruently colored word \n with the F and J keys \n (F = left and J = right) \n and ignore the tones.', 'center', 'center', white);
            Screen('Flip',window);
            KbStrokeWait;
        end
        if task == 1
            Screen('TextSize', window, 50);
            Screen('TextFont', window, 'Courier');
            DrawFormattedText(window, 'Respond to the location of \n the incongeutnly colored word \n with the F and J keys \n (F = left and J = right) \n unless you hear a high tone. \n Do not respond when you \n hear a high tone.', 'center', 'center', white);
            Screen('Flip',window);
            KbStrokeWait;
        end
    end
    numCond = 3;

    for cond = 1:numCond
        %ramdomize condition order for the visual cues
        condOrder = randperm(3);
        if cond == 1
            thisCond = condOrder(1,1);
        elseif cond == 2
            thisCond = condOrder(1,2);
        elseif cond == 3
            thisCond = condOrder(1,3);
        end
        %start block loop

        numBlocks = 2;
        blockData = nan(10,numBlocks);
        numTrials = 4;
        trialData = nan(8,numTrials);
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
                %draw cue
                baseRect = [0 0 x1 2*y1];
                boxCenX = xCenter + CenX;
                centeredRect = CenterRectOnPointd(baseRect, boxCenX, yCenter);
                rectColor = [0 0 0];
                Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                Screen('FrameRect',window,rectColor,centeredRect,1);
                Screen('Flip',window);
                WaitSecs(0.5);
                Screen('FillRect',window,grey,[]);
                Screen('Flip',window);
                WaitSecs(0.5);
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
                       colorRec1 = 1;
                       colorRec2 = 0;
                       colorRec3 = 0;
                       colorRec4 = 0;
                    elseif color2 == colorTarget
                       color1 = [1 0 0];
                       color2 = [1 0 0];
                       color3 = [1 0 0];
                       color4 = [0 0 1];
                       colorRec1 = 0;
                       colorRec2 = 1;
                       colorRec3 = 0;
                       colorRec4 = 0;
                    elseif color3 == colorTarget
                       color1 = [1 0 0];
                       color2 = [0 0 1];
                       color3 = [0 0 1];
                       color4 = [0 0 1];
                       colorRec1 = 0;
                       colorRec2 = 0;
                       colorRec3 = 1;
                       colorRec4 = 0;
                    elseif color4 == colorTarget
                       color1 = [1 0 0];
                       color2 = [0 0 1];
                       color3 = [1 0 0];
                       color4 = [1 0 0];
                       colorRec1 = 0;
                       colorRec2 = 0;
                       colorRec3 = 0;
                       colorRec4 = 1;
                    end
                end
                if thisCond == 2
                    if boxLctn < 50
                        rng('shuffle');
                        textColor = randi([0,1000],1,1);
                        if textColor<=375
                           color1 = [0 0 1];       
                           color2 = [0 0 1];
                           color3 = [1 0 0];
                           color4 = [0 0 1];
                           colorRec1 = 1;
                           colorRec2 = 0;
                           colorRec3 = 0;
                           colorRec4 = 0;
                        elseif (375<textColor)&&(textColor<=750)
                           color1 = [1 0 0];
                           color2 = [0 0 1];
                           color3 = [0 0 1];
                           color4 = [0 0 1];
                           colorRec1 = 0;
                           colorRec2 = 0;
                           colorRec3 = 1;
                           colorRec4 = 0;
                        elseif (750<textColor)&&(textColor<=875)
                           color1 = [1 0 0];
                           color2 = [1 0 0];
                           color3 = [1 0 0];
                           color4 = [0 0 1];
                           colorRec1 = 0;
                           colorRec2 = 1;
                           colorRec3 = 0;
                           colorRec4 = 0;
                        elseif (875<textColor)&&(textColor<=1000)
                           color1 = [1 0 0];
                           color2 = [0 0 1];
                           color3 = [1 0 0];
                           color4 = [1 0 0];
                           colorRec1 = 0;
                           colorRec2 = 0;
                           colorRec3 = 0;
                           colorRec4 = 1;
                        end
                    elseif boxLctn >= 50
                        rng('shuffle');
                        textColor = randi([0,1000],1,1);
                        if textColor<=125
                           color1 = [0 0 1];       
                           color2 = [0 0 1];
                           color3 = [1 0 0];
                           color4 = [0 0 1];
                           colorRec1 = 1;
                           colorRec2 = 0;
                           colorRec3 = 0;
                           colorRec4 = 0;
                        elseif (125<textColor)&&(textColor<=250)
                           color1 = [1 0 0];
                           color2 = [0 0 1];
                           color3 = [0 0 1];
                           color4 = [0 0 1];
                           colorRec1 = 0;
                           colorRec2 = 0;
                           colorRec3 = 1;
                           colorRec4 = 0;
                        elseif (250<textColor)&&(textColor<=625)
                           color1 = [1 0 0];
                           color2 = [1 0 0];
                           color3 = [1 0 0];
                           color4 = [0 0 1];
                           colorRec1 = 0;
                           colorRec2 = 1;
                           colorRec3 = 0;
                           colorRec4 = 0;
                        elseif (625<textColor)&&(textColor<=1000)
                           color1 = [1 0 0];
                           color2 = [0 0 1];
                           color3 = [1 0 0];
                           color4 = [1 0 0];
                           colorRec1 = 0;
                           colorRec2 = 0;
                           colorRec3 = 0;
                           colorRec4 = 1;
                        end
                    end
                end
                if thisCond == 3
                    if boxLctn < 50
                        rng('shuffle');
                        textColor = randi([0,100],1,1);
                        if textColor < 50
                           color1 = [0 0 1];       
                           color2 = [0 0 1];
                           color3 = [1 0 0];
                           color4 = [0 0 1];
                           colorRec1 = 1;
                           colorRec2 = 0;
                           colorRec3 = 0;
                           colorRec4 = 0;
                        elseif textColor >= 50
                           color1 = [1 0 0];
                           color2 = [0 0 1];
                           color3 = [0 0 1];
                           color4 = [0 0 1];
                           colorRec1 = 0;
                           colorRec2 = 0;
                           colorRec3 = 1;
                           colorRec4 = 0;
                        end
                    elseif boxLctn >= 50
                        rng('shuffle');
                        textColor = randi([0,100],1,1);
                        if textColor < 50
                           color1 = [1 0 0];
                           color2 = [1 0 0];
                           color3 = [1 0 0];
                           color4 = [0 0 1];
                           colorRec1 = 0;
                           colorRec2 = 1;
                           colorRec3 = 0;
                           colorRec4 = 0;
                        elseif textColor >= 50
                           color1 = [1 0 0];
                           color2 = [0 0 1];
                           color3 = [1 0 0];
                           color4 = [1 0 0];
                           colorRec1 = 0;
                           colorRec2 = 0;
                           colorRec3 = 0;
                           colorRec4 = 1;
                        end
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
                rt = 0;

                Screen('Flip',window);
                PsychPortAudio('Start', pahandle, soundRep, 0, waitForDeviceStart);
                tStart = GetSecs;
                
                %record response
                for flip=1:900
                    if taskResp==0
                        [keyIsDown, secs, keyCode, delta] = KbCheck(keyboardIndices);
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
                

                trialData(1,trial) = colorRec1;
                trialData(2,trial) = colorRec2;
                trialData(3,trial) = colorRec3;
                trialData(4,trial) = colorRec4;
                trialData(5,trial) = boxCenX;
                trialData(6,trial) = tone;
                trialData(7,trial) = taskResp;
                trialData(8,trial) = rt;
                
                allStroopTrials(trial).thisTrialData = trialData; 
            end
            save('allStroopTrialsFile.mat','allStroopTrials');
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
            while numResp <= 5
                if numResp == 1
                [keyIsDown, secs, keyCode, delta] = KbCheck(keyboardIndices);
                    if keyIsDown == 1
                        ind = find(keyCode~=0);
                        if (3<ind)&&(ind<=29)
                            Screen('TextSize', window, 35);
                            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                            Screen('DrawText',window,letters(1,ind-3),xCenter - 1.5*xScale,yCenter,white);
                            Screen('Flip',window,[],1);
                            wmResp(1,numResp) = letters(1,ind-3);
                            numResp = numResp+1;
                            KbWait(keyboardIndices,1);
                        end
                    end
                end
                if numResp == 2
                [keyIsDown, secs, keyCode, delta] = KbCheck(keyboardIndices);
                    if keyIsDown == 1
                        ind = find(keyCode~=0);
                        if (3<ind)&&(ind<=29)
                            Screen('TextSize', window, 35);
                            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                            Screen('DrawText',window,letters(1,ind-3),xCenter - .75*xScale,yCenter,white);
                            Screen('Flip',window,[],1);
                            wmResp(1,numResp) = letters(1,ind-3);
                            numResp = numResp+1;
                            KbWait(keyboardIndices,1);
                        end
                    end
                end
                if numResp == 3
                [keyIsDown, secs, keyCode, delta] = KbCheck(keyboardIndices);
                    if keyIsDown == 1
                        ind = find(keyCode~=0);
                        if (3<ind)&&(ind<=29)
                            Screen('TextSize', window, 35);
                            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                            Screen('DrawText',window,letters(1,ind-3),xCenter,yCenter,white);
                            Screen('Flip',window,[],1);
                            wmResp(1,numResp) = letters(1,ind-3);
                            numResp = numResp+1;
                            KbWait(keyboardIndices,1);
                        end
                    end
                end
                if numResp == 4
                [keyIsDown, secs, keyCode, delta] = KbCheck(keyboardIndices);
                    if keyIsDown == 1
                        ind = find(keyCode~=0);
                        if (3<ind)&&(ind<=29)
                            Screen('TextSize', window, 35);
                            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                            Screen('DrawText',window,letters(1,ind-3),xCenter + .75*xScale,yCenter,white);
                            Screen('Flip',window,[],1);
                            wmResp(1,numResp) = letters(1,ind-3);
                            numResp = numResp+1;
                            KbWait(keyboardIndices,1);
                        end
                    end
                end
                if numResp == 5
                [keyIsDown, secs, keyCode, delta] = KbCheck(keyboardIndices);
                    if keyIsDown == 1
                        ind = find(keyCode~=0);
                        if (3<ind)&&(ind<=29)
                            Screen('TextSize', window, 35);
                            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                            Screen('DrawText',window,letters(1,ind-3),xCenter + 1.5*xScale,yCenter,white);
                            Screen('Flip',window,[],1);
                            wmResp(1,numResp) = letters(1,ind-3);
                            numResp = numResp+1;
                            KbWait(keyboardIndices,1);
                        end
                    end
                end        
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

            allStroopBlock(block).thisBlockTrials = allStroopTrials;
            allStroopBlock(block).thisblockWM = blockData;
            Screen('FillRect',window,grey);
            save('allStroopBlockFile.mat','allStroopBlock');
            

        end

        allStroopCond(cond).thisCondData = allStroopBlock;
        save('allStroopCondFile.mat','allStroopCond');

    end
    
    allStroopTask(task).thisTaskData = allStroopCond;
    save([filePath '/' sprintf('sj%02d_allStroopTaskFile.mat',sjNum)],'allStroopTask');
    
    
end
ListenChar(2);
KbStrokeWait;
sca

return
