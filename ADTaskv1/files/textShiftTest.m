
Screen('Preference', 'SkipSyncTests', 1);
screenNumber = max(Screen('Screens'));
white = [255 255 255];
grey = white./2;
[window,rect] = Screen('OpenWindow',screenNumber,grey);
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
stimX = x - x1/2;
stimY = y - y1/2;
yScale = arrayY(1,2);
xScale = arrayX(1,2);
fixCrossDimPix = 20;
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];
lineWidthPix = 2;
crossSize=18;
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('TextSize', window, crossSize);
Screen('DrawLines',window,allCoords,lineWidthPix,white,[xCenter yCenter], 2);
Screen('Flip', window,[],1);

Screen('TextSize', window, 35);
line1='Red';
line2='Blue';
line3='Blue';
line4='Red';
bounds1=Screen('TextBounds',window,line1);
X1textShift=round(bounds1(1,3)/2);
Y1textShift=round(bounds1(1,4)/2);
bounds2=Screen('TextBounds',window,line2);
X2textShift=round(bounds2(1,3)/2);
Y2textShift=round(bounds2(1,4)/2);
bounds3=Screen('TextBounds',window,line3);
X3textShift=round(bounds3(1,3)/2);
Y3textShift=round(bounds3(1,4)/2);
bounds4=Screen('TextBounds',window,line4);
X4textShift=round(bounds4(1,3)/2);
Y4textShift=round(bounds4(1,4)/2);
color=[255 255 255];
                
Screen('TextSize', window, 35);
Screen('DrawText',window,line1,xCenter-X1textShift+stimX(1,1),yCenter-Y1textShift+stimY(1,1),color);
Screen('DrawText',window,line2,xCenter-X2textShift+stimX(1,2),yCenter-Y2textShift+stimY(1,2),color);
Screen('DrawText',window,line3,xCenter-X3textShift+stimX(2,1),yCenter-Y3textShift+stimY(2,1),color);
Screen('DrawText',window,line4,xCenter-X4textShift+stimX(2,2),yCenter-Y4textShift+stimY(2,2),color);        
Screen('Flip',window);

% X1textShift=0;
% Y1textShift=0;

% Screen('TextSize', window, 35);
% [xa,ya]=Screen('DrawText',window,line1,640-128-X1textShift,400-100-Y1textShift,color);
% [xb,yb]=Screen('DrawText',window,line2,640-128-X1textShift,400+100-Y1textShift,color);
% [xc,yc]=Screen('DrawText',window,line3,640+128-X1textShift,400-100-Y1textShift,color);
% [xd,yd]=Screen('DrawText',window,line4,640+128-X1textShift,400+100-Y1textShift,color);        
% Screen('Flip',window);
% 
