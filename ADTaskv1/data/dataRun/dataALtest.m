
%test on small set of data to make sure analysis methods are correct

data=[1,1,0,1,1,1,0,1;1,0,1,0,1,0,1,0;0,1,1,1,0,1,1,1;1,1,1,1,1,1,1,1;740,540,540,540,740,540,540,540;300,300,300,300,600,600,300,300;2,1,0,1,2,0,0,1;0.354860973020550,0.245418464997783,0.998900000000000,0.226365971000632,0.354860973020550,0.986700000000000,0.978900000000000,0.226365971000632];
resp = find(data(7,:)>0);
numResp=numel(resp);
trials = size(data,2);
errorOm = trials-numResp;
rt = zeros(1,trials-errorOm);
for count=1:trials-errorOm
    rt(1,count)=data(8,resp(1,count));
end
ac = zeros(1,trials);
for count=1:trials
    if data(6,count)==300
        if data(7,count)==1
            if data(1,count)==1
                ac(1,count)=1;
            elseif data(2,count)==1
                ac(1,count)=1;
            end
        elseif data(7,count)==2
            if data(3,count)==1
                ac(1,count)=1;
            elseif data(4,count)==1
                ac(4,count)=1;
            end
        end
    end
    if data(6,count)==600
        if data(7,count)==0
            ac(1,count)=1;
        elseif data(7,count)~=0
            ac(1,count)=0;
        end
    end
end

correct = find(ac==1);
numCorrect = numel(correct);
accuracy = numCorrect/trials;
meanRT = mean(rt);
