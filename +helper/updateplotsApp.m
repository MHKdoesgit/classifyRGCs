

function updateplotsApp(app)

% get data and current index
appdat  =    app.singlecellpanel.UserData;
curridx =    app.T.UserData.curridx;

% auto-correlogram
app.acg.Children.YData = appdat.acg.autocorr(curridx,:);

% temporal component
app.tempcomp.Children.YData = appdat.rf.tempComp(curridx,:);

% all RFs
x = [squeeze(appdat.rf.correctedcenter(1,:,:));nan(1,size(appdat.rf.correctedcenter,3))];
y = [squeeze(appdat.rf.correctedcenter(2,:,:));nan(1,size(appdat.rf.correctedcenter,3))];
% first all the lines
app.RFall.Children(2).XData = x(:);
app.RFall.Children(2).YData = y(:);
% on top of it, the selected cell
app.RFall.Children(1).XData = appdat.rf.correctedcenter(1,:,curridx);
app.RFall.Children(1).YData = appdat.rf.correctedcenter(2,:,curridx);
app.RFall.Title.String = ['center: ',num2str(round(appdat.rf.RFdiameter(curridx,1))),...
    ', surround: ',num2str(round(appdat.rf.gaussfit(curridx).surrounddiameter,1)),' (µm)'];

% app.RFall.Children(app.T.UserData.previdx).Color = 0.85 * [1 1 1];
% app.RFall.Children(app.T.UserData.previdx).LineWidth = 0.5;
% app.RFall.Children(curridx).Color = [1 0 0];
% app.RFall.Children(curridx).LineWidth = 2;

% spatial component
xsx = appdat.rf.subrow(curridx,:);      xsx = xsx(~isnan(xsx));
ysy = appdat.rf.subcol(curridx,:);      ysy = ysy(~isnan(ysy));
xsx = xsx(1:size(appdat.rf.spatialComp,2));
ysy = ysy(1:size(appdat.rf.spatialComp,1));
mx = max(abs(appdat.rf.spatialComp(:,:,curridx)),[],'all');
app.spatialcomp.Children(3).XData = xsx;
app.spatialcomp.Children(3).YData = ysy;
app.spatialcomp.Children(3).CData = appdat.rf.spatialComp(1:length(xsx),1:length(ysy),curridx);
app.spatialcomp.CLim = [-mx mx];
% plotting receptive field center
app.spatialcomp.Children(1).XData = appdat.rf.correctedcenter(1,:,curridx);
app.spatialcomp.Children(1).YData = appdat.rf.correctedcenter(2,:,curridx);
% plotting surround
app.spatialcomp.Children(2).XData = appdat.rf.correctedcenter(1,:,curridx);
app.spatialcomp.Children(2).YData = appdat.rf.correctedcenter(2,:,curridx);
app.spatialcomp.Title.String = ['morans I: ', round(num2str(appdat.rf.moransI(curridx,1),1))];


% STA frames
helper.plotSTAframesApp(app, 'update');
% staimg = find(strcmpi(get(app.sta.Children,'type'),'image'));
% for ii = 1:numel(staimg)
%     app.sta.Children(staimg(ii)).CData = appdat.rf.STA{curridx}(:,:,end-ii);
% end

helper.plotDSdataApp(app,'update');

% for ii = 1:6
%     dsp = app.(['ds',num2str(ii)]).Children;
%     dsp(1).String{1} = sprintf(' %g', round(app.singlecellpanel.UserData.dsplt.txtvals(curridx,ii,2)));
%     dsp(2).String{1} = sprintf(' %g', round(app.singlecellpanel.UserData.dsplt.txtvals(curridx,ii,1)));
%     
% end

helper.plotPCAsApp(app, 'update');

app.classifyprogress.Value = curridx;

chinfo = appdat.sortinginfo(curridx);
app.celltitle.Text = ['cell ',num2str(chinfo.ch),', cluster ',num2str(chinfo.clus),...
            ', ks id ',num2str(chinfo.id),', quality ',num2str(chinfo.quality),...
            ', nspk ',num2str(chinfo.n_spikes),', ',strrep(chinfo.comment{1},'_',' '),...
            ' for experiment on ',datemaker(appdat.savingpath)];

end