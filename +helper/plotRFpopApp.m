

function plotRFpopApp(app, lbindex, varargin)

rgclabels = app.T.Data(:,6);

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

cells2oplt = (strcmpi(rgclabels,lbtomatch));

rf = app.singlecellpanel.UserData.rf.correctedcenter;


if isempty(app.(['rfpop',num2str(rgclabelnum)]).Children)
    x = [squeeze(rf(1,:,cells2oplt))';nan(1,sum(cells2oplt))];
    y = [squeeze(rf(2,:,cells2oplt))';nan(1,sum(cells2oplt))];
    plot(app.(['rfpop',num2str(rgclabelnum)]),x(:), y(:),'Color',app.UIFigure.UserData.colorset(rgclabelnum,:));
    axis(app.(['rfpop',num2str(rgclabelnum)]),'equal');
    app.(['rfpop',num2str(rgclabelnum)]).XLim = [0 app.singlecellpanel.UserData.rf.para.screen(1)];
    app.(['rfpop',num2str(rgclabelnum)]).YLim = [0 app.singlecellpanel.UserData.rf.para.screen(2)];
    app.(['rfpop',num2str(rgclabelnum)]).XTick = [];
    app.(['rfpop',num2str(rgclabelnum)]).YTick = [];
    
else
    x = [squeeze(rf(1,:,cells2oplt));nan(1,sum(cells2oplt))];
    y = [squeeze(rf(2,:,cells2oplt));nan(1,sum(cells2oplt))];
    app.(['rfpop',num2str(rgclabelnum)]).Children.XData = x(:);
    app.(['rfpop',num2str(rgclabelnum)]).Children.YData = y(:);
end



end