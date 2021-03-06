

function sortTableDataApp(app, sortedcolumn, varargin)

% switch lower(event.Interaction)
%     case 'sort'
loaddataflag = false;
if nargin < 3, currtable = app.T.Data; else, currtable = varargin{1}; loaddataflag = true;  end
if ~isa(sortedcolumn,'double'), sortedcolumn = double(sortedcolumn); end

if sortedcolumn < 6
    [assort, assortidx] = sort([currtable{:,sortedcolumn}],'ascend');
    [dssort, dssortidx] = sort([currtable{:,sortedcolumn}],'descend');
    if isequaln(assort, [app.T.DisplayData{:,sortedcolumn}]) % use isequaln to consider NaN, otherwise you are fucked
        appsortingidx = assortidx;
        sortdir = 'ascend';
    elseif isequaln(dssort, [app.T.DisplayData{:,sortedcolumn}])
        appsortingidx = dssortidx;
        sortdir = 'descend';
    else
        [~,appsortingidx] = sort([app.T.DisplayData{:,1}],'ascend'); % back to original state
    end
    
else
    % for the label and comments columns
    [assort, assortidx] = sortrows(currtable(:,sortedcolumn),'ascend');
    [dssort, dssortidx] = sortrows(currtable(:,sortedcolumn),'descend');
    if isequaln(assort, app.T.DisplayData(:,sortedcolumn)) % use isequaln to consider NaN, otherwise you are fucked
        appsortingidx = assortidx;
        sortdir = 'ascend';
    elseif isequaln(dssort, app.T.DisplayData(:,sortedcolumn))
        appsortingidx = dssortidx;
        sortdir = 'descend';
    else
        [~,appsortingidx] = sort([app.T.DisplayData{:,1}],'ascend'); % back to original state
    end
end
%si = app.T.UserData.sortindex;
if isrow(appsortingidx), appsortingidx = appsortingidx'; end
dat = app.singlecellpanel.UserData;

sorteddat.acg.autocorrraw = sortDatfield_2D(dat.acg, 'autocorrraw', appsortingidx, 1);
sorteddat.acg.lagraw = dat.acg.lagraw;
sorteddat.acg.isnormalized = dat.acg.isnormalized;
sorteddat.acg.normrange = dat.acg.normrange;
sorteddat.acg.autocorr = sortDatfield_2D(dat.acg, 'autocorr', appsortingidx, 1);
sorteddat.acg.lag = dat.acg.lag;
sorteddat.clus = sortDatfield_2D(dat, 'clus', appsortingidx, 1);
sorteddat.date = dat.date;

% for ds infos
if isfield(dat,'dsos')
    sorteddat.dsos.x = sortDatfield_3D(dat.dsos, 'x', appsortingidx, 1);
    sorteddat.dsos.y = sortDatfield_3D(dat.dsos, 'y', appsortingidx, 1);
    sorteddat.dsos.circAvg = sortDatfield_3D(dat.dsos, 'circAvg', appsortingidx, 1);
    sorteddat.dsos.maxF = sortDatfield_2D(dat.dsos, 'maxF', appsortingidx, 1);
    sorteddat.dsos.minF = sortDatfield_2D(dat.dsos, 'minF', appsortingidx, 1);
    sorteddat.dsos.grx = sortDatfield_3D(dat.dsos, 'grx', appsortingidx, 1);
    sorteddat.dsos.gry = sortDatfield_3D(dat.dsos, 'gry', appsortingidx, 1);
    sorteddat.dsos.txtvals = sortDatfield_3D(dat.dsos, 'txtvals', appsortingidx, 1);
    sorteddat.dsos.dsi = sortDatfield_2D(dat.dsos, 'dsi', appsortingidx, 1);
    sorteddat.dsos.dsi_pval = sortDatfield_2D(dat.dsos, 'dsi_pval', appsortingidx, 1);
    sorteddat.dsos.osi = sortDatfield_2D(dat.dsos, 'osi', appsortingidx, 1);
    sorteddat.dsos.osi_pval = sortDatfield_2D(dat.dsos, 'osi_pval', appsortingidx, 1);
    sorteddat.dsos.respquality = sortDatfield_2D(dat.dsos, 'respquality', appsortingidx, 1);
    sorteddat.dsos.dscandicates = sortDatfield_2D(dat.dsos, 'dscandicates', appsortingidx, 1);
    sorteddat.dsos.oscandicates = sortDatfield_2D(dat.dsos, 'oscandicates', appsortingidx, 1);
end

% nonlinearities
sorteddat.nl.nlx = sortDatfield_2D(dat.nl, 'nlx', appsortingidx, 1);
sorteddat.nl.nly = sortDatfield_2D(dat.nl, 'nly', appsortingidx, 1);

% pca data
sorteddat.pcadata.coeffs = dat.pcadata.coeffs;
sorteddat.pcadata.scores = sortDatfield_2D(dat.pcadata, 'scores', appsortingidx, 1);

% rfcontours
sorteddat.rfcontours.contourspts = sortDatfield_3D(dat.rfcontours, 'contourspts', appsortingidx, 1);
sorteddat.rfcontours.shapes = sortDatfield_2D(dat.rfcontours, 'shapes', appsortingidx, 1);
sorteddat.rfcontours.centroids = sortDatfield_2D(dat.rfcontours, 'centroids', appsortingidx, 1);
sorteddat.rfcontours.scalevalue = dat.rfcontours.scalevalue;

if isfield(dat.rfdata, 'frozenRates')
    frozenflag = true;
else
    frozenflag = false;
end
% receptive field data
if frozenflag, sorteddat.rfdata.allReliableRsq = sortDatfield_2D(dat.rfdata, 'allReliableRsq', appsortingidx, 1); end
sorteddat.rfdata.allmoran = sortDatfield_2D(dat.rfdata, 'allmoran', appsortingidx, 1);
sorteddat.rfdata.allrangex = sortDatfield_2D(dat.rfdata, 'allrangex', appsortingidx, 1);
sorteddat.rfdata.allrangey = sortDatfield_2D(dat.rfdata, 'allrangey', appsortingidx, 1);
sorteddat.rfdata.autoCorrLag = dat.rfdata.autoCorrLag;
sorteddat.rfdata.autoCorrelations = sortDatfield_2D(dat.rfdata, 'autoCorrelations', appsortingidx, 1);
sorteddat.rfdata.contourareas = sortDatfield_2D(dat.rfdata, 'contourareas', appsortingidx, 1);
sorteddat.rfdata.contourpoints = sortDatfield_3D(dat.rfdata, 'contourpoints', appsortingidx, 1);
sorteddat.rfdata.ellipseareas = sortDatfield_2D(dat.rfdata, 'ellipseareas', appsortingidx, 1);
sorteddat.rfdata.ellipsepoints = sortDatfield_3D(dat.rfdata, 'ellipsepoints', appsortingidx, 1);
if frozenflag
    sorteddat.rfdata.frozenRates = sortDatfield_2D(dat.rfdata, 'frozenRates', appsortingidx, 1);
    sorteddat.rfdata.frozenTimeVec = dat.rfdata.frozenTimeVec;
end
sorteddat.rfdata.gaussparams = sortDatfield_2D(dat.rfdata, 'gaussparams', appsortingidx, 1);
if frozenflag
    sorteddat.rfdata.lrCCnorm = sortDatfield_2D(dat.rfdata, 'lrCCnorm', appsortingidx, 1);
    sorteddat.rfdata.lrRsq = sortDatfield_2D(dat.rfdata, 'lrRsq', appsortingidx, 1);
    sorteddat.rfdata.lrpredictions = sortDatfield_2D(dat.rfdata, 'lrpredictions', appsortingidx, 1);
    sorteddat.rfdata.modelCCnorm = sortDatfield_2D(dat.rfdata, 'modelCCnorm', appsortingidx, 1);
    sorteddat.rfdata.modelRsq = sortDatfield_2D(dat.rfdata, 'modelRsq', appsortingidx, 1);
    sorteddat.rfdata.modelpredictions = sortDatfield_2D(dat.rfdata, 'modelpredictions', appsortingidx, 1);
end
sorteddat.rfdata.modelscomps = sortDatfield_3D(dat.rfdata, 'modelscomps', appsortingidx, 1);
sorteddat.rfdata.modeltcomps = sortDatfield_2D(dat.rfdata, 'modeltcomps', appsortingidx, 1);
sorteddat.rfdata.nlncentslr = sortDatfield_2D(dat.rfdata, 'nlncentslr', appsortingidx, 1);
sorteddat.rfdata.nlncentsmodel = sortDatfield_2D(dat.rfdata, 'nlncentsmodel', appsortingidx, 1);
sorteddat.rfdata.nlnvalslr = sortDatfield_2D(dat.rfdata, 'nlnvalslr', appsortingidx, 1);
sorteddat.rfdata.nlnvalsmodel = sortDatfield_2D(dat.rfdata, 'nlnvalsmodel', appsortingidx, 1);
sorteddat.rfdata.rfdiameters = sortDatfield_2D(dat.rfdata, 'rfdiameters', appsortingidx, 1);
sorteddat.rfdata.rfmodelparams = sortDatfield_2D(dat.rfdata, 'rfmodelparams', appsortingidx, 1);
sorteddat.rfdata.sigmaActivation = sortDatfield_2D(dat.rfdata, 'sigmaActivation', appsortingidx, 1);
sorteddat.rfdata.sigmaVals = dat.rfdata.sigmaVals;
sorteddat.rfdata.spaceVecX = dat.rfdata.spaceVecX;
sorteddat.rfdata.spaceVecY = dat.rfdata.spaceVecY;
sorteddat.rfdata.spatialComponents = sortDatfield_3D(dat.rfdata, 'spatialComponents', appsortingidx, 1);
sorteddat.rfdata.staAll = sortDatfield_4D(dat.rfdata, 'staAll', appsortingidx, 1);
sorteddat.rfdata.stimPara = dat.rfdata.stimPara;
sorteddat.rfdata.surroundIdx = sortDatfield_2D(dat.rfdata, 'surroundIdx', appsortingidx, 1);
sorteddat.rfdata.temporalComponents = sortDatfield_2D(dat.rfdata, 'temporalComponents', appsortingidx, 1);
sorteddat.rfdata.timeVec = dat.rfdata.timeVec;
if frozenflag
    sorteddat.rfdata.trialRates = sortDatfield_3D(dat.rfdata, 'trialRates', appsortingidx, 1);
end

sorteddat.savingpath = dat.savingpath;
sorteddat.sortinginfo = sortDatfield_2D(dat, 'sortinginfo', appsortingidx, 1);
sorteddat.tablevalues = sortDatfield_2D(dat, 'tablevalues', appsortingidx, 1);

sortedtable = app.T.Data(appsortingidx,:);
%sortDatfield_2D(app.T, 'Data', appsortingidx, 1);

app.singlecellpanel.UserData = sorteddat;
if ~loaddataflag
    app.T.Data = sortedtable; %app.T.DisplayData;
    app.T.UserData.curridx = find(appsortingidx==app.T.UserData.curridx);
    app.T.UserData.previdx = find(appsortingidx==app.T.UserData.previdx);
    %app.T.UserData.sortindex = 1: size(dat.clus,1);
    app.T.UserData.sortedcolumn = sortedcolumn;
    app.T.UserData.sortdirection = sortdir;
end
removeStyle(app.T);
addStyle(app.T, app.T.UserData.tablestyle,'row',app.T.UserData.curridx);


% numcells = size(dat.clus,1);
% fn = fieldnames(dat);
% fn = fn(~contains(fn,'savingpath'));
%
% for ii = 1:numel(fn)
%     df1 = dat.(fn{ii});
%     sdf1 = size(df1);
%
%     if ~any(eq(sdf1, numcells)) && isstruct(df1)
%         fn2 = fieldnames(df1);
%         for jj = 1:numel(fn2)
%             df2 = df1.(fn2{jj});
%             sdf2 = size(df2);
%             ncelldim = find(eq(sdf2, numcells));
%             if isempty(ncelldim), ncelldim = 0; end
%             if length(sdf2)==3 && ncelldim < 3 % find better slution later!
%                 if ncelldim == 1, ncelldim = 4; else, ncelldim = 5; end
%             end
%
%             switch ncelldim
%                 case 1
%                     dat.(fn{ii}).(fn2{jj}) = dat.(fn{ii}).(fn2{jj})(appsortingidx,:);
%                 case 2
%                     dat.(fn{ii}).(fn2{jj}) = dat.(fn{ii}).(fn2{jj})(:,appsortingidx);
%                 case 3
%                     dat.(fn{ii}).(fn2{jj})(:,:,:) = dat.(fn{ii}).(fn2{jj})(:,:,appsortingidx);
%                 case 4
%                     dat.(fn{ii}).(fn2{jj})(:,:,:) = dat.(fn{ii}).(fn2{jj})(appsortingidx,:,:);
%                 case 5
%                     dat.(fn{ii}).(fn2{jj})(:,:,:) = dat.(fn{ii}).(fn2{jj})(:,appsortingidx,:);
%             end
%         end
%     else
%         ncelldim = find(eq(sdf1, numcells));
%         if isempty(ncelldim), ncelldim = 0; end
%         if length(sdf2)==3 && ncelldim < 3
%             if ncelldim == 1, ncelldim = 4; else, ncelldim = 5; end
%         end
%         switch ncelldim
%             case 1
%                 dat.(fn{ii}) = dat.(fn{ii})(appsortingidx,:);
%             case 2
%                 dat.(fn{ii}) = dat.(fn{ii})(:,appsortingidx);
%             case 3
%                 dat.(fn{ii})(:,:,:) = dat.(fn{ii})(:,:,appsortingidx);
%             case 4
%                 dat.(fn{ii})(:,:,:) = dat.(fn{ii})(appsortingidx,:,:);
%             case 5
%                 dat.(fn{ii})(:,:,:) = dat.(fn{ii})(:,appsortingidx,:);
%         end
%
%     end
%
% end
%app.T.UserData.curridx
% app.singlecellpanel.UserData = dat;
% app.T.Data = currtable(appsortingidx,:); %app.T.DisplayData;
% %app.T.UserData.sortindex = 1: size(dat.clus,1);
% app.T.UserData.sortedcolumn = sortedcolumn;
%end

end


function flout = sortDatfield_2D(dat, flfn, sortidx, dim)

if isfield(dat,flfn)
    switch dim
        case 1
            flout = dat.(flfn)(sortidx,:);
        case 2
            flout = dat.(flfn)(:,sortidx);
    end
else
    flout = 'field does not exist';
end
end


function flout = sortDatfield_3D(dat, flfn, sortidx, dim)

if isfield(dat,flfn)
    switch dim
        case 1
            flout = dat.(flfn)(sortidx,:,:);
        case 2
            flout = dat.(flfn)(:,sortidx,:);
        case 3
            flout = dat.(flfn)(:,:,sortidx);
    end
else
    flout = 'field does not exist';
end
end

function flout = sortDatfield_4D(dat, flfn, sortidx, dim)

if isfield(dat,flfn)
    switch dim
        case 1
            flout = dat.(flfn)(sortidx,:,:,:);
        case 2
            flout = dat.(flfn)(:,sortidx,:,:);
        case 3
            flout = dat.(flfn)(:,:,sortidx,:);
        case 4
            flout = dat.(flfn)(:,:,:,sortidx);
    end
else
    flout = 'field does not exist';
end
end

function flout = sortDatfield_5D(dat, flfn, sortidx, dim)

if isfield(dat,flfn)
    switch dim
        case 1
            flout = dat.(flfn)(sortidx,:,:,:,:);
        case 2
            flout = dat.(flfn)(:,sortidx,:,:,:);
        case 3
            flout = dat.(flfn)(:,:,sortidx,:,:);
        case 4
            flout = dat.(flfn)(:,:,:,sortidx,:);
        case 5
            flout = dat.(flfn)(:,:,:,:,sortidx);
    end
else
    flout = 'field does not exist';
end
end


