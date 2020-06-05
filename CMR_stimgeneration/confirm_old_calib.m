function [calib_dBSPL,calib_70dBtone_rms,Fs] = confirm_old_calib
% File: confirm_old_calib
%
% Created: M. Heinz Jun 1 2020
%
% Just checks rough calibration based on a previous file we know is ~70 dB
% SPL overall level.  Includes 10 dB attenuation in chinch code.


clear all; close all; clc

%% Read in previously calibrated stim, and confirm TDT Fs sampling rate (Fs)
calib_fname='4kHz80dBT_999dBAM_NN.wav';   % 10 dB attenuation is added in chinch code.
calib_dBSPL=70; % This tone was calibrated at one point to be 70 dB SPL
cd('orig_signals')
[calibtone,Fs] = audioread(calib_fname);
calib_rms = rms(calibtone);   % 0.0196 Same for both!

calib_70dBtone_rms=0.02;  % Ballpark at 0.02.
cd ../
end
