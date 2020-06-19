% File: Pilot_CMR_testing.m
% Created: Fernando Aguilera - Jun 16 2020
% Last Modified by: Fernando Aguilera de Alba - June 16 2020
%% Goal
% Randomize tone levels, condition (REF, CORR, ACORR), and output order
% (standard vs signal). Present 33 audio samples based on randomized user
% parameter list to determine which tone, condition, and output order are
% presented each time. User will input his/her responses to determine in
% which interval the signal was made (1 or 2). The number of correct
% answers and score will be recorded. File containing user input, user ID, 
% and results will be saved in a matlab file under folder "CMRpilot_results"  
%% Requirements
% 1. Must load generated signal data in order for testing user interface to
% work. Signal data is retrieved from "Create_CMR_stim.m".
run('Create_CMR_stim.m');
%% SECTION 2: TESTING USER INTERFACE
% User input
userID = input('\nUser ID: ','s');
userBlock = input('\nBlock #','s');
if isempty(userBlock)
   userBlock =  'X';
end
if isempty(userID)
    userID = 'X';
end
%% Signal presentation (randomized using "randomize_user_output.m")
tally = ones(length(levelVEC_tone_dBSPL),3); % record responses from user
reps = length(levelVEC_tone_dBSPL)*3; % number of audios played (# of tones * # of conditions
user_parameters = zeros(reps,3); % row # = audio # | col1 = tone level | col2 = condition | col3 = output order |
% create user's personal randomized parameters -> tone levels, conditions, output order (standard vs signal) 
for i = 1:reps
% randomize vectors every time a tone is played
rand_conditions = randperm(3); %  1 = REF  2 = CORR  3 = ACORR 
rand_tone_levels = randperm(length(levelVEC_tone_dBSPL)); 
rand_order_output = randperm(2); % 1 = standard | 2 = signal |
% check for repeated parameters
while tally(rand_tone_levels(1), rand_conditions(1)) == 0
        rand_conditions = randperm(3); %  1 = REF  2 = CORR  3 = ACORR 
        rand_tone_levels = randperm(length(levelVEC_tone_dBSPL)); 
        rand_order_output = randperm(2); % 1 = standard | 2 = signal |
end 
if tally(rand_tone_levels(1), rand_conditions(1)) == 1
    % Parameters
    %fprintf('\nUser parameters (Trial #%d): Tone %d and condition %d\n',i,rand_tone_levels(1), rand_conditions(1));
    % mark tone and condition as used in tally (0)
    tally(rand_tone_levels(1), rand_conditions(1)) = 0;
    % store user parameter for audio # i (tone level, condition, output order)
    user_parameters(i,1) = rand_tone_levels(1); % save tone level in user parameters
    user_parameters(i,2) = rand_conditions(1); % save condition in user parameters
    user_parameters(i,3) = rand_order_output(1); % save order output in user parameters
end
end
% Play sounds and collect user input
testResponse = zeros(length(user_parameters),1); % vector to save user responses
for i = 1:length(user_parameters)
% REF user input/output
if user_parameters(i,2) == 1 % REF
    input('\nPress Enter to play audio');
    fprintf('\nPlaying audio #%d\n',i);
        if user_parameters(i,3) == 1 % standard is played first
            soundsc([standard_output_REF(user_parameters(i,1),:) zeros(size(signal_REF)) signal_output_REF(user_parameters(i,1),:) ],Fs_Hz);
        elseif user_parameters(i,3) == 2 % signal is played first
            soundsc([signal_output_REF(user_parameters(i,1),:) zeros(size(signal_REF)) standard_output_REF(user_parameters(i,1),:)],Fs_Hz);
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
            soundsc([standard_output_CORR(user_parameters(i,1),:) zeros(size(signal_CORR)) signal_output_CORR(user_parameters(i,1),:) ],Fs_Hz);
        elseif user_parameters(i,3) == 2 % signal is played first
            soundsc([signal_output_CORR(user_parameters(i,1),:) zeros(size(signal_CORR)) standard_output_CORR(user_parameters(i,1),:)],Fs_Hz);
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
            soundsc([standard_output_ACORR(user_parameters(i,1),:) zeros(size(signal_ACORR)) signal_output_ACORR(user_parameters(i,1),:) ],Fs_Hz);
        elseif user_parameters(i,3) == 2 % signal is played first
            soundsc([signal_output_ACORR(user_parameters(i,1),:) zeros(size(signal_ACORR)) standard_output_ACORR(user_parameters(i,1),:)],Fs_Hz); 
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
if i == reps
fprintf('\n\nAUDIO DISCRIMINATION TASK COMPLETED');
end 
end
% output user results with randomly predetermined tone levels, conditions
% and order output along with user responses.
for i = 1:length(user_parameters)
user_parameters(i,1) = levelVEC_tone_dBSPL(user_parameters(i,1));
end
userResults = [user_parameters testResponse]; % row = audio # | col1 = tone level | col2 = condition (1 = REF, 2 = CORR, 3 = ACORR) 
                                                              % col3 = output order (1 = standard first, 2 = signal first) | col4 = user responses (correct answers on col3)
REFscore = 0; CORRscore = 0; ACORRscore = 0;
% calculate percent correctness
for i = 1:length(userResults)
    if userResults(i,2) == 1 % REF
        if userResults(i,3) ~= userResults(i,4)
            if userResults(i,4) == 0
                REFscore = REFscore - 1;
            end
        REFscore = REFscore + 1;
        end
    end
    
    if userResults(i,2) == 2 % CORR
        if userResults(i,3) ~= userResults(i,4)
            if userResults(i,4) == 0
                CORRscore = CORRscore - 1;
            end
        CORRscore = CORRscore + 1;
        end
    end
    
    if userResults(i,2) == 3 % ACORR
        if userResults(i,3) ~= userResults(i,4)
            if userResults(i,4) == 0
                ACORRscore = ACORRscore - 1;
            end
        ACORRscore = ACORRscore + 1;
        end
    end
end
userScore = ((REFscore + CORRscore + ACORRscore)/length(userResults))*100; % percent score
user_filename = sprintf('%s_Block%s_%s_Pilot_Results.mat',userID,userBlock,CMRcondition);  % user results file name
cd CMRpilot_results
save(user_filename,'userID', 'userResults','userScore','REFscore','CORRscore', 'ACORRscore');
cd ../
fprintf('\nRESULTS\n\nTotal Correct: %d\nTotal Score: %6.2f\n',(REFscore + CORRscore + ACORRscore), userScore);
fprintf('\nScore By Category\nREF: %6.2f \nCOR: %6.2f \nACORR: %6.2f\n',(REFscore/length(levelVEC_tone_dBSPL)*100), (CORRscore/length(levelVEC_tone_dBSPL)*100), (ACORRscore/length(levelVEC_tone_dBSPL)*100));
%% Notes: 