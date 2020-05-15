
function plotDSdataApp(app, state)


curridx = app.T.UserData.curridx;
%previdx = app.T.UserData.previdx;

switch lower(state)
    case 'new'
        dat = app.singlecellpanel.UserData;
        col = app.UIFigure.UserData.colorset(2,:);      %lines(3);
        
        for ii = 1:3
            
            pcaplt = app.(['pca',num2str(ii)]);
            plot(pcaplt, dat.pcascores(:,ii), dat.rf.RFdiameter,'o', 'MarkerFaceColor' ,0.65.*[1 1 1],'Color',0.85*[1 1 1]);
            hold(pcaplt,'on');
            plot(pcaplt, dat.pcascores(curridx,ii), dat.rf.RFdiameter(curridx),'o', 'MarkerFaceColor' ,col(ii,:),...
                'Color',col(ii,:),'MarkerSize',7);
            pcaplt.XLim = [-max(abs(pcaplt.XLim)) max(abs(pcaplt.XLim))];
            pcaplt.XTick = -5:0.5:5;
            pcaplt.YTick = 0:100:1e3;
            if ii==1
                pcaplt.XLabel.String = ['time course (PC',num2str(ii),')'];
                pcaplt.YLabel.String = 'RF diameter (µm)';
            else
                pcaplt.XLabel.String = ['PC',num2str(ii)];
                pcaplt.YColor = 'none';
                axis(pcaplt,'square');
            end
            pcaplt.Title.String = ['PC',num2str(ii)];
            %   pcaplt.GridAlpha
            grid(pcaplt,'on');
            
        end
        
        
    case 'update'
        
        for ii = 1:3
            pcaplt = app.(['pca',num2str(ii)]).Children;
            pcaplt(1).XData = app.singlecellpanel.UserData.pcascores(curridx,ii);
            pcaplt(1).YData = app.singlecellpanel.UserData.rf.RFdiameter(curridx);
            
            
        end
end








end