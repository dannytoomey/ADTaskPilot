
function analyzeDiv2(sjRange)

numTrials=18;

for sub=1:size(sjRange,2)
    
    thisSub=sjRange(1,sub);
    load(['/Users/dannytoomey/Documents/Research/ADTask/Experiments/ADTaskPilot/validationTests/dividedTest/'...
        'sj' sprintf('%02d',thisSub) '_allDivData.mat'])
    
    if thisSub==99
        tasks=size(testData,2);
    else
        tasks=size(allData,2);
    end 
    
    for task=1:tasks
        
        if thisSub==99
            thisTask=testData(task).thisTask;
            condData=testData(task).condData;
        else
            thisTask=allData(task).thisTask;
            condData=allData(task).condData;
        end
        
        if thisSub==99
            if thisTask==1
                numCond=2;
            else
                numCond=1;
            end
        else
            if thisTask==1
                numCond=4;
            else
                numCond=2;
            end
        end
        
        for cond=1:numCond
            
            for trial=1:numTrials
                
                resps=[condData(cond).blockTrials(trial).resp1,condData(cond).blockTrials(trial).resp2,...
                    condData(cond).blockTrials(trial).resp3,condData(cond).blockTrials(trial).resp4];
                targets=[condData(cond).blockTrials(trial).target1,condData(cond).blockTrials(trial).target2,...
                    condData(cond).blockTrials(trial).target3,condData(cond).blockTrials(trial).target4];
                
                for stim=1:4
                    respDataMat(task,cond,trial,thisSub,stim)=resps(1,stim);
                    tarDataMat(task,cond,trial,thisSub,stim)=targets(1,stim);
                    if respDataMat(task,cond,trial,thisSub,stim)~=0&&tarDataMat(task,cond,trial,thisSub,stim)==1
                        if thisTask==1
                            singRTMat(cond,trial,thisSub,stim)=respDataMat(task,cond,trial,thisSub,stim);
                        elseif thisTask==2
                            dualRTMat(cond,trial,thisSub,stim)=respDataMat(task,cond,trial,thisSub,stim);
                        end
                        %rtMat(task,cond,trial,thisSub,stim)=respDataMat(task,cond,trial,thisSub,stim);
                    else
                        if thisTask==1
                            singRTMat(cond,trial,thisSub,stim)=NaN;
                        elseif thisTask==2
                            dualRTMat(cond,trial,thisSub,stim)=NaN;
                        end
                    end
                    if respDataMat(task,cond,trial,thisSub,stim)~=0&&tarDataMat(task,cond,trial,thisSub,stim)==1||...
                         respDataMat(task,cond,trial,thisSub,stim)==0&&tarDataMat(task,cond,trial,thisSub,stim)==0
                        if thisTask==1
                            singAccMat(cond,trial,thisSub,stim)=1;
                        elseif thisTask==2
                            dualAccMat(cond,trial,thisSub,stim)=1;
                        end
                        %accMat(task,cond,trial,thisSub,stim)=1;
                    else
                        if thisTask==1
                            singAccMat(cond,trial,thisSub,stim)=NaN;
                        elseif thisTask==2
                            dualAccMat(cond,trial,thisSub,stim)=NaN;
                        end
                        %accMat(task,cond,trial,thisSub,stim)=NaN;
                    end
                end
            end
        end
    end
end

save('singRTMat.mat','singRTMat')
save('singAccMat.mat','singAccMat')
save('dualRTMat.mat','dualRTMat')
save('dualAccMat.mat','dualAccMat')

for sub=1:size(sjRange,2)
    thisSub=sjRange(sub);
    for task=1:2
        if task==1
            subData=singRTMat(:,:,thisSub,:);
            subData=subData(~isnan(subData));
            normData=subData(abs(subData(:)-mean(subData))<=(2*std(subData)));
            singNorm(sub)=mean(normData);
        elseif task==2
            subData=dualRTMat(:,:,thisSub,:);
            subData=subData(~isnan(subData));
            normData=subData(abs(subData(:)-mean(subData))<=(2*std(subData)));
            dualNorm(sub)=mean(normData);
        end
    end
end

save('singNorm.mat','singNorm')
save('dualNorm.mat','dualNorm')

end

