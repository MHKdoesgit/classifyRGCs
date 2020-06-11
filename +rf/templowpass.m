function [f,J] = templowpass(params,tt)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%==========================================================================
%Unwrap inputs
%==========================================================================
tt=tt(:);
p1=params(1); tau1=params(2); p2=params(3); tau2=params(4);
n=params(5);
%==========================================================================

%==========================================================================
%Calculate function value
%==========================================================================
k1=(-tt/tau1).*exp(tt/tau1+1); k2=(-tt/tau2).*exp(tt/tau2+1);
f1=k1.^n; f2=k2.^n;
f = p1*f1-p2*f2;
%==========================================================================
%Calculate Jacobian
%==========================================================================
if nargout>1

    dp1=f1; 
    dtau1=-p1*f1*(n/tau1).*(1+tt/tau1);
    dp2=-f2; 
    dtau2=p2*f2*(n/tau2).*(1+tt/tau2);
    dn=p1*f1.*log(k1)-p2*f2.*log(k2);
    
    J=[dp1 dtau1 dp2 dtau2 dn]; 
end


