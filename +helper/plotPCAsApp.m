

function plotPCAsApp(app, varargin)

if nargin > 1, showpts = varargin{1}; else, showpts = false; end

curridx     = app.T.UserData.curridx;
rgclabels   = app.T.Data(:,6);

lbtomatch = {'off parasol', 'on parasol', 'off midget', 'on midget'};

dat = app.singlecellpanel.UserData;
curridxcol = [1 0 0];
if strcmpi(app.themeSwitch.Value,'light')
    colface = 0.8 .* [1 1 1];
    coledge = 0.3 .* [1 1 1];
else
    colface = 0.75 .* [1 1 1];
    coledge = 0.95 .* [1 1 1];
end


for ii = 1:4
    %rf = app.singlecellpanel.UserData.rf.correctedcenter;
    %     x = dat.pcadata.scores(cells2plt,ii);
    %     y = dat.rf.RFdiameter(cells2plt);
    
    %     if isempty(x), x = NaN; y = NaN; end % little trick to plot not NaN for empty shit
    %currx  = dat.pcadata.scores(curridx,ii);
    %curry  = dat.rf.RFdiameter(curridx);
    
    if isempty(app.(['pca',num2str(ii)]).Children)
        pcaplt = app.(['pca',num2str(ii)]);
        % first all points
        line(pcaplt, dat.pcadata.scores(:,ii), dat.rfdata.contourareas,'Marker','o', 'LineStyle','none',...
            'MarkerFaceColor' ,colface,'Color',coledge,'MarkerSize',4);
        hold(pcaplt,'on');
        % then selected classes
        %         line(pcaplt, x,y,'Marker','o','LineStyle','none','Color',abs(app.UIFigure.UserData.colorset(rgclabelnum,:)-0.1),...
        %             'MarkerFaceColor',app.UIFigure.UserData.colorset(rgclabelnum,:));
        
        for jj = 1:4
            cells2plt = (strcmpi(rgclabels,lbtomatch{jj}));
            x = dat.pcadata.scores(cells2plt,ii);
            y = dat.rfdata.contourareas(cells2plt);
            if isempty(x), x = NaN; y = NaN; end % little trick to plot not NaN for empty shit
            scatter(pcaplt, x, y, 16, 'MarkerFaceColor',app.UIFigure.UserData.colorset(jj,:), 'MarkerEdgeColor',...
                abs(app.UIFigure.UserData.colorset(jj,:)-0.1),'MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.9);
            %line(pcaplt, x,y,'Marker','o','LineStyle','none','Color',abs(app.UIFigure.UserData.colorset(jj,:)-0.1),...
            %    'MarkerFaceColor',app.UIFigure.UserData.colorset(jj,:));
        end
        % and finally current cell
        line(pcaplt, dat.pcadata.scores(curridx,ii), dat.rfdata.contourareas(curridx),'Marker','o', 'LineStyle','none',...
            'MarkerFaceColor' ,curridxcol,'Color',[0.85 0.078 0.24],'MarkerSize',6);
        
        pcaplt.XLim = [-max(abs(pcaplt.XLim)) max(abs(pcaplt.XLim))];
        pcaplt.XTick = -5:0.5:5;
        pcaplt.YTick = 0:0.05:1;
        if ii==1
            pcaplt.XLabel.String = ['time course (PC',num2str(ii),')'];
            pcaplt.YLabel.String = 'RF contour area (µm^2)';
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
            y = dat.rfdata.contourareas(cells2plt);
            app.(['pca',num2str(ii)]).Children(6-jj).XData = x(:);
            app.(['pca',num2str(ii)]).Children(6-jj).YData = y(:);
        end
        app.(['pca',num2str(ii)]).Children(1).XData = dat.pcadata.scores(curridx,ii);
        app.(['pca',num2str(ii)]).Children(1).YData = dat.rfdata.contourareas(curridx);
    end
    
    if showpts % this is to hide or show the pca point on all the plots
        if isequal(app.(['pca',num2str(ii)]).Children(6).Color, coledge)
            app.(['pca',num2str(ii)]).Children(6).Color  = app.(['pca',num2str(ii)]).Color;
            app.(['pca',num2str(ii)]).Children(6).MarkerFaceColor  = app.(['pca',num2str(ii)]).Color;
        else
            app.(['pca',num2str(ii)]).Children(6).Color  = coledge;
            app.(['pca',num2str(ii)]).Children(6).MarkerFaceColor  = colface;
        end
            
%         switch lower(showpts)
%             case 'show'
%                 app.(['pca',num2str(ii)]).Children(6).Color  = coledge;
%                 app.(['pca',num2str(ii)]).Children(6).MarkerFaceColor  = colface;
%             case 'hide'
%                 app.(['pca',num2str(ii)]).Children(6).Color  = app.(['pca',num2str(ii)]).Color;
%                 app.(['pca',num2str(ii)]).Children(6).MarkerFaceColor  = app.(['pca',num2str(ii)]).Color;
%         end
        
    end

end

end