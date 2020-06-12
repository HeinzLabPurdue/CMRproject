function [rand1, rand2] = randomize_user_output(tones)
%% Purpose:  
% 1. Randomize the order in which REF, CORR, and ACORR signal conditions are presented to user.
% 2. Randomize the order in which tone levels are presented to user.

 %% Initialization
 % create array with random permutations for randomization for each user
 number_conditions = 3; % set number of conditions --> 3 conditions: REF, CORR, ACORR
 conditions = 1:number_conditions;
 rand_conditions = randperm(number_conditions); 
 rand_tone_levels = randperm(length(tones));  % number of tone levels
 %% Randomization: re-arrange original order of array based on random permutation
  % randomize conditions
 rand_index = 0; % repeated to make sure index is zero at the start of for loop
 for i = 1:number_conditions
     rand_index = rand_conditions(i);
     rand1(i) = conditions(rand_index);
 % randomize tone levels
 rand_index = 0;
 for i = 1:length(tones)
     rand_index = rand_tone_levels(i);
     rand2(i) = tones(rand_index);
 end
 end
end
%% Notes:
% tones = levelVEC_tone_dBSPL
% signal = [ signal_REF   signal_CORR   signal_ACORR];
% standard = [standard_REF standard_CORR standard_ACORR]; 