% File: PsychometricCurve_CMR.m
% Created: Fernando Aguilera - Jun 28 2020
% Last Modified by: Fernando Aguilera de Alba - July 7 2020
%% Goal
% Generate psychometric curver for REF, CORR, and ACORR conditions from user data for CMR pilot testing.
clear all; close all; clc;
%% Requirement
CMRstimuli = input('\nType of CMR stimuli: ','s');
subject = input('\nSubject --> Chinchilla (C) OR Human (H): ','s');
if subject == 'H' || subject == 'h'
    subject = 'Human';
elseif subject == 'C' || subject == 'c'
    subject = 'Chin';
else
    error('Please enter a valid character (C or H)');
end
filename = sprintf('%s_%s_Stimuli.mat',CMRstimuli, subject);
cd new_signals
cd CMR2B % CHANGE FOLDER TO TYPE OF STIMULI
load(filename,'CMRcondition');
cd ../
cd ../
% Load all blocks from user files from CMRpilot_results folder
fprintf('\nAnalyze individual subject data -- 1');
fprintf('\nAnalyze all subjects data -- 2');
menuresponse = input('\n\nMenu option: ');
while isempty(menuresponse)
    fprintf('\n\nERROR: Invalid menu option');
    menuresponse = input('\n\nMenu option: ');
end
%% Individual data
if menuresponse == 1
    userid = input('\nUser ID: ','s');
    blocks = input('Number of blocks: ');
    cd CMRpilot_results % open pilot data folder
    cd CMR2B % CHANGE FOLDER TO TYPE OF STIMULI
% load files for subject based on userid    
    for i = 1:blocks   
        filename = [userid '_Block' num2str(i) '_' CMRcondition '_Pilot_Results.mat'];
        load(filename);
        REFresults_avg(:,i+1) = (REFtonescore(:,2)/2)*100;
        CORRresults_avg(:,i+1) = (CORRtonescore(:,2)/2)*100;
        ACORRresults_avg(:,i+1) = (ACORRtonescore(:,2)/2)*100;
        fprintf('\nFile loaded:%s ',filename);
    end
    cd ../
    cd ../
% Average results
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
REFresults_avg(:,1) = levelVEC_tone_dBSPL'; CORRresults_avg(:,1) = levelVEC_tone_dBSPL'; ACORRresults_avg(:,1) = levelVEC_tone_dBSPL';
%% Psychometric curve generation for each block
plotlegend = string(zeros(blocks,1));
for i = 1:blocks
plotlegend(i,1) = ['Block ' num2str(i)];
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
criteria = 75; % 
REFplot = sprintf('Psychometric Curve (Condition: REF | User ID: %s)', userid);
CORRplot = sprintf('Psychometric Curve (Condition: CORR | User ID: %s)', userid);
ACORRplot = sprintf('Psychometric Curve (Condition: ACORR | User ID: %s)', userid);

figure(1); % REF 
hold on;
title(REFplot); xlabel('Tone Level (dB)'); ylabel('Correctness (%)'); xlim([levelVEC_tone_dBSPL(1) levelVEC_tone_dBSPL(end)]); ylim([0,110]);
fitPsychometricFunctionCMR(REFresults_avg(:,1), REFresults_avg(:,(blocks+2)), 1, criteria);
legend(plotlegend(1:blocks,:),'Location','SouthEast');
hold off;

figure(2); % CORR
hold on;
title(CORRplot); xlabel('Tone Level (dB)'); ylabel('Correctness (%)'); xlim([levelVEC_tone_dBSPL(1) levelVEC_tone_dBSPL(end)]); ylim([0,110]);
fitPsychometricFunctionCMR(CORRresults_avg(:,1), CORRresults_avg(:,(blocks+2)), 1, criteria);
legend(plotlegend(1:blocks,:),'Location','SouthEast');
hold off;

figure(3); % ACORR
hold on;
title(ACORRplot); xlabel('Tone Level (dB)'); ylabel('Correctness (%)'); xlim([levelVEC_tone_dBSPL(1) levelVEC_tone_dBSPL(end)]); ylim([0,110]);
fitPsychometricFunctionCMR(ACORRresults_avg(:,1), ACORRresults_avg(:,(blocks+2)), 1, criteria);
legend(plotlegend(1:blocks,:),'Location','SouthEast');
hold off;

cd CMRpilot_results
cd CMR2B % CHANGE FOLDER TO TYPE OF STIMULI
cd Psychometric_Curves_CMR2B % CHANGE FOLDER TO TYPE OF STIMULI
cd Subject_Average_CMR2B % CHANGE FOLDER TO TYPE OF STIMULI
plotnameREF = sprintf('%s_Block_Averages_REF_%s_Pilot_Results.jpg',userid, CMRcondition);
plotnameCORR = sprintf('%s_Block_Averages_CORR_%s_Pilot_Results.jpg',userid, CMRcondition);
plotnameACORR = sprintf('%s_Block_Averages_ACORR_%s_Pilot_Results.jpg',userid, CMRcondition);
saveas(figure(1), plotnameREF); saveas(figure(2), plotnameCORR); saveas(figure(3), plotnameACORR);
cd ../
cd ../
cd ../
end

%% All subjects
REFtotalavg = []; CORRtotalavg = []; ACORRtotalavg = [];
if menuresponse == 2
    numsubjects = input('\nNumber of Subjects: ');
    cd CMRpilot_results % open pilot data folder   
    cd CMR2B % CHANGE FOLDER TO TYPE OF STIMULI
% load files for each subject based on userid    
for i = 1:numsubjects
        fprintf('\n\nUser ID #%d: ', i); userid = input('','s');
        blocks = input('Number of blocks: ');
        plotlegend(i,:) = ['Subject: ' userid ', Blocks: ' mat2str(blocks)];
        for j = 1:blocks
            filename = [userid '_Block' num2str(j) '_' CMRcondition '_Pilot_Results.mat'];
            load(filename);
            REFresults_avg(:,j+1) = (REFtonescore(:,2)/2)*100;
            CORRresults_avg(:,j+1) = (CORRtonescore(:,2)/2)*100;
            ACORRresults_avg(:,j+1) = (ACORRtonescore(:,2)/2)*100;
            fprintf('\nFile loaded:%s ',filename);
        end
% Average results for each subject's block
    REF = 0; CORR = 0; ACORR = 0;
    for j = 1:length(levelVEC_tone_dBSPL)
        for k = 1:blocks
            REF = REF + REFresults_avg(j,k+1);
            CORR = CORR + CORRresults_avg(j,k+1);
            ACORR = ACORR + ACORRresults_avg(j,k+1);
        end
    REFresults_avg(j,(blocks+2)) = (REF/blocks);
    CORRresults_avg(j,(blocks+2)) = (CORR/blocks);
    ACORRresults_avg(j,(blocks+2)) = (ACORR/blocks);
    REF = 0; CORR = 0; ACORR = 0;
    end
    REFtotalavg(:,i+1) = REFresults_avg(:,blocks+2); 
    CORRtotalavg(:,i+1) = CORRresults_avg(:,blocks+2); 
    ACORRtotalavg(:,i+1) = ACORRresults_avg(:,blocks+2); 
end
% Average results for all subjects
  REFall = 0; CORRall = 0; ACORRall = 0;
    for j = 1:length(levelVEC_tone_dBSPL)
        for k = 1:numsubjects
            REFall = REFall + REFtotalavg(j,k+1);
            CORRall = CORRall + CORRtotalavg(j,k+1);
            ACORRall = ACORRall + ACORRtotalavg(j,k+1);
        end
    REFtotalavg(j,(numsubjects+1)) = (REFall/numsubjects);
    CORRtotalavg(j,(numsubjects+1)) = (CORRall/numsubjects);
    ACORRtotalavg(j,(numsubjects+1)) = (ACORRall/numsubjects);
    REFall = 0; CORRall = 0; ACORRall = 0;
    end
cd ../
cd ../
REFtotalavg(:,1) = levelVEC_tone_dBSPL'; CORRtotalavg(:,1) = levelVEC_tone_dBSPL'; ACORRtotalavg(:,1) = levelVEC_tone_dBSPL'; 
%% Psychometric curve generation for each subject's average
Markers = {'+','o','*','x','v','d','^','s','>','<'};
counter = 1;
for i = 2:(numsubjects+1)
% REF
figure(1);
hold on;
plot(REFtotalavg(:,1),REFtotalavg(:,i),strcat(Markers{counter})); % scatter plot of block REF
hold off;
% CORR
figure(2);
hold on;
scatter(CORRtotalavg(:,1),CORRtotalavg(:,i),strcat(Markers{counter})); % scatter plot of block CORR
hold off;
% ACORR
figure(3);
hold on;
scatter(ACORRtotalavg(:,1),ACORRtotalavg(:,i),strcat(Markers{counter})); % scatter plot of block ACORR
hold off;
counter = counter + 1; 
end
%% Psychometric curve generation average
criteria = 75; % 
REFplot = sprintf('Subject Averages Psychometric Curve (Condition: REF | Subjects: %d)',numsubjects);
CORRplot = sprintf('Subject Averages Psychometric Curve (Condition: CORR | Subjects: %d)',numsubjects');
ACORRplot = sprintf('Subject Averages Psychometric Curve (Condition: ACORR | Subjects: %d)',numsubjects');

figure(1); % REF 
hold on;
fitPsychometricFunctionCMR(REFtotalavg(:,1), REFtotalavg(:,(numsubjects+1)), 1, criteria);
title(REFplot); xlabel('Tone Level (dB SPL)'); ylabel('Correctness (%)'); xlim([levelVEC_tone_dBSPL(1) levelVEC_tone_dBSPL(end)]);ylim([0,110]);
legend(plotlegend(1:numsubjects,:),'Location','SouthEast');
hold off;

figure(2); % CORR
hold on;
fitPsychometricFunctionCMR(CORRtotalavg(:,1), CORRtotalavg(:,(numsubjects+1)), 1, criteria);
title(CORRplot); xlabel('Tone Level (dB SPL)'); ylabel('Correctness (%)'); ylim([0,110]);
legend(plotlegend(1:numsubjects,:),'Location','SouthEast');
hold off;

figure(3); % ACORR
hold on;
fitPsychometricFunctionCMR(ACORRtotalavg(:,1), ACORRtotalavg(:,(numsubjects+1)), 1, criteria);
title(ACORRplot); xlabel('Tone Level (dB SPL)'); ylabel('Correctness (%)'); xlim([levelVEC_tone_dBSPL(1) levelVEC_tone_dBSPL(end)]); ylim([0,110]);
legend(plotlegend(1:numsubjects,:),'Location','SouthEast');
hold off;

cd CMRpilot_results % open pilot data folder  
cd CMR2B % CHANGE FOLDER TO TYPE OF STIMULI
cd Psychometric_Curves_CMR2B % CHANGE FOLDER TO TYPE OF STIMULI
cd All_Subjects_CMR2B % CHANGE FOLDER TO TYPE OF STIMULI
plotnameREF = sprintf('Subject_Averages_REF_%s_Pilot_Results.jpg', CMRcondition);
plotnameCORR = sprintf('Subject_Averages_CORR_%s_Pilot_Results.jpg', CMRcondition);
plotnameACORR = sprintf('Subject_Averages_ACORR_%s_Pilot_Results.jpg', CMRcondition);
saveas(figure(1), plotnameREF); saveas(figure(2), plotnameCORR); saveas(figure(3), plotnameACORR);
cd ../
cd ../
end
%% Notes:
% Fix problem with curve fit for CORR condition (option 1)
% Curve fit (option 2)
