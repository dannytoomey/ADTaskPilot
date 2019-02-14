function [rtData accData] = processCABDataFile(dataFile)

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
while moreData & trialNum < (maxTrials+1)
    thisTrial = fgetl(fid);
    
    if thisTrial ~= -1 & length(thisTrial)>10
        
        [thisBlock,trial,thisSoa,thisCue,...
            thisCon,arrowDir,resp,acc,rt,fixation,nFrames]=...
            strread(thisTrial,'%d\t%d\t%d\t%c\t%d\t%c\t%c\t%d\t%7.2f\t%d\t%d');
        if thisCue == 'V'
            cueIdx = 1;
        elseif thisCue == 'I'
            cueIdx = 2;
            
        elseif thisCue == 'C'
            cueIdx = 3;
        elseif thisCue == 'N'
            cueIdx = 4;
        end
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


