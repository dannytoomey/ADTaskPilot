
% runfile for 4LocTask

sjNum = input('Input Subject Number ');
age = input('Input Age ');
gender = input('Input Gender (0 = M, 1 = F) ');
handedness = input('Input Handedness (0 = L, 1 = R) ');

counterBal=[1	2	3	4	5	6	1	2	3	4	5	6	1	2	3	4	5	6	1	2	3	4	5	6	1	2	3	4	5	6	1	2	3	4	5	6
            1	2	3	4	5	6	2	3	4	5	6	1	3	4	5	6	1	2	4	5	6	1	2	3	5	6	1	2	3	4	6	1	2	3	4	5];

if sjNum==99
    taskCBOrder=input('Input Task Order ');
    condCBOrder=input('Input Condition Order ');
elseif sjNum<=36
    taskCBOrder=counterBal(1,sjNum);
    condCBOrder=counterBal(2,sjNum);
else
    cycle=floor(sjNum/36);
    orderNum=sjNum-(36*cycle);    
    if orderNum==0
        taskCBOrder=6;
        condCBOrder=5;
    else
        taskCBOrder=counterBal(1,orderNum);
        condCBOrder=counterBal(2,orderNum);
    end
end

filePath = '/Users/labadmin/Documents/Experiments/ADTask/4LocResp/4LocResp/4LocRespData';
save([filePath '/' sprintf('sj%02d_SubjectInfo.mat',sjNum)],'age','gender','handedness','condCBOrder','taskCBOrder');

if taskCBOrder==1
    lowTaskOrder = 1;
    medTaskOrder = 1;
    highTaskOrder = 1;
elseif taskCBOrder==2
    lowTaskOrder = 2;
    medTaskOrder = 1;
    highTaskOrder = 1;
elseif taskCBOrder==3
    lowTaskOrder = 2;
    medTaskOrder = 2;
    highTaskOrder = 1;
elseif taskCBOrder==4
    lowTaskOrder = 2;
    medTaskOrder = 2;
    highTaskOrder = 2;
elseif taskCBOrder==5
    lowTaskOrder = 1;
    medTaskOrder = 2;
    highTaskOrder = 2;
elseif taskCBOrder==6
    lowTaskOrder = 1;
    medTaskOrder = 1;
    highTaskOrder = 2;
end

save('taskCBOrder.mat','lowTaskOrder','medTaskOrder','highTaskOrder','filePath');

if condCBOrder==1
    practiceCond4Loc_v2(sjNum)
    lowIntfCond4Loc(sjNum)
    medIntfCond4Loc(sjNum)
    highIntfCond4Loc_v2(sjNum)
elseif condCBOrder==2
    practiceCond4Loc_v2(sjNum)
    lowIntfCond4Loc(sjNum)
    highIntfCond4Loc_v2(sjNum)
    medIntfCond4Loc(sjNum)
elseif condCBOrder==3
    practiceCond4Loc_v2(sjNum)
    medIntfCond4Loc(sjNum)
    lowIntfCond4Loc(sjNum)
    highIntfCond4Loc_v2(sjNum)
elseif condCBOrder==4
    practiceCond4Loc_v2(sjNum)
    medIntfCond4Loc(sjNum)
    highIntfCond4Loc_v2(sjNum)
    lowIntfCond4Loc(sjNum)
elseif condCBOrder==5
    practiceCond4Loc_v2(sjNum)
    highIntfCond4Loc_v2(sjNum)
    lowIntfCond4Loc(sjNum)
    medIntfCond4Loc(sjNum)
elseif condCBOrder==6
    practiceCond4Loc_v2(sjNum)
    highIntfCond4Loc_v2(sjNum)
    medIntfCond4Loc(sjNum)
    lowIntfCond4Loc(sjNum)
end
