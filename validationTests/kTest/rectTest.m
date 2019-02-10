
screen=max(Screen('Screens'));
[win,~]=Screen(screen,'OpenWindow',[0 0 0]);
text=['a a a a'];
Screen('TextSize',win,20);
[rect]=Screen('TextBounds',win,text);
sca
rect

%rect(3) = width of x pixels, rect(4) = width of y pixels