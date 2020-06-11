function [params,res,rsq] = fitParametricSTA2(tt,spx, spy, sta,guess)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% tt should be in ms
%==========================================================================
%Setup variable ranges
cx=median(spx); cy=median(spy); 
dx=mean(diff(spx)); dy=mean(diff(spy));

[Y,T,X] = meshgrid((spy-cy)/dy,tt,(spx-cx)/dx);
%==========================================================================
%Setup guess
tempGuess=guess(1:5);
spaceGuess=guess(6:end);
spaceGuess(1)=(spaceGuess(1)-cx)/dx; spaceGuess(2)=(spaceGuess(2)-cy)/dy;
spaceGuess(3)=spaceGuess(3)/dx; spaceGuess(4)=spaceGuess(4)/dy;

guessfit=[tempGuess spaceGuess];
%==========================================================================
%Setup sta range
tvec = rf.templowpass(tempGuess,tt);

maxt = max(abs(tvec));
maxs = 1-spaceGuess(end);
maxsta = max(abs(sta(:)));

stafit = sta*maxt*maxs/maxsta;
%==========================================================================
%Define lower and upper bounds for the parameters
%mint=min(abs(tt)); maxt=max(abs(tt));
mint = min(tempGuess([2 4]))/4; maxt=max(abs(tt));
tlb = [0 mint 0 mint 0];  
tub = [Inf maxt Inf maxt Inf];

%spatial bounds
splb=[spaceGuess(1)-range(X(:))/2 spaceGuess(2)-range(Y(:))/2 0 0 -1 1 0];
spub=[spaceGuess(1)+range(X(:))/2 spaceGuess(2)+range(Y(:))/2 range(X(:))/2 range(Y(:))/2 1 Inf Inf];

%combine bounds
lb=[tlb splb]; ub=[tub spub];
%==========================================================================
%b=[0]; 
% 
% if spaceGuess(3)>spaceGuess(4)
%    A = [0,0,0,0,0,0,0,-1,1,0,0,0]; %sy should be smaller than sx
% else
%    A = [0,0,0,0,0,0,0,1,-1,0,0,0]; %sy should be smaller than sx
% end

if spaceGuess(5)>0; lb(10)=0; else; ub(10)=0;end
%==========================================================================
%Calculate gradient at initial point
[~,startGrad] = rf.tempDOG3DFun(guessfit,{T(:), X(:), Y(:)}); %calculate gradient at initial point
if all(isfinite(startGrad)); useGrad=true; else, useGrad=false; end
if ~all(isfinite(startGrad)); params = NaN(size(guessfit)); return; end
%==========================================================================
%Perform the fit

options= optimoptions('fmincon','Algorithm','trust-region-reflective',...
    'Display','off','SpecifyObjectiveGradient',useGrad,'CheckGradients',false);

foptim=@(p) funOptim(p,{T(:), X(:), Y(:)},stafit(:));
[params,res]= fmincon(foptim, guessfit,[],[],[],[],lb,ub,[],options);

Z = rf.tempDOG3DFun(params,{T(:), X(:), Y(:)});

rsq = rf.rsquare(stafit(:),Z);

% plotTimeCourseSTA(reshape(Z,numel(tt),numel(spy),numel(spx)));
% plotTimeCourseSTA(sta);
%==========================================================================
%Bring parameters to original scale
params(6)=params(6)*dx+cx; params(7)=params(7)*dy+cy;
params(8)=params(8)*dx; params(9)=params(9)*dy;
%==========================================================================
end

function [f,g] = funOptim(p,X,Y)
[lf,lg] = rf.tempDOG3DFun(p,X);
f = sum((lf-Y).^2)/2; % Calculate objective f
if nargout > 1
    g = (lf-Y)' * lg; 
end % gradient
end