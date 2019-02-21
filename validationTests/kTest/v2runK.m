
function v2runK

%===========================================
% Purpose: run KTest
% Inputs: debug (1 = no, 0 = yes), testing (1 = test, 0 = practice)
% Author: Lindsey
%===========================================
% update: Feb 2019
% author: Danny
% purpose: to use as validation for AD Task. cleaned up certain parts to
% flow a little smoother. full comments on each change are in KTask folder
% design update = numTrials will be 390 for all participants
%===========================================
exp=0; %1 for experiment, 0 for testing/debugging
laptopDebug=1;  %added input to KTest to work on latop. turns off synchronization and sets ifi to 1/60 - D

if exp == 1
    sjNum = input('Input subject number: ');
    sjAge = input('Please enter participant age: ');
    sjGender = input('Please enter participant gander (M or F): ','s');
    sjHand = input('Please enter participant handedness (L or R):  ','s');
else
    sjNum = 99;
    sjAge = 22;
    sjGender='M';
    sjHand = 'R';
end

sjFile=sprintf('sj%02dInfo.mat',sjNum);
save(sjFile,'sjNum','sjAge','sjGender','sjHand');

numTrials = 390;        %can be 390, 720, or 1080, going to go with 390   

%don't need to counterbalance setSize b/c makeTrialTypeMatrix

%not using K_info_setup b/c intergated function into k_make_trial    
v2K_make_trialSequences(sjNum,sjAge,sjHand,numTrials)
v2KTest(sjNum,numTrials,exp,laptopDebug)

ShowCursor;
    
end
