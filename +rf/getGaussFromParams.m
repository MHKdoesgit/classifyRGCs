function [gauss] = getGaussFromParams(params)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

gauss.mu=[params(1);params(2)];
gauss.sigma=[params(3)^2 params(5)*params(3)*params(4);...
    params(5)*params(3)*params(4) params(4)^2];


end

