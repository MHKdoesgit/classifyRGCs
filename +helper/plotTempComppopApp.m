

function plotTempComppopApp(app, lbindex, varargin)

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

x = repmat([app.singlecellpanel.UserData.rfdata.timeVec';nan(1,1)],sum(cells2plt),1);
y = [ app.singlecellpanel.UserData.rfdata.temporalComponents(cells2plt,:)';nan(1,sum(cells2plt))];

if isempty(x), x = NaN; y = NaN; end % little trick to plot not NaN for empty shit
if any(ismember(find(cells2plt),curridx))
    curry  = app.singlecellpanel.UserData.rfdata.temporalComponents(curridx,:);
else
    curry = nan(size(app.singlecellpanel.UserData.rfdata.timeVec));
end


if isempty(app.(['tcpop',num2str(rgclabelnum)]).Children)
    line(app.(['tcpop',num2str(rgclabelnum)]),x(:), y(:),'color',app.UIFigure.UserData.colorset(rgclabelnum,:));
    line(app.(['tcpop',num2str(rgclabelnum)]), app.singlecellpanel.UserData.rfdata.timeVec,...
        curry, 'color',abs(app.UIFigure.UserData.colorset(rgclabelnum,:)-0.2),'Linewidth',2);
    app.(['tcpop',num2str(rgclabelnum)]).XLim = [-0.5 0];
    app.(['tcpop',num2str(rgclabelnum)]).YLim = [-0.5 0.5];
    app.(['tcpop',num2str(rgclabelnum)]).XLim = app.tempcomp.XLim;
    pbaspect(app.(['tcpop',num2str(rgclabelnum)]),[4 3 1]);
    %pbaspect(app.(['tcpop',num2str(rgclabelnum)]),[864 480 1])
    %axis( app.(['tcpop',num2str(rgclabelnum)]),'tight')
else
    app.(['tcpop',num2str(rgclabelnum)]).Children(1).YData = curry;
    app.(['tcpop',num2str(rgclabelnum)]).Children(2).XData = x(:);
    app.(['tcpop',num2str(rgclabelnum)]).Children(2).YData = y(:);
end


end