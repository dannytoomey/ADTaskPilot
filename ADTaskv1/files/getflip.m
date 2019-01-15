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
flipInt=Screen('GetFlipInterval',window);
counts=zeros(1,100);
tStart=GetSecs;
numflips=0;
for flip=1:1/flipInt
    Screen('FillRect',window,grey);
    Screen('Flip',window);
end
tEnd=GetSecs;
time1=tEnd-tStart;
test=1-time1;

tStart=GetSecs;

while numflips<=(1/flipInt+1/test)
    if numflips<40
        Screen('FillRect',window,white);
        Screen('Flip',window)
    elseif numflips>=40
        Screen('FillRect',window,grey);
        Screen('Flip',window);
    end
    numflips=numflips+1;
end

tEnd=GetSecs;
time2=tEnd-tStart;
sca;
