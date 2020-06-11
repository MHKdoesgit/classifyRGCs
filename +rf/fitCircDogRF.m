function [params]= fitCircDogRF(spx,spy,img)
%DOGRECEPTFIELD
%==========================================================================
cx=median(spx); cy=median(spy);
dx=mean(diff(spx)); dy=mean(diff(spy));

[X,Y] = meshgrid((spx-cx)/dx,(spy-cy)/dy);
%==========================================================================
%fitZ=log(img(:)-min(img(:))+1e3);
%polyn=polyfitn([X(:) Y(:)],fitZ, [0 0;1 0;2 0;0 1;1 1;0 2]);
%Construct guess
[amp, im] = max(img(:));
%spMat=[X(:) Y(:)];
%spMat'*bsxfun(@times,spMat, img(:))

%rfinds=(img>amp/5);
rfinds=(img>3*std(img(:)));
if sum(rfinds)>0; guessmx=mean(X(rfinds)); guessmy=mean(Y(rfinds));
else, guessmx=X(im); guessmy=Y(im); end

guessArea=max([sum(rfinds(:)) 1]);
guessSigma=1.5*sqrt(guessArea)/2;

surrinds=(img<-3*std(img(:)));

guessSurrArea=sum(surrinds(:))+guessArea;

guesssc=sqrt(guessSurrArea/guessArea); 
guessAs=amp/exp(1/guesssc^2)/10; %start from no surround strength
guessAc=(amp+guessAs*exp(1/guesssc^2))/exp(1); 

guess=[guessmx guessmy guessSigma guesssc guessAc guessAs];
%==========================================================================
%Define lower and upper bounds for the parameters
lb=[guessmx-range(X(:))/2 guessmy-range(Y(:))/2 0 1 0 0];
ub=[guessmx+range(X(:))/2 guessmy+range(Y(:))/2 range(X(:))/2 Inf Inf Inf];
%==========================================================================
%Setting up linear inequality constraints
A=[0,0,0,0,-1,1]; %center must be stronger than surround
b=[0]; 
%==========================================================================
%Perform the fit
options= optimoptions('fmincon','Algorithm','sqp',...
    'Display','off','SpecifyObjectiveGradient',true,'CheckGradients',false);

foptim=@(p) dogOptim(p,{X(:), Y(:)},img(:));

params = fmincon(foptim, guess,A,b,[],[],lb,ub,[],options);
%==========================================================================
%Bring parameters to original scale
params(1)=params(1)*dx+cx; params(2)=params(2)*dy+cy;
params(3)=params(3)*dx;
%==========================================================================
end


function [f,g] = dogOptim(p,X,Y)
% Calculate objective f

[lf,lg]= rf.dogmatrixcircfun(p,X);

f = sum((lf-Y).^2)/2;

if nargout > 1 % gradient required
    g = sum((lf-Y).*lg);
end
    
end
