
function v2K_make_trialSequences(sjNum,numTrials,KfilePath)

rng('shuffle')
%rand('seed',sum(100*clock));

%corrected version to successfulll produce even split of set size and probe
%loc across blocks 

%get expInfo for the entire experiment
%read setupExpInfo

%do we need the info_setup function at all? it just makes a struct..

outFile = sprintf('sj%02d_KtrialSequences.mat',sjNum);

%'trialSequenceFile', trialSequenceFile,...     this was in expInfo struct
%but it's saved at the end of this script so why save it twice..

%got rid of
    %'sjAge', sjAge,... 
    %'sjHand', sjHand,...
%in expInfo b/c sjInfo already has it
    

expInfo = struct(...
    'sjNum', sjNum,...
    'numTrials', numTrials,...
    'outFile', outFile,...
    'date', datestr(now),...
    'searchRadius', 6.5,...%in degrees of visual angle
    'nExpDurations', 1,...
    'expDurations', 100,...%in ms
    'nSetSizes', 2,...  %shouldn't this be 3?? - D // later on it uses nSetSizes+1, so no
    'setSizes', [4 6],...%includes target, so 1= target only // shouldn't this be [4 6 8]? -D
    'nTrialType', 2,...
    'TrialType', [0 1],...%change or no? 0=no, 1=yes
    'retentInterval', 900,...
    'screenWidth', 36.5,...%in cm
    'screenHeight', 27,...%in cm
    'viewDistance', 70,...%in cm
    'feedBack', 0); %1=yes, 0 = no for main exp only

nSetSizes = expInfo.nSetSizes;
nTrialType = expInfo.nTrialType;

%numTrials/numrepeats has to = 6 
%so change trials/block to 36, otherwise have to do 9 blocks to get an
%integer that will work with make_trialTypeMatrix
if numTrials==180
    numrepeats=30;  %numTrials/numrepeats still = 6, uses 36 trials/block to get integer value for numTrials and t/b
elseif numTrials == 390
    numrepeats = 65;
elseif numTrials == 720
    numrepeats = 120;
else
    numrepeats = 180;
end

%create sessions of about 900 trials/session
%design info
%before calling make_trialTypeMatrix, we need to check if any of the levels
%is equal to 1, find out what they are and pass only the nonsingleton
%factors to make trial type matrix. afterwards, add ones in the column
%dedicated for that factor.
factorLevels = [nSetSizes+1, nTrialType];
singFactors = find(factorLevels==1);

%this approach assumes 2 set sizes, 1 exposure durations etc
%3 blocks of about 306 trials for 918 overall to get 153 trials for each
%set size at each activity level.

if ~isempty(singFactors)
    nonSingFactors = find(factorLevels~=1);
    singFactors = find(factorLevels==1);
    tempTrials = make_trialTypeMatrix(1,size(nonSingFactors,2),factorLevels(nonSingFactors));
    trialSequence = zeros(size(tempTrials,1),size(factorLevels,2));
    for i = 1:size(nonSingFactors,2)
        trialSequence(:,nonSingFactors(i))=tempTrials(:,i);
    end
    for i =1:size(singFactors,2)
        trialSequence(:,singFactors(i))=1;
    end
    clear tempTrials;
else
    trialSequence = make_trialTypeMatrix(numrepeats,size(factorLevels,2),factorLevels);
end
for i = 1:7
    newOrder = randperm(size(trialSequence,1));
    trialSequence = trialSequence(newOrder,:);
end

allSessionSequences = zeros(1,size(trialSequence,1),size(trialSequence,2));

allSessionSequences(1,:,:)=trialSequence(:,:);    
    
%save trial sequences
saveFile=[KfilePath outFile];
save(saveFile, 'allSessionSequences');

return

