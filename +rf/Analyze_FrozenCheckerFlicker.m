

function res = Analyze_FrozenCheckerFlicker(ft, spikes, clusters, stimPara, savingpath,varargin)

%ANALYZECHEKERFLICKER
%--------------------------------------------------------------------------

% p = inputParser();      % check the user options.
% p.addParameter('tbins', 0.5/1e3, @(x) isnumeric(x));
% p.addParameter('lagnbins', 200, @(x) isnumeric(x));
% p.addParameter('channelsaround', 15, @(x) isnumeric(x));
% p.addParameter('elecImgAngle', 0, @(x) isnumeric(x));
% p.addParameter('crosscorrthreshold', 0.25, @(x) isnumeric(x));
% p.addParameter('plotscaling', 0.35, @(x) isnumeric(x));
% p.addParameter('amplitudeNumPoints', 2500, @(x) isnumeric(x));
% p.addParameter('waveformNumLines', 150, @(x) isnumeric(x));
% p.parse(varargin{:});

if nargin < 5, savingpath = []; end

expId = stimPara.expnumber;
if isfield(stimPara,'nblinks'), stimPara.Nblinks = stimPara.nblinks; stimPara = rmfield(stimPara,'nblinks'); end

stimPara.Nx = ceil(stimPara.screen(1)/stimPara.stixelwidth);
stimPara.Ny = ceil(stimPara.screen(2)/stimPara.stixelheight);


%experimentPath=experiment.originalFolder;
%folderName=[num2str(expId) '_' stimPara.stimulus];
%if nargin<3, options=defaultOptions(stimPara.stimulus); else, options=varargin{1}; end
%res = stimdata; res.options=options;
%--------------------------------------------------------------------------
disp(['Starting ' stimPara.stimulus ' analysis for stimulus ' num2str(expId) '...'])

Nt = ceil(stimPara.filterWindow*stimPara.refreshrate/stimPara.Nblinks);
Ny = stimPara.Ny; Nx = stimPara.Nx;

Ncells = size(clusters,1);
if iscell(spikes) && size(spikes,2)~=2
    spiketimes = rf.spikeCell2Mat(spikes,stimPara.fs);
    spiketimes = spiketimes(:,[2 1]); % the dimension of spiketimes should be flipped to match KS order
    ft = round(ft * stimPara.fs);
else
    spiketimes = spikes;
end
spikesbin  = rf.blinkBinnerKS(spiketimes, Ncells, ft(:,1), ft(:,2), stimPara.Nblinks, stimPara.pulseRate);


%spikesbin = stimdata.spikesbin;
Nframes   = size(spikesbin,2);

runningFrames = stimPara.RunningFrames;
trialFrames   = runningFrames+stimPara.FrozenFrames;

Ntrials     = floor(Nframes/trialFrames);
totalFrames = Ntrials*trialFrames;

totalbin   = reshape(spikesbin(:,1:totalFrames), Ncells, trialFrames, Ntrials);
runningbin = totalbin(:,1:runningFrames,:);

%this part adds the remaining spikes for STA calculation
rembin     = spikesbin(:,totalFrames+1:end);
if size(rembin,2)>runningFrames; rembin=rembin(:,1:runningFrames); end
runningbin = cat(3,runningbin,zeros(Ncells,runningFrames));
runningbin(:,1:size(rembin,2),end) = rembin;
%--------------------------------------------------------------------------
% Prediction part
frozenbin = totalbin(:, runningFrames+Nt:end,:);
res.trialRates = frozenbin;

allReliableRsq = rf.imageTrialRsq( permute(frozenbin,[1 3 2]) ); %think of removing variable part
res.allReliableRsq = allReliableRsq;

frozenRates=mean(frozenbin,3)*stimPara.refreshrate/stimPara.Nblinks;
res.frozenRates=frozenRates;

frozenTimeVec=(0:(stimPara.FrozenFrames-1))*stimPara.Nblinks/stimPara.refreshrate; %in seconds
frozenTimeVec=frozenTimeVec+stimPara.Nblinks/stimPara.refreshrate/2;
res.frozenTimeVec=frozenTimeVec;
%--------------------------------------------------------------------------
disp('Generating STAs for the running part...');
seeduse = stimPara.seed;
% if isfield(stimPara, 'color')
%     if stimPara.color
%         seeduse = stimPara.seed/2;
%     end
% end
staAll = rf.calculateBlockSTAbwGPU(runningbin, Nt, Nx*Ny, seeduse, stimPara.contrast);
staAll = reshape(staAll, Ncells, Ny, Nx,Nt);
staAll = flip(staAll,2); %flipping because of C++
res.staAll = staAll;
fprintf('Done! \n');
%--------------------------------------------------------------------------
%define coordinates
timeVec=(-(Nt-1/2):1:-1/2)*stimPara.Nblinks/stimPara.refreshrate; %in seconds
spaceVecX = stimPara.lmargin +0.5 + stimPara.stixelwidth*(0:Nx-1)+stimPara.stixelwidth/2;
spaceVecY = stimPara.bmargin +0.5 + stimPara.stixelheight*(0:Ny-1)+stimPara.stixelheight/2;
res.timeVec = timeVec; res.spaceVecX = spaceVecX; res.spaceVecY = spaceVecY;
%--------------------------------------------------------------------------
rfac   = 4.5 * 1.4826;

stixelsForFit = ceil(50/stimPara.stixelwidth);
%Nstfit = 2*stixelsForFit + 1;

%allspred = zeros(Ncells, 1);
allmads = mad(staAll(:,:),1,2);

%rsta = staAll(:,:)./allmads;
iuse = sum((abs(staAll(:,:)) - rfac*allmads)>0, 2);

dpx = stimPara.pixelsize;
%contfac = 0.14;
%dtcorr  = stimPara.dtcorr;  %5e-4;
%Ncorr   = stimPara.Ncorr;   %60e-3/dtcorr; % old values

nelipspoints = 100;

gaussParams        = NaN(Ncells, 6);
spatialComponents  = zeros(Ncells, Ny, Nx,'single');
modelscomps        = zeros(Ncells, Ny, Nx,'single');
temporalComponents = zeros(Ncells, Nt,'single');
modeltcomps        = zeros(Ncells, Nt,'single');
autoCorrs          = NaN(Ncells, stimPara.Ncorr, 'single');
rfdiameters        = NaN(Ncells, 1);
ellipseareas       = NaN(Ncells, 1);
contourareas       = NaN(Ncells, 1);
contourpoints      = cell(Ncells, 1);
ellipsepoints      = NaN(Ncells, 2, nelipspoints);
rfmodelparams      = NaN(Ncells, 12);
allrangex          = cell(Ncells, 1);
allrangey          = cell(Ncells, 1);
allmoran           = NaN(Ncells, 1);

cellspktimes = accumarray(spiketimes(:,2),spiketimes(:,1), [Ncells, 1], @(x) {x});


disp('Beginning cell by cell analysis...'); tic;
msg = [];
for icell = 1:Ncells
    
    if iuse(icell) == 0, continue; end
    csta = double(squeeze(staAll(icell,:,:,:)));
    %======================================================================
    % select ROI after blurring
    smsta = rf.smoothSTA(squeeze(staAll(icell,:,:,:)), 0.5);
    [~, imax] = max(abs(smsta(:)));
    [y0, x0, t0] = ind2sub(size(smsta), imax);
    
    rangeX = x0+(-stixelsForFit:stixelsForFit); rangeX = rangeX(rangeX>0 & rangeX<=Nx);
    rangeY = y0+(-stixelsForFit:stixelsForFit); rangeY = rangeY(rangeY>0 & rangeY<=Ny);
    zoomsta = reshape(csta(rangeY, rangeX, :), numel(rangeY)*numel(rangeX), Nt);
    
    allrangex{icell} = rangeX; allrangey{icell} = rangeY;
    %======================================================================
    % find significant pixels in the zoomed region
    [bpx, ~] = find(abs(zoomsta) > rfac*mad(csta(:),1));
    if isempty(bpx), continue, end
    %======================================================================
    % extract temporal and spatial components
    
    tempcomp = mean(zoomsta(bpx,:),1)';
    spcomp   = reshape(zoomsta*tempcomp, numel(rangeY),numel(rangeX));
    
    %[s,d,v] = svd(zoomsta,'econ');
    
    spatialComponents(icell, rangeY,  rangeX) = spcomp;
    temporalComponents(icell, :) = tempcomp;
    
    % get simple ellipse fit and contour
    
    %tempcomp = mean(zoomsta(bpx,:),1)';
    %spcomp   = reshape(zoomsta*tempcomp, numel(rangeY),numel(rangeX));
    
    allmoran(icell) = rf.moransI(spcomp, size(spcomp,1), size(spcomp,2));
    
    spatialComponents(icell, rangeY,  rangeX) = spcomp;
    temporalComponents(icell, :) = tempcomp;
    
    % get simple ellipse fit and contour
    
    [contpts, contarea, centgaussparams] = rf.getRfContourPts(...
        spaceVecX(rangeX),spaceVecY(rangeY), spcomp);
    
    %     c = getEllipseFromParams(centgaussparams, 2);
    %     clf;
    %     imagesc(spaceVecX(rangeX),spaceVecY(rangeY), spcomp, [-1 1]*max(abs(spcomp(:))));
    %     hold on; colormap(redblue)
    %     plot(contpts(1,:), contpts(2,:), '-k', c(1,:), c(2,:), 'g')
    %
    %     areac = contarea*(dpx*1e3)^2;
    %     effd  = 2*sqrt(areac/pi);
    %     title(sprintf('diam: %d', round(effd*1e3)))
    
    gaussParams(icell, :) = centgaussparams;
    contourareas(icell)   = contarea*(dpx*1e3)^2;
    rfdiam = rf.getRFDiam(rf.getGaussFromParams(centgaussparams), stimPara.nsigma, dpx);
    ellipseareas(icell) = pi * (rfdiam*1e3/2)^2;
    contourpoints{icell} = contpts;
    ellipsepoints(icell,:,:) = rf.getEllipseFromParams(centgaussparams, stimPara.nsigma, nelipspoints);
    %==========================================================================
    % fit DoG+time RF model
    tempGuess  = rf.fitTemporalComponent(timeVec, tempcomp);
    spaceGuess = rf.dogreceptfield2(spaceVecX(rangeX), spaceVecY(rangeY), spcomp);
    
    fullGuess = [tempGuess spaceGuess(1:6) spaceGuess(8)/spaceGuess(7)];
    stafit    = permute(reshape(zoomsta,numel(rangeY),numel(rangeX), Nt), [3 1 2]);
    modelprms = rf.fitParametricSTA2(timeVec, spaceVecX(rangeX), spaceVecY(rangeY), stafit, fullGuess);
    rfmodelparams(icell, :) = modelprms;
    
    modeltcomps(icell, :) = rf.templowpass(modelprms(1:5), timeVec);
    
    spParams = [modelprms(6:end-1) 1 modelprms(end)];
    [X, Y] = meshgrid(spaceVecX(rangeX),spaceVecY(rangeY));
    Z = rf.dogmatrixfun(spParams,{X(:), Y(:)});
    modelscomps(icell, rangeY,  rangeX) = reshape(Z, numel(rangeY), numel(rangeX));
    %==========================================================================
    % get model values
    %tvec = templowpass(modelprms(1:5), timeVec);
    
    cgauss = rf.getGaussFromParams(modelprms(6:end));
    rfdiameters(icell) = rf.getRFDiam(cgauss, stimPara.nsigma, dpx);
    %==========================================================================
    % get acg
    spks = cellspktimes{icell}/stimPara.fs;
    K = rf.ccg(spks, spks, stimPara.Ncorr, stimPara.dtcorr);
    K(stimPara.Ncorr+1) = 0;
    autoCorrs(icell, :) = single(K((stimPara.Ncorr+1):end-1));
    %==========================================================================
    if mod(icell, 20) == 0 || icell == Ncells
        fprintf(repmat('\b', 1, numel(msg)));
        msg = sprintf('Cell %d/%d. Time elapsed %2.2f s...\n', icell,Ncells,toc);
        fprintf(msg);
    end
end

% to change the format of contourpoints from cell to mat for faster plotting
cp = contourpoints;
bigestcont = max(cellfun(@(x) (size(x,2)),cp));
contpts = nan(Ncells,2,bigestcont+1);
for ii = 1:Ncells
    if not(isempty(cp{ii}))
        contpts(ii,:,1:size(cp{ii},2)) = cp{ii};
    end
end

sigmas = linspace(0,8,1e3);
%central equation
activations = (1-exp(-sigmas.^2/2))-...
    rfmodelparams(:,end).*(1-exp(-sigmas.^2/2./rfmodelparams(:,11).^2));
activations(activations<0) = 0;
surrIdx = 1-activations(:,end)./max(activations,[],2);
% autocorr output
if stimPara.normACG
    autoCorrs = autoCorrs./sum(autoCorrs,2);
end
autoCorrsLag   = linspace(0, stimPara.Ncorr * stimPara.dtcorr *1e3, stimPara.Ncorr); % xaxis of autocorr
%--------------------------------------------------------------------------
res.spatialComponents  = spatialComponents;         res.modelscomps     = modelscomps;
res.temporalComponents = temporalComponents;        res.modeltcomps     = modeltcomps;
res.autoCorrelations   = autoCorrs;                 res.autoCorrLag     = autoCorrsLag; 
res.surroundIdx     = surrIdx;
res.sigmaActivation    = activations;               res.sigmaVals       = sigmas;
res.allrangex          = allrangex;                 res.allrangey       = allrangey;
res.contourareas       = contourareas;              res.ellipseareas    = ellipseareas;
res.rfdiameters        = rfdiameters;               res.contourpoints   = contpts;
res.gaussparams        = gaussParams;               res.rfmodelparams   = rfmodelparams;
res.ellipsepoints      = ellipsepoints;             res.allmoran        = allmoran;

%--------------------------------------------------------------------------
fprintf('Calculating generator signals... '); tic;

temporalComponents = temporalComponents./sqrt(sum(temporalComponents.^2,2));
lrspacepredict  = reshape(flip(spatialComponents, 2), Ncells, Ny*Nx);
lrspacepredict  = lrspacepredict./sqrt(sum(lrspacepredict.^2,2));

% calculate low-rank generator signals
[lrgenerators, ~] = rf.calculateLowRankGeneratorsbw(runningbin(:,:,1:Ntrials),...
    lrspacepredict, temporalComponents, stimPara.seed);

modeltcomps  = modeltcomps./sqrt(sum(modeltcomps.^2,2));
modelspredict  = reshape(flip(modelscomps, 2), Ncells, Ny*Nx);
modelspredict  = modelspredict./sqrt(sum(modelspredict.^2,2));

% calculate model generator signals
[modelgenerators, spikes] = rf.calculateLowRankGeneratorsbw(runningbin(:,:,1:Ntrials),...
    modelspredict, modeltcomps, stimPara.seed);

fprintf('Done! Took %2.2f s...\n', toc);
%--------------------------------------------------------------------------
fprintf('Extracting nonlinearities... '); tic;

nlncentslr    = NaN(Ncells, stimPara.nonlinBinN, 'single');
nlnvalslr     = NaN(Ncells, stimPara.nonlinBinN, 'single');
nlncentsmodel = NaN(Ncells, stimPara.nonlinBinN, 'single');
nlnvalsmodel  = NaN(Ncells, stimPara.nonlinBinN, 'single');

for icell = 1:Ncells
    
    cellgenslr = lrgenerators(icell,:)';
    if isnan(sum(cellgenslr(:))); continue; end
    [staVals, staCents,~] = rf.getNonlinearity(cellgenslr, spikes(icell,:),...
        stimPara.nonlinBinN,stimPara.Nblinks/stimPara.refreshrate);
    nlncentslr(icell,:) = staCents;
    nlnvalslr(icell, :) = staVals;
    
    cellgensmodel = modelgenerators(icell,:)';
    if isnan(sum(cellgensmodel)); continue; end
    [staVals,staCents,~] = rf.getNonlinearity(cellgensmodel, spikes(icell,:),...
        stimPara.nonlinBinN,stimPara.Nblinks/stimPara.refreshrate);
    nlncentsmodel(icell,:) = staCents;
    nlnvalsmodel(icell,:) = staVals;
end

res.nlncentslr    = nlncentslr;             res.nlnvalslr           = nlnvalslr;
res.nlncentsmodel = nlncentsmodel;          res.nlnvalsmodel        = nlnvalsmodel;

fprintf('Done! Took %2.2f s...\n', toc);
%--------------------------------------------------------------------------
fprintf('Calculating predictions and performances... '); tic;

%Generate stimulus
[frozenstimulus, ~] = rf.ran1bool(stimPara.secondseed, stimPara.FrozenFrames*Nx*Ny);
frozenstimulus      = reshape(frozenstimulus, Ny*Nx, stimPara.FrozenFrames);
frozenstimulus      = 2 * single(frozenstimulus) - 1; % transform to contrast

% filter with spatial components
filteredstim_model = modelspredict  * frozenstimulus;
filteredstim_lr    = lrspacepredict * frozenstimulus;

trialrates = frozenbin * stimPara.refreshrate/stimPara.Nblinks;

lrRsq            = NaN(Ncells,1);  lrCCnorm    = NaN(Ncells,1);
modelRsq         = NaN(Ncells,1);  modelCCnorm = NaN(Ncells,1);

lrpredictions    = NaN(Ncells, stimPara.FrozenFrames-Nt+1, 'single');
modelpredictions = NaN(Ncells, stimPara.FrozenFrames-Nt+1, 'single');

% filter with temporal components and predict
for icell = 1:Ncells
    
    cellrates = squeeze(trialrates(icell,:,:));
    % low rank
    fgens_lr = conv(filteredstim_lr(icell,:), flip(temporalComponents(icell,:)),'valid');
    preds_lr = rf.getPredictionFromBinnedNonlinearity(fgens_lr,...
        nlncentslr(icell, :), nlnvalslr(icell, :));
    
    % model
    fgens_model = conv(filteredstim_model(icell,:), flip(modeltcomps(icell,:)),'valid');
    preds_model = rf.getPredictionFromBinnedNonlinearity(fgens_model,...
        nlncentsmodel(icell, :), nlnvalsmodel(icell, :));
    
    lrCCnorm(icell)    = rf.calc_CCnorm(cellrates', preds_lr');
    lrRsq(icell)       = rf.rsquare(mean(cellrates, 2), preds_lr');
    modelCCnorm(icell) = rf.calc_CCnorm(cellrates', preds_model');
    modelRsq(icell)    = rf.rsquare(mean(cellrates, 2), preds_model');
    modelpredictions(icell,:) = preds_model;
    lrpredictions   (icell,:) = preds_lr;
    
end

res.lrpredictions = lrpredictions;          res.modelpredictions    = modelpredictions;
res.lrRsq         = lrRsq;                  res.modelRsq            = modelRsq;
res.lrCCnorm      = lrCCnorm;               res.modelCCnorm         = modelCCnorm;
res.stimPara      = stimPara;

fprintf('Done! Took %2.2f s...\n', toc);
%--------------------------------------------------------------------------
if not(isempty(savingpath))
    fprintf('Saving data... '); tic;
    saveName = [filesep, num2str(expId,'%02d'), '-checkerflicker_analysis.mat'];
    save([savingpath,saveName], '-v7.3', '-struct', 'res');
    fprintf('Done! Took %2.2f s...\n', toc);
end
%--------------------------------------------------------------------------
end

