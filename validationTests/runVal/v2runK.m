
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

%numTrials = 390;        %can be 390, 720, or 1080, going to go with 390   

numTrials=180;  %5 blocks*36 trials/block. changed from 40 to 36 to work with make_trialTypeMatrix
                %doing this to cut down on time. a lot less than the original experiment, 
                %but still provides 60 meaures per set size and 90
                %measures per change cond
                
%don't need to counterbalance setSize b/c makeTrialTypeMatrix

%not using K_info_setup b/c intergated function into k_make_trial    
v2K_make_trialSequences(sjNum,numTrials,KfilePath)

practice=1;  %run a practice block
v2KTest(sjNum,numTrials,exp,KfilePath,practice,laptopDebug)  %laptopDebug turns off synchronization and sets ifi to 1/60 - D
practice=0;  %run the experiment
v2KTest(sjNum,numTrials,exp,KfilePath,practice,laptopDebug)

ShowCursor;
    
end
