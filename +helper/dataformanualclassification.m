

function cldata = dataformanualclassification(dp)

savingpath = [dp,filesep,'Data Analysis',filesep,'Manual Classification of Primate Ganglion Cells'];
if not(exist(savingpath,'dir')), mkdir(savingpath); end


clusp = dir([dp,filesep,'CellsList_*.mat']);
clus = struct2array(load([clusp.folder, filesep, clusp.name]));

if exist([dp,'/ksrasters'],'dir')
    sortinginfo = struct2array(load([dp,'/ksrasters/ksrasters.mat'],'sort_info'));
    sortinginfo = sortinginfo(ismember([sortinginfo.id],clus(:,4)),:);
elseif exist([dp,'/preprocessed'],'dir')
    sortinginfo = struct2array(load([dp,'/preprocessed/sortinginfo.mat']));
else
    sortinginfo = [];
end

dsp = dir([dp,filesep,'Data Analysis',filesep,'*direction*']);
dsp = dir([dsp.folder,filesep,dsp.name,filesep,'dsgcseq_data',filesep,'*directiongratingsequence*.mat']);
ds = load([dsp.folder,filesep,dsp.name],'dsosdata');

chffile = dir([savingpath,filesep,'*checkerflicker_analysis.mat']);

if isempty(chffile)
    disp('no receptive data found in this folder, analyzing checkerflicker data...');
    rfdata = rf.rfdataforclassification(dp, savingpath);
    chffile = dir([savingpath,filesep,'*checkerflicker_analysis.mat']);
    stimnum = extractBefore(chffile.name,'-');
else
    if numel(chffile) > 1
        [indx,tf] = listdlg('PromptString','Select an analyzed receptive field data for classification:',...
            'SelectionMode','single','ListString',{chffile.name},'ListSize',[400 80]);
        if tf
            rfdata = load([chffile(indx).folder,filesep,chffile(indx).name]);
            stimnum = extractBefore(chffile(indx).name,'-');
        else
            error('yo bro, what the actuall fuck!, you should select one of the data sets for classification!');
        end
    else
        rfdata = load([chffile.folder,filesep,chffile.name]);
        stimnum = extractBefore(chffile.name,'-');
    end
end


% rf = loadRFdata(dp,clus,'STA','gaussfit','rnfznoise','correctedcenter','RFdiameter','peakpos','para',...
%     'tempComp','spatialComp','moransI','correctedsurround','subrow','subcol');
%if isfield(rf,'green'), rf = rf.green; end

% acgdp = dir([dp,filesep,'Data Analysis',filesep,'*Auto-Cross correlation*']);
% acgdp = dir([acgdp.folder,filesep,acgdp.name,filesep,'*checkerflicker*']);
% if isempty(acgdp)
%     acgdp = dir([dp,filesep,'Data Analysis',filesep,'*Auto-Cross correlation*']);
%     acgdp = dir([acgdp.folder,filesep,acgdp.name,filesep,'*frozennoise*']);
% end
% acgdp = dir([acgdp.folder,filesep,acgdp.name,filesep,'acsq_data',filesep,'*autocorr spike quality*']);
% acgdat = struct2array(load([acgdp.folder,filesep,acgdp.name],'ccdata'));

% % normalize acg by its integral, Chichilnisky style
% ac = zeros(size(acgdat.autocorrnopeak));
% for ii = 1: size(ac,1)
%    ac(ii,:) = acgdat.autocorrnopeak(ii,:) ./ sum(acgdat.autocorrnopeak(ii,:));  
% end


% dtcorr  = 5e-4;
% Ncorr   = 60e-3/dtcorr;
% aclag   = linspace(0, Ncorr * dtcorr *1e3, Ncorr);

% table columns are : channel, cluster, rating, ks id, RF diameter, label, comment
% here we put together the first 4 columns as double and load them as cell is the gui
cldata.clus = clus(:,1:4);
% cldata.tablevalues = [clus,rf.RFdiameter];

cldata.tablevalues = [clus(:,1:4),rfdata.rfdiameters* 1e6];
cldata.sortinginfo = sortinginfo;
% cldata.acg.autocorr = ac;
% cldata.acg.lag = acgdat.laghalfms;
cldata.acg.autocorrraw = rfdata.autoCorrelations;
cldata.acg.lagraw = rfdata.autoCorrLag;
cldata.acg.isnormalized = rfdata.stimPara.normACG;
cldata.acg.normrange = [0 50];
acgnormrange = (cldata.acg.lagraw >=cldata.acg.normrange(1) & cldata.acg.lagraw <= cldata.acg.normrange(2));
cldata.acg.autocorr = rfdata.autoCorrelations(:,acgnormrange) ./ sum(rfdata.autoCorrelations(:,acgnormrange),2);
cldata.acg.lag = rfdata.autoCorrLag(acgnormrange);

% if isfield(rf,'rnfznoise')
%     cldata.nl = rf.rnfznoise;
%     cldata.rf = rmfield(rf,'rnfznoise');
% else
%     cldata.rf = rf;
% end
%cldata.dsos = ds.dsosdata;
cldata.dsos = circAvgallDScells(ds.dsosdata,size(ds.dsosdata.angles,2),size(ds.dsosdata.angles,3));
cldata.dsos.dsi = ds.dsosdata.dsi;
cldata.dsos.dsi_pval = ds.dsosdata.dsi_pval;
cldata.dsos.osi = ds.dsosdata.osi;
cldata.dsos.osi_pval = ds.dsosdata.osi_pval;
cldata.dsos.respquality = ds.dsosdata.responsequality;
cldata.dsos.dscandicates = ds.dsosdata.dscandicates;
cldata.dsos.oscandicates = ds.dsosdata.oscandicates;

cldata.rfdata = rfdata;
tc = cldata.rfdata.temporalComponents;
cldata.rfdata.temporalComponents = tc ./ sqrt(sum(tc.^2,2));
tcf = cldata.rfdata.modeltcomps;
cldata.rfdata.modeltcomps = tcf ./ sqrt(sum(tcf.^2,2));

tc = rfdata.temporalComponents;
[pcoeff, pscore] = pca(tc);

ptc = pcoeff(end-15:end,1); % first principal component
[maxptc, maxloc] = max(ptc);
[minptc, minloc] = min(ptc);

if abs(maxptc) > abs(minptc) && maxloc > minloc
    ptcsign = 1;
else
    ptcsign = -1;
end

cldata.pcadata.coeffs = pcoeff;
cldata.pcadata.scores = pscore .* ptcsign;

cldata.rfcontours.contourspts = rfdata.contourpoints;
[~, cldata.rfcontours.shapes, cldata.rfcontours.centroids] = rf.rescaleRFcontours(cldata.rfcontours.contourspts,1);
cldata.rfcontours.scalevalue = 1;

% put the nonlinearities in separate field 
nlynorm = zeros(size(rfdata.nlnvalslr)); 
for ii = 1:size(clus,1)
    nlynorm(ii,:) = rfdata.nlnvalslr(ii,:) ./ max(rfdata.nlnvalslr(ii,:),[],'all');    
end
cldata.nl.nlx = rfdata.nlncentslr;
cldata.nl.nly = nlynorm;


cldata.savingpath = savingpath;
cldata.date       = datemaker(dp);

save([savingpath,filesep,stimnum,'-Data for manual classification of cells for exepriment on ',datemaker(dp),'.mat'],'-struct','cldata','-v7.3');


end