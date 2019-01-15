
% runfile for ADTaskv2

sjNum = input('Input Subject Number ');
condCBOrder = input('Input Condition CB Order ');
taskCBOrder = input('Input Task CB Order ');
age = input('Input Age ');
gender = input('Input Gender (0 = M, 1 = F) ');
handedness = input('Input Handedness (0 = L, 1 = R) ');


filePath = '/Users/labadmin/Documents/Experiments/ADTask/data';


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
    practiceCond(sjNum)
    lowIntfCond(sjNum)
    medIntfCond(sjNum)
    highIntfCond(sjNum)
elseif condCBOrder==2
    practiceCond(sjNum)
    lowIntfCond(sjNum)
    highIntfCond(sjNum)
    medIntfCond(sjNum)
elseif condCBOrder==3
    practiceCond(sjNum)
    medIntfCond(sjNum)
    lowIntfCond(sjNum)
    highIntfCond(sjNum)
elseif condCBOrder==4
    practiceCond(sjNum)
    medIntfCond(sjNum)
    highIntfCond(sjNum)
    lowIntfCond(sjNum)
elseif condCBOrder==5
    practiceCond(sjNum)
    highIntfCond(sjNum)
    lowIntfCond(sjNum)
    medIntfCond(sjNum)
elseif condCBOrder==6
    practiceCond(sjNum)
    highIntfCond(sjNum)
    medIntfCond(sjNum)
    lowIntfCond(sjNum)
end
