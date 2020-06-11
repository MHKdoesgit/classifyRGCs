function [ F,J] = dogmatrixcircfun( params, xy)
%DOGFUN evaluates modified gaussian with params at x
%   Output: 
%       F: function value
%       J: Jacobian of the parameters
%Written by Dimos.
%==========================================================================
%Unwrap inputs
%==========================================================================
x=xy{1}; y=xy{2}; x=x(:); y=y(:);

mx=params(1); my=params(2); ss=params(3); 
k=params(4); Ac=params(5); As=params(6);
%==========================================================================
%Calculate function value
%==========================================================================
inExpC=-((x-mx).^2 + (y-my).^2)/(2*ss^2);
inExpS=inExpC./k.^2;
F = Ac*exp(inExpC)-As*exp(inExpS);
%==========================================================================
%Calculate Jacobian
%==========================================================================
if nargout>1
    dmx=(x-mx)/ss^2;
    J1=Ac*exp(inExpC).*dmx-As*exp(inExpS).*dmx*(k^-2);

    dmy=(y-my)/ss^2;
    J2=Ac*exp(inExpC).*dmy-As*exp(inExpS).*dmy*(k^-2);

    dss=((x-mx).^2 + (y-my).^2)*ss^-3;
    J3=Ac*exp(inExpC).*dss-As*exp(inExpS).*dss*(k^-2);

    J4=2*As*(k^-3)*exp(inExpS).*inExpC;
    J5=exp(inExpC); J6=-exp(inExpS);
    J=[J1 J2 J3 J4 J5 J6];
end
%==========================================================================
end

