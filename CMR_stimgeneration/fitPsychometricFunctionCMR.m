function [TH_dB,MSE,fit_vec_dB,fit_correctness_vec] = fitPsychometricFunctionCMR(vec_dB,correctness_vec,plotYN,crit)
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
%% pick region of function to interpolate
% (avoids "non-monotonic" error)
funvals = f(BETA,x);
ub = find(funvals>crit);
lb = find(funvals<crit);
bmax = min(ub);
bmin = max(lb);
try
TH_dB = interp1(f(BETA,x(bmin:bmax)),x(bmin:bmax),crit);
catch
    plot(x,y,'k*'); hold on
    line(x,f(BETA,x),'color','r')
   close;
   TH_dB = NaN;
end
if plotYN
    hold on;
    % plot(x,y,'k*'); hold on % plot average scatter plot
    line(x,f(BETA,x),'color','r','linewidth',2.5)
    plot(TH_dB,crit,'ok','markersize',10,'linewidth',2)
    plot(x,crit*ones(size(x)),'--k','markersize',10,'linewidth',1)
	text(TH_dB+1,.95*crit,sprintf('THR = %.1f dB SPL',TH_dB),'fontsize',25,'backgroundcolor','white')
    ylim([ll ul]);
end
fit_vec_dB = x;
fit_correctness_vec = f(BETA,x);
end
