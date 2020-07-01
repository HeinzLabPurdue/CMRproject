% File: PsychometricCurve_CMR.m
% Created: Fernando Aguilera - Jun 28 2020
% Last Modified by: Fernando Aguilera de Alba - July 1 2020
%% Goal
% Generate psychometric curver for REF, CORR, and ACORR conditions from user data for CMR pilot testing.
clear all;close all;clc;
%% Requirement
% Load all blocks from user files from CMRpilot_results folder
userID = input('User ID: ','s');
blocks = input('How many blocks of data will you analyze?: ');
cd CMRpilot_results % open pilot data folder 
% create vector for each condition with data from all blocks
for i = 1:blocks
    filename = [userID '_Block' num2str(i) '_CMR2_Human_Pilot_Results.mat'];
    load(filename);
    REFresults_avg(:,i+1) = (REFtonescore(:,2)/2)*100;
    CORRresults_avg(:,i+1) = (CORRtonescore(:,2)/2)*100;
    ACORRresults_avg(:,i+1) = (ACORRtonescore(:,2)/2)*100;
    fprintf('\nFile loaded:%s ',filename);
end
cd ../
REFresults_avg(:,1) = levelVEC_tone_dBSPL'; CORRresults_avg(:,1) = levelVEC_tone_dBSPL'; ACORRresults_avg(:,1) = levelVEC_tone_dBSPL';
%% Average results
REF = 0; CORR = 0; ACORR = 0;
for j = 1:length(levelVEC_tone_dBSPL)
    for i = 1:blocks
        REF = REF + REFresults_avg(j,i+1);
        CORR = CORR + CORRresults_avg(j,i+1);
        ACORR = ACORR + ACORRresults_avg(j,i+1);
    end
    REFresults_avg(j,(blocks+2)) = (REF/blocks);
    CORRresults_avg(j,(blocks+2)) = (CORR/blocks);
    ACORRresults_avg(j,(blocks+2)) = (ACORR/blocks);
    REF = 0; CORR = 0; ACORR = 0;
end
%% Psychometric curve generation for each block
for i = 2:(blocks+1)
figure;
subplot(1,3,1); % REF 
scatter(REFresults_avg(:,1),REFresults_avg(:,i),'*','LineWidth', 1.5); % scatter plot of average REF
REFplot = sprintf('Psychometric Curve (Condition: REF | Block: %d)', i-1);
title(REFplot);
xlabel('Tone Level (dB)'); ylabel('Correctness (%)');
ylim([0,110]);
subplot(1,3,2); % CORR
scatter(CORRresults_avg(:,1),CORRresults_avg(:,i),'*','LineWidth', 1.5); % scatter plot of average CORR
CORRplot = sprintf('Psychometric Curve (Condition: CORR | Block: %d)', i-1);
title(CORRplot);
xlabel('Tone Level (dB)'); ylabel('Correctness (%)');
ylim([0,110]);
subplot(1,3,3); % ACORR
scatter(ACORRresults_avg(:,1),ACORRresults_avg(:,i),'*','LineWidth', 1.5); % scatter plot of average ACORR
ACORRplot = sprintf('Psychometric Curve (Condition: ACORR | Block: %d)', i-1);
title(ACORRplot);
xlabel('Tone Level (dB)'); ylabel('Correctness (%)');
ylim([0,110]);
end
%% Psychometric curve generation average
figure;
subplot(1,3,1); % REF 
scatter(REFresults_avg(:,1),REFresults_avg(:,(blocks+2)),'*','LineWidth', 1.5); % scatter plot of average REF
title('Average Psychometric Curve (Condition: REF)');
xlabel('Tone Level (dB)'); ylabel('Correctness (%)');
ylim([0,110]);
subplot(1,3,2); % CORR
scatter(CORRresults_avg(:,1),CORRresults_avg(:,(blocks+2)),'*','LineWidth', 1.5); % scatter plot of average CORR
title('Average Psychometric Curve (Condition: CORR)');
xlabel('Tone Level (dB)'); ylabel('Correctness (%)');
ylim([0,110]);
subplot(1,3,3); % ACORR
scatter(ACORRresults_avg(:,1),ACORRresults_avg(:,(blocks+2)),'*','LineWidth', 1.5); % scatter plot of average ACORR
title('Average Psychometric Curve (Condition: ACORR)');
xlabel('Tone Level (dB)'); ylabel('Correctness (%)');
ylim([0,110]);