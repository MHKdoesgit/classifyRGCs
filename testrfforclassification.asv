


%experiment = 1;
%expId = stimPara.expnumber;

rd = load('D:\2-MARMOSET\20180710_60MEA_YE\fr_fp_p42\Data Analysis\Raw Data\06_frozennoise8x8bw1blink1500run300freeze for Experiment on 10-Jul-2018.mat');

stimPara = rd.stimPara;
%stimPara = stimdata.stimPara;
stimPara.refreshrate = 60;
stimPara.screen = rd.screen;
stimPara.fs = double(rd.samplingrates);
stimPara.pulseRate = 2;
stimPara.seed = stimPara.seedrunningnoise;
stimPara.secondseed = stimPara.seedfrozennoise;
stimPara.pixelsize = 7.5e-6;
% old options
stimPara.filterWindow = 0.5;
stimPara.nsigma = 2;
stimPara.nonlinBinN = 40;

clusters = rd.clusters;
%ft = rd.ftimes;
ft = [rd.ftimes(1:2:numel(rd.ftimes));rd.ftimes(2:2:numel(rd.ftimes))]';
spikes = rd.spiketimes; 
res = rf.Analyze_FrozenCheckerFlicker(ft, spikes, clusters, stimPara);


rdch = load('D:\2-MARMOSET\20180710_60MEA_YE\fr_fp_p42\Data Analysis\Raw Data\11_checkerflicker5x51blink for Experiment on 10-Jul-2018.mat');

stimPara = rdch.stimPara;
%stimPara = stimdata.stimPara;
stimPara.refreshrate = 60;
stimPara.screen = rdch.screen;
stimPara.fs = double(rdch.samplingrates);
stimPara.pulseRate = 2;
% stimPara.seed = stimPara.seedrunningnoise;
% stimPara.secondseed = stimPara.seedfrozennoise;
stimPara.pixelsize = 7.5e-6;
% old options
stimPara.filterWindow = 0.5;
stimPara.nsigma = 2;
stimPara.nonlinBinN = 40;

clusters = rdch.clusters;
%ft = rdch.ftimes;
ft = [rdch.ftimes(1:2:numel(rdch.ftimes));rdch.ftimes(2:2:numel(rdch.ftimes))]';
spikes = rdch.spiketimes'; 
resch = rf.Analyze_CheckerFlicker(ft, spikes, clusters, stimPara);


for ii = 1:size(clusters,1)
    if not(isempty(resch.contourpoints{ii}))
    plot(resch.contourpoints{ii}(1,:),resch.contourpoints{ii}(2,:));
    hold on;
    end
    plot(resch.ellipsepoints(1,:,:),resch.ellipsepoints(2,:,:));
end




