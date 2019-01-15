
load('sj105_allDotTaskFile.mat');

numTask=2;
numCue=2;
cueRec=zeros(1,numCue);
taskRec=zeros(numCue,numTask);

for task=1:numTask
    for cue=1:numCue
        blockWM=allDotTask(task).thisTaskData(cue).thisCondData(8).thisBlockWM;
        blockWMload=blockWM(1:5,:);
        blockWMprobe=blockWM(6:10,:);
        WMletter=zeros(1,size(blockWM,2));
        for block=1:size(blockWM,2)
            letterInLoad=0;
            thisBlockWM=blockWMload(:,block);
            for letter=1:size(blockWMload,1)
                resp=find(blockWMprobe(letter,block)==thisBlockWM);
                if 0<resp
                    letterInLoad=letterInLoad+1;
                end
                acLetter=letterInLoad/size(blockWMload,1);
            end
            meanWMletter(1,block)=acLetter;
        end
        acWMletter=sum(meanWMletter)/numel(meanWMletter);
        cueRec(1,cue)=acWMletter;
    end
    taskRec(:,task)=cueRec;
end

