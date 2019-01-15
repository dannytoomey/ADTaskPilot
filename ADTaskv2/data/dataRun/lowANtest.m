
%lowAN test

cue1data=[1	1	1	1	1	1
5	1	4	6	2	3
13	24	24	95	9	66
80	27	95	99	29	62
600	300	300	600	300	300
4	1	2	2	1	4
0	1	1	0	1	2
0.999679811	0.493059009	0.499580409	1.000026366	0.454674672	0.549373791];

cue2data=[2	2	2	2	2	2
3	5	6	2	1	4
83	17	78	3	82	9
67	70	83	26	80	96
300	300	300	600	300	600
2	4	2	1	4	4
1	2	1	0	2	0
0.624401473	0.526906189	0.669232657	0.999210019	0.424559208	0.999089738];

numTask=2;
numCue=2;

cueCond=1;
taskCond=1;

if cueCond==1
    data=cue1data;
elseif cueCond==2
    data=cue2data;
end

for task=1:numTask
    for cue=1:numCue
        if cue==1
            thisData=cue1data;
        elseif cue==2
            thisData=cue2data;
        end
        test(task).allTestTask(cue).thisCueData(1).thisData=thisData;
    end
end
        

numTrials = size(data,2);
errorCom = 0;
errorOm = 0;
cueRow=2;
toneRow=5;
targetRow=6;
respRow=7;
rtRow=8;

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
            if data(respRow,count)~=0
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
        if (data(targetRow,lowToneResp(1,resp))<=2)&&data(respRow,lowToneResp(1,resp))==1||...
            2<(data(targetRow,lowToneResp(1,resp)))&&data(respRow,lowToneResp(1,resp))==2
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
            if (data(respRow,resps(1,count))==1)&&(data(targetRow,resps(1,count))<=2)||...
                (data(respRow,resps(1,count))==2)&&(2<data(targetRow,resps(1,count)))
                numCorrect=numCorrect+1;
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



if cueCond==1
    thres=numTrials*(2/3);
elseif cueCond==2
    thres=numTrials*(1/3);
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
    if data(cueRow,useTrials(1,trial))<=thres
        valTrials(1,trial)=data(rtRow,useTrials(1,trial));
    elseif thres<data(cueRow,useTrials(1,trial))
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

