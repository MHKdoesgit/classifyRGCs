

function plotRFpopApp(app, lbindex, varargin)

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

rf = app.singlecellpanel.UserData.rf.correctedcenter;
x = squeeze(rf(1,:,cells2plt));
y = squeeze(rf(2,:,cells2plt));

if size(x,2) ~= sum(cells2plt)
    x = transpose(x);
    y = transpose(y);
end

if isempty(x), x = NaN; y = NaN; end % little trick to plot not NaN for empty shit
if any(ismember(find(cells2plt),curridx))
    currx  = squeeze(rf(1,:,curridx));
    curry  = squeeze(rf(2,:,curridx));
else
    currx  = NaN;
    curry  = NaN;
end

if isempty(app.(['rfpop',num2str(rgclabelnum)]).Children)
    x = [x;nan(1,sum(cells2plt))];
    y = [y;nan(1,sum(cells2plt))];
    line(app.(['rfpop',num2str(rgclabelnum)]),x(:), y(:),'Color',app.UIFigure.UserData.colorset(rgclabelnum,:));
    line(app.(['rfpop',num2str(rgclabelnum)]),currx(:), curry(:),...
        'color',abs(app.UIFigure.UserData.colorset(rgclabelnum,:)-0.2),'Linewidth',2);
    axis(app.(['rfpop',num2str(rgclabelnum)]),'equal');
    axis(app.(['rfpop',num2str(rgclabelnum)]),'tight');
    app.(['rfpop',num2str(rgclabelnum)]).XLim = app.RFall.XLim; %[0 app.singlecellpanel.UserData.rf.para.screen(1)];
    app.(['rfpop',num2str(rgclabelnum)]).YLim = app.RFall.YLim; %[0 app.singlecellpanel.UserData.rf.para.screen(2)];
    app.(['rfpop',num2str(rgclabelnum)]).XTick = [];
    app.(['rfpop',num2str(rgclabelnum)]).YTick = [];
    box(app.(['rfpop',num2str(rgclabelnum)]),'on');
    %app.(['rfpop',num2str(rgclabelnum)]).XDir = 'reverse';
    app.(['rfpop',num2str(rgclabelnum)]).YDir = 'reverse';
else
    x = [x;nan(1,sum(cells2plt))];
    y = [y;nan(1,sum(cells2plt))];
    app.(['rfpop',num2str(rgclabelnum)]).Children(2).XData = x(:);
    app.(['rfpop',num2str(rgclabelnum)]).Children(2).YData = y(:);
    app.(['rfpop',num2str(rgclabelnum)]).Children(1).XData = currx;
    app.(['rfpop',num2str(rgclabelnum)]).Children(1).YData = curry;
end

end