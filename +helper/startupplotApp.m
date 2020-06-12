

function startupplotApp(app)


appdat  =    app.singlecellpanel.UserData;
curridx =    app.T.UserData.curridx;
cols    =    app.UIFigure.UserData.colorset; 

bar(app.acg,appdat.acg.lag,appdat.acg.autocorr(curridx,:),'FaceColor',cols(1,:),'EdgeColor','none','BarWidth',1);
app.acg.XLim = [0 50];
app.acg.XTick = 0:25:100;
pbaspect(app.acg,[4 3 1]);
app.acg.Title.FontSize = 11;

line(app.tempcomp,appdat.rfdata.timeVec,appdat.rfdata.temporalComponents(curridx,:),'color',cols(1,:),'LineWidth',1);
line(app.tempcomp,appdat.rfdata.timeVec,appdat.rfdata.modeltcomps(curridx,:),'color',cols(2,:),'LineWidth',1);
app.tempcomp.XLim = [-0.5 0];
legend(app.tempcomp,'data','fit','Location','southwest');       legend(app.tempcomp, 'boxoff');
pbaspect(app.tempcomp,[4 3 1]);
app.tempcomp.Title.FontSize = 11;

% x = [squeeze(appdat.rf.correctedcenter(1,:,:));nan(1,size(appdat.rf.correctedcenter,3))];
% y = [squeeze(appdat.rf.correctedcenter(2,:,:));nan(1,size(appdat.rf.correctedcenter,3))];

x = [squeeze(appdat.rfdata.contourpoints(:,1,:)),nan(size(appdat.rfdata.contourpoints,1),1)]';
y = [squeeze(appdat.rfdata.contourpoints(:,2,:)),nan(size(appdat.rfdata.contourpoints,1),1)]';

line(app.RFall, x(:),y(:),'color',0.65*[1 1 1],'linewidth',0.5);
% line(app.RFall, appdat.rf.correctedcenter(1,:,curridx),appdat.rf.correctedcenter(2,:,curridx),'color','r','linewidth',2);
line(app.RFall, squeeze(appdat.rfdata.contourpoints(curridx,1,:)),...
    squeeze(appdat.rfdata.contourpoints(curridx,2,:)),'color','r','linewidth',2);
axis(app.RFall,'equal');        axis(app.RFall,'tight');        box(app.RFall,'on');
app.RFall.XLim = [0 appdat.rfdata.stimPara.screen(1)];       app.RFall.YLim = [0 appdat.rfdata.stimPara.screen(2)];
app.RFall.XTick = [];           app.RFall.YTick = [];
app.RFall.Title.String = ['center: ',num2str(round(appdat.rfdata.rfdiameters(curridx,1)*1e6,1)),' (µm)',...
    ', area: ',num2str(round(appdat.rfdata.contourareas(curridx),3)),' (mm^2)'];
app.RFall.Title.FontSize = 11;
%app.RFall.XDir = 'reverse';
app.RFall.YDir = 'reverse';
%app.RFall.XColor = 'none';
%app.RFall.YColor = 'none';


% xsx = appdat.rfdata.subrow(curridx,:);      xsx = xsx(~isnan(xsx));
% ysy = appdat.rf.subcol(curridx,:);      ysy = ysy(~isnan(ysy));
% mx = max(abs(appdat.rf.spatialComp(:,:,curridx)),[],'all');

xsx = appdat.rfdata.spaceVecX(appdat.rfdata.allrangex{curridx});
ysy = appdat.rfdata.spaceVecY(appdat.rfdata.allrangey{curridx});
sc = squeeze(appdat.rfdata.spatialComponents(curridx, appdat.rfdata.allrangey{curridx}, appdat.rfdata.allrangex{curridx}));

imagesc(app.spatialcomp,xsx,ysy, sc, [-1 1]* max(abs(sc(:))));
%imagesc(app.spatialcomp,xsx,ysy,appdat.rf.spatialComp(1:length(xsx),1:length(ysy),curridx));
hold( app.spatialcomp, 'on' );
line(app.spatialcomp,squeeze(appdat.rfdata.contourpoints(curridx,1,:)),...
    squeeze(appdat.rfdata.contourpoints(curridx,2,:)),'color',0.45.*[1 1 1]);
line(app.spatialcomp,squeeze(appdat.rfdata.ellipsepoints(curridx,1,:)),...
    squeeze(appdat.rfdata.ellipsepoints(curridx,2,:)),'color','k');

%plot(app.spatialcomp,appdat.rf.correctedcenter(1,:,curridx),appdat.rf.correctedcenter(2,:,curridx),'k','LineWidth',2);
%app.spatialcomp.CLim = [-mx mx];
axis(app.spatialcomp,'equal');      axis(app.spatialcomp,'tight');          box(app.spatialcomp,'on');
app.spatialcomp.XTick = [];           app.spatialcomp.YTick = [];
app.spatialcomp.Title.String = ['morans I: ', num2str(round(appdat.rfdata.allmoran(curridx,1),2)),...
    ', surround index: ', num2str(round(appdat.rfdata.surroundIdx(curridx,1),2))];
app.spatialcomp.Title.FontSize = 11;

helper.plotSTAframesApp(app, 'new');

helper.plotDSdataApp(app, 'new');

helper.plotPCAsApp(app);

app.classifyprogress.Limits = [1,size(app.T.Data,1)];
app.classifyprogress.Value = curridx;

chinfo = appdat.sortinginfo(curridx);
app.celltitle.Text = ['cell ',num2str(chinfo.ch),', cluster ',num2str(chinfo.clus),...
            ', ks id ',num2str(chinfo.id),', quality ',num2str(chinfo.quality),...
            ', nspk ',num2str(chinfo.n_spikes),', ',strrep(chinfo.comment{1},'_',' '),...
            ' for experiment on ',appdat.date];
app.celltitle.HorizontalAlignment = 'center';
app.celltitle.VerticalAlignment = 'center';
app.celltitle.FontSize = 20;
%app.celltitle.FontWeight = 'bold';
        
lblist = {'Off parasol','On parasol', 'Off midget','On midget'};
lbline = '-';
for ii = 1:size(lblist,2)
    app.([strrep(lblist{ii},' ',''),'Label']).Text = [repmat(lbline,1,55),repmat(' ',1,5),lblist{ii},repmat(' ',1,5),repmat(lbline,1,55)];
    app.([strrep(lblist{ii},' ',''),'Label']).VerticalAlignment = 'top';
    app.([strrep(lblist{ii},' ',''),'Label']).HorizontalAlignment = 'center';
    %app.([strrep(lblist{ii},' ',''),'Label']).Enable = 'on';
end

app.datapanel.Visible = 'on';


end