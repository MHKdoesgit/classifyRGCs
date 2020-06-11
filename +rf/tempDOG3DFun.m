function [ F,J] = tempDOG3DFun( params, txy)
%GAUSSIAN2DFUN evaluates modified gaussian with params at x
%   Output: 
%       F: function value
%       J: Jacobian of the parameters
%Written by Dimos.

%==========================================================================
%Unwrap inputs
%==========================================================================
tt =txy{1}; xx=txy{2}; yy=txy{3}; tt= tt(:);xx=xx(:); yy=yy(:);
tparams=params(1:5); 
spparams=[params(6:end-1) 1 params(end)];
%==========================================================================

%==========================================================================
%Calculate function value
%==========================================================================
[spf, spj] = rf.dogmatrixfun(spparams,{xx,yy}); spj(:,7)=[];
[tf, tj] = rf.templowpass(tparams,tt);
F = spf.*tf;
%==========================================================================
%Calculate Jacobian
%==========================================================================
if nargout>1
    J=[bsxfun(@times,spf,tj) bsxfun(@times,tf,spj)];
end
%==========================================================================
end

