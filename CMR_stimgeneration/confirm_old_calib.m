% File: Create_CMR_stim
%
% Created: M. Heinz Jun 1 2020
% Modified by: ??
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

%% Read in previously calibrated stim, and confirm TDT Fs sampling rate (Fs)
calib_fname='4kHz80dBT_999dBAM_NN.wav';
calib_dBSPL=80; % This tone was calibrated at one point to be 80 dB SPL
cd('orig_signals\')
[calibtone,Fs] = audioread(calib_fname);
calib_rms_80dBtone = rms(calibtone);   % 0.0196 Same for both!
a
calib_rms_80dBtone=0.02;

cd('../')

%% Compute duration, confirm the same, and make silence of same duration for playback.
dur_std_sec = length(std)/Fs;   % 
dur_sig_sec = length(sig)/Fs;   % 
if dur_std_sec ~= dur_sig_sec
    error('mismatching duration')
else
    dur_sec=dur_sig_sec;
    clear dur_sig_sec dur_std_sec
end
silence = zeros(size(sig));
timevec_sec = (1:length(sig))/Fs;
freqvec_Hz = (0:(length(sig)-1))*Fs/length(sig);

%% Compute amplitudes, confirm similar
max_std = max(abs(std));   % ~0.05 Good!! headroom
max_sig = max(abs(sig));
rms_std = rms(std);   % 0.0196 Same for both!
rms_sig = rms(sig);
if abs(max_std-max_sig) > 0.25*mean([max_std max_sig])
    error('mismatching max - more than 25% diff')
end
if abs(rms_std-rms_sig) > 0.01*mean([rms_std rms_sig])
    error('mismatching rms - more than 1% diff')
end

%% Plot original sounds 
figure(1); clf
subplot(211)
plot(timevec_sec*1000,std,'r'); hold on; plot(timevec_sec*1000,sig,'b'); hold off
xlim([0 250])
ylabel('Amp')
xlabel('Time (msec)')
title(sprintf('STD: %s;    \nSIG: %s',std_fname,sig_fname),'interpreter','none')
subplot(212)
plot(freqvec_Hz,20*log10(abs(fft(std))),'r'); hold on; plot(freqvec_Hz,20*log10(abs(fft(sig))),'b'); hold off
xlim([0 Fs/2])
ylabel('Magnitude (dB)')
xlabel('Frequency (Hz)')

set(gcf,'units','norm','pos',[0.5005    0.0565    0.4990    0.8324])


%% Play original sounds 
disp('Playing Standard then Signal')
sound([std silence sig],Fs)

input('Press Enter to Continue')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make NEW STIMULI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd('new_signals\')

%% Create BB (10kHz) noise to add to the original sounds
% Filter design
Wn=10000/(Fs/2);                 % normalized frequency re: Fs/2.
[b,a]=butter(8,Wn,'low');        % 8th order Butterworth - Lowpass digital filter design
% h = fvtool(b,a);                 % Visualize filter

%% Run through all SNRs
for SNR_dB = 8:-2:-12;
    SNR_fact= 10^(-SNR_dB/20);
    % noise for standard
    temp = randn(size(std));
    temp2=filter(b,a,temp);  % Apply filter to limit to 10 kHz
    std_noise = temp2/rms(temp2)*rms_std*SNR_fact;

    % noise for signal
    temp = randn(size(std));  
    temp2=filter(b,a,temp);  % Apply filter to limit to 10 kHz  
    sig_noise = temp2/rms(temp2)*rms_sig*SNR_fact;

    %% make new STIM
    sigIN=sig + sig_noise;
    stdIN=std + std_noise;

    %% Compute amplitudes, confirm similar
    rms_std_noise = rms(std_noise);   % 0.0196 Same for both!
    rms_sig_noise = rms(sig_noise);
    max_std_noise = max(abs(std_noise));   % ~0.15 Good!! bit of headroom
    max_sig_noise = max(abs(sig_noise));

    if abs(rms_std_noise-rms_sig_noise) > 0.25*mean([rms_std_noise rms_sig_noise])
        error('mismatching rms(with noise) - more than 25% diff')
    end
    % Confirm no WAV clipping 
    if max([max_std_noise max_std_noise]) >= 1
        error('sig_or_std_noise has MAXamp > 1)')
    end
    
    
    %% Plot new sounds
    figure(2); clf
    subplot(211)
    plot(timevec_sec*1000,stdIN,'r'); hold on; plot(timevec_sec*1000,sigIN,'b'); hold off
    xlim([0 250])
    ylabel('Amp')
    xlabel('Time (msec)')
    title(sprintf('SNR=%.fdB;  STD: %s;    \nSIG: %s',SNR_dB, std_fname,sig_fname),'interpreter','none')
    subplot(212)
    plot(freqvec_Hz,20*log10(abs(fft(stdIN))),'r'); hold on; plot(freqvec_Hz,20*log10(abs(fft(sigIN))),'b'); hold off
    xlim([0 Fs/2])
    ylabel('Magnitude (dB)')
    xlabel('Frequency (Hz)')
    
    set(gcf,'units','norm','pos',[0.5005    0.0565    0.4990    0.8324])
    
    
    %% Play new sounds
    disp(sprintf('In Noise (SNR=%.fdB): Playing Standard then Signal',SNR_dB))
    sound([stdIN silence sigIN],Fs)

    %% Save New Stim files
    if SNR_dB<0
        SNRaddon_text = sprintf('_n%.fdBSNR2f',abs(SNR_dB));
    else
        SNRaddon_text = sprintf('_%.fdBSNR2f',abs(SNR_dB));
    end
    sigSNR_fname=sprintf('%s%s.wav',sig_fname(1:end-4),SNRaddon_text);   %'4kHz80dBT_999dBAM_NN.wav';
    stdSNR_fname=sprintf('%s%s.wav',std_fname(1:end-4),SNRaddon_text);   %'4kHz80dBT_999dBAM_NN.wav';
    
    disp(sprintf('Saving\n   Std: %s\n   Sig: %s',stdSNR_fname,sigSNR_fname))
    audiowrite(stdSNR_fname,stdIN,Fs)
    audiowrite(sigSNR_fname,sigIN,Fs)
            
    input('Press Enter to Continue')
end

cd('..\')    
