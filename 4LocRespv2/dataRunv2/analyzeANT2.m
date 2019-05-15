function analyzeANT2(subjects,fileIdentifier)
%=========================================================
% function: analyzeANT
% purpose: to analyze the matlabVersion of the ANT experiment
% inputs:  subjects, the subject numbers in square brackets
%          if numbers are consecutive, then separate the first and
%          last numbers by a colon.
%          e.g., subject 1 -10 would be [1:10]
%          if not consecutive, then separate by a comma
%          e.g., if you wanted to skip sj 4 & 5, then you would go
%          [1:3,6:10]
%          Fileidentifier, a name in quotes to attach to the output
%          file so you don't overwrite anything. e.g., 'tenSjAnal'
%
% outputs: two files for accData and rtData
%          e.g., t1DatatSjAnal.txt
%          subject gender
% date:    Feb 23, 2006
% author:  Barry
%=========================================================

%use [11,13,15:22,24:28,31,32,35,37,38,40:44,46,47,50:63,65:72,74:80]

nCueCon = 4;
cueCon = ['val';'ivl';'ctr';'non'];
nDifCon = 2;
difCon = ['inc';'con'];
nSoas = 3;

allAccData = zeros(size(subjects,2),nCueCon*nDifCon*nSoas);
allRTData = zeros(size(subjects,2),nCueCon*nDifCon*nSoas);
accFid = fopen(['accData' fileIdentifier '.txt'],'w');
rtFid = fopen(['rtData' fileIdentifier '.txt'],'w');

for i = 1:size(subjects,2)
    
    dataFile = ['/Users/dannytoomey/Documents/Research/ADTask/Experiments/ADTaskPilot/validationTests/ANT/'...
        sprintf('s%02d_allANTData.txt',subjects(i))];

    [rtData, accData] = processANTData2(dataFile);
    if i == 1
        for x=1:nCueCon
            for y=1:nDifCon
                for z=1:nSoas
                    fprintf(accFid,'%s_%s_L%d\t',cueCon(x,:),difCon(y,:),z);
                    fprintf(rtFid,'%s_%s_L%d\t',cueCon(x,:),difCon(y,:),z);
                end
            end
        end

        fprintf(accFid,'\n');
        fprintf(rtFid,'\n');
    end

    colCtr = 1;

    for x=1:nCueCon
        for y=1:nDifCon
            for z=1:nSoas
                allAccData(i,colCtr) = accData(x,y,z);
                fprintf(accFid,'%5.3f\t',allAccData(i,colCtr));
                allRTdata(i,colCtr) = rtData(x,y,z);
                fprintf(rtFid,'%7.2f\t',allRTdata(i,colCtr));
                colCtr = colCtr +1;
            end
        end
    end
    
    fprintf(accFid,'\n');
    fprintf(rtFid,'\n');
    
end

fclose(accFid);
fclose(rtFid);
