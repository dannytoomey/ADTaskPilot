
% test 4loc an

cue1data=[1	1	1	1	1	1
1	5	4	2	3	6
768	768	512	512	768	768
92	9	87	25	76	93
300	600	300	600	300	300
4	1	2	1	4	2
4	0	3	1	4	2
0.511378502	0.999765707	0.602119897	0.528	0.518396424	0.740932144];

cue2data=[2	2	2	2	2	2
1	6	5	3	2	4
512	512	512	768	768	768
31	44	77	30	70	97
600	300	300	300	300	600
1	3	4	1	4	2
0	3	3	1	4	2
0.999913013	0.643315889	0.464213863	0.573903352	0.548915209	0.5283];

wmData=[86,79,89,85,87,75,76,84;69,74,78,83,68,89,71,68;84,88,87,68,80,90,80,83;88,65,73,74,74,83,81,89;68,86,66,87,75,84,85,80;86,79,89,85,87,75,76,84;69,74,78,83,68,89,71,68;84,88,87,68,80,90,66,83;88,86,73,74,74,83,80,89;68,69,66,87,75,84,81,80];
    
cueCond=2;
taskCond=2;

if cueCond==1
    data=cue1data;
elseif cueCond==2
    data=cue2data;
end

cueOrder=2;
toneRow=5;
targetRow=6;
respRow=7;
rtRow=8;

numTrials=size(data,2);
numBlocks=8;
blockTrials=6;

errorOm=0;
errorCom=0;

wmLoad=wmData(1:5,:);
wmProbe=wmData(6:10,:);
numLetter=5;
correctWM=0;

for block=1:numBlocks
    for letter=1:numLetter
        if wmLoad(letter,block)==wmProbe(letter,block)
            correctWM=correctWM+1;
        end
    end
end

accuracyWM=correctWM/(numBlocks*numLetter);

if taskCond==1

    correct=zeros(1,numTrials);

    for trial=1:numTrials
        if data(targetRow,trial)==data(respRow,trial)
            correct(1,trial)=data(rtRow,trial);
        elseif data(respRow,trial)==0
            errorOm=errorOm+1;
        end
    end

    correctTrials=find(correct~=0);
    useTrials=zeros(1,size(correctTrials,2));
    for trial=1:size(useTrials,2)
        useTrials(1,trial)=data(rtRow,correctTrials(1,trial));
    end    

    meanRT=mean(useTrials);
    accuracy=size(useTrials,2)/numTrials;

end

if taskCond==2

    lowToneCorrect=zeros(1,numTrials*(2/3));
    highToneCorrect=zeros(1,numTrials*(1/3));
    for trial=1:numTrials
        if data(toneRow,trial)==300&&data(targetRow,trial)==data(respRow,trial)
            lowToneCorrect(1,trial)=1;
        elseif data(toneRow,trial)==300&&data(respRow,trial)==0
            errorOm=errorOm+1;
        elseif data(toneRow,trial)==600&&data(respRow,trial)==0
            highToneCorrect(1,trial)=1;
        elseif data(toneRow,trial)==600&&data(respRow,trial)~=0
            errorCom=errorCom+1;
        end
    end

    correctTrials=find(lowToneCorrect~=0);
    correctHighTrials=find(highToneCorrect~=0);
    useTrials=zeros(1,size(correctTrials,2));
    for trial=1:size(useTrials,2)
        useTrials(1,trial)=data(rtRow,correctTrials(1,trial));
    end

    meanRT=mean(useTrials);
    accuracy=(size(correctTrials,2)+size(correctHighTrials,2))/numTrials;

end

if cueCond==1
    thres=blockTrials*(2/3);
elseif cueCond==2
    thres=blockTrials*(1/3);
end

valTrials=zeros(1,thres);
invalTrials=zeros(1,numTrials-thres);

for trial=1:size(correctTrials,2)
    if data(cueOrder,correctTrials(1,trial))<=thres
        valTrials(1,trial)=data(rtRow,correctTrials(1,trial));
    elseif thres<data(cueOrder,correctTrials(1,trial))
        invalTrials(1,trial)=data(rtRow,correctTrials(1,trial));
    end
end

useValTrials=find(valTrials~=0);
valTrialTimes=zeros(1,size(useValTrials,2));
for trial=1:size(useValTrials,2)
    valTrialTimes(1,trial)=valTrials(1,useValTrials(1,trial));
end
useInvalTrials=find(invalTrials~=0);
invalTrialTimes=zeros(1,size(useInvalTrials,2));
for trial=1:size(useInvalTrials,2)
    invalTrialTimes(1,trial)=invalTrials(1,useInvalTrials(1,trial));
end

oriEf=mean(invalTrialTimes)-mean(valTrialTimes);
