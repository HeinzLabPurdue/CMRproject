% File: Pilot_CMR_testing.m
% Created: Fernando Aguilera - Jun 16 2020
% Last Modified by: Fernando Aguilera de Alba - July 1 2020
%% Goal
% Randomize tone levels, condition (REF, CORR, ACORR), and output order
% (standard vs signal). Present 66 audio samples based on randomized user
% parameter list to determine which tone, condition, and output order are
% presented each time. User will input his/her responses to determine in
% which interval the signal was played (1 or 2). The number of correct
% answers and scores will be recorded. File containing user results will 
% be saved under folder "CMRpilot_results"  
%% Requirement
clear all; close all; clc;
% Load stimuli from folder "new_signals"
cd new_signals
load('CMR2stimuli.mat');
cd ../
%% USER INTERFACE
% User input
userID = input('\nUser ID: ','s');
userBlock = input('\nBlock #','s');
if isempty(userBlock)
   userBlock =  'X';
end
if isempty(userID)
    userID = 'X';
end
fprintf('\n\nInstructions:\n\nYou will be presented a set of two audio samples for 66 trials.');
fprintf('\nAfter each trial, you will need to indicate in which interval (1 or 2) you heard the tone.');
fprintf('\nThe sound level of the tone will vary across trials, so sometimes it will be hard to detect the tone.');
fprintf('\nMake sure to record an answer for all trial even if you are not sure.');
fprintf('\nThe tone presented will be similar to the audio sample used for volume setting.');
fprintf('\n\nVolume Setting:');
fprintf('\n\nPlease, select a comfortable volume setting based on the following audio sample.');
input('\nPress Enter to play audio sample');
fprintf('Playing audio sample...');
sound(signal_output_REF(1,:),Fs_Hz); % softest tone in REF condition for user reference
volume_setup = input('\nWould you like to replay the audio sample? (Y/N): ');
while volume_setup == 'Y' || volume_setup == 'y'
    fprintf('Playing audio sample...');
    sound(signal_output_REF(1,:),Fs_Hz); % softest tone in REF condition for user reference
    volume_setup = input('\nWould you like to replay the audio sample? (Y/N): ');
end
fprintf('\nNOTE: Make sure to keep the volume unchanged until the testing block is completed.');
fprintf('\n      Please, allow both audios to finish playing before answering the question.');
fprintf('\n\nTESTING BLOCK WILL BEGIN NOW\n');
%% Signal presentation
trials = length(levelVEC_tone_dBSPL) * 3 * 2; % number of audios played (# of tones * # of conditions * # of outputs)
user_parameters = zeros(trials,3); % row # = audio # | col1 = tone level | col2 = condition | col3 = output order |
% create user parameters for 66 trials
for i = 1:trials
if i <= trials/3
    user_parameters(i,1) = i;
    user_parameters(i,2) = 1; % REF
        if i <= (trials/6)
            user_parameters(i,3) = 1; % standard first, signal second
        end
        if i > (trials/6) && i <= (trials/3)
            user_parameters(i,1) = i - length(levelVEC_tone_dBSPL);
            user_parameters(i,3) = 2; % signal first, standard second
        end
elseif i >= trials/3 && i <= 2*trials/3
    user_parameters(i,1) = i-(trials/3);
    user_parameters(i,2) = 2; % CORR
        if i > (trials/3) && i <= (trials/2)
            user_parameters(i,3) = 1; % standard first, signal second
        end
        if i > (trials/2) && i <= (2*trials/3)            
            user_parameters(i,1) = i - 3*length(levelVEC_tone_dBSPL);          
            user_parameters(i,3) = 2; % signal first, standard second
        end
else
    user_parameters(i,1) = i-(2*trials/3);
    user_parameters(i,2) = 3; % ACORR
   
        if i > (2*trials/3) && i <= (5*trials/6)
            user_parameters(i,3) = 1; % standard first, signal second
        end
        if i > (5*trials/6) && i <= trials
            user_parameters(i,1) = i - 5*length(levelVEC_tone_dBSPL);
            user_parameters(i,3) = 2; % signal first, standard second
        end
end
end
% Randomize order of user parameters
user_order = randperm(trials);
box = zeros(length(user_parameters),3);
for i = 1:length(user_order)
    box(i,:) = user_parameters(user_order(i),:);
end
user_parameters = box; % randomized user parameters
% Play sounds and collect user input
testResponse = zeros(length(user_parameters),1); % vector to save user responses
for i = 1:length(user_parameters)
% REF user input/output
if user_parameters(i,2) == 1 % REF
    input('\nPress Enter to play audio');
    fprintf('\nPlaying audio #%d\n',i);
        if user_parameters(i,3) == 1 % standard is played first
            sound([standard_output_REF(user_parameters(i,1),:) zeros(1,length(standard_output_REF)) signal_output_REF(user_parameters(i,1),:) ],Fs_Hz);
        elseif user_parameters(i,3) == 2 % signal is played first
            sound([signal_output_REF(user_parameters(i,1),:) zeros(1,length(standard_output_REF)) standard_output_REF(user_parameters(i,1),:)],Fs_Hz);
        else
            fprintf('\nError: Cannot play audio');
        end
    % Collect user input            
    userResponse = input('In which interval (1 or 2) did you hear the tone? ');
        if isempty(userResponse) 
            fprintf('\nERROR: Invalid input. Answer will not be recorded.\n');
            userResponse = 0;
        end    
    testResponse(i,1) = userResponse;       
% CORR user input/output
elseif user_parameters(i,2) == 2 % CORR
    input('\nPress Enter to play audio');            
    fprintf('\nPlaying audio #%d\n', i);
        if user_parameters(i,3) == 1 % standard is played first
            sound([standard_output_CORR(user_parameters(i,1),:) zeros(1,length(standard_output_CORR)) signal_output_CORR(user_parameters(i,1),:) ],Fs_Hz);
        elseif user_parameters(i,3) == 2 % signal is played first
            sound([signal_output_CORR(user_parameters(i,1),:) zeros(1,length(standard_output_CORR)) standard_output_CORR(user_parameters(i,1),:)],Fs_Hz);
        else
            fprintf('\nError: Cannot play audio');
        end
% Collect user input            
    userResponse = input('In which interval (1 or 2) did you hear the tone? ');
        if isempty(userResponse) 
            fprintf('\nERROR: Invalid input. Answer will not be recorded.\n');
            userResponse = 0;
        end    
        testResponse(i,1) = userResponse;
% ACORR user input/output            
elseif user_parameters(i,2) == 3 % ACORR
    input('\nPress Enter to play audio');
    fprintf('\nPlaying audio #%d\n', i);       
        if user_parameters(i,3) == 1 % standard is played first
            sound([standard_output_ACORR(user_parameters(i,1),:) zeros(1,length(standard_output_ACORR)) signal_output_ACORR(user_parameters(i,1),:) ],Fs_Hz);
        elseif user_parameters(i,3) == 2 % signal is played first
            sound([signal_output_ACORR(user_parameters(i,1),:) zeros(1,length(standard_output_ACORR)) standard_output_ACORR(user_parameters(i,1),:)],Fs_Hz); 
        else
            fprintf('\nError: Cannot play audio');
        end
        % Collect user input            
    userResponse = input('In which interval (1 or 2) did you hear the tone? ');
        if isempty(userResponse) 
            fprintf('\nERROR: Invalid input. Answer will not be recorded.\n');
            userResponse = 0;
        end    
        testResponse(i,1) = userResponse;
else
    fprintf('\nERROR: Cannot determine condition (REF, CORR, ACORR');
end
% Indicate to user testing is done
if i == trials
fprintf('\n\nTESTING BLOCK COMPLETED');
end 
end
% output user results with randomly predetermined tone levels, conditions
% and order output along with user responses.
for i = 1:length(user_parameters)
user_parameters(i,1) = levelVEC_tone_dBSPL(user_parameters(i,1));
end
userResults = [user_parameters testResponse]; % row = audio # | col1 = tone level | col2 = condition (1 = REF, 2 = CORR, 3 = ACORR) 
                                                              % col3 = output order (1 = standard first, 2 = signal first) | col4 = user responses (correct answers on col3)
REFresults = []; CORRresults = []; ACORRresults = [];
% Separate data by condition
% col1 = tone level | col2 = response points -> correct = 1   incorrect = 0
for i = 1:length(userResults)
% REF
    if userResults(i,2) == 1 
        if userResults(i,3) ~= userResults(i,4)
            if userResults(i,4) == 0
                REFresults(i,1) = userResults(i,1);
                REFresults(i,2) = 0;
            else
                REFresults(i,1) = userResults(i,1);
                REFresults(i,2) = 1;
            end
        else
            REFresults(i,1) = userResults(i,1);
            REFresults(i,2) = 0;
        end
    end
% CORR
    if userResults(i,2) == 2 
        if userResults(i,3) ~= userResults(i,4)
           if userResults(i,4) == 0
                CORRresults(i,1) = userResults(i,1);
                CORRresults(i,2) = 0;
           else
                CORRresults(i,1) = userResults(i,1);
                CORRresults(i,2) = 1;
           end
        else
            CORRresults(i,1) = userResults(i,1);
            CORRresults(i,2) = 0;
        end       
    end
% ACORR
    if userResults(i,2) == 3 
        if userResults(i,3) ~= userResults(i,4)
            if userResults(i,4) == 0
                ACORRresults(i,1) = userResults(i,1);
                ACORRresults(i,2) = 0;
            else
                ACORRresults(i,1) = userResults(i,1);
                ACORRresults(i,2) = 1;
            end
        else
            ACORRresults(i,1) = userResults(i,1);
            ACORRresults(i,2) = 0;
        end
   end
end
% Calculate each condition's score
REFscore = 0; CORRscore = 0; ACORRscore = 0;
for i = 1:length(REFresults)
    if REFresults(i,2) == 1
        REFscore = REFscore + 1;
    end
end
for i = 1:length(CORRresults)
    if CORRresults(i,2) == 1
        CORRscore = CORRscore + 1;
    end
end
for i = 1:length(ACORRresults)
    if ACORRresults(i,2) == 1
        ACORRscore = ACORRscore + 1;
    end
end
% Calculate each tone's score
REFtonescore = zeros(length(levelVEC_tone_dBSPL),2); CORRtonescore = zeros(length(levelVEC_tone_dBSPL),2); ACORRtonescore = zeros(length(levelVEC_tone_dBSPL),2);
REFtonescore(:,1) = levelVEC_tone_dBSPL'; CORRtonescore(:,1) = levelVEC_tone_dBSPL'; ACORRtonescore(:,1) = levelVEC_tone_dBSPL';
for i = 1:length(REFresults)
   if REFresults(i,1) ~= 0
       for j = 1:length(REFtonescore)
           if REFresults(i,1) == REFtonescore(j,1)
               REFtonescore(j,2) = REFtonescore(j,2) + REFresults(i,2);
           end
       end
   end
end
for i = 1:length(CORRresults)
if CORRresults(i,1) ~= 0
   for j = 1:length(CORRtonescore)
       if CORRresults(i,1) == CORRtonescore(j,1)
           CORRtonescore(j,2) = CORRtonescore(j,2) + CORRresults(i,2);
       end
   end
end
end
for i = 1:length(ACORRresults)
if ACORRresults(i,1) ~= 0
    for j = 1:length(ACORRtonescore)
        if ACORRresults(i,1) == ACORRtonescore(j,1)
            ACORRtonescore(j,2) = ACORRtonescore(j,2) + ACORRresults(i,2);
        end
    end
end
end
userScore = ((REFscore + CORRscore + ACORRscore)/length(userResults))*100; % total percent score
user_filename = sprintf('%s_Block%s_%s_Pilot_Results.mat',userID,userBlock,CMRcondition);  % user results file name
fprintf('\n\nRESULTS\n\nTotal Correct: %d\nTotal Score: %6.2f\n',(REFscore + CORRscore + ACORRscore), userScore);
fprintf('\nScore By Condition\nREF: %6.2f \nCOR: %6.2f \nACORR: %6.2f\n',(REFscore/(trials/3)*100), (CORRscore/(trials/3)*100), (ACORRscore/(trials/3)*100));
%% Data analysis for psychometric curves
cd CMRpilot_results
save(user_filename,'userResults','userScore','REFscore','CORRscore', 'ACORRscore','CMRcondition','REFtonescore','CORRtonescore','ACORRtonescore','levelVEC_tone_dBSPL');
cd ../