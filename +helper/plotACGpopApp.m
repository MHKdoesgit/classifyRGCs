

function plotACGpopApp(app, lbindex, varargin)

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

cells2plt = (strcmpi(rgclabels,lbtomatch));

x = repmat([app.singlecellpanel.UserData.acg.lag';nan(1,1)],sum(cells2plt),1);
y = [ app.singlecellpanel.UserData.acg.autocorr(cells2plt,:)';nan(1,sum(cells2plt))];


if isempty(app.(['acgpop',num2str(rgclabelnum)]).Children)
    plot(app.(['acgpop',num2str(rgclabelnum)]),x(:), y(:),'color',app.UIFigure.UserData.colorset(rgclabelnum,:));
    pbaspect(app.(['acgpop',num2str(rgclabelnum)]),[4 3 1]);
else
    app.(['acgpop',num2str(rgclabelnum)]).Children.XData = x(:);
    app.(['acgpop',num2str(rgclabelnum)]).Children.YData = y(:);
end

end