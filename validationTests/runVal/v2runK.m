
function v2runK(sjNum,laptopDebug,KfilePath,exp)

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

numTrials = 390;        %can be 390, 720, or 1080, going to go with 390   

%don't need to counterbalance setSize b/c makeTrialTypeMatrix

%not using K_info_setup b/c intergated function into k_make_trial    
v2K_make_trialSequences(sjNum,numTrials,KfilePath)
v2KTest(sjNum,numTrials,exp,KfilePath,laptopDebug)  %laptopDebug turns off synchronization and sets ifi to 1/60 - D

ShowCursor;
    
end
