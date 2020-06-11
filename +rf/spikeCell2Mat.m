

function [spkmat] = spikeCell2Mat(spkcell,fs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

spknums     =   cellfun(@numel,spkcell);
spkmat      =   zeros(sum(spknums),2);
istart      =   1;
for ii = 1 : numel(spkcell)
    iend    =   spknums(ii) + istart-1;
    cellids =   ii*ones(spknums(ii),1);
    celltimes = round(spkcell{ii}(:) * fs);
    spkmat(istart:iend,:) = [cellids celltimes];
    istart = iend +1;
end

end
