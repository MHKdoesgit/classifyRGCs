function [ preds ] = getPredictionFromBinnedNonlinearity(gens, centers, values)
%GETPREDICTIONFROMBINNEDNONLINEARITY Summary of this function goes here
%   Detailed explanation goes here

if any(isnan(values))
    preds = NaN(size(gens));
    return;
end

preds =  interp1(centers,values,gens,'linear','extrap');


end

