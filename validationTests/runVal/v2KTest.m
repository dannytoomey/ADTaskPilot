
function v2KTest(sjNum,numTrials,exp,KfilePath,practice,laptopDebug,backup)

% PTB3 implementation of a color change detection task following Luck &
% Vogel (1997).

%%

%2/26/19 - add practice block, run 4 blocks during experiment, change resp
%time to 1.5 sec

% must run K_info_setup and K_make_all_session_trialSequences first

ListenChar(2);
close all;
clc;
s = round(sum(100*clock));  % check to make sure something was typed in
p.subNum = sjNum; 
p.rndSeed = s;              % grab name & number info out of the gui
rng('shuffle')
%rand('state',p.rndSeed);

[keyboardIndices, ~, ~] = GetKeyboardIndices('Apple Internal Keyboard / Trackpad');
KbName('UnifyKeyNames');
sameResp=KbName('f');
diffResp=KbName('j');
respTime=1.5;  %give them one second to respond // change to 1.5 - D

%----------------------------------------------------
% General Experimental Parameters
%----------------------------------------------------

%do 5 blocks of 36 trials/block

if exp==1                   %could we move this down to 5 blocks to save time? ~27min -> ~14min
    if numTrials==180       %this will have 36 trials/block for 5 blocks, 180 total trials
        p.nBlocks=5;        %this gives an integer value for numrepeats (in make_trialSequences) and p.nTrials.
    elseif numTrials==390   %these all have 40 trials/block. move down to 36 to work with make_trialTypeMatrix
        p.nBlocks=10;
    elseif numTrials==720
        p.nBlocks=18;
    elseif numTrials==1080
        p.nBlocks=27;
    end               
    p.nTrials = numTrials/p.nBlocks;    %number of trials/block
end
if exp==0||practice==1
    p.nBlocks=2;    %do 2 blocks of 10 trials if practice or debugging
    p.nTrials=10;    
end                 

% Stimulus geometry - relative to screen dimensions
p.fixSize = 3; 
p.sqSize = 30;                                              % size of stimuli
p.minDist = 2*p.sqSize;                           % minimum center-to-center distance between stimuli

% Color information
p.backColor = [150 150 150];                                % background color - medium grey
p.foreColor = [180 180 180];                                % foreground color - light grey
p.colors = [255 0 0; 0 255 0; 0 0 255; 255 255 0; 255 255 255; 0 0 0];
colors1 = p.colors;%repmat(p.colors,2,1); 
colors2 = p.colors;% Duplicate and concatinate the p.colors matrix

%----------------------------------------------------
% Get screen params, build the display
%----------------------------------------------------

s = max(Screen('Screens'));          % grab a handle into the current display (this should return 0, thereby identifying the monitor as the primary output)
p.refRate = 60;

% Open a display of a size determined by the p.windowed field. The
% 'OpenWindow' command returns two output values: a window identifier
% ("win"), and the dimensions of the screen ("p.sRect"). Type
% Screen('OpenWindow?') at the command line for more information.

if laptopDebug==1
    Screen('Preference','SkipSyncTests',1)
    [win, p.sRect]=Screen(s,'OpenWindow', p.backColor);
    ifi=1/60;
else
    ctr = 0;
    error_ctr = 0;
    while error_ctr == ctr
        try
            [win,p.sRect] = Screen('OpenWindow',s,[127.5 127.5 127.5]);
        catch
            error_ctr = error_ctr+1;
        end
        ctr = ctr+1;
    end
    ifi = Screen('GetFlipInterval',win,10);
end
    
Screen('FillRect', win, p.backColor);
HideCursor;                                             % if we're in fullscreen mode, hide the cursor

% Timing information
expDurations=100;
expDurFrames = round((expDurations/1000)./(1/p.refRate));  
stimTime=expDurFrames*ifi;                                %100ms
p.fixDur = round(1000/(1000/p.refRate));                  %1s
p.delay = round(1000/(1000/p.refRate));                   %1s

% compute and store the center of the screen.
p.xCenter = (p.sRect(3) - p.sRect(1))/2;
p.yCenter = (p.sRect(4) - p.sRect(2))/2;

% calculate degree to pixel ratio so can code in degree
screenWidth = 33; %in cm
screenWidthMM = screenWidth*10;
viewDistance = 110;
viewDistanceMM = viewDistance*10;
visang_rad = 2*atan(screenWidthMM/2/viewDistanceMM);
visang_deg = visang_rad*(180/pi);
screenres = p.sRect(3);
pix_pervisang = screenres/visang_deg;
sq_size_in_deg = 6.5; %6.5 degree square

sq_size_in_px = pix_pervisang*sq_size_in_deg;

% Compute foreground and fixation rectangles
foreRect = [0 0 sq_size_in_px sq_size_in_px];
foreRect = CenterRectOnPoint(foreRect,p.xCenter,p.yCenter);
fixRect = [(p.xCenter - p.fixSize),(p.yCenter - p.fixSize),(p.xCenter  + p.fixSize), (p.yCenter + p.fixSize)];

%---------------------------------------------------
% Begin block loop
%---------------------------------------------------

for b = 1:p.nBlocks
    
    % Build an output file and check to make sure that it doesn't exist yet
    
    fName = ['sj', num2str(p.subNum), '_AllKTaskData.mat'];
    
    %--------------------------------------------------------
    % Preallocate some vectors to control experimental params
    %--------------------------------------------------------
    
    % Stimulus parameters:
    stim.setSize = zeros(1,p.nTrials);
    stim.change = zeros(1,p.nTrials);
    stim.rndInd = randperm(p.nTrials);
    
    % Response params
    stim.response = zeros(1,p.nTrials);
    stim.accuracy = zeros(1,p.nTrials);
    stim.rt = zeros(1,p.nTrials);
   
    
    %--------------------------------------------------------
    % Load the stimulus sequence
    %--------------------------------------------------------
    ts=load([KfilePath sprintf('sj%02d_KtrialSequences.mat',sjNum)]);
    setSize = ts.allSessionSequences(1,:,1);
    change = ts.allSessionSequences(1,:,2);
    
    %--------------------------------------------------------
    % Give instructions
    %--------------------------------------------------------
    
    Screen('FillRect',win,[127.5 127.5 127.5])
    
    if b==1
        inst=['You are about to see \n'...
            'a series of colored squares \n'...
            'followed by a single square. \n \n'...
            'Press "F" if the square was the \n'...
            'same color in the proceeding array or \n'...
            'press "J" if the square was a \n' ...
            'different color in the proceeding array.'];
        Screen('TextSize',win,40)
        DrawFormattedText(win,inst,'center','center',[255 255 255])
        Screen('Flip',win)
        KbStrokeWait
    end
            

    Screen('TextSize',win,40);
    if practice==1
        blockMessage=sprintf('This is %d of %d practice blocks',b,p.nBlocks);
    else
        blockMessage=sprintf('This is %d of %d blocks',b,p.nBlocks);
    end
    [normBoundsRect]=Screen('TextBounds',win,blockMessage);
    Screen('DrawText',win,blockMessage,p.xCenter-round(normBoundsRect(3)/2),...
        p.yCenter-(10*round(normBoundsRect(4)/3)),[255 255 255]);
    [normBoundsRect]=Screen('TextBounds',win,'Press "f" for same, "j" for different');
    Screen('DrawText',win,'Press "f" for same, "j" for different',p.xCenter-round(normBoundsRect(3)/2),...
        p.yCenter-round(normBoundsRect(4)/2),[255 255 255]);
    [normBoundsRect]=Screen('TextBounds',win,'Press Space to Start the Block');
    Screen('DrawText',win,'Press Space to Start the Block',p.xCenter-round(normBoundsRect(3)/2),...
        p.yCenter+(10*round(normBoundsRect(4)/3)),[255 255 255]);
    Screen('Flip',win);
    
    KbWait([],2);
    
    Screen('FillRect',win,p.foreColor,foreRect);            % Draw the foreground window
    Screen('Flip',win);
    WaitSecs(2.0);
    
    
    %--------------------------------------------------------
    % Create and flip up the basic stimulus display
    %--------------------------------------------------------
    Screen('FillRect',win,p.foreColor,foreRect);            % Draw the foreground window
    Screen('FillOval',win,p.colors(6,:),fixRect);           % Draw the fixation point
    Screen('Flip',win);
    %-------------------------------------------------------
    % Begin Trial Loop
    %-------------------------------------------------------
    for t = 1:p.nTrials
        % Grab stim parameters for the current trial
        stim.setSize(t) = setSize(stim.rndInd(t));
        stim.change(t) = change(stim.rndInd(t));
        
        % segment the inner window into four quadrants - for xCoords, 1st
        % row = positions in left half of display, 2nd row = right half.
        % For yCoords - 1st row = top half, 2nd row = bottom half
        xCoords = [linspace((foreRect(1)+p.sqSize),p.xCenter-p.sqSize,300); linspace(p.xCenter+p.sqSize,(foreRect(3)-p.sqSize),300)];         
        yCoords = [linspace((foreRect(2)+p.sqSize),p.yCenter-p.sqSize,300); linspace(p.yCenter+p.sqSize,(foreRect(4)-p.sqSize),300)]; 
        xLocInd = randperm(size(xCoords,2)); yLocInd = randperm(size(yCoords,2));
        
        % compute and grab a random index into the color matrix
        mix1 = randperm(length(colors1));
        mix2 = randperm(length(colors2));
        colormix1 = colors1(mix1(1:6), :);
        colorIndex = (1:8);
        colormix2 = colors2(mix2(1:2), :);
        colors= [colormix1; colormix2];%randperm(size(colors,1));
        
        % Pick x,y coords for drawing stimuli on this trial, making sure
        % that all stimuli are seperated by >= p.minDist  
        
        %stim.setsize = 1 means size size of 4, 2 means 6,  3 means 8
      
        if stim.setSize(t)==1
            SS=4;
        elseif stim.setSize(t)==2
            SS=6;
        elseif stim.setSize(t)==3
            SS=8;
        end
        if SS==4
            xPos = [xCoords(1,xLocInd(1)),xCoords(2,xLocInd(2)),xCoords(1,xLocInd(3)),xCoords(2,xLocInd(4))];
            yPos = [yCoords(1,yLocInd(1)),yCoords(1,yLocInd(2)),yCoords(2,yLocInd(3)),yCoords(2,yLocInd(4))];
        elseif SS==6
            while 1
                xLocInd = Shuffle(xLocInd); yLocInd = Shuffle(yLocInd);
                xPos = [xCoords(1,xLocInd(1)),xCoords(2,xLocInd(2)),xCoords(1,xLocInd(3)),xCoords(2,xLocInd(4)),xCoords(1,xLocInd(5)),xCoords(2,xLocInd(6))];
                yPos = [yCoords(1,yLocInd(1)),yCoords(1,yLocInd(2)),yCoords(2,yLocInd(3)),yCoords(2,yLocInd(4)),yCoords(1,yLocInd(5)),yCoords(1,yLocInd(6))];
                if sqrt(abs(xPos(1)-xPos(5))^2+abs(yPos(1)-yPos(5))^2)>p.minDist 
                    if sqrt((xPos(2)-xPos(6))^2+(yPos(2)-yPos(6))^2)>p.minDist
                        if sqrt((xPos(3)-xPos(4))^2+(yPos(3)-yPos(4))^2)>p.minDist 
                            break;
                        end
                    end
                end
                % make sure that w/in quadrant points satisfy the minimum
                % distance requirement
            end
        elseif SS==8   
            while 1
                xLocInd = Shuffle(xLocInd); yLocInd = Shuffle(yLocInd);
                xPos = [xCoords(1,xLocInd(1)),xCoords(2,xLocInd(2)),xCoords(1,xLocInd(3)),xCoords(2,xLocInd(4)),xCoords(1,xLocInd(5)),xCoords(2,xLocInd(6)),xCoords(1,xLocInd(7)),xCoords(2,xLocInd(8))];
                yPos = [yCoords(1,yLocInd(1)),yCoords(1,yLocInd(2)),yCoords(2,yLocInd(3)),yCoords(2,yLocInd(4)),yCoords(1,yLocInd(5)),yCoords(1,yLocInd(6)),yCoords(2,yLocInd(7)),yCoords(2,yLocInd(8))];
                if sqrt(abs(xPos(1)-xPos(5))^2+abs(yPos(1)-yPos(5))^2)>p.minDist 
                    if sqrt((xPos(2)-xPos(6))^2+(yPos(2)-yPos(6))^2)>p.minDist
                        if sqrt((xPos(3)-xPos(7))^2+(yPos(3)-yPos(7))^2)>p.minDist 
                            if sqrt((xPos(4)-xPos(8))^2+(yPos(4)-yPos(8))^2)>p.minDist
                                break;
                            end
                        end
                    end
                end
            end
        end
        
        % Wait the fixation interval
        for i = 1:p.fixDur
            Screen('WaitBlanking',win);
        end
        
        % Draw squares on the main window
        Screen('FillRect',win,p.foreColor,foreRect);            % Draw the foreground window
        Screen('FillOval',win,p.colors(6,:),fixRect);           % Draw the fixation point
        
        
        for i = 1:SS
            Screen('FillRect',win,colors(colorIndex(i),:),[(xPos(i)-p.sqSize/2),(yPos(i)-p.sqSize/2),(xPos(i)+p.sqSize/2),(yPos(i)+p.sqSize/2)]);
        end        
        
        Screen('Flip',win);
        WaitSecs(stimTime)
        
        Screen('FillRect',win,p.foreColor,foreRect);            % Draw the foreground window
        Screen('FillOval',win,p.colors(6,:),fixRect);           % Draw the fixation point
        Screen('Flip',win);
        
        %------------------------------------------------------------------
        % Figure out the change stuff
        %------------------------------------------------------------------
        
        changeIndex = randperm(SS);
        changeLocX = xPos(changeIndex(1)); 
        changeLocY = yPos(changeIndex(1)); 
        sColor = colorIndex(changeIndex(1));
        
        if sColor > 6
            sColor2 = sColor - 6;
        elseif sColor < 7
            sColor2 = sColor + 6;
        end
        while 1
            ind = randi(SS);
            if ind ~= sColor && ind ~= sColor2
                break;
            end
        end
        changeColor = colors(ind,:);
        
        % wait the ISI
        for i = 1:p.delay
            Screen('WaitBlanking',win);
        end

        % Draw a new square on the screen, with the color value determined
        % by whether it's a change trial or not
        Screen('FillRect',win,p.foreColor,foreRect);            % Draw the foreground window
        Screen('FillOval',win,p.colors(6,:),fixRect);           % Draw the fixation point
        
        
        if stim.change(t)==1    %change
            Screen('FillRect',win,changeColor,[(changeLocX-p.sqSize/2),(changeLocY-p.sqSize/2),(changeLocX+p.sqSize/2),(changeLocY+p.sqSize/2)]);
        else                    %don't change
            Screen('FillRect',win,colors(sColor,:),[(changeLocX-p.sqSize/2),(changeLocY-p.sqSize/2),(changeLocX+p.sqSize/2),(changeLocY+p.sqSize/2)]);
        end
        
        tStart = Screen('Flip',win);
        
        % Response
        
        resp=0;
        
        while GetSecs<=tStart+respTime
            [keyIsDown, tEnd, keyCode] = KbCheck(keyboardIndices);
            if keyIsDown==1
                ind=find(keyCode~=0);
                if size(ind,2)==1
                    resp = ind;
                end
            end
        end
        
        %stim.change 2 = same, 1 = different
        
        stim.response(1,t) = resp;
        if stim.change(1,t)==1
            if stim.response(1,t)==diffResp
                stim.accuracy(1,t)=1;
            else
                stim.accuracy(1,t)=0;
            end
        elseif stim.change(1,t)==2
            if stim.response(1,t)==sameResp
                stim.accuracy(1,t)=1;
            else
                stim.accuracy(1,t)=0;
            end
        end
        reactionTime = tEnd - tStart;
        stim.rt(1,t) = reactionTime*1000;
        RestrictKeysForKbCheck([]);   
            
        Screen('FillRect',win,p.foreColor,foreRect);        %Draw the foreground window
        if practice==1                                      %give practice feedback
            if stim.accuracy(1,t)==1
                Screen('FillOval',win,[0 255 0],fixRect)    %green if correct
            else
                Screen('FillOval',win,[255 0 0],fixRect)    %red if incorrect
            end
        else    
            Screen('FillOval',win,p.colors(6,:),fixRect);   %Draw the fixation point if exp
        end
        
        Screen('Flip',win);
        
        Screen('WaitBlanking',win,p.delay/2);
        
    end  
    % end of trial loop
    
    WaitSecs(0.5)
    
    % save data file at the end of each block
    
    allData(b).p=p;
    allData(b).stim=stim;
    
    save([backup 'KblockDataBackup.mat'],'allData')
    
end         % end of block loop

if practice==1
    Screen('FillRect',win,[127.5 127.5 127.5])
    DrawFormattedText(win,'Please wait for the administrator''s cue to start','center','center',[255 255 255])
    Screen('Flip',win)
    KbStrokeWait
end

if practice==0
    saveFile=[KfilePath fName];
    save(saveFile,'allData') 
    backupFile=[backup fName];
    save(backupFile,'allData')
end

% pack up and go home
ListenChar([]);
sca;
ShowCursor;

return
