
function [rtData, accData] = processANTData2(dataFile)

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
        
        text=textscan(thisTrial,'%d\t%d\t%d\t%c\t%d\t%c\t%c\t%d\t%7.2f\t%d\t%d');
            
        thisBlock=cell2mat(text(1));
        trial=cell2mat(text(2));
        thisSoa=cell2mat(text(3));
        thisCue=cell2mat(text(4));
        thisCon=cell2mat(text(5));
        arrowDir=cell2mat(text(6));
        resp=cell2mat(text(7));
        acc=cell2mat(text(8));
        rt=cell2mat(text(9));
        fixation=cell2mat(text(10));
        nFrames=cell2mat(text(11));
        
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
