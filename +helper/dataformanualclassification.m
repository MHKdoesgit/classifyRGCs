

function cldata = dataformanualclassification(dp)

savingpath = [dp,filesep,'Data_Analysis',filesep,'Manual Classification of Primate Ganglion Cells'];
if not(exist(savingpath,'dir')), mkdir(savingpath); end


dsp = dir([dp,filesep,'Data_Analysis',filesep,'*direction*']);
dsflag = false;
if exist([dsp.folder,filesep,dsp.name],'dir') && ~isempty(dsp)
    dsp = [dsp.folder,filesep,dsp.name,filesep,'dsgcseq_data'];
    if ~exist(dsp,'dir'), dsp = dir([dp,filesep,'Data Analysis',filesep,'*direction*']); end
    dsp = dir([dsp.folder,filesep,dsp.name,filesep,'*directiongratingsequence*.mat']);
    ds = load([dsp.folder,filesep,dsp.name],'dsosdata');
    if ~isempty(fieldnames(ds)), dsflag = true; end
end
chffile = dir([savingpath,filesep,'*checkerflicker_analysis*.mat']);

if isempty(chffile)
    disp('no receptive data found in this folder, analyzing checkerflicker data...');
    rfdata = rf.rfdataforclassification(dp, savingpath);
    chffile = dir([savingpath,filesep,'*checkerflicker_analysis*.mat']);
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

% load clusters
if isfield(rfdata,'clusters')
    clus = rfdata.clusters;
else
    clusp = dir([dp,filesep,'experiment_info',filesep,'CellsList_*.mat']);
    clus = struct2array(load([clusp.folder, filesep, clusp.name]));
end

if exist([dp,'/ksrasters'],'dir')
    sortinginfo = struct2array(load([dp,'/ksrasters/ksrasters.mat'],'sort_info'));
    sortinginfo = sortinginfo(ismember([sortinginfo.id],clus(:,4)),:);
elseif exist([dp,'/preprocessed'],'dir')
    sortinginfo = struct2array(load([dp,'/preprocessed/sortinginfo.mat']));
else
    sortinginfo = cell(size(clus,1),1);
    for ii = 1:size(clus,1)
        sortinginfo{ii}.ch = clus(ii,1);
        sortinginfo{ii}.clus = clus(ii,2);
        sortinginfo{ii}.id = NaN;
        sortinginfo{ii}.quality = clus(ii,3);
        sortinginfo{ii}.n_spikes = NaN;
        sortinginfo{ii}.comment = {''};        
    end
    sortinginfo = cell2mat(sortinginfo);
end


% rf = loadRFdata(dp,clus,'STA','gaussfit','rnfznoise','correctedcenter','RFdiameter','peakpos','para',...
%     'tempComp','spatialComp','moransI','correctedsurround','subrow','subcol');
%if isfield(rf,'green'), rf = rf.green; end

% acgdp = dir([dp,filesep,'Data_Analysis',filesep,'*Auto-Cross correlation*']);
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
cldata.acg.isnormalized = rfdata.para.normACG;
cldata.acg.normrange = [0 50];
acgnormrange = (cldata.acg.lagraw >=cldata.acg.normrange(1) & cldata.acg.lagraw <= cldata.acg.normrange(2));
cldata.acg.autocorr = rfdata.autoCorrelations(:,acgnormrange) ./ sum(rfdata.autoCorrelations(:,acgnormrange),2);
cldata.acg.lag = rfdata.autoCorrLag(acgnormrange);


if dsflag
    cldata.dsos = helper.circAvgallDScells(ds.dsosdata,size(ds.dsosdata.angles,2),size(ds.dsosdata.angles,3));
    cldata.dsos.dsi = ds.dsosdata.dsi;
    cldata.dsos.dsi_pval = ds.dsosdata.dsi_pval;
    cldata.dsos.osi = ds.dsosdata.osi;
    cldata.dsos.osi_pval = ds.dsosdata.osi_pval;
    cldata.dsos.respquality = ds.dsosdata.responsequality;
    cldata.dsos.dscandicates = ds.dsosdata.dscandicates;
    cldata.dsos.oscandicates = ds.dsosdata.oscandicates;
end

cldata.rfdata = rfdata;
tc = cldata.rfdata.temporalComps;
cldata.rfdata.temporalComps = tc ./ sqrt(sum(tc.^2,2));
tcf = cldata.rfdata.modeltcomps;
cldata.rfdata.modeltcomps = tcf ./ sqrt(sum(tcf.^2,2));

tc = rfdata.temporalComps;
[pcoeff, pscore] = pca(tc);
if size(pcoeff,1) > 20, s=15; else, s = 0;end % to only select limited number of pcas
ptc = pcoeff(end-s:end,1); % first principal component
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
nlynorm = zeros(size(rfdata.nly)); 
for ii = 1:size(clus,1)
    nlynorm(ii,:) = rfdata.nly(ii,:) ./ max(rfdata.nly(ii,:),[],'all');    
end
cldata.nl.nlx = rfdata.nlx;
cldata.nl.nly = nlynorm;


cldata.savingpath = savingpath;
if isfield(rfdata.para,'date')
    cldata.date = rfdata.para.date;
else
    cldata.date       = helper.datemaker(dp);
end

save([savingpath,filesep,stimnum,'-Data_for_manual_classification_for_exepriment_on_',cldata.date,'.mat'],'-struct','cldata','-v7.3');


end