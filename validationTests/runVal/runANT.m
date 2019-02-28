function runANT(sjNum,laptopDebug,ANTfilePath)
%=========================================================
% function: runiLab01Sj
% purpose: to run the ilab experiment
% inputs:  subject number (integer)
% usage:   runiLab01Sj(subjectNumber)
%          This function sets up the conditions
%          for the iLab experiment and then 
%          executes a call to the experimental program
%          iLab.m. The output includes two figures for
%          T1 accuracy and conditionalized T2 accuracy
%          and a summary data file with the paramters
%          subject number, date and time, and the summary
%          statistics for the subjects.
% date:    Feb 28, 2005
% author:  Barry
%=========================================================

%Experiment Parameters
%lags are 300 and 700 ms

mySOA = [300,600,900];
logFileName = [ANTfilePath sprintf('s%02d_allANTData.txt',sjNum)];

makeImgJudgement = 0;
practice = 1;
[trialMatrix,targets]=ANT(sjNum,logFileName,mySOA,practice,laptopDebug);

practice = 0;
[trialMatrix,targets]=ANT(sjNum,logFileName,mySOA,practice,laptopDebug);

