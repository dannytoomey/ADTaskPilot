
function [rtData accData] = processANTData(dataFile)

% sjProcess=99;%input('input sj data file for processing ');
% 
% dataFile=sprintf('s%02d_allData.txt',sjProcess);

fid=fopen(dataFile,'r');

% process header
nHdrLines = 11;

for ln=1:nHdrLines
    temp = fgetl(fid);
end

rtData = zeros(4,2,3);
accData = rtData;
trialCtr = rtData;
t2Gt1Data = rtData;
moreData = 1;
maxTrials = 2000;
trialNum=1;

while moreData==1&&trialNum<(maxTrials+1)
    
    thisTrial = fgetl(fid);
    read=size(find(thisTrial==-1));
    
    if read(2)==0&&length(thisTrial)>10
        
        thisBlock=str2double(thisTrial(1));
        trial=str2double(thisTrial(3));
        thisSoa=str2double(thisTrial(5));
        thisCue=thisTrial(7);
        thisCon=str2double(thisTrial(9));
        arrowDir=thisTrial(11);
        resp=thisTrial(13);
        acc=str2double(thisTrial(15));
        rt=str2double(thisTrial(18:23));
        fixation=str2double(thisTrial(25:26));
        if size(thisTrial,2)==29
            nFrames=str2double(thisTrial(28:29));
        else
            nFrames=str2double(thisTrial(28));
        end
        
%         [thisBlock,trial,thisSoa,thisCue,...
%             thisCon,arrowDir,resp,acc,rt,fixation,nFrames]=...
%             textscan(thisTrial,'%d\t%d\t%d\t%c\t%d\t%c\t%c\t%d\t%7.2f\t%d\t%d');

        
        if thisCue == 'V'
            cueIdx = 1;
        elseif thisCue == 'I'
            cueIdx = 2;
        elseif thisCue == 'C'
            cueIdx = 3;
        elseif thisCue == 'N'
            cueIdx = 4;
        end
        
        save('test.mat','cueIdx','thisCon','thisSoa')
        
        accData(cueIdx,thisCon,thisSoa) = accData(cueIdx,thisCon,thisSoa)+acc;
        if acc
          rtData(cueIdx,thisCon,thisSoa) = rtData(cueIdx,thisCon,thisSoa)+rt;
        end
          trialCtr(cueIdx,thisCon,thisSoa) = trialCtr(cueIdx,thisCon,thisSoa)+1;
       
        trialNum = trialNum+1;
        
    else
        moreData = 0;
    end



end

rtData = rtData./accData;
accData = accData./trialCtr;
fclose(fid);

return;


