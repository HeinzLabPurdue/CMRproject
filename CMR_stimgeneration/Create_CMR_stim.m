% File: Create_CMR_stim.m
%
% Created: M. Heinz Jun 1 2020
% Modified by: Fernando Aguilera de Alba
% Branched Created: June 5th 2020

%
% Creates a set of basic CMR stimuli (REF, CORR, UNCORR) for one condition.
%% REF:
% Steady tone is to be detected within a modulated (10 Hz SAM) narrowband
% (1 ERB) wide noise centered on tone.  Tone starts ~10% after start of
% noise, and ends with noise (500 ms).   
%% CORR:
% Two flanking noise bands are added (one below and one above the tone).
% The spacing between the center noise band edge (e.g., upper edge) and the
% closest flanking noise bands edge (e.g., lower edge) is 2 ERBs. All three bands
% are co-modulated (in phase) with 10 Hz SAM.
%% UNCORR:
% Same two flanking noise bands are added.  But here, the flanking bands
% are modualted out of phase (180 deg) with the center band.
%% CMR_dB = Threshold_UNCORR (tone dB SPL) - Thresholds_CORR (tone dB SPL)

clear all; close all; clc

%% Parameters
f_Hz = 4000;  % center frequency of tone and on-frequency band (OFB)
Q10 = 3.7;  % for chins at 4kHz (Temchin and Ruggero 2008 (I; Fig. 6B); Kale and Heinz 2010)
% BWnoise_Hz=f_hz/Q10; 

%%%%%%%%%%%%%%%%%%% 
% pick chin or human
%%%%%%%%%%%%%%%%%%%
BWnoise_Hz=1000;  % chin approx to make it easy for now
% BWnoise_Hz=600;  % human approx to make it easy for now (4000 * 0.15)

%%%%%%%%%%%%%%%%%%% 
% Adjust to find threshold
%%%%%%%%%%%%%%%%%%%
level_tone_dBSPL = 70
No_SPL_Hz=30;  % Noise Spectrum level (OAL noise = No + 10*log10(BW))
dur_noise_sec=500/1000;
delay_tone_sec=0.1*dur_noise_sec;  % 10% delay for tone
rft_sec=10/1000;
fmod_Hz = 10;   % SAM modulation for noises

%% Read in previously calibrated stim, and confirm TDT Fs sampling rate (Fs)
% see confirm_old_calib (based on tone we know was calibrated at one point
% to be 70 dB SPL) 
[calib_dBSPL,calib_70dBtone_rms,Fs_Hz] = confirm_old_calib;  % 70 dB SPL tone is rms of 0.02.
levels_tone_dBSPL = 40:3:70;  % to be used later for testing tone detection

%% Compute center frequencies of all noise bands
f_LSB_Hz = f_Hz - 3*BWnoise_Hz;  % center frequency of lower-side-band (LSB) (creates 2 BWgap between OFB lower edge and LSB upper edge)
f_USB_Hz = f_Hz + 3*BWnoise_Hz;  % center frequency of upper-side-band (USB) (creates 2 BWgap between OFB upper edge and USB lower edge)
if (f_LSB_Hz-0.5*BWnoise_Hz <= 0) % confirm there is room for LSB
    error('lower side band is below 0Hz');
end
if (f_USB_Hz+0.5*BWnoise_Hz >= Fs_Hz/2) % confirm there is room for USB
    error('upper side band is above Fs/2 Hz');
end

%% Compute length of relevant signals
len_tone = round((dur_noise_sec - delay_tone_sec)*Fs_Hz);   % length of tone
len_noise = round(dur_noise_sec*Fs_Hz);   
len_delay = len_noise - len_tone;   % silence before tone 

%% Make signals
timevec_sec = (0:(len_noise-1))/Fs_Hz;
freqvec_Hz = (0:(len_noise-1))*Fs_Hz/len_noise;   
% Tone
silence = zeros(1,len_delay);  % Delay for tone
tone = sin(2*pi*f_Hz*timevec_sec(1:len_tone));
%% Make noise bands
% Filter design (LPF at BW/2)
Rp  = 0.00057565; % Corresponds to 0.01 dB peak-to-peak ripple
Rst = 1e-4;       % Corresponds to 80 dB stopband attenuation
TW_Hz=100;  % Transition Width = 100 Hz
b = firgr('minorder',[0,((BWnoise_Hz)/2/(Fs_Hz/2)),((BWnoise_Hz/2+TW_Hz)/(Fs_Hz/2)),1],[1 1 0 0],...
    [Rp Rst]);
% fvt = fvtool(b,1,'Fs',Fs_Hz,'Color','White');

% start with BBnoise, 
noise_BB = randn(1,2*len_noise);
% create LPnoise,
temp_noise=filter(b,1,noise_BB);  % Apply filter to BB noise (twice length to avoid endpt issues)
noise_LPF=temp_noise(2*length(b):(len_noise+2*length(b)-1));  % proper length LPnoise by taking from middle
% modulate up to 3 CFs
noise_OFB = noise_LPF.*sin(2*pi*f_Hz*timevec_sec);
noise_LSB = noise_LPF.*sin(2*pi*f_LSB_Hz*timevec_sec);
noise_USB = noise_LPF.*sin(2*pi*f_USB_Hz*timevec_sec);

%% Modulate all noise bands
noise_OFB = noise_OFB.*(1+sin(2*pi*fmod_Hz*timevec_sec));
noise_LSB_CORR = noise_LSB.*(1+sin(2*pi*fmod_Hz*timevec_sec));
noise_USB_CORR = noise_USB.*(1+sin(2*pi*fmod_Hz*timevec_sec));
noise_LSB_UCORR = noise_LSB.*(1+sin(2*pi*fmod_Hz*timevec_sec+pi));
noise_USB_UCORR = noise_USB.*(1+sin(2*pi*fmod_Hz*timevec_sec+pi));

%% Calibration
rms_tone_new = calib_70dBtone_rms * 10^((level_tone_dBSPL-calib_dBSPL)/20);
tone = tone/rms(tone)*rms_tone_new;

rms_noise_new = calib_70dBtone_rms * 10^((No_SPL_Hz+10*log10(BWnoise_Hz)-calib_dBSPL)/20);
noise_OFB= noise_OFB/rms(noise_OFB)*rms_noise_new;
noise_LSB_CORR= noise_LSB_CORR/rms(noise_LSB_CORR)*rms_noise_new;
noise_USB_CORR= noise_USB_CORR/rms(noise_USB_CORR)*rms_noise_new;
noise_LSB_UCORR= noise_LSB_UCORR/rms(noise_LSB_UCORR)*rms_noise_new;
noise_USB_UCORR= noise_USB_UCORR/rms(noise_USB_UCORR)*rms_noise_new;


%% Apply ramps to each signals
tone_rft=linear_window_waveform(tone,Fs_Hz,rft_sec);  % apply window to tone signal
noise_OFB_rft=linear_window_waveform(noise_OFB,Fs_Hz,rft_sec);  % apply window to noise band
noise_LSB_CORR_rft=linear_window_waveform(noise_LSB_CORR,Fs_Hz,rft_sec);  % apply window to CORR noise band
noise_USB_CORR_rft=linear_window_waveform(noise_USB_CORR,Fs_Hz,rft_sec);  % apply window to CORR noise band
noise_LSB_UCORR_rft=linear_window_waveform(noise_LSB_UCORR,Fs_Hz,rft_sec);  % apply window to UCORR noise band
noise_USB_UCORR_rft=linear_window_waveform(noise_USB_UCORR,Fs_Hz,rft_sec);  % apply window to UCORR noise band

%% Create complete signals
signal_REF = [silence tone_rft] + noise_OFB_rft;
standard_REF = noise_OFB_rft;
signal_CORR = [silence tone_rft] + noise_OFB_rft + noise_LSB_CORR_rft + noise_USB_CORR_rft;
standard_CORR = noise_OFB_rft + noise_LSB_CORR_rft + noise_USB_CORR_rft;
signal_UCORR = [silence tone_rft] + noise_OFB_rft + noise_LSB_UCORR_rft + noise_USB_UCORR_rft;
standard_UCORR = noise_OFB_rft + noise_LSB_UCORR_rft + noise_USB_UCORR_rft;

%% Save files
% eventtually we'll need to put in some parameter values for all the signal
% levels
% sigSNR_fname=sprintf('%s%s.wav',sig_fname(1:end-4),SNRaddon_text);   %'4kHz80dBT_999dBAM_NN.wav';
% stdSNR_fname=sprintf('%s%s.wav',std_fname(1:end-4),SNRaddon_text);   %'4kHz80dBT_999dBAM_NN.wav';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LATER - add to file name/chinch code storage (chin/human, tone level,
% noise level, BW) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
std_REF_fname = 'CMR1_REF_std.wav';  % test condition1
sig_REF_fname = 'CMR1_REF_sig.wav'; 
std_CORR_fname = 'CMR1_CORR_std.wav';  % test condition1
sig_CORR_fname = 'CMR1_CORR_sig.wav'; 
std_UCORR_fname = 'CMR1_UCORR_std.wav';  % test condition1
sig_UCORR_fname = 'CMR1_UCORR_sig.wav'; 


audiowrite(std_REF_fname,standard_REF,Fs_Hz)
audiowrite(sig_REF_fname,signal_REF,Fs_Hz)
audiowrite(std_CORR_fname,standard_CORR,Fs_Hz)
audiowrite(sig_CORR_fname,signal_CORR,Fs_Hz)
audiowrite(std_UCORR_fname,standard_UCORR,Fs_Hz)
audiowrite(sig_UCORR_fname,signal_UCORR,Fs_Hz)



%% Plot and listen to REF stimuli
figure(1); clf
subplot(211)
plot(timevec_sec*1000,signal_REF,'r'); hold on; plot(timevec_sec*1000,standard_REF,'b'); hold off
YLIMITS=ylim;
YLIMITS = 2.5*max(abs(YLIMITS))*[-1 1];
ylim(YLIMITS)
xlim([0 dur_noise_sec*1000])
ylabel('Amp')
xlabel('Time (msec)')
title(sprintf('REF CONDITION:   STD: %s;    \nSIG: %s',std_REF_fname,sig_REF_fname),'interpreter','none')
subplot(212)
plot(freqvec_Hz,20*log10(abs(fft(signal_REF))),'r'); hold on; plot(freqvec_Hz,20*log10(abs(fft(standard_REF))),'b'); hold off
xlim([0 Fs_Hz/2])
ylabel('Magnitude (dB)')
xlabel('Frequency (Hz)')

set(gcf,'units','norm','pos',[0.5005    0.0565    0.4990    0.8324])


%% Plot and listen to CORR stimuli
figure(2); clf
subplot(211)
plot(timevec_sec*1000,signal_CORR,'r'); hold on; plot(timevec_sec*1000,standard_CORR,'b'); hold off
xlim([0 dur_noise_sec*1000])
ylim(YLIMITS)
ylabel('Amp')
xlabel('Time (msec)')
title(sprintf('CORR CONDITION:   STD: %s;    \nSIG: %s',std_CORR_fname,sig_CORR_fname),'interpreter','none')
subplot(212)
plot(freqvec_Hz,20*log10(abs(fft(signal_CORR))),'r'); hold on; plot(freqvec_Hz,20*log10(abs(fft(standard_CORR))),'b'); hold off
xlim([0 Fs_Hz/2])
ylabel('Magnitude (dB)')
xlabel('Frequency (Hz)')

set(gcf,'units','norm','pos',[0.5005    0.0565    0.4990    0.8324])


%% Plot and listen to UCORR stimuli
figure(3); clf
subplot(211)
plot(timevec_sec*1000,signal_UCORR,'r'); hold on; plot(timevec_sec*1000,standard_UCORR,'b'); hold off
xlim([0 dur_noise_sec*1000])
ylim(YLIMITS)
ylabel('Amp')
xlabel('Time (msec)')
title(sprintf('UCORR CONDITION:   STD: %s;    \nSIG: %s',std_UCORR_fname,sig_UCORR_fname),'interpreter','none')
subplot(212)
plot(freqvec_Hz,20*log10(abs(fft(signal_UCORR))),'r'); hold on; plot(freqvec_Hz,20*log10(abs(fft(standard_UCORR))),'b'); hold off
xlim([0 Fs_Hz/2])
ylabel('Magnitude (dB)')
xlabel('Frequency (Hz)')

set(gcf,'units','norm','pos',[0.5005    0.0565    0.4990    0.8324])

%% Play sounds 

disp('Playing Standard the Signal:  REF condition then CORR then UCORR')
soundsc([standard_REF zeros(size(signal_REF)) signal_REF zeros(1,3*len_noise) ...
    standard_CORR zeros(size(signal_CORR)) signal_CORR zeros(1,3*len_noise) ...
    standard_UCORR zeros(size(signal_UCORR)) signal_UCORR],Fs_Hz)

input('press Enter to Hear Again (REF then CORR then UCORR)')

soundsc([standard_REF zeros(size(signal_REF)) signal_REF zeros(1,3*len_noise) ...
    standard_CORR zeros(size(signal_CORR)) signal_CORR zeros(1,3*len_noise) ...
    standard_UCORR zeros(size(signal_UCORR)) signal_UCORR],Fs_Hz)


cd('..\')    
