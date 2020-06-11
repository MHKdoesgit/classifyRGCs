function [ sta ] = calculateSTAbwGPU(spikesbin, winN, Nyx, seed, contrast)
%CALCULATEBLOCKSTABW Calculates STA for multiple cells
%--------------------------------------------------------------------------
%   Input:
%           spikesbin: cellN x frameN x blockN 3D array (blockN for frozendata)
%           winN: number of time bins to consider for STA
%           Nyx: numer of stixels
%           seed: seed for ran1
%           contrast: contrast of stixels (usually 1)
%   Output:
%           sta: cellN x Nyx x winN 3D array of all STAs (single type)
%--------------------------------------------------------------------------
[cellN, frameN, blockN]=size(spikesbin);
sumspikes=sum(reshape(spikesbin(:,winN:frameN,:),cellN,[]),2);
spikesbin=single(spikesbin); %casting spikes to single
sta=zeros(cellN,Nyx,winN,'single'); %preallocate sta in RAM
stacurr=zeros(cellN,Nyx,winN,'single'); %preallocate stacurr in RAM
%--------------------------------------------------------------------------
chunkN=ceil(frameN*Nyx*4/(500*2^20)); chunkSize=ceil(frameN/chunkN);
spikesbin(:,1:winN-1,:)=0; %these spikes will not be used
spikesbin=cat(2,spikesbin,zeros(cellN,chunkSize*chunkN-frameN,blockN,'single')); %round spikes
stimulus=zeros(Nyx,chunkSize+winN-1,'single','gpuArray');%preallocate stimulus chunk
spikes=zeros(cellN,chunkSize,'single','gpuArray'); %preallocate spikes chunk in gpu
%--------------------------------------------------------------------------
for iBlock=1:blockN
    stimbuffer=zeros(Nyx,winN-1,'single','gpuArray');
    spikesBlock=spikesbin(:,:,iBlock);
    for iChunk=1:chunkN
        stimulus(:,1:winN-1)=stimbuffer;
        [stimulus(Nyx*(winN-1)+1:end),seed]=ran1bool(seed,Nyx*chunkSize);
        stimbuffer=stimulus(:,end-winN+2:end); %to use in the next chunk
        
        stimulus=2*stimulus-1;
        spikes(:)=spikesBlock(:,(iChunk-1)*chunkSize+1+(0:chunkSize-1));
        
        for it=1:winN
            stacurr(:,:,it)=gather(spikes*stimulus(:,it:(end-winN+it))');
        end
        sta=sta+contrast*stacurr;
    end
end
sta=bsxfun(@rdivide,sta,sumspikes);
end