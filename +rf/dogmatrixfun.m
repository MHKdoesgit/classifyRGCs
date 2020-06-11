function [ F,J] = dogmatrixfun( params, xy)
%DOGFUN evaluates modified gaussian with params at x
%   Output: 
%       F: function value
%       J: Jacobian of the parameters
%Written by Dimos.
%==========================================================================
%Unwrap inputs
%==========================================================================
x=xy{1}; y=xy{2}; x=x(:); y=y(:);

mx=params(1); my=params(2); sx=params(3); sy=params(4);
rho=params(5); k=params(6); Ac=params(7); As=params(8);
%==========================================================================
%Calculate function value
%==========================================================================
inExpC=-(2*(1-rho^2))^-1 * ((x-mx).^2/sx^2 + (y-my).^2/sy^2 - 2*rho*(x-mx).*(y-my)/(sx*sy));
inExpS=inExpC./k.^2;
F = Ac*exp(inExpC)-As*exp(inExpS);
%==========================================================================
%Calculate Jacobian
%==========================================================================
if nargout>1
    dmx=-(2*(1-rho^2))^-1 * (-2*(x-mx)/sx^2+2*rho.*(y-my)/(sx*sy));
    J1=Ac*exp(inExpC).*dmx-As*exp(inExpS).*dmx*(k^-2);

    dmy=-(2*(1-rho^2))^-1 * (-2*(y-my)/sy^2+2*rho.*(x-mx)/(sx*sy));
    J2=Ac*exp(inExpC).*dmy-As*exp(inExpS).*dmy*(k^-2);

    dsx=(-(2*(1-rho^2))^-1).*(-2*sx^-3*(x-mx).^2+2*sx^-2*rho*(x-mx).*(y-my)/sy);
    J3=Ac*exp(inExpC).*dsx-As*exp(inExpS).*dsx*(k^-2);

    dsy=(-(2*(1-rho^2))^-1).*(-2*sy^-3*(y-my).^2+2*sy^-2*rho*(x-mx).*(y-my)/sx);
    J4=Ac*exp(inExpC).*dsy-As*exp(inExpS).*dsy*(k^-2);

    dr=inExpC*2*rho/(1-rho^2) + (-(2*(1-rho^2))^-1).*(- 2*(x-mx).*(y-my)/(sx*sy));
    J5=Ac*exp(inExpC).*dr-As*exp(inExpS).*dr*(k^-2);

    J6=2*As*(k^-3)*exp(inExpS).*inExpC;
    J7=exp(inExpC); J8=-exp(inExpS);
    J=[J1 J2 J3 J4 J5 J6 J7 J8];
end
%==========================================================================
end

