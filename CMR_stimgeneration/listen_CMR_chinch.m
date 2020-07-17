% File: listen_CMR_chinch

cd('C:\HEINZ\Work\Research\Behavior\CMRproject\CMR_stimgeneration\new_signals')

ToneLEV=75;



[std_REF, Fs] = audioread('CMR3_REF_No20_std.wav');
[sig_REF, Fs] = audioread(sprintf('CMR3_REF_No20_T%.f_sig.wav',ToneLEV));
std_REF=std_REF';
sig_REF=sig_REF';
disp('REF')
sound([std_REF zeros(size(std_REF)) sig_REF zeros(size(std_REF))],Fs)

pause(3)

[std_CORR, Fs] = audioread('CMR3_CORR_No20_std.wav');
[sig_CORR, Fs] = audioread(sprintf('CMR3_CORR_No20_T%.f_sig.wav',ToneLEV));
std_CORR=std_CORR';
sig_CORR=sig_CORR';
disp('CORR')
sound([std_CORR zeros(size(std_CORR)) sig_CORR zeros(size(std_CORR))],Fs)

pause(3)

[std_ACORR, Fs] = audioread('CMR3_ACORR_No20_std.wav');
[sig_ACORR, Fs] = audioread(sprintf('CMR3_ACORR_No20_T%.f_sig.wav',ToneLEV));
std_ACORR=std_ACORR';
sig_ACORR=sig_ACORR';
disp('ACORR')
sound([std_ACORR zeros(size(std_ACORR)) sig_ACORR zeros(size(std_ACORR))],Fs)


