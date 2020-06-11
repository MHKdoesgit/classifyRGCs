function [generators, spikes] = calculateLowRankGeneratorsbw(spikesbin, staspace, statime, seed)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   sta: last dimension can be types of stas


%--------------------------------------------------------------------------
[Ncells, Nframes, Nblocks]=size(spikesbin);
[~, Nyx] = size(staspace);
[~,  Nt] = size(statime);
%--------------------------------------------------------------------------
% filter with spatial components
stimulus   = zeros(Nyx, Nframes,'single'); %preallocate stimulus
filterstim = zeros(Ncells, Nframes, Nblocks, 'single');

for iblock = 1:Nblocks
    [stimulus(:),seed] = ran1bool(seed, Nyx*Nframes);
    stimulus = 2*stimulus - 1;
    filterstim(:, :, iblock) = staspace*stimulus;
end

% filter with temporal components
generators = zeros([Ncells, (Nframes-Nt+1) * Nblocks],'single'); %artificially round it
for icell = 1:Ncells
    if Nblocks>1
        convres = conv2(flip(statime(icell,:)), 1, squeeze(filterstim(icell,:,:)), 'valid');
    else
        convres = conv(squeeze(filterstim(icell,:,:)), flip(statime(icell,:)), 'valid');
    end
    generators(icell, :) = reshape(convres, 1, (Nframes-Nt+1) * Nblocks); 
end

spikes = reshape(spikesbin(:, Nt:end,:), Ncells, (Nframes-Nt+1) * Nblocks); 
end

