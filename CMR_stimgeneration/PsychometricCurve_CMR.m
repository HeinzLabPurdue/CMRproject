% File: Pilot_CMR_testing.m
% Created: Fernando Aguilera - Jun 16 2020
% Last Modified by: Fernando Aguilera de Alba - June 29 2020
%% Goal
% Generate psychometric curver for REF, CORR, and ACORR conditions from user data for CMR pilot testing.
clear all;close all;clc;
%% Requirement
% Load all 3 blocks from user files from CMRpilot_results folder
cd CMRpilot_results % open pilot data folder 
blocks = input('How many blocks of data will you analyze?: ');
% create vector for each condition with data from all blocks
for i = 1:blocks
    fprintf('\nBlock #%d\n',i);
    block = input('Filename: ','s'); % LINE MODIFIED
    load(block);
    REFresults_avg(:,i+1) = REFtonescore(:,2);
    CORRresults_avg(:,i+1) = CORRtonescore(:,2);
    ACORRresults_avg(:,i+1) = ACORRtonescore(:,2);
end
REFresults_avg(:,1) = levelVEC_tone_dBSPL'; CORRresults_avg(:,1) = levelVEC_tone_dBSPL'; ACORRresults_avg(:,1) = levelVEC_tone_dBSPL';
%% Average results
REF = 0; CORR = 0; ACORR = 0;
for j = 1:length(levelVEC_tone_dBSPL)
    for i = 1:blocks
        REF = REF + REFresults_avg(j,i+1);
        CORR = CORR + CORRresults_avg(j,i+1);
        ACORR = ACORR + ACORRresults_avg(j,i+1);
    end
    REFresults_avg(j,(blocks+2)) = (REF/blocks)*100/2;
    CORRresults_avg(j,(blocks+2)) = (CORR/blocks)*100/2;
    ACORRresults_avg(j,(blocks+2)) = (ACORR/blocks)*100/2;
    REF = 0; CORR = 0; ACORR = 0;
end
%% Psychometric curve generation
figure(1);
plot(REFresults_avg(:,1),REFresults_avg(:,(blocks+2)),'LineWidth', 1.5);
title('Psychometric Curve (Condition: REF)');
xlabel('Tone Level (dB)'); ylabel('Average Correctness (%)');
ylim([0,110]);
figure(2);
plot(CORRresults_avg(:,1),CORRresults_avg(:,(blocks+2)),'LineWidth', 1.5);
title('Psychometric Curve (Condition: CORR)');
xlabel('Tone Level (dB)'); ylabel('Average Correctness (%)');
ylim([0,110]);
figure(3);
plot(ACORRresults_avg(:,1),ACORRresults_avg(:,(blocks+2)),'LineWidth', 1.5);
title('Psychometric Curve (Condition: ACORR)');
xlabel('Tone Level (dB)'); ylabel('Average Correctness (%)');
ylim([0,110]);
