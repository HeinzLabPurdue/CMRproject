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
for i = 1:blocks+1
plotlegend(i,:) = ['Block ' num2str(i)];
if i == blocks+1
    plotlegend(i,:) = ['Average'];
end
end

Markers = {'+','o','*','x','v','d','^','s','>','<'};
counter = 1;


for i = 2:(blocks+1)
% REF
figure(1);
hold on;
plot(REFresults_avg(:,1),REFresults_avg(:,i),strcat(Markers{counter})); % scatter plot of block REF
hold off;
% CORR
figure(2);
hold on;
scatter(CORRresults_avg(:,1),CORRresults_avg(:,i),strcat(Markers{counter})); % scatter plot of block CORR
hold off;
% ACORR
figure(3);
hold on;
scatter(ACORRresults_avg(:,1),ACORRresults_avg(:,i),strcat(Markers{counter})); % scatter plot of block ACORR
hold off;
counter = counter + 1; 
end
%% Psychometric curve generation average
REFplot = sprintf('Psychometric Curve (Condition: REF | User ID: %s)', userID);
CORRplot = sprintf('Psychometric Curve (Condition: CORR | User ID: %s)', userID);
ACORRplot = sprintf('Psychometric Curve (Condition: ACORR | User ID: %s)', userID);

figure(1); % REF 
hold on;
plot(REFresults_avg(:,1),REFresults_avg(:,(blocks+2)),'*--','LineWidth', 1.5); % scatter plot of average REF
title(REFplot); xlabel('Tone Level (dB)'); ylabel('Correctness (%)'); ylim([0,110]);
legend(plotlegend,'Location','SouthEast');
hold off;
figure(2); % CORR
hold on;
plot(CORRresults_avg(:,1),CORRresults_avg(:,(blocks+2)),'*--','LineWidth', 1.5); % scatter plot of average CORR
title(CORRplot); xlabel('Tone Level (dB)'); ylabel('Correctness (%)'); ylim([0,110]);
legend(plotlegend,'Location','SouthEast');
hold off;
figure(3); % ACORR
hold on;
plot(ACORRresults_avg(:,1),ACORRresults_avg(:,(blocks+2)),'*--','LineWidth', 1.5); % scatter plot of average ACORR
title(ACORRplot); xlabel('Tone Level (dB)'); ylabel('Correctness (%)'); ylim([0,110]);
legend(plotlegend,'Location','SouthEast');
hold off;