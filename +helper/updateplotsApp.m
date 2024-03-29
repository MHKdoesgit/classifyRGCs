

function updateplotsApp(app)

% get data and current index
appdat  =    app.singlecellpanel.UserData;
curridx =    app.T.UserData.curridx;

% auto-correlogram
app.acg.Children.YData = appdat.acg.autocorr(curridx,:);

% temporal component
app.tempcomp.Children(1).YData = appdat.rfdata.modeltcomps(curridx,:); %  fit
app.tempcomp.Children(2).YData = appdat.rfdata.temporalComps(curridx,:); % data

% all RFs
% x = [squeeze(appdat.rf.correctedcenter(1,:,:));nan(1,size(appdat.rf.correctedcenter,3))];
% y = [squeeze(appdat.rf.correctedcenter(2,:,:));nan(1,size(appdat.rf.correctedcenter,3))];

x = [squeeze(appdat.rfdata.contourpoints(:,1,:)),nan(size(appdat.rfdata.contourpoints,1),1)]';
y = [squeeze(appdat.rfdata.contourpoints(:,2,:)),nan(size(appdat.rfdata.contourpoints,1),1)]';

% first all the lines
app.RFall.Children(2).XData = x(:);
app.RFall.Children(2).YData = y(:);
% on top of it, the selected cell
% app.RFall.Children(1).XData = appdat.rf.correctedcenter(1,:,curridx);
% app.RFall.Children(1).YData = appdat.rf.correctedcenter(2,:,curridx);
app.RFall.Children(1).XData = squeeze(appdat.rfdata.contourpoints(curridx,1,:));
app.RFall.Children(1).YData = squeeze(appdat.rfdata.contourpoints(curridx,2,:));

app.RFall.Title.String = ['center: ',num2str(round(appdat.rfdata.rfdiameters(curridx,1)*1e6,1)),' (�m)',...
    ', area: ',num2str(round(appdat.rfdata.contourareas(curridx),3)),' (mm^2)'];

%['center: ',num2str(round(appdat.rf.RFdiameter(curridx,1))),...
%    ', surround: ',num2str(round(appdat.rf.gaussfit(curridx).surrounddiameter,1)),' (�m)'];

% app.RFall.Children(app.T.UserData.previdx).Color = 0.85 * [1 1 1];
% app.RFall.Children(app.T.UserData.previdx).LineWidth = 0.5;
% app.RFall.Children(curridx).Color = [1 0 0];
% app.RFall.Children(curridx).LineWidth = 2;

xsx = appdat.rfdata.spaceVecX(appdat.rfdata.rangex{curridx});
ysy = appdat.rfdata.spaceVecY(appdat.rfdata.rangey{curridx});
sc = squeeze(appdat.rfdata.spatialComps(curridx, appdat.rfdata.rangey{curridx}, appdat.rfdata.rangex{curridx}));

% spatial component
% xsx = appdat.rf.subrow(curridx,:);      xsx = xsx(~isnan(xsx));
% ysy = appdat.rf.subcol(curridx,:);      ysy = ysy(~isnan(ysy));
% xsx = xsx(1:size(appdat.rf.spatialComp,2));
% ysy = ysy(1:size(appdat.rf.spatialComp,1));
% mx = max(abs(appdat.rf.spatialComp(:,:,curridx)),[],'all');
app.spatialcomp.Children(3).XData = xsx;
app.spatialcomp.Children(3).YData = ysy;
app.spatialcomp.Children(3).CData = sc;
if ~isempty(sc) && max(abs(sc(:))) ~= 0
    app.spatialcomp.CLim = [-1 1]* max(abs(sc(:)));
end
% plotting receptive field center
app.spatialcomp.Children(1).XData = squeeze(appdat.rfdata.ellipsepoints(curridx,1,:)); %appdat.rf.correctedcenter(1,:,curridx);
app.spatialcomp.Children(1).YData = squeeze(appdat.rfdata.ellipsepoints(curridx,2,:)); %appdat.rf.correctedcenter(2,:,curridx);
% plotting surround
app.spatialcomp.Children(2).XData = squeeze(appdat.rfdata.contourpoints(curridx,1,:)); %appdat.rf.correctedcenter(1,:,curridx);
app.spatialcomp.Children(2).YData = squeeze(appdat.rfdata.contourpoints(curridx,2,:)); %appdat.rf.correctedcenter(2,:,curridx);
app.spatialcomp.Title.String = ['morans I: ', num2str(round(appdat.rfdata.moransI(curridx,1),2)),...
    ', surround index: ', num2str(round(appdat.rfdata.surroundIndex(curridx,1),2))];


% STA frames
helper.plotSTAframesApp(app, 'update');
% staimg = find(strcmpi(get(app.sta.Children,'type'),'image'));
% for ii = 1:numel(staimg)
%     app.sta.Children(staimg(ii)).CData = appdat.rf.STA{curridx}(:,:,end-ii);
% end
if isfield(appdat,'dsos')
    if ~isempty(appdat.dsos)
    helper.plotDSdataApp(app,'update');
    end
end
% for ii = 1:6
%     dsp = app.(['ds',num2str(ii)]).Children;
%     dsp(1).String{1} = sprintf(' %g', round(app.singlecellpanel.UserData.dsplt.txtvals(curridx,ii,2)));
%     dsp(2).String{1} = sprintf(' %g', round(app.singlecellpanel.UserData.dsplt.txtvals(curridx,ii,1)));
%     
% end

helper.plotPCAsApp(app);

app.classifyprogress.Value = curridx;

chinfo = appdat.sortinginfo(curridx);
app.celltitle.Text = ['cell ',num2str(chinfo.ch),', cluster ',num2str(chinfo.clus),...
            ', ks id ',num2str(chinfo.id),', quality ',num2str(chinfo.quality),...
            ', nspk ',num2str(chinfo.n_spikes),', ',strrep(chinfo.comment{1},'_',' '),...
            ' for experiment on ',appdat.date];

end