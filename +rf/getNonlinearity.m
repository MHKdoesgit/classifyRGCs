function [ values, centers,sevalues] = getNonlinearity(linearOutput, spikes, nbins, dt)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

qtStep = 1/nbins;
qtEdges = 0:qtStep:1;
genEdges = quantile(linearOutput, qtEdges);

[a, spikebins] = histc(linearOutput,genEdges);

values   = accumarray(spikebins, spikes', [nbins+1 1], @sum);
sdvalues = accumarray(spikebins, spikes', [nbins+1 1], @std);

values   = values./a/dt;
sevalues = sdvalues./sqrt(a)/dt;

values(end)=[];
sevalues(end)=[];
centers = genEdges(1:nbins)+diff(genEdges)/2; 
 
end

