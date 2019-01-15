% this will be used to run the different conditions...

sjNum = input('Input Subject Number ');
age = input('Input Age ');
gender = input('Input Gender (0 = M, 1 = F) ');
condCBOrder = input('Input Condition CB Order ');
taskCBOrder = input('Input Task CB Order ');

filePath = '/Users/dannytoomey/Documents/Research/ADTask/ADTaskPilot/data';
save([filePath '/' sprintf('sj%02d_SubjectInfo.mat',sjNum)],'age','gender','condCBOrder','taskCBOrder');


if taskCBOrder==1
    dotTaskOrder = 1;
    neutralTaskOrder = 1;
    stroopTaskOrder = 1;
elseif taskCBOrder==2
    dotTaskOrder = 2;
    neutralTaskOrder = 1;
    stroopTaskOrder = 1;
elseif taskCBOrder==3
    dotTaskOrder = 2;
    neutralTaskOrder = 2;
    stroopTaskOrder = 1;
elseif taskCBOrder==4
    dotTaskOrder = 2;
    neutralTaskOrder = 2;
    stroopTaskOrder = 2;
elseif taskCBOrder==5
    dotTaskOrder = 1;
    neutralTaskOrder = 2;
    stroopTaskOrder = 2;
elseif taskCBOrder==6
    dotTaskOrder = 1;
    neutralTaskOrder = 1;
    stroopTaskOrder = 2;
end

save('taskCBOrder.mat','dotTaskOrder','neutralTaskOrder','stroopTaskOrder','filePath');
    
if condCBOrder==1
    %Condition0_Practice(sjNum)
    Condition1_Dots_v5(sjNum)
    Condition2_Neutral_v4(sjNum)
    Condition3_Stroop_v5(sjNum)
elseif condCBOrder==2
    Condition0_Practice(sjNum)
    Condition1_Dots_v5(sjNum)
    Condition3_Stroop_v5(sjNum)
    Condition2_Neutral_v4(sjNum)
elseif condCBOrder==3
    Condition0_Practice(sjNum)
    Condition2_Neutral_v4(sjNum)
    Condition1_Dots_v5(sjNum)
    Condition3_Stroop_v5(sjNum)
elseif condCBOrder==4
    Condition0_Practice(sjNum)
    Condition2_Neutral_v4(sjNum)
    Condition3_Stroop_v5(sjNum)
    Condition1_Dots_v5(sjNum)
elseif condCBOrder==5
    Condition0_Practice(sjNum)
    Condition3_Stroop_v5(sjNum)
    Condition1_Dots_v5(sjNum)
    Condition2_Neutral_v4(sjNum)
elseif condCBOrder==6
    Condition0_Practice(sjNum)
    Condition3_Stroop_v5(sjNum)
    Condition2_Neutral_v4(sjNum)
    Condition1_Dots_v5(sjNum)
end
