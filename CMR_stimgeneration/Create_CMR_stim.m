% File: Create_CMR_stim.m
%
% Created: M. Heinz Jun 1 2020
% Modified by: Fernando Aguilera de Alba
% Branched Created: June 5th 2020

% Updated Jul 11 2020 - Generated CMR2D [0:4:40 dB]

% Updated: July 18 2020 by M Heinz to:
% 1) randomize noise across all instances (REF/COR/ACORR and all SPLs)
% *2) incorporate CMR2 and CMR3 (wider chin BWs)

%  1) to be more precise in chin ERB (*** still issues to resolve *** - see
%  Niemiec et al 1992 - we likely need to try CMR with narrow and broad ERB
%  estimates to see if any diffs, since chins seem to be broadband
%  processesors Yost and Shoffner 2009)  *****
% ????? still to resolve - what ERBs to use for chins (NN or CR/CB?)
%  2) to match Hari's params (see his email, code)
%  * make three noise bands independent
%  * use human ERBs from Moore and Glasberg, not just 15% estimate.
%  * ramp tone gradually re: noise, not delay onset.
%  * fix flanking band spacing to 1.5 ERB gap, not 2 ERB.
%  ??? remaining question - do we make each band ERB at it's CF, or tone's
%  frequency (i.e., same BW for all 3 bands (NOW), or broader as CF
%  increases? maybe how Hari does it?)
%  3) include noise (No: dB SPL/Hz) and tone (T: dB SPL) sound level in
%  file name
% ????? still to resolve: adapt on tone or noise level? (easy to setup
% either way)

% Creates a set of basic CMR stimuli (REF, CORR, ACORR) for one condition.
%% REF:
% Steady tone is to be detected within a modulated (10 Hz SAM) narrowband
% (1 ERB) wide noise centered on tone.  Tone ramp is gradual re: noise.
%% CORR:
% Two independent flanking noise bands are added (one below and one above
% the tone). The spacing between the tone frequency and the closest
% flanking noise bands edge (e.g., lower edge of upper band) is 2 ERBs
% (i.e., edge to edge gap is 1.5 ERBs). All three bands are co-modulated
% (in phase) with 10 Hz SAM.
%% ANTI-CORR (ACORR):
% Same two flanking noise bands are added.  But here, the flanking bands
% are modualted out of phase (180 deg) with the center band.
%% CMR_dB = Threshold_ACORR (tone dB SPL) - Thresholds_CORR (tone dB SPL)  (Hari YNH: ~10-12 dB, < 5% have 3 dB or less)
%% or CMR_dB = Threshold_REF (tone dB SPL) - Thresholds_CORR (tone dB SPL) (Hari YNH: ~3 dB)


clear all; close all; clc
% -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% SECTION 1: SIGNAL GENERATION

%% Menu Selection: Chin or Human & CMRstim condition (e.g., CMR2, CMR3)
% Pick chin (C) or human (H)
subject = input('\nSubject: Chinchilla (C) OR Human (H): ','s');
CMRstimuli = input('\nCMR stimuli (e.g., CMR3): ','s');

%% Parameters
f_Hz = 4000;  % center frequency of tone and on-frequency band (OFB)

% Noise BW set to 1 ERB (either chin or human)
% Chin
if subject == 'C' || subject == 'c'
    if strcmp(CMRstimuli,'CMR2') | strcmp(CMRstimuli,'CMR1')
        Q10_chin = 3.7;  % for chins at 4kHz (Temchin and Ruggero 2008 (I; Fig. 6B); Kale and Heinz 2010)
        BW10dB_chin_Hz = f_Hz/Q10_chin;
        % ERB_chin_Hz = BW10dB_chin_Hz; % use Q10 as approx for ERB [1080 Hz at 4kHz] % Probably not right.
        ERB_chin_Hz = BW10dB_chin_Hz/2;  % from Patterson et al (2005) ISH2003, response to comment from Kollmeier (pp 28-29).
        %% ****** TO DO - decide how to handle this.  Lab mammals are ~2-3 worse tuning than humans (Shera at al), so the 1080 to 456 ratio makes sense.  But, Q10 BWs are 2 times bigger than ERB estimates (Patterson et al., 2005 (ISH2003)), so perhaps they are closer than 2-3 times?  Look at Shoffner pitch studies as well (resolved harmonics - he must comment on chin vs human).
        % Niemiec et al (Shofner), 1992 - measured behavior ERBs in chins, and
        % found NN estimates in chins were comparable (or narrower) to humans, but
        % CR and CB estimate using noise bands centered on tone gave estimate much
        % broader - they attribute this to chins being more broadband listeners
        % than humans (e.g., central processing diffs, more than peripheral diffs -
        % SO WE MAY NEED TO TRY CMR WITH SEVERAL BWs to explore.  Go with narrower
        % for now.
    elseif strcmp(CMRstimuli,'CMR3')
        % Niemiec found (at 4 kHz): NN = 335; CB = ~1800
        % Yost and Shofner have CB data across several studies:
        % Fig.1: CR:  chins: 1250, 1350, 1700 = mean 1433 Hz
        % 1400 causes problems with lower band crossing ZERO
        % USE 1200 Hz as ~CB (~CR in studies 1 and 2; and our Q10 BW = 1080 Hz),
        % which is perhaps more apprporiate since on-CF energy is what CNR uses
        % (so CR, CB more comparable than NN)
        % This leave 400 Hz gap from DC to 400Hz - avoids any real LF issues.
        ERB_chin_Hz = 1200;
    else
        error('no chin ERB set for this CMRstim #')
    end
    BWnoise_Hz = ERB_chin_Hz;
    fprintf('...Using chin ERBs (%.f Hz) [Fc= %.f kHz]\n',BWnoise_Hz,f_Hz/1000)
    CMRcondition = sprintf('%s_Chin',CMRstimuli);
    % Human
elseif subject == 'H' || subject == 'h'
    ERB_human_Hz = 24.7*(4.37*f_Hz/1000+1);  % from Moore and Glasberg (1983) [456 Hz at 4kHz]
    %  B.C.J. Moore and B.R. Glasberg, "Suggested formulae for calculating
    %  auditory-filter bandwidths and excitation patterns" Journal of the Acoustical Society of America 74: 750-753, 1983.
    
    BWnoise_Hz = ERB_human_Hz;
    fprintf('...Using human ERBs (%.f Hz) [Fc= %.f kHz]\n',BWnoise_Hz,f_Hz/1000)
    CMRcondition = sprintf('%s_Human',CMRstimuli);
else
    error('Please enter a valid character (C or H)');   
end


% CMR condition predetermined from Menu option (CMRChin or CMRHuman)
fprintf('Generating "%s" stimuli ...\n',CMRcondition)
%% Adjust to find threshold
if ~isempty(strfind(CMRcondition,'Chin'))
    levelVEC_tone_dBSPL = 35:4:75;  % ALL tone levels to include
elseif ~isempty(strfind(CMRcondition,'Human'))
    levelVEC_tone_dBSPL = 9:4:65;  % ALL tone levels to include
end
if strcmp(CMRstimuli,'CMR2')
    NoVEC_dBSPL_Hz=30;  % ALL Noise Spectrum levels to include (OAL noise = No + 10*log10(BW))
elseif strcmp(CMRstimuli,'CMR3')
    NoVEC_dBSPL_Hz=20;  % ALL Noise Spectrum levels to include (OAL noise = No + 10*log10(BW))
end
dur_sec=500/1000;
rft_noise_sec=20/1000;
rft_tone_sec=150/1000;
fmod_Hz = 10;   % SAM modulation for noises
fprintf('...Tone levels (dB SPL): %s\n',mat2str(levelVEC_tone_dBSPL))
fprintf('...Noise levels (dB SPL/Hz): %s\n',mat2str(NoVEC_dBSPL_Hz))

%% Read in previously calibrated stim, and confirm TDT Fs sampling rate (Fs)
% see confirm_old_calib (based on tone we know was calibrated at one point
% to be 70 dB SPL)
fprintf('...Calibrating based on previous stimuli\n')
[calib_dBSPL,calib_70dBtone_rms,Fs_Hz] = confirm_old_calib;  % 70 dB SPL tone is rms of 0.02.

%% Compute center frequencies of all noise bands
f_LSB_Hz = f_Hz - 2.5*BWnoise_Hz;  % center frequency of lower-side-band (LSB) (creates 1.5-ERBgap between OFB lower edge and LSB upper edge)
f_USB_Hz = f_Hz + 2.5*BWnoise_Hz;  % center frequency of upper-side-band (USB) (creates 1.5-ERBgap between OFB upper edge and USB lower edge)
if (f_LSB_Hz-0.5*BWnoise_Hz <= 0) % confirm there is room for LSB
    error('lower side band is below 0Hz');
end
if (f_USB_Hz+0.5*BWnoise_Hz >= Fs_Hz/2) % confirm there is room for USB
    error('upper side band is above Fs = %s Hz', mat2str(Fs_Hz/2));
end

%% Make signals
len_samples = round(dur_sec*Fs_Hz);
timevec_sec = (0:(len_samples-1))/Fs_Hz;
freqvec_Hz = (0:(len_samples-1))*Fs_Hz/len_samples;
% Tone
tone = sin(2*pi*f_Hz*timevec_sec);
%% Make noise-band filter
fprintf('...Creating noise-band filter\n')
% Filter design (LPF at BW/2)
Rp  = 0.00057565; % Corresponds to 0.01 dB peak-to-peak ripple
Rst = 1e-4;       % Corresponds to 80 dB stopband attenuation
TW_Hz=50;  % Transition Width = 100 Hz
b = firgr('minorder',[0,((BWnoise_Hz)/2/(Fs_Hz/2)),((BWnoise_Hz/2+TW_Hz)/(Fs_Hz/2)),1],[1 1 0 0],...
    [Rp Rst]);
% fvt = fvtool(b,1,'Fs',Fs_Hz,'Color','White');  %

%% Decide if save/plot wav files
signalsave_user = input('\nSave audio files (Y/N): ', 's');
if signalsave_user == 'Y' || signalsave_user == 'y'
    signalplot_user = input('\nPlot audio files (Y/N): ','s');
end
% cannot plot signals if they are not saved
if signalsave_user == 'N' || signalsave_user == 'n'
    signalplot_user = 'N';
end

%% Generate Stimuli fprintf('...Creating stimuli\n')
% Prior to Jul 18,2020 - we had things set to generate same noise token
% for (may have led to better performance for some listeners): 
% 1) sig&std
% 2) three bands
% 3) three conditions (REF/CORR/ACORR)
% 4) all SPLs
% NOW: fresh noise token for all bands, stg & std, all 3 conditions, all SPLs 
% Ideally we'd do fresh for all stimuli, but with WAV files this is best
% without many many wav files

% start with BBnoise (long enough to avoid end point issues with filtering,
% and 3 bands to be chosen from with (5 times length needed)
Nconds=3; % REF=1; CORR=1; ACORR=3
Nsigstd=2; % Signal = 1; Standard = 2;
NlevsT=length(levelVEC_tone_dBSPL);
NlevsN=length(NoVEC_dBSPL_Hz);
noise_OFB=cell(NlevsT,NlevsN,Nsigstd,Nconds);
noise_LSB=cell(NlevsT,NlevsN,Nsigstd,Nconds);
noise_USB=cell(NlevsT,NlevsN,Nsigstd,Nconds);

% Gen all indep noise bands
for noiseIND=1:NlevsN
    for toneIND=1:NlevsT
        for SigStdIND=1:Nsigstd  % Signal = 1; Standard = 2;
            for CondIND=1:Nconds   % REF=1; CORR=1; ACORR=3
                % Apply filter to BB noise (extra length to avoid endpt
                % issues); 3 bands (LSB, OFB, USB) are taken from middle 3 independent samples
                temp_noise_LPF = filter(b,1,randn(1,5*len_samples));

                % modulate up to 3 CFs
                noise_OFB{noiseIND,toneIND,SigStdIND,CondIND} = temp_noise_LPF(1,len_samples+1:2*len_samples).*sin(2*pi*f_Hz*timevec_sec);
                noise_LSB{noiseIND,toneIND,SigStdIND,CondIND} = temp_noise_LPF(1,2*len_samples+1:3*len_samples).*sin(2*pi*f_LSB_Hz*timevec_sec);
                noise_USB{noiseIND,toneIND,SigStdIND,CondIND} = temp_noise_LPF(1,3*len_samples+1:4*len_samples).*sin(2*pi*f_USB_Hz*timevec_sec);
 
                %% Modulate each noise band - depending on condition
                % All 3 conditions same for OFB
                noise_OFB{noiseIND,toneIND,SigStdIND,CondIND} = noise_OFB{noiseIND,toneIND,SigStdIND,CondIND}.*(1+sin(2*pi*fmod_Hz*timevec_sec));
                if CondIND==1 % REF
                    noise_LSB{noiseIND,toneIND,SigStdIND,CondIND} = NaN*ones(size(noise_LSB{noiseIND,toneIND,SigStdIND,CondIND}));  % no LSB for REF
                    noise_USB{noiseIND,toneIND,SigStdIND,CondIND} = NaN*ones(size(noise_USB{noiseIND,toneIND,SigStdIND,CondIND}));  % no USB for REF
                elseif CondIND==2 % CORR
                    noise_LSB{noiseIND,toneIND,SigStdIND,CondIND} = noise_LSB{noiseIND,toneIND,SigStdIND,CondIND}.*(1+sin(2*pi*fmod_Hz*timevec_sec));   % Correlated modulation
                    noise_USB{noiseIND,toneIND,SigStdIND,CondIND} = noise_USB{noiseIND,toneIND,SigStdIND,CondIND}.*(1+sin(2*pi*fmod_Hz*timevec_sec));
                elseif CondIND==3 % ACORR
                    noise_LSB{noiseIND,toneIND,SigStdIND,CondIND} = noise_LSB{noiseIND,toneIND,SigStdIND,CondIND}.*(1-sin(2*pi*fmod_Hz*timevec_sec));  % Anti-correlated modulation
                    noise_USB{noiseIND,toneIND,SigStdIND,CondIND} = noise_USB{noiseIND,toneIND,SigStdIND,CondIND}.*(1-sin(2*pi*fmod_Hz*timevec_sec));
                end
            end
        end
    end
end

%% Generate all stimuli for all tone and No levels
for noiseIND=1:length(NoVEC_dBSPL_Hz)
    No_dBSPL_Hz=NoVEC_dBSPL_Hz(noiseIND);  % Noise Spectrum level (OAL noise = No + 10*log10(BW))
    rms_noise_new = calib_70dBtone_rms * 10^((No_dBSPL_Hz+10*log10(BWnoise_Hz)-calib_dBSPL)/20);
    for toneIND=1:length(levelVEC_tone_dBSPL)
        level_tone_dBSPL = levelVEC_tone_dBSPL(toneIND);
        %% Calibration
        rms_tone_new = calib_70dBtone_rms * 10^((level_tone_dBSPL-calib_dBSPL)/20);
        tone = tone/rms(tone)*rms_tone_new;
        
        for SigStdIND=1:Nsigstd  % Signal = 1; Standard = 2;
            for CondIND=1:Nconds   % REF=1; CORR=1; ACORR=3
                noise_OFB{noiseIND,toneIND,SigStdIND,CondIND} = noise_OFB{noiseIND,toneIND,SigStdIND,CondIND}/rms(noise_OFB{noiseIND,toneIND,SigStdIND,CondIND})*rms_noise_new;
                noise_LSB{noiseIND,toneIND,SigStdIND,CondIND} = noise_LSB{noiseIND,toneIND,SigStdIND,CondIND}/rms(noise_LSB{noiseIND,toneIND,SigStdIND,CondIND})*rms_noise_new;
                noise_USB{noiseIND,toneIND,SigStdIND,CondIND} = noise_USB{noiseIND,toneIND,SigStdIND,CondIND}/rms(noise_USB{noiseIND,toneIND,SigStdIND,CondIND})*rms_noise_new;
                %                 noise_USB_CORR = noise_USB_CORR/rms(noise_USB_CORR)*rms_noise_new;
                %                 noise_LSB_ACORR = noise_LSB_ACORR/rms(noise_LSB_ACORR)*rms_noise_new;
                %                 noise_USB_ACORR = noise_USB_ACORR/rms(noise_USB_ACORR)*rms_noise_new;
        
                %% Apply ramps to each signals (after calibration)
                tone_rft=linear_window_waveform(tone,Fs_Hz,rft_tone_sec);    % Tone is ramped differently then noise bands (keep rft separate from tone for calibrations)
                noise_OFB{noiseIND,toneIND,SigStdIND,CondIND}=linear_window_waveform(noise_OFB{noiseIND,toneIND,SigStdIND,CondIND},Fs_Hz,rft_noise_sec);
                noise_LSB{noiseIND,toneIND,SigStdIND,CondIND}=linear_window_waveform(noise_LSB{noiseIND,toneIND,SigStdIND,CondIND},Fs_Hz,rft_noise_sec);
                noise_USB{noiseIND,toneIND,SigStdIND,CondIND}=linear_window_waveform(noise_USB{noiseIND,toneIND,SigStdIND,CondIND},Fs_Hz,rft_noise_sec);
            end % Cond
        end %SigStd
            
        %% Create complete signals
        signal_REF = tone_rft + noise_OFB{noiseIND,toneIND,1,1};  %Sig,REF: 1,1
        standard_REF = noise_OFB{noiseIND,toneIND,2,1};  %Std,REF: 2,1
        signal_CORR = tone_rft + noise_OFB{noiseIND,toneIND,1,2} + noise_LSB{noiseIND,toneIND,1,2} + noise_USB{noiseIND,toneIND,1,2};  %Sig,CORR: 1,2
        standard_CORR = noise_OFB{noiseIND,toneIND,2,2} + noise_LSB{noiseIND,toneIND,2,2} + noise_USB{noiseIND,toneIND,2,2};  %Std,CORR: 2,2
        signal_ACORR = tone_rft + noise_OFB{noiseIND,toneIND,1,3} + noise_LSB{noiseIND,toneIND,1,3} + noise_USB{noiseIND,toneIND,1,3};  %Sig,ACORR: 1,3
        standard_ACORR = noise_OFB{noiseIND,toneIND,2,3} + noise_LSB{noiseIND,toneIND,2,3} + noise_USB{noiseIND,toneIND,2,3};  %Std,ACORR: 2,3
        % save all audio in signal and standard matrices
        standard_output_REF(toneIND,:) = standard_REF;
        standard_output_CORR(toneIND,:) = standard_CORR;
        standard_output_ACORR(toneIND,:) = standard_ACORR;
        signal_output_REF(toneIND,:) = signal_REF;
        signal_output_CORR(toneIND,:) = signal_CORR;
        signal_output_ACORR(toneIND,:) = signal_ACORR;
        %% Save files
        if signalsave_user == 'Y' || signalsave_user == 'y'
            % eventually we'll need to put in some parameter values for all the signal
            % levels
            % sigSNR_fname=sprintf('%s%s.wav',sig_fname(1:end-4),SNRaddon_text);   %'4kHz80dBT_999dBAM_NN.wav';
            % stdSNR_fname=sprintf('%s%s.wav',std_fname(1:end-4),SNRaddon_text);   %'4kHz80dBT_999dBAM_NN.wav';
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % LATER - add to file name/chinch code storage (chin/human, tone level,
            % noise level, BW)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % need to save T levels for std as well, since independent
            % noises
            std_REF_fname = sprintf('%s_REF_No%.f_T%.f_std.wav',CMRcondition,No_dBSPL_Hz,level_tone_dBSPL);  % test condition1
            sig_REF_fname = sprintf('%s_REF_No%.f_T%.f_sig.wav',CMRcondition,No_dBSPL_Hz,level_tone_dBSPL);
            std_CORR_fname = sprintf('%s_CORR_No%.f_T%.f_std.wav',CMRcondition,No_dBSPL_Hz,level_tone_dBSPL);  % test condition2
            sig_CORR_fname = sprintf('%s_CORR_No%.f_T%.f_sig.wav',CMRcondition,No_dBSPL_Hz,level_tone_dBSPL);
            std_ACORR_fname = sprintf('%s_ACORR_No%.f_T%.f_std.wav',CMRcondition,No_dBSPL_Hz,level_tone_dBSPL); % test condition3
            sig_ACORR_fname = sprintf('%s_ACORR_No%.f_T%.f_sig.wav',CMRcondition,No_dBSPL_Hz,level_tone_dBSPL);
            
            cd ('new_signals')
            % Check if CMRcondition Directory there, if not make it
            Dlist=dir(CMRcondition);
            if isempty(Dlist)
                fprintf('   ***Creating "%s" Directory\n',CMRcondition);
                mkdir(CMRcondition);
            end
            cd(CMRcondition);   % CHANGE FOLDER TO TYPE OF STIMULI
            
            fprintf('Saving WAV files:\n  %s\n  %s\n  %s\n  %s\n  %s\n  %s\n',std_REF_fname,sig_REF_fname,std_CORR_fname,sig_CORR_fname,std_ACORR_fname,sig_ACORR_fname)
            audiowrite(std_REF_fname,standard_REF,Fs_Hz)
            audiowrite(sig_REF_fname,signal_REF,Fs_Hz)
            audiowrite(std_CORR_fname,standard_CORR,Fs_Hz)
            audiowrite(sig_CORR_fname,signal_CORR,Fs_Hz)
            audiowrite(std_ACORR_fname,standard_ACORR,Fs_Hz)
            audiowrite(sig_ACORR_fname,signal_ACORR,Fs_Hz)
            cd ../
            cd ../
        end % save files prompt
        %% Plot Stimuli
        if signalplot_user == 'Y' || signalplot_user == 'y'
            %REF stimuli
            figure(toneIND); clf;
            ax1=subplot(231);
            plot(timevec_sec*1000,signal_REF,'r'); hold on; plot(timevec_sec*1000,standard_REF,'b'); hold off
            xlim([0 dur_sec*1000])
            ylabel('Amplitude')
            title(sprintf('REF CONDITION:\nSTD: %s;    \nSIG: %s',std_REF_fname,sig_REF_fname),'interpreter','none')
            ax4=subplot(234);
            plot(freqvec_Hz/1000,20*log10(abs(fft(signal_REF))),'r'); hold on; plot(freqvec_Hz/1000,20*log10(abs(fft(standard_REF))),'b'); hold off
            xlim([0 10])
            ylabel('Magnitude (dB)')
            set(gca,'XTick',[0:2:10])
            
            % CORR stimuli
            ax2=subplot(232);
            plot(timevec_sec*1000,signal_CORR,'r'); hold on; plot(timevec_sec*1000,standard_CORR,'b'); hold off
            xlim([0 dur_sec*1000])
            xlabel('Time (msec)')
            title(sprintf('CORR CONDITION:\nSTD: %s;    \nSIG: %s',std_CORR_fname,sig_CORR_fname),'interpreter','none')
            ax5=subplot(235);
            plot(freqvec_Hz/1000,20*log10(abs(fft(signal_CORR))),'r'); hold on; plot(freqvec_Hz/1000,20*log10(abs(fft(standard_CORR))),'b'); hold off
            xlim([0 10])
            xlabel('Frequency (kHz)')
            set(gca,'XTick',[0:2:10])
            
            % ACORR stimuli
            ax3=subplot(233);
            plot(timevec_sec*1000,signal_ACORR,'r'); hold on; plot(timevec_sec*1000,standard_ACORR,'b'); hold off
            xlim([0 dur_sec*1000])
            title(sprintf('ACORR CONDITION:\nSTD: %s;    \nSIG: %s',std_ACORR_fname,sig_ACORR_fname),'interpreter','none')
            ax6=subplot(236);
            plot(freqvec_Hz/1000,20*log10(abs(fft(signal_ACORR))),'r'); hold on; plot(freqvec_Hz/1000,20*log10(abs(fft(standard_ACORR))),'b'); hold off
            xlim([0 10])
            set(gca,'XTick',[0:2:10])
            
            linkaxes([ax1, ax2, ax3])
            linkaxes([ax4, ax5, ax6])
            
            set(gcf,'units','norm','pos',[0.2    0.0565    0.8    0.8324])
        end % plot prompt
    end % tone levels
end % noise levels
%% Normalize output amplitude
standard_output = [max(max(abs(standard_output_REF))) max(max(abs(standard_output_CORR))) max(max(abs(standard_output_ACORR)))];
signal_output = [max(max(abs(signal_output_REF))) max(max(abs(signal_output_CORR))) max(max(abs(signal_output_ACORR)))];
max_standard_output = max(standard_output);
max_signal_output = max(signal_output);
max_amplitude = 0;
% max amplitude is signal
if max_signal_output > max_standard_output
    max_amplitude = max_signal_output;
end
% max amplitude is standard
if max_standard_output > max_signal_output
    max_amplitude = max_standard_output;
end
standard_output_REF = standard_output_REF/max_amplitude;
standard_output_CORR = standard_output_CORR/max_amplitude;
standard_output_ACORR = standard_output_ACORR/max_amplitude;
signal_output_REF = signal_output_REF/max_amplitude;
signal_output_CORR = signal_output_CORR/max_amplitude;
signal_output_ACORR = signal_output_ACORR/max_amplitude;
%% save signal and standard output vectors
cd new_signals
cd(CMRcondition) % CHANGE FOLDER TO TYPE OF STIMULI
filename = sprintf('%s_Stimuli.mat',CMRcondition);  % test condition1
save(filename,'standard_output_REF','standard_output_CORR','standard_output_ACORR','signal_output_REF','signal_output_CORR','signal_output_ACORR','levelVEC_tone_dBSPL','Fs_Hz','CMRcondition');
cd ../
cd ../