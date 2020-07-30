

function plotNLpopApp(app, lbindex, varargin)

curridx     = app.T.UserData.curridx;
rgclabels   = app.T.Data(:,6);

switch lower(lbindex)
    
    case {1, '1', 'off parasol', 'off p'}
        lbtomatch = 'off parasol';
        rgclabelnum = 1;
        
    case {2, '2', 'on parasol', 'on p'}
        lbtomatch = 'on parasol';
        rgclabelnum = 2;
        
    case {3, '3', 'off midget', 'off m'}
        lbtomatch = 'off midget';
        rgclabelnum = 3;
        
    case {4, '4', 'on midget', 'on m'}
        lbtomatch = 'on midget';
        rgclabelnum = 4;
end

cells2plt = (strcmpi(rgclabels,lbtomatch));

x = [ app.singlecellpanel.UserData.nl.nlx(cells2plt,:),nan(sum(cells2plt),1)]';
y = [ app.singlecellpanel.UserData.nl.nly(cells2plt,:),nan(sum(cells2plt),1)]';

if isempty(x), x = NaN; y = NaN; end % little trick to plot not NaN for empty shit
if any(ismember(find(cells2plt),curridx))
    currx  = app.singlecellpanel.UserData.nl.nlx(curridx,:);
    curry  = app.singlecellpanel.UserData.nl.nly(curridx,:);
else
    currx  = NaN;
    curry  = NaN;
end

if isfield(app.singlecellpanel.UserData.rfdata,'nlncentsmodel')
    if isempty(app.(['nlpop',num2str(rgclabelnum)]).Children)
        patch(app.(['nlpop',num2str(rgclabelnum)]), x(:),y(:),1,'edgecolor','none');
        line(app.(['nlpop',num2str(rgclabelnum)]), x(:), y(:),'color',app.UIFigure.UserData.colorset(rgclabelnum,:));
        line(app.(['nlpop',num2str(rgclabelnum)]), currx, curry,...
            'color',abs(app.UIFigure.UserData.colorset(rgclabelnum,:)-0.2),'Linewidth',2);
        app.(['nlpop',num2str(rgclabelnum)]).XLim = [-3.2 3.2];
        app.(['nlpop',num2str(rgclabelnum)]).YLim = [0 1.1];
        pbaspect(app.(['nlpop',num2str(rgclabelnum)]),[4 3 1]);
    else
        app.(['nlpop',num2str(rgclabelnum)]).Children(2).XData = x(:);
        app.(['nlpop',num2str(rgclabelnum)]).Children(2).YData = y(:);
        app.(['nlpop',num2str(rgclabelnum)]).Children(1).XData = currx;
        app.(['nlpop',num2str(rgclabelnum)]).Children(1).YData = curry;
        app.(['nlpop',num2str(rgclabelnum)]).Children(2).LineWidth = 0.5;
        app.(['nlpop',num2str(rgclabelnum)]).Children(2).Color = app.UIFigure.UserData.colorset(rgclabelnum,:);
        app.(['nlpop',num2str(rgclabelnum)]).Children(2).LineStyle = '-';
    end
end

end