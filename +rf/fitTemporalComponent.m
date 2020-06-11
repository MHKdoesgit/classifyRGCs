function [params] =fitTemporalComponent(tt, yy)
%UNTITLED2 Summary of this function goes here
%   tt should be in ms!!!
%==========================================================================
%Define lower and upper bounds for the parameters
lb=[0 min(abs(tt)) 0 min(abs(tt)) 0];
ub=[Inf min([0.4 max(abs(tt))]) Inf min([0.4 max(abs(tt))]) Inf];
%==========================================================================
%construct guess
dt=mean(diff(tt));
ysmooth=smoothdata(yy,'gaussian',0.05/dt);

[m1,idx1]=max(ysmooth);
[m2,idx2]=min(ysmooth);
m1=max(m1,1e-3); m2=min(m2,-1e-3);
tg1=max(dt,abs(tt(idx1))); tg2=max(dt,abs(tt(idx2)));

%nguess=max([1 log(10/m1) log(10/abs(m2))]);
%guess=[100 tg1 100 tg2 nguess];
guess=[m1 tg1 abs(m2) tg2 5];

pp=polyfit(rf.templowpass(guess,tt),ysmooth,1);

guess=[m1*pp(1) tg1 abs(m2)*pp(1) tg2 5];

[~,startGrad]=rf.templowpass(guess,tt); %calculate gradient at initial point
if all(isfinite(startGrad)); useGrad=true; else, useGrad=false; end

guessopts= optimoptions('lsqcurvefit','Display','off',...
    'SpecifyObjectiveGradient',useGrad,'CheckGradient',false);
guessparams=lsqcurvefit(@rf.templowpass, guess, tt, ysmooth,lb,ub,guessopts);
%==========================================================================
[~,startGrad]=rf.templowpass(guessparams,tt); %calculate gradient at initial point
if all(isfinite(startGrad)); useGrad=true; else, useGrad=false; end

%perform the final fit
opts= optimoptions('lsqcurvefit','Display','off',...
    'FunctionTolerance',eps*1e3,'MaxIterations',1e3,...
    'SpecifyObjectiveGradient',useGrad,'CheckGradient',false);
params=lsqcurvefit(@rf.templowpass, guessparams, tt, yy,lb,ub,opts);
%==========================================================================
end
