
function plotDSdataApp(app, state)

curridx = app.T.UserData.curridx;
%previdx = app.T.UserData.previdx;
dat = app.singlecellpanel.UserData;

switch lower(state)
    case 'new'
        
        col = app.UIFigure.UserData.colorset(5,:);      %lines(3);
        lcol = 0.5 .* [1 1 1];%app.acg.XColor;
        
        for ii = 1:6
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
            dsp = app.(['ds',num2str(ii)]).Children;
            dsp(1).String{1} = sprintf(' %g', round(dat.dsos.txtvals(curridx,ii,2)));
            dsp(2).String{1} = sprintf(' %g', round(dat.dsos.txtvals(curridx,ii,1)));
            dsp(3).XData = [0 dat.dsos.circAvg(curridx,ii,1)];     % DS circular average
            dsp(3).YData = [0 dat.dsos.circAvg(curridx,ii,2)];
            dsp(4).XData = squeeze(dat.dsos.x(curridx,ii,:));      % DS plot
            dsp(4).YData = squeeze(dat.dsos.y(curridx,ii,:));
            dsp(5).XData = squeeze(dat.dsos.grx(curridx,ii,:));    % grid
            dsp(5).YData = squeeze(dat.dsos.gry(curridx,ii,:));
            axmax = ceil(max(abs(dat.dsos.txtvals(curridx,ii,:)))/5)*5;
            if axmax == 0, axmax = 1; end % to avoid axis issues when there is no response
            app.(['ds',num2str(ii)]).XLim = [-axmax axmax];
            
        end
end


end