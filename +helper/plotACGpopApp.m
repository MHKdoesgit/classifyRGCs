

function plotACGpopApp(app, lbindex, varargin)

curridx     = app.T.UserData.curridx;
rgclabels   = app.T.Data(:,6);

[lbtomatch, rgclabelnum] = helper.getAppRGClabels(lbindex);

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

cells2plt = (strcmpi(rgclabels,lbtomatch));

x = repmat([app.singlecellpanel.UserData.acg.lag';nan(1,1)],sum(cells2plt),1);
y = [ app.singlecellpanel.UserData.acg.autocorr(cells2plt,:)';nan(1,sum(cells2plt))];

if isempty(x), x = NaN; y = NaN; end % little trick to plot not NaN for empty shit
if any(ismember(find(cells2plt),curridx))
    currx  = app.singlecellpanel.UserData.acg.lag;
    curry  = app.singlecellpanel.UserData.acg.autocorr(curridx,:);
else
    currx = nan(size(app.singlecellpanel.UserData.acg.lag));
    curry = nan(size(app.singlecellpanel.UserData.acg.lag));
end


if isempty(app.(['acgpop',num2str(rgclabelnum)]).Children)
    patch(app.(['acgpop',num2str(rgclabelnum)]), x(:),y(:),1,'edgecolor','none');
    line(app.(['acgpop',num2str(rgclabelnum)]),x(:), y(:),'color',app.UIFigure.UserData.colorset(rgclabelnum,:));
    line(app.(['acgpop',num2str(rgclabelnum)]),app.singlecellpanel.UserData.acg.lag, curry,...
        'color',abs(app.UIFigure.UserData.colorset(rgclabelnum,:)-0.2),'Linewidth',2);
    pbaspect(app.(['acgpop',num2str(rgclabelnum)]),[4 3 1]);
    app.(['acgpop',num2str(rgclabelnum)]).XLim = app.acg.XLim;
else
    app.(['acgpop',num2str(rgclabelnum)]).Children(2).XData = x(:);
    app.(['acgpop',num2str(rgclabelnum)]).Children(2).YData = y(:);
    app.(['acgpop',num2str(rgclabelnum)]).Children(1).XData = currx;
    app.(['acgpop',num2str(rgclabelnum)]).Children(1).YData = curry;
    app.(['acgpop',num2str(rgclabelnum)]).Children(2).LineWidth = 0.5;
    app.(['acgpop',num2str(rgclabelnum)]).Children(2).Color = app.UIFigure.UserData.colorset(rgclabelnum,:);
    app.(['acgpop',num2str(rgclabelnum)]).Children(2).LineStyle = '-';
    
end

end