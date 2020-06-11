function [ F, J ] = gaussian2DFun( params, xy)
%GAUSSIAN2DFUN evaluates modified gaussian with params at x
%   Output: 
%       F: function value
%       J: Jacobian of the parameters
%Written by Dimos.

%==========================================================================
%Unwrap inputs
%==========================================================================
x=xy{1}; y=xy{2}; x=x(:); y=y(:);

mx=params(1); my=params(2); sx=params(3); sy=params(4);
rho=params(5); A=params(6);
%==========================================================================

%==========================================================================
%Calculate function value
%==========================================================================
inExp=-(2*(1-rho^2))^-1*((x-mx).^2/sx^2 + (y-my).^2/sy^2 - 2*rho*(x-mx).*(y-my)/(sx*sy));
multi=(2*pi*sx*sy*sqrt(1-rho^2))^-1;
F = A*multi*exp(inExp);
%==========================================================================

%==========================================================================
%Calculate Jacobian
%==========================================================================
if nargout>1
    dmx=-(2*(1-rho^2))^-1 * (-2*(x-mx)/sx^2+2*rho.*(y-my)/(sx*sy));
    J1=A*multi*exp(inExp).*dmx;

    dmy=-(2*(1-rho^2))^-1 * (-2*(y-my)/sy^2+2*rho.*(x-mx)/(sx*sy));
    J2=A*multi*exp(inExp).*dmy;

    dsx1=-multi/sx;
    dsx2=(-(2*(1-rho^2))^-1).*(-2*sx^-3*(x-mx).^2+2*sx^-2*rho*(x-mx).*(y-my)/sy);
    J3=A*exp(inExp).*(dsx1+multi.*dsx2);

    dsy1=-multi/sy;
    dsy2=(-(2*(1-rho^2))^-1).*(-2*sy^-3*(y-my).^2+2*sy^-2*rho*(x-mx).*(y-my)/sx);
    J4=A*exp(inExp).*(dsy1+multi.*dsy2);

    dr1=multi*rho/(1-rho^2);
    dr2=inExp*2*rho/(1-rho^2) + (-(2*(1-rho^2))^-1).*(- 2*(x-mx).*(y-my)/(sx*sy));
    J5=A*exp(inExp).*(dr1+multi.*dr2);

    J6=multi*exp(inExp);

    J=[J1 J2 J3 J4 J5 J6];
end
%==========================================================================
end

