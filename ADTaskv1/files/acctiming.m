
sca;
close all;
clearvars;
Screen('Preference', 'SkipSyncTests', 1);
PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = max(screens);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
ifi = Screen('GetFlipInterval', window);
topPriorityLevel = MaxPriority(window);
numSecs = 1;
numFrames = round(numSecs / ifi);
vbl = Screen('Flip', window);
Priority(topPriorityLevel);
tStart=GetSecs;
for trial=1:30
    for frame = 1:numFrames

        Screen('FillRect', window, grey);
        vbl = Screen('Flip', window, vbl * ifi);

    end
end
tEnd=GetSecs;
stim=(tEnd-tStart)/30;

Priority(topPriorityLevel);
vbl = Screen('Flip', window);
tStart=GetSecs;
for trial=1:60
    for frame = 1:numFrames

        Screen('FillRect', window, grey);
        vbl = Screen('Flip', window, vbl * ifi);

    end
end
tEnd=GetSecs;
stim2=(tEnd-tStart)/60;

Priority(topPriorityLevel);
vbl = Screen('Flip', window);
tStart=GetSecs;
for trial=1:90
    for frame = 1:numFrames

        Screen('FillRect', window, grey);
        vbl = Screen('Flip', window, vbl * ifi);

    end
end
tEnd=GetSecs;
stim3=(tEnd-tStart)/90;

sca;

