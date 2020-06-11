

function [c] = getEllipseFromParams(params,nsigma,numpoints)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

if nargin<3; numpoints=50; end


gauss = rf.getGaussFromParams(params);
c     = rf.getEllipse(gauss, nsigma, numpoints); 
end

