function runANT(subjectNumber)
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

laptopDebug=1;
if laptopDebug==1
    Screen('Preference','SkipSyncTests',1);
    subjectNumber=99;
else
    subjectNumber=input('Input Subject Number ');
end

mySOA = [300,600,900];
nSOA = size(mySOA,2);
logFileName = sprintf('s%02d_allData.txt',subjectNumber);

makeImgJudgement = 0;
practice = 0;
[trialMatrix,targets]=ANT(subjectNumber,logFileName,mySOA,practice,laptopDebug);

practice = 0;
[trialMatrix,targets]=ANT(subjectNumber,logFileName,mySOA,practice,laptopDebug);

