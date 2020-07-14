function [MSE,fit_vec_dB,fit_correctness_vec] = fitPsychometricFunctionCMR2(vec_dB,correctness_vec,plotYN,crit)
ll = 49;  ul = 101; % lower and upper limit for curves
x = vec_dB;
y = correctness_vec;
lower_asymptote = 50; % Min %correct in a 2AFC expt = 50% (chance level)
upper_asymptote = 100;
f = @(p,x) (upper_asymptote - lower_asymptote)./ (1 + exp(-(x-p(3))/p(4))) + lower_asymptote;
vals(1) = mean(correctness_vec([1,2]));
vals(2) = mean(correctness_vec([end-1,end]))-mean(correctness_vec([1,2]));
vals(3) = vec_dB(round(length(vec_dB)/2));
vals(4) = 25;
[BETA,R,J,COVB,MSE] = nlinfit(x,y,f,vals);
%% Plot/
if plotYN
hold on;
plot(x,y,'k*'); hold on % plot average scatter plot
plot(x,f(BETA,x),'color','r','linewidth',1.5)
plot(x,crit*ones(size(x)),'--k','markersize',10,'linewidth',1)
xlabel('dB')
ylabel('Correctness (%)')
ylim([ll ul]);
fit_vec_dB = x;
fit_correctness_vec = f(BETA,x);
end
end
