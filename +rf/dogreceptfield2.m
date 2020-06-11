function [params]= dogreceptfield2(spx,spy,img)
%DOGRECEPTFIELD

%==========================================================================
%define ranges
cx=median(spx); cy=median(spy);
dx=mean(diff(spx)); dy=mean(diff(spy));

[X,Y] = meshgrid((spx-cx)/dx,(spy-cy)/dy);
%==========================================================================
%get circular guess
circguess = rf.fitCircDogRF((spx-cx)/dx,(spy-cy)/dy, img);
guess = [circguess(1:2) circguess(3) circguess(3) 0 1 circguess(5:6)];
%==========================================================================
%Define lower and upper bounds for the parameters
lb=[guess(1)-range(X(:))/2 guess(2)-range(Y(:))/2     0              0       -1  1   0    0];
ub=[guess(1)+range(X(:))/2 guess(2)+range(Y(:))/2 range(X(:))/2 range(Y(:))/2 1 Inf Inf Inf];
%==========================================================================
%Setting up linear inequality constraints
A=[]; b=[]; 
%==========================================================================
[fstart, startGrad] = rf.dogmatrixfun(guess,{X(:), Y(:)}); %calculate gradient at initial point
if ~all(isfinite(fstart)), params = NaN(size(guess)); return; end
% if all(isfinite(startGrad)); useGrad = true; else, useGrad = false; end
%==========================================================================

%Perform the fit
options= optimoptions('fmincon','Algorithm','trust-region-reflective',...
    'Display','off','SpecifyObjectiveGradient',true,'CheckGradients',false);

foptim=@(p) dogOptim(p,{X(:), Y(:)},img(:));

params = fmincon(foptim, guess,A,b,[],[],lb,ub,[],options);
%==========================================================================
%Bring parameters to original scale
params(1) = params(1)*dx+cx; params(2)=params(2)*dy+cy;
params(3) = params(3)*dx;    params(4)=params(4)*dy;
%==========================================================================
end


function [f,g] = dogOptim(p,X,Y)
% Calculate objective f

[lf,lg]= rf.dogmatrixfun(p,X);

f = 0.5 * ((lf - Y)' * (lf - Y));

if nargout > 1 % gradient required
    g = (lf-Y)'*lg;
end
    
end
