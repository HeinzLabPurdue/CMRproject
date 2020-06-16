function output = randomize_user_output(nonrand)
%% Purpose: Randomize order of vector (1 row)
 %% Initialization
 % create array with random permutations for randomization for input array
 rand = randperm(length(nonrand)); 
 %% Randomization: re-arrange original order of array based on random permutation
 output = zeros(size(nonrand));
 for i = 1:length(nonrand)
     j = rand(i);
     output(i) = nonrand(j);
 end
end