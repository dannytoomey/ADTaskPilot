

numTask=2;
numCue=2;
numSub=11;

numBins=numTask*numCue;
varBins=zeros(1,numBins);

sjdataMat=nan(numTask,numCue,numSub);

sjdataMat(1,1,:)=[1 2 3 4 5 6 7 8 9 10 NaN];          %standDev=3.0277 -0.5554<array<11.5554 mean=5.5
sjdataMat(1,2,:)=[2 4 6 8 10 12 14 16 18 20 NaN];     %standDev=6.0553 -1.1106<array<23.1106 mean=11
sjdataMat(2,1,:)=[1 26 26 27 28 29 27 55 25 25 NaN];  %standDev=12.8015 1.297<array<52.503 mean=26.625
sjdataMat(2,2,:)=[5 5 5 5 20 5 5 5 5 5 NaN];          %standDev=4.7434  -2.9868<array<15.9868 mean=5

count=1;
thisVar='xTest';
% 
% useSubs=~isnan(sjdataMat);
% dataMat=nan;
% 
% for var=1:numVar
%     for cond=1:numCond
%         for task=1:numTask
%             for cue=1:numCue
%                 use=find(useSubs(var,cond,task,cue,:)~=0);
%                 for sub=1:size(use,1)
%                     dataMat(var,cond,task,cue,sub)=sjdataMat(var,cond,task,cue,use(sub,1));
%                 end
%                     
%                 
%             end
%         end
%     end
% end
% 


% dataMat=nan(numVar,numCond,numTask,numCue,[]);
% 
% for cond=1:numCond
%     for task=1:numTask
%         for cue=1:numCue
%             thisSubs=sjdataMat(var,cond,task,cue,:);
%             useSubs=thisSubs(~isnan(thisSubs));
%             numSub=size(useSubs,2);
%             for sub=1:numSub
%                 dataMat(var,cond,task,cue,sub)=useSubs(1,sub);
%             end
%         end
%     end
% end
% 

for task=1:numTask
    for cue=1:numCue
        useScores=(~isnan(sjdataMat(task,cue,:)));
        thisScores=find(useScores~=0);
        graphScores=zeros(1,size(thisScores,1));
        for score=1:size(thisScores,1)
            graphScores(1,score)=sjdataMat(task,cue,thisScores(score,1));
        end
        meanVar=mean(graphScores);
        sqDev=(graphScores-meanVar).^2;
        SS=sum(sqDev);
        numScores=size(graphScores,2);
        standDev=sqrt(SS/(numScores-1));
        normScores=nan(1,numScores);
        for x=1:numScores
            if abs(graphScores(1,x)-meanVar)<=(2*standDev)
                normScores(1,x)=graphScores(1,x);
            end
        end
        normGraph=normScores(~isnan(normScores));
        varBins(1,count)=mean(normGraph);
        count=count+1;
    end
end

bar(varBins)
ylabel(thisVar,'FontSize',12);
file=['/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/4LocResp/4LocResp/graphs/' sprintf('%s',thisVar)];
saveas(gcf,file,'png');

graph=imread([file '.png']);
label=imread('/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/4LocResp/4LocResp/graphs/xLabel1167.png');


% annotation('textbox',[.01 .01 .1 .1],'String','Text outside the axes','EdgeColor','none')
% annotation('textbox',[.01 0 .1 .1],'String','Text outside the axes','EdgeColor','none')

% 
% figure;
% h=[];
% h(1) = subplot(2,2,1);
% h(2) = subplot(2,2,2);
% image(graph,'Parent',h(1));
% image(label,'Parent',h(2));

% imageRows=size(graph,1)+size(label,1);
% imageCols=size(graph,2);
% numColor=3;
% imageMat=nan(imageRows,imageCols,numColor);
% imageMat(1:size(graph,1),:,:)=graph(:,:,:);
% imageMat(1+size(graph,1):size(graph,1)+size(label,1),:,:)=label(:,:,:);
% 
% imagesc(imageMat)    
