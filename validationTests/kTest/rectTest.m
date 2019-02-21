
screen=max(Screen('Screens'));
[win,~]=Screen(screen,'OpenWindow',[0 0 0]);
text=['a a a a'];
Screen('TextSize',win,20);
[rect]=Screen('TextBounds',win,text);
fr=FrameRate(win);
sca
rect
fr
function drawFixation(thisWin)
Screen('TextSize',thisWin,24);
Screen('TextFont',thisWin,'Arial');
fix='+';
[fixBounds]=Screen('TextBounds',thisWin,'+');
xFix=centerX-round(fixBounds(3)/2);
yFix=centerY-round(fixBounds(4)/2);
Screen('DrawText',thisWin,fix,xFix,yFix,black);
return

%rect(3) = width of x pixels, rect(4) = width of y pixels