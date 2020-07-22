% File: PsychometricCurve_CMR.m
% Created: Fernando Aguilera - Jun 28 2020

% Last Modified by: Fernando Aguilera de Alba - July 11 2020
%% Goal
% Generate psychometric curves for REF, CORR, and ACORR conditions from user data for CMR pilot testing.
clear all; close all; clc;
criteria = 75; % percent correctness threshold
offsetREF = 0; offsetCORR = -10; offsetACORR = 0; % threshold placement (REF, CORR, ACORR)
ll = 49;  ul = 101; % lower and upper limit for curves
CMRstimuli = input('\nCMR stimuli: ','s');
%% Load subject's matlab data file
% Load all blocks from user files from CMRpilot_results folder
fprintf('\nBlock analysis -- 1'); 
fprintf('\nPopulation Average analysis -- 2');
menuresponse = input('\n\nMenu option: ');
while isempty(menuresponse)
    fprintf('\n\nERROR: Invalid menu option');
    menuresponse = input('\n\nMenu option: ');
end
%% Individual data: plot all blocks and average
if menuresponse == 1
    subject = input('\nSubject: Chinchilla (C) | Human (H): ','s');
    if subject == 'H' || subject == 'h'
        subject = 'Human';
        CMRcondition = sprintf('%s_%s',CMRstimuli,subject);
    elseif subject == 'C' || subject == 'c'
        subject = 'Chin';
        CMRcondition = sprintf('%s_%s',CMRstimuli,subject);
    else
        error('Please enter a valid character (C or H)');
    end
    userid = input('\nUser ID: ','s');
    blocks = input('Number of blocks: ');
    cd CMRpilot_results
    cd(CMRcondition) % CHANGE FOLDER TO TYPE OF STIMULI
    cd (userid)
    REFresults_avg = [];
    CORRresults_avg = [];
    ACORRresults_avg = [];
% load block files for subject based on userid    
        for i = 1:blocks
            filename = [userid '_Block' num2str(i) '_' CMRstimuli '_Pilot_Results.mat'];
            load(filename);
            REFresults_avg(:,i+1) = (REFtonescore(:,2)/2)*100;
            CORRresults_avg(:,i+1) = (CORRtonescore(:,2)/2)*100;
            ACORRresults_avg(:,i+1) = (ACORRtonescore(:,2)/2)*100;
            fprintf('\nFile loaded:%s ',filename);
        end
cd ../
cd ../
cd ../
% Average results
REF = 0; CORR = 0; ACORR = 0;
for j = 1:length(levelVEC_tone_dBSPL)
    REF = mean(REFresults_avg(j,2:(blocks+1)));
    CORR = mean(CORRresults_avg(j,2:(blocks+1)));
    ACORR = mean(ACORRresults_avg(j,2:(blocks+1)));
    REFresults_avg(j,blocks+2) = REF;
    CORRresults_avg(j,blocks+2) = CORR;
    ACORRresults_avg(j,blocks+2) = ACORR;
end
REFresults_avg(:,1) = levelVEC_tone_dBSPL'; CORRresults_avg(:,1) = levelVEC_tone_dBSPL'; ACORRresults_avg(:,1) = levelVEC_tone_dBSPL';
%% Psychometric curve generation for each block
plotlegend = string(zeros(blocks,1));
for i = 1:blocks
plotlegend(i,1) = ['Block ' num2str(i)];
end
Markers = {'+','o','*','x','v','d','^','s','>','<'};
% Scatter plot of each block
for i = 2:(blocks+1)
% REF
figure(1);
hold on;
plot(REFresults_avg(:,1),REFresults_avg(:,i),strcat(Markers{i-1})); % scatter plot of block REF
hold off;
% CORR
figure(2);
hold on;
scatter(CORRresults_avg(:,1),CORRresults_avg(:,i),strcat(Markers{i-1})); % scatter plot of block CORR
hold off;
% ACORR
figure(3);
hold on;
scatter(ACORRresults_avg(:,1),ACORRresults_avg(:,i),strcat(Markers{i-1})); % scatter plot of block ACORR
hold off; 
end
%% Psychometric curve generation average
REFplot = sprintf('2-Alternative Forced Choice Tone Detection Threshold (Condition: REF | User ID: %s)', userid);
CORRplot = sprintf('2-Alternative Forced Choice Tone Detection Threshold (Condition: CORR | User ID: %s)', userid);
ACORRplot = sprintf('2-Alternative Forced Choice Tone Detection Threshold (Condition: ACORR | User ID: %s)', userid);
ALLplot = sprintf('Block Average 2-Alternative Forced Choice Tone Detection Threshold (User ID: %s)', userid);

figure(1); % REF 
hold on;
if min(REFresults_avg(:,end)) > 75  && min(REFresults_avg(:,end)) < 100 % no intersection at 75
    [REF_MSE,REF_fit_vec_dB,REF_fit_correctness_vec] = fitPsychometricFunctionCMR2(REFresults_avg(:,1), REFresults_avg(:,end), 1, criteria);
     REF_TH = NaN;
else
    [REF_TH,REF_MSE,REF_fit_vec_dB,REF_fit_correctness_vec] = fitPsychometricFunctionCMR(REFresults_avg(:,1), REFresults_avg(:,end), 1, criteria);
end
title(REFplot); xlabel('Tone Level (dB SPL)'); ylabel('Correctness (%)'); xlim([levelVEC_tone_dBSPL(1) levelVEC_tone_dBSPL(end)]);
legend(plotlegend(1:blocks,:),'Location','SouthEast');
hold off;

figure(2); % CORR
hold on;
if min(CORRresults_avg(:,end)) > 75 &&  min(CORRresults_avg(:,end)) < 100 % no intersection at 75
    [CORR_MSE,CORR_fit_vec_dB,CORR_fit_correctness_vec] = fitPsychometricFunctionCMR2(CORRresults_avg(:,1), CORRresults_avg(:,end), 1, criteria);
    CORR_TH = NaN;
else
    [CORR_TH,CORR_MSE,CORR_fit_vec_dB,CORR_fit_correctness_vec] = fitPsychometricFunctionCMR(CORRresults_avg(:,1), CORRresults_avg(:,end), 1, criteria);
end
title(CORRplot); xlabel('Tone Level (dB)'); ylabel('Correctness (%)'); xlim([levelVEC_tone_dBSPL(1) levelVEC_tone_dBSPL(end)]);
legend(plotlegend(1:blocks,:),'Location','SouthEast');
hold off;

figure(3); % ACORR
hold on;
if max(ACORRresults_avg(:,end)) > 0 && max(ACORRresults_avg(:,end)) < 75 % no intersection at 75
    [ACORR_MSE,ACORR_fit_vec_dB,ACORR_fit_correctness_vec] = fitPsychometricFunctionCMR2(ACORRresults_avg(:,1), ACORRresults_avg(:,end), 1, criteria);
    ACORR_TH = NaN;
else
    [ACORR_TH,ACORR_MSE,ACORR_fit_vec_dB,ACORR_fit_correctness_vec] = fitPsychometricFunctionCMR(ACORRresults_avg(:,1), ACORRresults_avg(:,end), 1, criteria);
end
title(ACORRplot); xlabel('Tone Level (dB)'); ylabel('Correctness (%)'); xlim([levelVEC_tone_dBSPL(1) levelVEC_tone_dBSPL(end)]); 
legend(plotlegend(1:blocks,:),'location','northwest'); ylim([ll ul]);
hold off;

figure(4); % ALL conditions
hold on;
plot(REF_fit_vec_dB,REF_fit_correctness_vec,'k','linewidth',1.5); % REF curve fit - black
plot(CORR_fit_vec_dB,CORR_fit_correctness_vec,'r','linewidth',1.5); % CORR curve fit - red
plot(ACORR_fit_vec_dB,ACORR_fit_correctness_vec,'b','linewidth',1.5); % ACORR curve fit - blue
plot(REF_TH,criteria,'ok','markersize',10,'linewidth',2); % REF Threshold
text(REF_TH+offsetREF,.95*criteria,sprintf('REF = %.1f dB',REF_TH)); % REF Threshold label
plot(CORR_TH,criteria,'ok','markersize',10,'linewidth',2); % CORR Threshold
text(CORR_TH+offsetCORR,.95*criteria,sprintf('CORR = %.1f dB',CORR_TH)); % CORR Threshold label
plot(ACORR_TH,criteria,'ok','markersize',10,'linewidth',2); % ACORR Threshold
text(ACORR_TH+offsetACORR,.95*criteria,sprintf('ACORR = %.1f dB',ACORR_TH)); % ACORR Threshold label
plot(levelVEC_tone_dBSPL,criteria*ones(size(levelVEC_tone_dBSPL)),'--k','markersize',10,'linewidth',1); % threshold line
title(ALLplot); 
xlabel('Tone Level (dB SPL)'); ylabel('Correctness (%)'); xlim([levelVEC_tone_dBSPL(1) levelVEC_tone_dBSPL(end)]); ylim([ll ul]);
hold off;

% Check if CMRcondition Directory there, if not make it
Dlist=dir(CMRcondition);
if isempty(Dlist)
    fprintf('   ***Creating "%s" Directory\n',CMRcondition);
    mkdir(CMRcondition);
end

cd CMRpilot_results
cd (CMRcondition)
cd (userid)
plotnameREF = sprintf('%s_2AFC_Average_Threshold_REF_%s.jpg',userid, CMRstimuli);
plotnameCORR = sprintf('%s_2AFC_Average_Threshold_CORR_%s.jpg',userid, CMRstimuli);
plotnameACORR = sprintf('%s_2AFC_Average_Threshold_ACORR_%s.jpg',userid, CMRstimuli);
plotnameALL = sprintf('%s_2AFC_Average_Threshold__ALL_%s.jpg',userid, CMRstimuli);
saveas(figure(1), plotnameREF); saveas(figure(2), plotnameCORR); saveas(figure(3), plotnameACORR); saveas(figure(4), plotnameALL);
%% CMR effect
clc;
thresholds = string(zeros(1,4)); % col1 = userid | col2 = REF | col3 = CORR | col4 = ACORR
thresholds(1,1) = userid; thresholds(1,2) = REF_TH; thresholds(1,3) = CORR_TH; thresholds(1,4) = ACORR_TH;
CMR_AC = ACORR_TH - CORR_TH;
CMR_RC = REF_TH - CORR_TH;
fprintf('\nThresholds (USER ID: %s)',userid);
fprintf('\nREF:%6.1f dB',REF_TH); fprintf('\nCORR:%6.1f dB',CORR_TH); fprintf('\nACORR:%6.1f dB',ACORR_TH);
fprintf('\n\nCMR Score (ACORR - CORR):%6.1f dB', CMR_AC); fprintf('\nCMR Score (REF - CORR):%6.1f dB', CMR_RC);
cd ../
cd ../
cd ../
end

%% All subjects: plot subject average and population average (no individual blocks)
REFtotalavg = []; CORRtotalavg = []; ACORRtotalavg = [];
if menuresponse == 2
    subject = input('\nSubject: Chinchilla (C) | Human (H): ','s');
    if subject == 'H' || subject == 'h'
        subject = 'Human';
        CMRcondition = sprintf('%s_%s',CMRstimuli,subject);
    elseif subject == 'C' || subject == 'c'
        subject = 'Chin';
        CMRcondition = sprintf('%s_%s',CMRstimuli,subject);
    else
        error('Please enter a valid character (C or H)');
    end
    numsubjects = input('\nNumber of Subjects: ');
    cd CMRpilot_results
    cd(CMRcondition) % CHANGE FOLDER TO TYPE OF STIMULI
% load files for each subject based on userid  
plotlegend = string(zeros(numsubjects,1));
for i = 1:numsubjects
        fprintf('\n\nUser ID #%d: ', i); userid = input('','s');
        blocks = input('Number of blocks: ');
        cd (userid)
        plotlegend(i,:) = ['Subject: ' userid ', Blocks: ' mat2str(blocks)];
        for j = 1:blocks
            filename = [userid '_Block' num2str(j) '_' CMRstimuli '_Pilot_Results.mat'];
            load(filename);
            REFresults_avg(:,j+1) = (REFtonescore(:,2)/2)*100;
            CORRresults_avg(:,j+1) = (CORRtonescore(:,2)/2)*100;
            ACORRresults_avg(:,j+1) = (ACORRtonescore(:,2)/2)*100;
            fprintf('\nFile loaded:%s ',filename);
        end
        cd ../
        
% Average results for each subject's block
REF = 0; CORR = 0; ACORR = 0;
for j = 1:length(levelVEC_tone_dBSPL)
    REF = mean(REFresults_avg(j,2:(blocks+1)));
    CORR = mean(CORRresults_avg(j,2:(blocks+1)));
    ACORR = mean(ACORRresults_avg(j,2:(blocks+1)));
    REFresults_avg(j,blocks+2) = REF;
    CORRresults_avg(j,blocks+2) = CORR;
    ACORRresults_avg(j,blocks+2) = ACORR;
end
REFtotalavg(:,i+1) = REFresults_avg(:,end); 
CORRtotalavg(:,i+1) = CORRresults_avg(:,end); 
ACORRtotalavg(:,i+1) = ACORRresults_avg(:,end); 
end
% Average results for all subjects
REFall = 0; CORRall = 0; ACORRall = 0;
for j = 1:length(levelVEC_tone_dBSPL)
    REFall = mean(REFtotalavg(j,2:numsubjects+1));
    CORRall = mean(CORRtotalavg(j,2:numsubjects+1));
    ACORRall = mean(ACORRtotalavg(j,2:numsubjects+1));
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
ylim([0,100]);
hold off;
% CORR
figure(2);
hold on;
scatter(CORRtotalavg(:,1),CORRtotalavg(:,i),strcat(Markers{counter})); % scatter plot of block CORR
ylim([0,100]);
hold off;
% ACORR
figure(3);
hold on;
scatter(ACORRtotalavg(:,1),ACORRtotalavg(:,i),strcat(Markers{counter})); % scatter plot of block ACORR
ylim([0,100]);
hold off;
counter = counter + 1; 
end
%% Psychometric curve generation average
REFplot = sprintf('Average 2-Alternative Forced Choice Tone Detection Threshold (Condition: REF | Subjects: %d)',numsubjects);
CORRplot = sprintf('Average 2-Alternative Forced Choice Tone Detection Threshold (Condition: CORR | Subjects: %d)',numsubjects);
ACORRplot = sprintf('Average 2-Alternative Forced Choice Tone Detection Threshold (Condition: ACORR | Subjects: %d)',numsubjects);
ALLplot = sprintf('Average 2-Alternative Forced Choice Tone Detection Threshold (All Conditions | Subjects: %d)',numsubjects);

figure(1); % REF 
hold on;
if min(REFtotalavg(:,end)) > 75 && min(REFtotalavg(:,end)) < 100% no intersection at 75%
    [REF_MSE,REF_fit_vec_dB,REF_fit_correctness_vec] = fitPsychometricFunctionCMR2(REFtotalavg(:,1), REFtotalavg(:,end), 1, criteria);
     REF_TH = NaN;
else
    [REF_TH,REF_MSE,REF_fit_vec_dB,REF_fit_correctness_vec] = fitPsychometricFunctionCMR(REFtotalavg(:,1), REFtotalavg(:,end), 1, criteria);
end
title(REFplot); xlabel('Tone Level (dB SPL)'); ylabel('Correctness (%)'); 
legend(plotlegend(1:numsubjects,:),'Location','SouthEast'); xlim([levelVEC_tone_dBSPL(1) levelVEC_tone_dBSPL(end)]); ylim([ll ul]);
hold off;

figure(2); % CORR
hold on;
if min(CORRtotalavg(:,end)) > 75 % no intersection at 75%
    [CORR_MSE,CORR_fit_vec_dB,CORR_fit_correctness_vec] = fitPsychometricFunctionCMR2(CORRtotalavg(:,1), CORRtotalavg(:,end), 1, criteria);
    CORR_TH = NaN;
else
    [CORR_TH,CORR_MSE,CORR_fit_vec_dB,CORR_fit_correctness_vec] = fitPsychometricFunctionCMR(CORRtotalavg(:,1), CORRtotalavg(:,end), 1, criteria);
end
title(CORRplot); xlabel('Tone Level (dB SPL)'); ylabel('Correctness (%)');
legend(plotlegend(1:numsubjects,:),'Location','southeast'); xlim([levelVEC_tone_dBSPL(1) levelVEC_tone_dBSPL(end)]); ylim([ll ul]);
hold off;

figure(3); % ACORR
hold on;
if max(ACORRtotalavg(:,end)) < 75 % no intersection at 75%
    [ACORR_MSE,ACORR_fit_vec_dB,ACORR_fit_correctness_vec] = fitPsychometricFunctionCMR2(ACORRtotalavg(:,1), ACORRtotalavg(:,end), 1, criteria);
    ACORR_TH = NaN;
else
    [ACORR_TH,ACORR_MSE,ACORR_fit_vec_dB,ACORR_fit_correctness_vec] = fitPsychometricFunctionCMR(ACORRtotalavg(:,1), ACORRtotalavg(:,end), 1, criteria);
end
title(ACORRplot); xlabel('Tone Level (dB SPL)'); ylabel('Correctness (%)'); 
legend(plotlegend(1:numsubjects,:),'Location','northwest'); ylim([ll ul]); xlim([levelVEC_tone_dBSPL(1) levelVEC_tone_dBSPL(end)]);
hold off;

figure(4); % ALL conditions
hold on;
plot(REF_fit_vec_dB,REF_fit_correctness_vec,'k','linewidth',1.5); % REF curve fit - black
plot(CORR_fit_vec_dB,CORR_fit_correctness_vec,'r','linewidth',1.5); % CORR curve fit - red
plot(ACORR_fit_vec_dB,ACORR_fit_correctness_vec,'b','linewidth',1.5); % ACORR curve fit - blue
plot(REF_TH,criteria,'ok','markersize',10,'linewidth',2); % REF Threshold
text(REF_TH+offsetREF,.95*criteria,sprintf('REF = %.1f dB',REF_TH)); % REF Threshold label
plot(CORR_TH,criteria,'ok','markersize',10,'linewidth',2); % CORR Threshold
text(CORR_TH+offsetCORR,.95*criteria,sprintf('CORR = %.1f dB',CORR_TH)); % CORR Threshold label
plot(ACORR_TH,criteria,'ok','markersize',10,'linewidth',2); % ACORR Threshold
text(ACORR_TH+offsetACORR,.95*criteria,sprintf('ACORR = %.1f dB',ACORR_TH)); % ACORR Threshold label
plot(levelVEC_tone_dBSPL,criteria*ones(size(levelVEC_tone_dBSPL)),'--k','markersize',10,'linewidth',1); % threshold line
title(ALLplot); 
xlabel('Tone Level (dB SPL)'); ylabel('Correctness (%)'); xlim([levelVEC_tone_dBSPL(1) levelVEC_tone_dBSPL(end)]); ylim([ll ul]);
hold off;

% Check if CMRcondition Directory there, if not make it
Dlist=dir(CMRcondition);
if isempty(Dlist)
    fprintf('   ***Creating "%s" Directory\n',CMRcondition);
    mkdir(CMRcondition);
end

cd CMRpilot_results % open pilot data folder  
cd (CMRcondition) % CHANGE FOLDER TO TYPE OF STIMULI
plotnameREF = sprintf('Average_Threshold_REF_%s.jpg', CMRstimuli);
plotnameCORR = sprintf('Average_Threshold_CORR_%s.jpg', CMRstimuli);
plotnameACORR = sprintf('Average_Threshold_ACORR_%s.jpg', CMRstimuli);
plotnameALL = sprintf('Average_Threshold_ALL_%s.jpg', CMRstimuli);
saveas(figure(1), plotnameREF); saveas(figure(2), plotnameCORR); saveas(figure(3), plotnameACORR); saveas(figure(4), plotnameALL);

%% Average thresholds results (all subjects)
clc;
CMR_AC = ACORR_TH - CORR_TH;
CMR_RC = REF_TH - CORR_TH;
fprintf('\nThresholds (Population Average)');
fprintf('\nREF:%6.1f dB',REF_TH); fprintf('\nCORR:%6.1f dB',CORR_TH); fprintf('\nACORR:%6.1f dB',ACORR_TH);
fprintf('\n\nCMR Score (ACORR - CORR):%6.1f dB', CMR_AC); fprintf('\nCMR Score (REF - CORR):%6.1f dB', CMR_RC);
cd ../
cd ../
end
%% Notes:
% 1. Code to choose curve fitting for CORR when threshold is not available
%
% (% correctness > 75% for all tone levels) -- DONE
% 2. Plot all three conditions in one plot for both menu options -- DONE
% 3. APLLY #1 to all conditions (working on menuresponse == 1 now) -- DONE
% 4. Check legend for CORR condition (not showing up) -- DONE

% Analysis
% - mu = average of CMR scores (ACORR - CORR) ~12 dB   (CORR - REF) ~3 dB
% - calculate variability between subject CMR scores

