function [ F,J] = gaussMatrixCircFun( params, xy)
%DOGFUN evaluates modified gaussian with params at x
%   Output: 
%       F: function value
%       J: Jacobian of the parameters
%Written by Dimos.
%==========================================================================
%Unwrap inputs
%==========================================================================
x=xy{1}; y=xy{2}; x=x(:); y=y(:);

mx=params(1); my=params(2); ss=params(3); Ac=params(4);
%==========================================================================
%Calculate function value
%==========================================================================
inExpC=-((x-mx).^2 + (y-my).^2)/(2*ss^2);
F = Ac*exp(inExpC);
%==========================================================================
%Calculate Jacobian
%==========================================================================
if nargout>1
    dmx=(x-mx)/ss^2;
    J1=Ac*exp(inExpC).*dmx;

    dmy=(y-my)/ss^2;
    J2=Ac*exp(inExpC).*dmy;

    dss=((x-mx).^2 + (y-my).^2)*ss^-3;
    J3=Ac*exp(inExpC).*dss;
    J4=exp(inExpC); 
    J=[J1 J2 J3 J4];
end
%==========================================================================
end

