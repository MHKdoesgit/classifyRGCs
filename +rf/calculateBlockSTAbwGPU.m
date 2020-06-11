
function [ sta ] = calculateBlockSTAbwGPU(spikesbin, winN, Nyx, oseed, contrast)
%CALCULATEBLOCKSTABW Calculates STA for multiple cells
%--------------------------------------------------------------------------
%   Input:
%           spikesbin: cellN x frameN x blockN 3D array
%           winN: number of time bins to consider for STA
%           Nyx: numer of stixels
%           seed: seed for ran1
%           contrast: contrast of stixels (usually 1)
%   Output:
%           sta: cellN x Nyx x winN array of all STAs
%--------------------------------------------------------------------------
[cellN, frameN, blockN]=size(spikesbin);
spikesbin = single(spikesbin(:,winN:frameN,:)); %casting spikes to single
sumspikes = sum(spikesbin(:,:), 2);
%--------------------------------------------------------------------------
%calculate cell chunks
g=gpuDevice(1); availableMem = g.AvailableMemory*8 - 6e9; %in bits with buffer
staMem    = cellN*Nyx*winN*32;
spikesMem = cellN*(frameN-winN+1)*32;
stimMem   = Nyx*frameN*32;
totalMem  = (staMem+spikesMem+stimMem); %buffer of 500MB added
Nchunks   = ceil(totalMem/availableMem); chunkSize=floor(cellN/Nchunks);
%--------------------------------------------------------------------------
sta      = zeros(cellN,Nyx,winN,'single'); %preallocate sta in RAM
stimulus = zeros(Nyx,frameN,'single','gpuArray'); %preallocate stimulus
%--------------------------------------------------------------------------
msg = []; tic;
for iChunk=1:Nchunks
    cellstart=(iChunk-1)*chunkSize+1;
    cellchunk=min(chunkSize, cellN-cellstart+1);
    cellend=cellstart+cellchunk-1;
    chunkspikesbin=spikesbin(cellstart:cellend,:,:); %casting spikes to single
    
    chunksta = zeros(cellchunk, Nyx,    winN, 'single','gpuArray'); %preallocate sta
    spikes   = zeros(cellchunk, frameN-winN+1, 'single','gpuArray');
    seed     = oseed;
    %--------------------------------------------------------------------------
    for iBlock=1:blockN
        [stimulus(:),seed]=ran1(seed,Nyx*frameN);
        stimulus  = 2*single(stimulus>0.5)-1;%making stimulus into single mat of 1s and -1s
        spikes(:) = chunkspikesbin(:,:,iBlock);
        for it=1:winN
            chunksta(:,:,it) = chunksta(:,:,it) + ...
                contrast * spikes * stimulus(:, it:(end-winN+it))';
        end
    end
    %--------------------------------------------------------------------------
    sta(cellstart:cellend,:,:)=gather(chunksta);
    %--------------------------------------------------------------------------
    fprintf(repmat('\b', 1, numel(msg)));
    msg = sprintf('Chunk %d/%d. Time elapsed %2.2f s...\n', iChunk,Nchunks,toc);
    fprintf(msg);
end
sta = bsxfun(@rdivide, sta, sumspikes);%cast sta to double and divide by nspikes
gpuDevice(1);
end