

function res = rfdataforclassification(dp, savingpath)

if nargin < 2,    savingpath = []; end

rd = loadRawData(dp,{'checkerflicker','frozennoise'});

stimPara = rd.stimPara;
%stimPara = stimdata.stimPara;
stimPara = checkstimParaArgs(stimPara, 'stimulus', 'frozennoise');
stimPara = checkstimParaArgs(stimPara, 'refreshrate', 60);
stimPara = checkstimParaArgs(stimPara, 'screen', rd.screen);
stimPara = checkstimParaArgs(stimPara, 'fs', double(rd.samplingrates));
stimPara = checkstimParaArgs(stimPara, 'pulseRate', 2);
stimPara = checkstimParaArgs(stimPara, 'filterWindow', 0.5);
stimPara = checkstimParaArgs(stimPara, 'nsigma', 2);
stimPara = checkstimParaArgs(stimPara, 'nonlinBinN', 40);
% for auto-correlogram
stimPara = checkstimParaArgs(stimPara, 'dtcorr', 5e-4);         % 5e-4;
stimPara = checkstimParaArgs(stimPara, 'Ncorr', 250e-3 / 5e-4); % %60e-3/dtcorr; % old values
stimPara = checkstimParaArgs(stimPara, 'normACG', false); 

if strcmpi( rd.lightprojection, 'oled')
    pixsize = 7.5e-6;
else % now for lightcrafter, add option for patch setups later
   pixsize = 8e-6;
end
stimPara = checkstimParaArgs(stimPara, 'pixelsize', pixsize);

switch lower(stimPara.stimulus)
    case {'frozennoise','frozencheckerflicker'}
        frozenflag = true;
    otherwise 
        frozenflag = false;
end

if frozenflag 
    stimPara = checkstimParaArgs(stimPara, 'seed', stimPara.seedrunningnoise);
    stimPara = checkstimParaArgs(stimPara, 'secondseed', stimPara.seedfrozennoise);
end
    
if size(rd.ftimes,2) ~=2
    ft = [rd.ftimes(1:2:numel(rd.ftimes));rd.ftimes(2:2:numel(rd.ftimes))]';
else
    ft = ftimes;
end

if frozenflag
    res = rf.Analyze_FrozenCheckerFlicker(ft, rd.spiketimes, rd.clusters, stimPara, savingpath);
else
    res = rf.Analyze_CheckerFlicker(ft, rd.spiketimes, rd.clusters, stimPara, savingpath);
end
% 
% stimPara.refreshrate = 60;
% stimPara.screen = rd.screen;
% stimPara.fs = double(rd.samplingrates);
% stimPara.pulseRate = 2;
% stimPara.seed = stimPara.seedrunningnoise;
% stimPara.secondseed = stimPara.seedfrozennoise;
% stimPara.pixelsize = 7.5e-6;
% % old options
% stimPara.filterWindow = 0.5;
% stimPara.nsigma = 2;
% stimPara.nonlinBinN = 40;
% 
% clusters = rd.clusters;
% %ft = rd.ftimes;
% ft = [rd.ftimes(1:2:numel(rd.ftimes));rd.ftimes(2:2:numel(rd.ftimes))]';
% spikes = rd.spiketimes; 
% res = rf.Analyze_FrozenCheckerFlicker(ft, spikes, clusters, stimPara);
% 
% 
% rdch = load('D:\2-MARMOSET\20180710_60MEA_YE\fr_fp_p42\Data Analysis\Raw Data\11_checkerflicker5x51blink for Experiment on 10-Jul-2018.mat');
% 
% stimPara = rdch.stimPara;
% %stimPara = stimdata.stimPara;
% stimPara.refreshrate = 60;
% stimPara.screen = rdch.screen;
% stimPara.fs = double(rdch.samplingrates);
% stimPara.pulseRate = 2;
% % stimPara.seed = stimPara.seedrunningnoise;
% % stimPara.secondseed = stimPara.seedfrozennoise;
% stimPara.pixelsize = 7.5e-6;
% % old options
% stimPara.filterWindow = 0.5;
% stimPara.nsigma = 2;
% stimPara.nonlinBinN = 40;
% 
% clusters = rdch.clusters;
% %ft = rdch.ftimes;
% ft = [rdch.ftimes(1:2:numel(rdch.ftimes));rdch.ftimes(2:2:numel(rdch.ftimes))]';
% spikes = rdch.spiketimes'; 
% resch = rf.Analyze_CheckerFlicker(ft, spikes, clusters, stimPara);
% 
% 
% for ii = 1:size(clusters,1)
%     if not(isempty(resch.contourpoints{ii}))
%     plot(resch.contourpoints{ii}(1,:),resch.contourpoints{ii}(2,:));
%     hold on;
%     end
%     plot(squeeze(resch.ellipsepoints(ii,1,:)),squeeze(resch.ellipsepoints(ii,2,:)));
% end
% 
% 
% cp = resch.contourpoints;
% bigestcont = max(cellfun(@(x) (size(x,2)),cp));
% conts = nan(size(cp,1),2,bigestcont+1);
% for ii = 1:size(cp,1)
%     if not(isempty(cp{ii}))
%         conts(ii,:,1:size(cp{ii},2)) = cp{ii};
%     end
% end
end

function para = checkstimParaArgs(para, argname, defval)
if not(isfield(para, argname))
    para.(argname) = defval;
end
end





