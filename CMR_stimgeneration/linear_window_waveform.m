%##########################################################################################
function out_wave = linear_window_waveform(in_wave,Fs_Hz,rft_sec)
%##########################################################################################
% stimOn_sec = dur_ms / 1000;

ramp_nSamples = ceil(Fs_Hz * rft_sec);

Nsamples = length(in_wave);

windowing_vector = ones(size(in_wave));
windowing_vector(1:ramp_nSamples) = [0:(ramp_nSamples-1)]/ramp_nSamples;
% windowing_vector((ramp_nSamples+1):(end_sample-ramp_nSamples)) = 1;
windowing_vector(((Nsamples-ramp_nSamples)+1):end) = [(ramp_nSamples-1):-1:0]/ramp_nSamples;
out_wave = windowing_vector .* in_wave;

return;
