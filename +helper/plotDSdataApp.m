
function plotDSdataApp(app, state)

curridx = app.T.UserData.curridx;
%previdx = app.T.UserData.previdx;
dat = app.singlecellpanel.UserData;

switch lower(state)
    case 'new'
        
        lcol = 0.5 .* [1 1 1];%app.acg.XColor;
        
        for ii = 1:6
            
            if dat.dsos.dsi(curridx,ii) > 0.15 && dat.dsos.dsi_pval(curridx,ii) < 0.05 && dat.dsos.respquality(curridx) > 0.5
                if strcmpi(app.themeSwitch.Value,'light')
                    col = [0 0.75 1];
                    titrcol = [0 0.3 0.8];
                else
                    col = [0 0.75 1];
                    titrcol = [0 0.8 1];
                end
            elseif dat.dsos.osi(curridx,ii) > 0.15 && dat.dsos.osi_pval(curridx,ii) < 0.05 && dat.dsos.respquality(curridx) > 0.5
                if strcmpi(app.themeSwitch.Value,'light')
                    col = [0.54 0.17 0.89];
                    titrcol = [0.34 0.1 0.69];
                else
                    col = [0.74 0.27 1]; 
                    titrcol = [0.8 0.4 0.9];
                end
            else
                col = app.UIFigure.UserData.colorset(5,:);      %lines(3);
                titrcol = app.acg.Title.Color;
            end
            dsp = app.(['ds',num2str(ii)]);
            
            plot(dsp, squeeze(dat.dsos.grx(curridx,ii,:)),squeeze(dat.dsos.gry(curridx,ii,:)),'color',lcol,'LineWidth',0.5);
            hold(dsp,'on');
            plot(dsp, squeeze(dat.dsos.x(curridx,ii,:)),squeeze(dat.dsos.y(curridx,ii,:)),'color',col,'LineWidth',2 );
            plot(dsp, [0 dat.dsos.circAvg(curridx,ii,1)],[0 dat.dsos.circAvg(curridx,ii,2)],'color',col,'LineWidth',2);
            %                 plot(dsp, d.dsos.circAvg(idx,ii,1),d.dsos.circAvg(idx,ii,2),'o','color',rgb('deepskyblue'),...
            %                     'LineWidth',3,'MarkerFaceColor',rgb('deepskyblue'),'MarkerSize',4);
            text(dsp, dat.dsos.txtvals(curridx,ii,1),0, {sprintf(' %g', round(dat.dsos.txtvals(curridx,ii,1)));' Hz'},'verticalalignment', ...
                'middle','horizontalalignment', 'left','fontsize',7,'color',lcol);
            
            text(dsp, dat.dsos.txtvals(curridx,ii,2),0, {sprintf(' %g', round(dat.dsos.txtvals(curridx,ii,2)));' Hz'},'verticalalignment', ...
                'middle','horizontalalignment', 'left','fontsize',7,'color',lcol);
            axis(dsp,'equal');      axis(dsp,'tight');
            dsp.XTick = [];
            dsp.YTick = [];
            titr = sprintf('dsi:%2.2f, ds-pval:%2.2f, osi:%2.2f\nos-pval:%2.2f, quality:%2.2f',dat.dsos.dsi(curridx,ii),...
                dat.dsos.dsi_pval(curridx,ii),dat.dsos.osi(curridx,ii),dat.dsos.osi_pval(curridx,ii),dat.dsos.respquality(curridx));
            dsp.Title.String        =  titr;
            dsp.Title.FontSize      = 10;
            dsp.Title.FontWeight    = 'normal';
            dsp.Title.Color         = titrcol;
            dsp.XColor = 'none';
            dsp.YColor = 'none';
            axmax = ceil(max(abs(dat.dsos.txtvals(curridx,ii,:)))/5)*5;
            dsp.XLim = [-axmax axmax];
            axis(dsp,'off');
        end
        
        
    case 'update'
        
        for ii = 1:6
            % dsp = app.(['ds',num2str(ii)]);
            % cla(dsp);
            if dat.dsos.dsi(curridx,ii) > 0.14 && dat.dsos.dsi_pval(curridx,ii) < 0.05 && dat.dsos.respquality(curridx) > 0.49
                if strcmpi(app.themeSwitch.Value,'light')
                    col = [0 0.75 1];
                    titrcol = [0 0.3 0.8];
                else
                    col = [0 0.75 1];
                    titrcol = [0 0.8 1];
                end
            elseif dat.dsos.osi(curridx,ii) > 0.14 && dat.dsos.osi_pval(curridx,ii) < 0.05 && dat.dsos.respquality(curridx) > 0.49
                if strcmpi(app.themeSwitch.Value,'light')
                    col = [0.54 0.17 0.89]; 
                    titrcol = [0.34 0.1 0.69];
                else
                    col = [0.74 0.27 1]; 
                    titrcol = [0.8 0.4 0.9];
                end
            else
                col = app.UIFigure.UserData.colorset(5,:);
                titrcol = app.acg.Title.Color;
            end
            
            dsp = app.(['ds',num2str(ii)]).Children;
            dsp(1).String{1} = sprintf(' %g', round(dat.dsos.txtvals(curridx,ii,2)));
            dsp(2).String{1} = sprintf(' %g', round(dat.dsos.txtvals(curridx,ii,1)));
            dsp(3).XData = [0 dat.dsos.circAvg(curridx,ii,1)];     % DS circular average
            dsp(3).YData = [0 dat.dsos.circAvg(curridx,ii,2)];
            dsp(3).Color = col;
            dsp(4).XData = squeeze(dat.dsos.x(curridx,ii,:));      % DS plot
            dsp(4).YData = squeeze(dat.dsos.y(curridx,ii,:));
            dsp(4).Color = col;
            dsp(5).XData = squeeze(dat.dsos.grx(curridx,ii,:));    % grid
            dsp(5).YData = squeeze(dat.dsos.gry(curridx,ii,:));
            axmax = ceil(max(abs(dat.dsos.txtvals(curridx,ii,:)))/5)*5;
            if axmax == 0, axmax = 1; end % to avoid axis issues when there is no response
            app.(['ds',num2str(ii)]).XLim = [-axmax axmax];
            titr = sprintf('dsi:%2.2f, ds-pval:%2.2f, osi:%2.2f\nos-pval:%2.2f, quality:%2.2f',dat.dsos.dsi(curridx,ii),...
                dat.dsos.dsi_pval(curridx,ii),dat.dsos.osi(curridx,ii),dat.dsos.osi_pval(curridx,ii),dat.dsos.respquality(curridx));
            app.(['ds',num2str(ii)]).Title.String =  titr;
            app.(['ds',num2str(ii)]).Title.Color  =  titrcol;
        end
end


end