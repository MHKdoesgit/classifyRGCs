

function plotPCAsApp(app)
%
% curridx = app.T.UserData.curridx;
% %previdx = app.T.UserData.previdx;
% switch lower(state)
%     case 'new'
%         dat = app.singlecellpanel.UserData;
%         col = [1 0 0];%app.UIFigure.UserData.colorset(3,:);      %lines(3);
%
%         for ii = 1:3
%
%             pcaplt = app.(['pca',num2str(ii)]);
%             line(pcaplt, dat.pcadata.scores(:,ii), dat.rf.RFdiameter,'o', 'MarkerFaceColor' ,0.65.*[1 1 1],'Color',0.85*[1 1 1]);
%             %hold(pcaplt,'on');
%             line(pcaplt, dat.pcadata.scores(curridx,ii), dat.rf.RFdiameter(curridx),'o', 'MarkerFaceColor' ,col,...
%                 'Color',[0.85 0.078 0.24],'MarkerSize',5);
%
%             pcaplt.XLim = [-max(abs(pcaplt.XLim)) max(abs(pcaplt.XLim))];
%             pcaplt.XTick = -5:0.5:5;
%             pcaplt.YTick = 0:100:1e3;
%             if ii==1
%                 pcaplt.XLabel.String = ['time course (PC',num2str(ii),')'];
%                 pcaplt.YLabel.String = 'RF diameter (µm)';
%             else
%                 pcaplt.XLabel.String = ['PC',num2str(ii)];
%                 pcaplt.YColor = 'none';
%                 axis(pcaplt,'square');
%             end
%             pcaplt.Title.String = ['PC',num2str(ii)];
%             %   pcaplt.GridAlpha
%             grid(pcaplt,'on');
%         end
%
%     case 'update'
%
%         for ii = 1:3
%             pcaplt = app.(['pca',num2str(ii)]).Children;
%             pcaplt(1).XData = app.singlecellpanel.UserData.pcadata.scores(curridx,ii);
%             pcaplt(1).YData = app.singlecellpanel.UserData.rf.RFdiameter(curridx);
%         end
% end


curridx     = app.T.UserData.curridx;
rgclabels   = app.T.Data(:,6);

% switch lower(lbindex)
%
%     case {1, '1', 'off parasol', 'off p'}
%         lbtomatch = 'off parasol';
%         rgclabelnum = 1;
%
%     case {2, '2', 'on parasol', 'on p'}
%         lbtomatch = 'on parasol';
%         rgclabelnum = 2;
%
%     case {3, '3', 'off midget', 'off m'}
%         lbtomatch = 'off midget';
%         rgclabelnum = 3;
%
%     case {4, '4', 'on midget', 'on m'}
%         lbtomatch = 'on midget';
%         rgclabelnum = 4;
% end

% cells2plt = (strcmpi(rgclabels,lbtomatch));

lbtomatch = {'off parasol', 'on parasol', 'off midget', 'on midget'};

dat = app.singlecellpanel.UserData;
col = [1 0 0];
for ii = 1:3
    %rf = app.singlecellpanel.UserData.rf.correctedcenter;
    %     x = dat.pcadata.scores(cells2plt,ii);
    %     y = dat.rf.RFdiameter(cells2plt);
    %
    %
    %     if isempty(x), x = NaN; y = NaN; end % little trick to plot not NaN for empty shit
    %currx  = dat.pcadata.scores(curridx,ii);
    %curry  = dat.rf.RFdiameter(curridx);
    
    if isempty(app.(['pca',num2str(ii)]).Children)
        
        pcaplt = app.(['pca',num2str(ii)]);
        % first all points
        line(pcaplt, dat.pcadata.scores(:,ii), dat.rf.RFdiameter,'Marker','o', 'LineStyle','none',...
            'MarkerFaceColor' ,0.65.*[1 1 1],'Color',0.85*[1 1 1],'MarkerSize',5);
        hold(pcaplt,'on');
        % then selected classes
        %         line(pcaplt, x,y,'Marker','o','LineStyle','none','Color',abs(app.UIFigure.UserData.colorset(rgclabelnum,:)-0.1),...
        %             'MarkerFaceColor',app.UIFigure.UserData.colorset(rgclabelnum,:));
        
        for jj = 1:4
            cells2plt = (strcmpi(rgclabels,lbtomatch{jj}));
            x = dat.pcadata.scores(cells2plt,ii);
            y = dat.rf.RFdiameter(cells2plt);
            if isempty(x), x = NaN; y = NaN; end % little trick to plot not NaN for empty shit
            scatter(pcaplt, x, y, 8, 'MarkerFaceColor',app.UIFigure.UserData.colorset(jj,:), 'MarkerEdgeColor',...
                abs(app.UIFigure.UserData.colorset(jj,:)-0.1),'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.7);
            %line(pcaplt, x,y,'Marker','o','LineStyle','none','Color',abs(app.UIFigure.UserData.colorset(jj,:)-0.1),...
            %    'MarkerFaceColor',app.UIFigure.UserData.colorset(jj,:));
        end
        % and finally current cell
        line(pcaplt, dat.pcadata.scores(curridx,ii), dat.rf.RFdiameter(curridx),'Marker','o', 'LineStyle','none',...
            'MarkerFaceColor' ,col,'Color',[0.85 0.078 0.24],'MarkerSize',7);
        
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
        hold(pcaplt,'off');
    else
        for jj = 1:4
            cells2plt = (strcmpi(rgclabels,lbtomatch{jj}));
            x = dat.pcadata.scores(cells2plt,ii);
            y = dat.rf.RFdiameter(cells2plt);
            app.(['pca',num2str(ii)]).Children(6-jj).XData = x(:);
            app.(['pca',num2str(ii)]).Children(6-jj).YData = y(:);
        end
        app.(['pca',num2str(ii)]).Children(1).XData = dat.pcadata.scores(curridx,ii);
        app.(['pca',num2str(ii)]).Children(1).YData = dat.rf.RFdiameter(curridx);
    end
end





end