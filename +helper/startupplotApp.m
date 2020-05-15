

function startupplotApp(app)


appdat  =    app.singlecellpanel.UserData;
curridx =    app.T.UserData.curridx;
cols    =    app.UIFigure.UserData.colorset; 

area(app.acg,appdat.acglag,appdat.acg(curridx,:),'FaceColor',cols(1,:),'EdgeColor','none');
app.acg.XLim = [0 50];
pbaspect(app.acg,[4 3 1]);
app.acg.Title.FontSize = 12;

plot(app.tempcomp,appdat.rf.para.time,appdat.rf.tempComp(curridx,:),'color',cols(1,:),'LineWidth',1);
app.tempcomp.XLim = [0 500];
pbaspect(app.tempcomp,[4 3 1]);
app.tempcomp.Title.FontSize = 12;

x = [squeeze(appdat.rf.correctedcenter(1,:,:));nan(1,size(appdat.rf.correctedcenter,3))];
y = [squeeze(appdat.rf.correctedcenter(2,:,:));nan(1,size(appdat.rf.correctedcenter,3))];

line(app.RFall, x(:),y(:),'color',0.65*[1 1 1],'linewidth',0.5);
line(app.RFall, appdat.rf.correctedcenter(1,:,curridx),appdat.rf.correctedcenter(2,:,curridx),'color','r','linewidth',2);
app.RFall.XLim = [0 appdat.rf.para.screen(1)];       app.RFall.YLim = [0 appdat.rf.para.screen(2)];
axis(app.RFall,'equal');        axis(app.RFall,'tight');        box(app.RFall,'on');
app.RFall.XTick = [];           app.RFall.YTick = [];
app.RFall.Title.String = ['center: ',num2str(round(appdat.rf.RFdiameter(curridx,1))),...
    ', surround: ',num2str(round(appdat.rf.gaussfit(curridx).surrounddiameter,1)),' (µm)'];
app.RFall.Title.FontSize = 12;
%app.RFall.XColor = 'none';
%app.RFall.YColor = 'none';


xsx = appdat.rf.subrow(curridx,:);      xsx = xsx(~isnan(xsx));
ysy = appdat.rf.subcol(curridx,:);      ysy = ysy(~isnan(ysy));
mx = max(abs(appdat.rf.spatialComp(:,:,curridx)),[],'all');
imagesc(app.spatialcomp,xsx,ysy,appdat.rf.spatialComp(1:length(xsx),1:length(ysy),curridx));
hold( app.spatialcomp, 'on' );
plot(app.spatialcomp,appdat.rf.correctedsurround(1,:,curridx),appdat.rf.correctedsurround(2,:,curridx),'color',0.65.*[1 1 1]);
plot(app.spatialcomp,appdat.rf.correctedcenter(1,:,curridx),appdat.rf.correctedcenter(2,:,curridx),'k','LineWidth',2);
app.spatialcomp.CLim = [-mx mx];
axis(app.spatialcomp,'equal');      axis(app.spatialcomp,'tight');          box(app.spatialcomp,'on');
app.spatialcomp.XTick = [];           app.spatialcomp.YTick = [];
app.spatialcomp.Title.String = ['morans I: ', round(num2str(appdat.rf.moransI(curridx,1),1))];
app.spatialcomp.Title.FontSize = 12;

helper.plotSTAframesApp(app);

helper.plotPCAsApp(app, 'new');

helper.plotPCAsApp(app, 'new');

app.classifyprogress.Limits = [1,size(app.T.Data,1)];
app.classifyprogress.Value = curridx;

app.datapanel.Visible = 'on';

end