
%only use correct trials for accuracy

cue1data=[0	0	0	0	1	1	0	0
0	0	1	1	0	0	0	0
1	1	0	0	0	0	0	1
0	0	0	0	0	0	1	0
1	1	1	1	1	1	1	1
768	512	512	512	512	768	768	768
300	300	300	300	600	300	600	300
0	2	1	2	1	1	0	1
0.480739363	0.340691143	0.408347788	0.373578315	0.3432	0.500878001	0.999932965	0.636834512];

cue2data=[0	0	0	0	0	0	0	1
0	0	0	0	0	0	1	0
1	1	1	1	1	1	0	0
0	0	0	0	0	0	0	0
2	2	2	2	2	2	2	2
768	768	512	768	512	512	512	512
600	300	300	300	300	300	300	600
1	2	2	2	2	1	1	0
0.999864139	0.497050178	0.549927399	0.409404419	0.413803866	0.392648246	0.517301699	0.999332664];

blockWM=[86	90	70	89
68	77	85	80
70	75	87	78
75	85	90	73
79	70	81	83
86	90	85	89
68	78	70	80
70	75	87	78
75	84	90	73
79	70	81	83];

taskCond=2;
cueCond=2;
data=cue2data;

blockWMload=blockWM(1:5,:);
blockWMprobe=blockWM(6:10,:);
numTrials = size(data,2);
errorCom = 0;
errorOm = 0;
cueRow=6;
toneRow=7;
respRow=8;
rtRow=9;

if taskCond==1
    taskResp = find(data(respRow,:)>0);
    numResp = numel(taskResp);
    errorOm = numTrials-numResp;
    %get accuracy
    ac = zeros(1,numTrials);
    for count=1:numTrials
        if data(respRow,count)==1
            if data(1,count)==1||data(2,count)==1
                ac(1,count)=1;
            end
        end
        if data(respRow,count)==2
            if data(3,count)==1||data(4,count)==1
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
        if (data(1,lowToneResp(1,resp))==1&&data(respRow,lowToneResp(1,resp))==1)||(data(2,lowToneResp(1,resp))==1&&data(respRow,lowToneResp(1,resp))==1)
            times(1,resp)=data(rtRow,lowToneResp(1,resp));
        elseif (data(3,lowToneResp(1,resp))==1&&data(respRow,lowToneResp(1,resp))==2)||(data(4,lowToneResp(1,resp))==1&&data(respRow,lowToneResp(1,resp))==2)
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
                if data(1,resps(1,count))==1
                    numCorrect=numCorrect+1;
                elseif data(2,resps(1,count))==1
                    numCorrect=numCorrect+1;
                end
            elseif data(respRow,resps(1,count))==2
                if data(3,resps(1,count))==1
                    numCorrect=numCorrect+1;
                elseif data(4,resps(1,count))==1
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
    if data(cueRow,useTrials(1,trial))<600&&data(3,useTrials(1,trial))==0&&data(4,useTrials(1,trial))==0
        valTrials(1,trial)=data(rtRow,useTrials(1,trial));
    elseif 600<data(cueRow,useTrials(1,trial))&&data(1,useTrials(1,trial))==0&&data(2,useTrials(1,trial))==0
        valTrials(1,trial)=data(rtRow,useTrials(1,trial));
    end
    if data(cueRow,useTrials(1,trial))<600&&data(1,useTrials(1,trial))==0&&data(2,useTrials(1,trial))==0
        invalTrials(1,trial)=data(rtRow,useTrials(1,trial));
    elseif 600<data(cueRow,useTrials(1,trial))&&data(3,useTrials(1,trial))==0&&data(4,useTrials(1,trial))==0
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
