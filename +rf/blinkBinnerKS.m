
function [ spikesbin ] = blinkBinnerKS(spiketimes, Ncells, fonsets, foffsets, nblinks, pulseRate)
%BLINKBINNER Summary of this function goes here
%
% This function bin the spiketimes bsed on stimulus ftimes.
%--------------------------------------------------------------------------
%   Input:
%       ftimes : stimulus frame timings. 
%       spikeTimes : Experiment spike timings.
%       nblinks : Number of blinks from experiment.
%   Output:
%   spikesbin : binned spiketimes.
%--------------------------------------------------------------------------
if numel(fonsets)>numel(foffsets)
    fonsets(end) = [];
end

totalFrames = numel(foffsets) * pulseRate;
stimFrames  = 1: nblinks:   totalFrames;

allfs = zeros(2*numel(fonsets),1);
allfs(1:2:end) = fonsets; 
allfs(2:2:end) = foffsets;

pframes = zeros(size(allfs));
pframes(1:2:end) = 1: pulseRate: totalFrames;
pframes(2:2:end) = 2: pulseRate: (totalFrames+1);

stimtimes = round(interp1(pframes, allfs, stimFrames,'linear','extrap'));

avgFrameInt = nanmean(diff(stimtimes));
stimtimes = [stimtimes stimtimes(end) + avgFrameInt];

Nframes = numel(stimtimes)-1;
%--------------------------------------------------------------------------
%do the binning
spikestobin = spiketimes(spiketimes(:,1)<=stimtimes(end) & spiketimes(:,1)>=stimtimes(1),:);
[~,~,bin] = histcounts(single(spikestobin(:,1)), single(stimtimes));
spikesbin = accumarray([spikestobin(:,2) bin], 1, [Ncells Nframes], @sum);
%--------------------------------------------------------------------------

end

