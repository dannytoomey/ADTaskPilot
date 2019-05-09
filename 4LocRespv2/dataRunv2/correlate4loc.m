%%
%function: correlate4loc
%purpose: correlate 4locv2 task to validation measures
%what correlates to what - 
%    novel              |val                    |measure
%                       |                       |
%       orienting       |   ANT - orienting     |   rt inval-val  
%                       |                       |
%       divided         |   div task            |   rt dual-single
%                       |                       |   acc dual-single (maybe combine both measures?) 
%                       |                       |
%       selective       |                       |   
%           easy-dot    |                       |   rt - easy cond - no distractors
%                       |                       |       ideally, this would be 0
%           hard-easy   |   ANT - incon-con     |   rt - hard selection - easy selection, gives cost of selecting                                                       
%                       |                       |       use single task conds
%                       |                       |
%       working memory  |   k task              |   avg correct x set size
%
%%
function correlate4loc(sjRange,dump)

numCond=3;
numTask=2;
numCue=2;

load('allDataStruct.mat')
load(['kDataSj' sprintf('%02d',min(sjRange)) '-Sj' sprintf('%d',max(sjRange)) '.mat'])
ANTrtFile=['rtDatasj' sprintf('%d',min(sjRange)) '-sj' sprintf('%d',max(sjRange)) '.txt'];
load('dualNorm.mat');
load('singNorm.mat');

fid=fopen(ANTrtFile,'r');
skipLines=1;
for ln=1:skipLines
    temp = fgetl(fid);
end

for sub=1:size(sjRange,2)
    
    sj=sjRange(1,sub);
    
    %working memory
    
    count=1;
    for cond=1:numCond
        for task=1:numTask
            for cue=1:numCue
                sjWM(1,count)=allDataStruct(cond).task(task).cue(cue).accuracyWM(sj);
                count=count+1;
            end
        end
    end
    
    corMat(sub,1)=mean(sjWM);                    %column 1 = novel WM
    corMat(sub,2)=allK(sub);                     %column 2 = val WM
    
    %selective attention 
    
    count=1;
    for cue=1:numCue
        sjEZrt(1,count)=allDataStruct(2).task(1).cue(cue).visMeanRT(sj);
        count=count+1;
    end
    count=1;
    for cue=1:numCue
        sjHDrt(1,count)=allDataStruct(3).task(1).cue(cue).visMeanRT(sj);
        count=count+1;
    end
    corMat(sub,3)=mean(sjHDrt)-mean(sjEZrt);     %column 3 = novel hard-easy
    
    thisSj=fgetl(fid);
    data=cell2mat(textscan(thisSj,'%7.2f'));
    corMat(sub,4)=mean(data([1:3,7:9,13:15,19:21]))-mean(data([4:6,10:12,16:18,22:24]));     %column 4 = val hard-easy
    
    count=1;
    for cue=1:numCue
        sjBasert(1,count)=allDataStruct(1).task(1).cue(cue).visMeanRT(sj);
        count=count+1;
    end
    corMat(sub,5)=mean(sjEZrt)-mean(sjBasert);  %column 5 = novel base rt
    
    %divided attention
    
    count=1;
    for cond=1:numCond
        for cue=1:numCue
            sjSingle(1,count)=allDataStruct(cond).task(1).cue(cue).visMeanRT(sj);
            sjDual(1,count)=allDataStruct(cond).task(2).cue(cue).visMeanRT(sj);
            count=count+1;
        end
    end
    corMat(sub,6)=mean(sjDual)-mean(sjSingle);       %column 6 = novel dual cost
    
    corMat(sub,7)=dualNorm(sub)-singNorm(sub);       %column 7 = val dual cost
                                                     
    %orienting effect
    
    count=1;
    for cond=1:numCond
        for task=1:numTask
            for cue=1:numCue
                sjOri(1,count)=allDataStruct(cond).task(task).cue(cue).oriEf(sj);
                count=count+1;
            end
        end
    end
    corMat(sub,8)=mean(sjOri);                       %column 8 = novel orienting effect

    corMat(sub,9)=mean(data(7:12))-mean(data(1:6));  %column 9 = val orienting effect

save('corMat.mat','corMat')
end

for col=1:size(corMat,2)
    temp=corMat(:,col);
    badSub=find(2*std(temp)<(abs(temp(:)-mean(temp))));
    badSubSt(col).badSub=sjRange(badSub);
end

save('badSubs.mat','badSubSt')

if dump==0
    dumpSub=[];
    count=1;
    for col=1:size(corMat,2)
        for sub=1:size(badSubSt(col).badSub,2)
            b=0;
            for a=1:size(corMat,2)
                if 1<=find(badSubSt(col).badSub(sub)==badSubSt(a).badSub)
                b=b+1;
                end
            end
            if b>1&&count==1||b>1&&count>1&&size(find(dumpSub==badSubSt(col).badSub(sub)),2)==0
                dumpSub(count)=badSubSt(col).badSub(sub);
                count=count+1;
            end
        end
    end
    dumpSub=sort(dumpSub);
    save('dumpSub.mat','dumpSub')
end

end
