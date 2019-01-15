
sca;
PsychDefaultSetup(2);
InitializePsychSound(1);
ListenChar(0);
screenNumber = max(Screen('Screens'));
white = [255 255 255];
grey = white./2;
ctr = 0;
error_ctr = 0;
[window,rect] = Screen('OpenWindow',screenNumber,grey);
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
screens = Screen('Screens');
screenNumber = max(screens);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

baseRect = [0 0 100 100];
maxDiameter = max(baseRect);

centeredRect1 = CenterRectOnPointd(baseRect, xCenter+stimX(1,1), yCenter+stimY(1,1));
centeredRect2 = CenterRectOnPointd(baseRect, stimX(2,1)+xCenter, stimY(2,1)+yCenter);
centeredRect3 = CenterRectOnPointd(baseRect, stimX(1,2)+xCenter, stimY(1,2)+yCenter);
centeredRect4 = CenterRectOnPointd(baseRect, stimX(2,2)+xCenter, stimY(2,2)+yCenter);

rectColor = [1 0 0];

Screen('FillOval', window, rectColor, centeredRect1, maxDiameter);
Screen('FillRect', window, rectColor, centeredRect2);
Screen('FillRect', window, rectColor, centeredRect3);
Screen('FillRect', window, rectColor, centeredRect4);

Screen('Flip', window);

KbStrokeWait;

sca;

