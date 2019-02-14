
function miscTests

screen=max(Screen('Screens'));
[win,rect]=Screen(screen,'OpenWindow',[0 0 0]);
[centerX, centerY] = RectCenter(rect);
text='a a a a';
Screen('TextSize',win,20);
[rect]=Screen('TextBounds',win,text);
fr=FrameRate(win);
wins=zeros(1,5);
for i=1:size(wins,2)
    wins(1,i)=Screen('OpenOffScreenWindow',win,[0 0 0]);
end
line1='flip=1;';
line2='while flip<=size(wins,2);';
line3='if flip==1;';
    line4='drawFixation(wins(1,flip),centerX,centerY);';
    line5='drawCue(wins(1,flip),-50,centerX,centerY);';
    line6='Screen(''CopyWindow'',wins(1,flip),win);';
    line7='Screen(''Flip'',win);';
    line8='elseif flip==2;';
    line9='drawFixation(wins(1,flip),centerX,centerY);';
    line10='drawCue(wins(1,flip),-40,centerX,centerY);';
    line11='Screen(''CopyWindow'',wins(1,flip),win);';
    line12='Screen(''Flip'',win);'; 
    line13='elseif flip==3;';
    line14='drawFixation(wins(1,flip),centerX,centerY);';
    line15='drawCue(wins(1,flip),-30,centerX,centerY);';
    line16='Screen(''CopyWindow'',wins(1,flip),win);';
    line17='Screen(''Flip'',win);';
    line18='elseif flip==4;';
    line19='drawFixation(wins(1,flip),centerX,centerY);';
    line20='drawCue(wins(1,flip),-20,centerX,centerY);';
    line21='Screen(''CopyWindow'',wins(1,flip),win);';
    line22='Screen(''Flip'',win);';
    line23='elseif flip==5;';
    line24='drawFixation(wins(1,flip),centerX,centerY);';
    line25='drawCue(wins(1,flip),-10,centerX,centerY);';
    line26='Screen(''CopyWindow'',wins(1,flip),win);';
    line27='Screen(''Flip'',win);';
    line28='end;';
    line29='flip=flip+1;';
line30='end';
loop=[line1 line2 line3 line4 line5 line6 line7 line8 line9 line10 line11 line12 line13 line14 line15 line16 line17 line18 line19 line20 line21 line22 line23 line24 line25 line26 line27 line28 line29 line30];
priorityLevel=MaxPriority(win,'WaitBlanking');
Rushv2(loop,priorityLevel)
% stimWin=Screen('OpenOffScreenWindow',win,[0 0 0]);
% drawFixation(stimWin,centerX,centerY)
% drawCue(stimWin,-210,centerX,centerY)
% Screen('CopyWindow',stimWin,win)%[centerX-200,centerY-150,centerX+200,centerY+150],[centerX-200,centerY-150,centerX+200,centerY+150])
% Screen('Flip',win)
disp(rect)
disp(fr)

end

function drawFixation(thisWin,centerX,centerY)
Screen('TextSize',thisWin,24);
Screen('TextFont',thisWin,'Arial');
fix='+';
[fixBounds]=Screen('TextBounds',thisWin,'+');
xFix=centerX-round(fixBounds(3)/2);
yFix=centerY-round(fixBounds(4)/2);
Screen('DrawText',thisWin,fix,xFix,yFix,[255 255 255]);
%Screen('Flip',thisWin,[],1)

end

function drawCue(thisWin,loc,centerX,centerY)

Screen('TextSize',thisWin,50);
Screen('TextFont',thisWin,'Arial');
cue='*';
[cueBounds]=Screen('TextBounds',thisWin,cue);
Screen('DrawText',thisWin,cue,centerX-round(cueBounds(3)/2)-1,centerY-round(cueBounds(4)/2)+loc,[255 255 255]);
%Screen('Flip',thisWin,[],1)
    
end

 
%rect(3) = width of x pixels, rect(4) = width of y pixels