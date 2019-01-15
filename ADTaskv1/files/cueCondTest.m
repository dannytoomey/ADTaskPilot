
numTrials = 8;
cueOrder=randperm(numTrials);
targetsCues=zeros(2,numTrials);

for trial=1:numTrials

    rng('shuffle');
    boxLctn = randi([0,100]);
    xLctn = [540,740];
    if boxLctn<=50
        CenX = min(xLctn);
    elseif 50<boxLctn
        CenX = max(xLctn);
    end

    dotColors = [0,0,0,0;0,0,0,0;1,1,1,1];
    dot1=0;
    dot2=0;
    dot3=0;
    dot4=0;
    
    thres=numTrials*.25;
    
    if boxLctn<=50
        rng('shuffle');
        targetLoc=randi([1,100]);
        if cueOrder(1,trial)<=thres
            if targetLoc<=50
                dotColors(1,1)=1;
                dotColors(3,1)=0;
                targetsCues(1,trial)=1;
                targetsCues(2,trial)=CenX;
            elseif 50<targetLoc
                dotColors(1,2)=1;
                dotColors(3,2)=0;
                targetsCues(1,trial)=2;
                targetsCues(2,trial)=CenX;
            end
        elseif thres<cueOrder(1,trial)
            if targetLoc<=50
                dotColors(1,3)=1;
                dotColors(3,3)=0;
                targetsCues(1,trial)=3;
                targetsCues(2,trial)=CenX;
            elseif 50<targetLoc
                dotColors(1,4)=1;
                dotColors(3,4)=0;
                targetsCues(1,trial)=4;
                targetsCues(2,trial)=CenX;
            end
        end
    elseif 50<boxLctn
        rng('shuffle');
        targetLoc=randi([1,100]);
        if cueOrder(1,trial)<=thres
            if targetLoc<=50
                dotColors(1,3)=1;
                dotColors(3,3)=0;
                targetsCues(1,trial)=3;
                targetsCues(2,trial)=CenX;
            elseif 50<targetLoc
                dotColors(1,4)=1;
                dotColors(3,4)=0;
                targetsCues(1,trial)=4;
                targetsCues(2,trial)=CenX;
            end
        elseif thres<cueOrder(1,trial)
            if targetLoc<=50
                dotColors(1,1)=1;
                dotColors(3,1)=0;
                targetsCues(1,trial)=1;
                targetsCues(2,trial)=CenX;
            elseif 50<targetLoc
                dotColors(1,2)=1;
                dotColors(3,2)=0;
                targetsCues(1,trial)=2;
                targetsCues(2,trial)=CenX;
            end
        end
    end
end
