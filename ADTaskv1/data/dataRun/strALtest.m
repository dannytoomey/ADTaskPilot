
data=[1	0	0	0	1	0	0	0	1	0	1	1	1	0	1	0
0	0	1	1	0	0	1	0	0	0	0	0	0	1	0	0
1	1	1	1	0	1	1	1	1	1	0	0	0	1	1	1
0	1	0	0	1	1	0	1	0	1	1	1	1	0	0	1
1	1	1	1	1	1	1	1	2	2	2	2	2	2	2	2
4	2	3	2	1	2	3	4	4	4	2	2	2	2	4	1
768	768	768	512	512	512	512	768	768	512	768	768	768	768	512	512
300	300	600	300	600	300	300	300	600	300	600	300	300	300	300	300
2	1	0	0	1	1	2	0	2	2	0	1	1	0	1	1
1.033879796	1.32516148	1.27241393	1.999272962	1.008560318	1.667548497	1.183557782	1.999344208	1.604551138	1.520933469	1.747832026	1.103633263	0.731255079	1.110471673	1.498828613	1.118330569];
    
blockWM=[73	81	78	81
77	77	90	78
86	69	87	80
83	87	85	74
76	89	73	83
73	81	78	81
77	85	90	78
86	76	87	80
76	87	85	74
83	89	73	83];

%tone=data(9,:), resp=data(10,:), rt=data(11,:) 

taskCond=2;
cueCond=2;

if cueCond==1
    data=data(:,1:8);
elseif cueCond==2
    data=data(:,9:16);
end

blockWMload=blockWM(1:5,:);
blockWMprobe=blockWM(6:10,:);
numTrials = size(data,2);
errorCom = 0;
errorOm = 0;
targetRow=6;
cueRow=7;
toneRow=8;
respRow=9;
rtRow=10;

if taskCond==1
    taskResp = find(data(respRow,:)>0);
    numResp = numel(taskResp);
    errorOm = numTrials-numResp;
    %get accuracy
    ac = zeros(1,numTrials);
    for count=1:numTrials
        if data(respRow,count)==1
            if data(targetRow,count)<=2
                ac(1,count)=1;
            end
        end
        if data(respRow,count)==2
            if 2<data(targetRow,count)
                ac(1,count)=1;
            end
        end
    end
    %get RT for correct trials
    correct = find(ac==1);
    rt=zeros(1,numel(correct));
    for count=1:numel(correct)
        rt(1,count)=data(rtRow,correct(1,count));
    end
    numCorrect = numel(correct);
    accuracy = numCorrect/numResp;
    meanRT = mean(rt);

end

if taskCond==2
    for count=1:numTrials
        if data(toneRow,count)==600
            if data(respRow,count)>0
                errorCom=errorCom+1;
            end
        elseif data(toneRow,count)==300
            if data(respRow,count)==0
                errorOm=errorOm+1;
            end
        end
    end
    
    lowToneResp=find(data(toneRow,:)==300&data(respRow,:)~=0);
    highToneResp=find(data(toneRow,:)==600&data(respRow,:)==0);
    numResp=numel(lowToneResp)+numel(highToneResp)+errorCom;
    sortResps=[lowToneResp,highToneResp];
    resps=sort(sortResps);
    times=zeros(1,numel(lowToneResp));
    
    for resp=1:numel(lowToneResp)
        if (data(targetRow,lowToneResp(1,resp))<=2&&data(respRow,lowToneResp(1,resp))==1)||2<data(targetRow,lowToneResp(1,resp))&&data(respRow,lowToneResp(1,resp))==2
            times(1,resp)=data(rtRow,lowToneResp(1,resp));
        end
    end
    
    correct=find(times~=0);
    rt=zeros(1,numel(correct));
    for count=1:numel(correct)
        rt(1,count)=times(1,correct(1,count));
    end
    
    numCorrect = 0;
    for count=1:numel(sortResps)
        if data(toneRow,resps(1,count))==300
            if data(respRow,resps(1,count))==1
                if data(targetRow,resps(1,count))<=2
                    numCorrect=numCorrect+1;
                end
            elseif data(respRow,resps(1,count))==2
                if 2<data(targetRow,resps(1,count))
                    numCorrect=numCorrect+1;
                end
            end
        elseif data(toneRow,resps(1,count))==600
            if data(respRow,resps(1,count))==0
                numCorrect=numCorrect+1;
            end
        end
    end

    accuracy = numCorrect/numResp;
    meanRT = mean(rt);

end

%determine WMC

WMorder=zeros(size(blockWMload,1),size(blockWM,2));
for block=1:size(blockWM,2)
    for letter=1:size(blockWMload,1)
        if blockWMload(letter,block)==blockWMprobe(letter,block)
            WMorder(letter,block)=1;
        end
    end
end

acWMorder=numel(find(WMorder==1))/numel(WMorder);
meanWMletter=zeros(1,size(blockWM,2));

for block=1:size(blockWM,2)
    letterInLoad=0;
    thisBlockWM=blockWMload(:,block);
    for letter=1:size(blockWMload,1)
        thisLet=find(blockWMprobe(letter,block)==thisBlockWM);
        if thisLet~=0
            letterInLoad=letterInLoad+1;
        end
        acLetter=letterInLoad/size(blockWMload,1);
    end
    meanWMletter(1,block)=acLetter;
end

acWMletter=mean(meanWMletter);

%find orienting effect

if cueCond==1
    thres=numTrials*.75;
elseif cueCond==2
    thres=numTrials*.25;
end
if taskCond==1
    useTrials=correct;
elseif taskCond==2
    useTrials=zeros(1,numel(correct));
    for trial=1:numel(correct)
        useTrials(1,trial)=lowToneResp(1,correct(1,trial));
    end
end

valTrials=zeros(1,thres);
invalTrials=zeros(1,numTrials-thres);

for trial=1:numel(useTrials)
    if data(cueRow,useTrials(1,trial))<600&&data(targetRow,useTrials(1,trial))<=2
        valTrials(1,trial)=data(rtRow,useTrials(1,trial));
    elseif 600<data(cueRow,useTrials(1,trial))&&2<data(targetRow,useTrials(1,trial))
        valTrials(1,trial)=data(rtRow,useTrials(1,trial));
    end
    if data(cueRow,useTrials(1,trial))<600&&2<data(targetRow,useTrials(1,trial))
        invalTrials(1,trial)=data(rtRow,useTrials(1,trial));
    elseif 600<data(cueRow,useTrials(1,trial))&&data(targetRow,useTrials(1,trial))<=2
        invalTrials(1,trial)=data(rtRow,useTrials(1,trial));
    end
end

findValTimes=find(valTrials~=0);
findInvalTimes=find(invalTrials~=0);
valTimes=size(findValTimes,2);
invalTimes=size(findInvalTimes,2);
for trial=1:size(findValTimes,2)
    valTimes(1,trial)=valTrials(1,findValTimes(1,trial));
end
for trial=1:size(findInvalTimes,2)
    invalTimes(1,trial)=invalTrials(1,findInvalTimes(1,trial));
end

oriEf=mean(invalTimes)-mean(valTimes);
