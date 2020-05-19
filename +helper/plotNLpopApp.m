

function plotNLpopApp(app, lbindex, varargin)

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

x = [[ app.singlecellpanel.UserData.nl(cells2plt).nlx];nan(1,sum(cells2plt))];
y = [ [ app.singlecellpanel.UserData.nl(cells2plt).nly];nan(1,sum(cells2plt))];

if isfield(app.singlecellpanel.UserData,'nl')
    if isempty(app.(['nlpop',num2str(rgclabelnum)]).Children)
        
        plot(app.(['nlpop',num2str(rgclabelnum)]), x(:), y(:),'color',app.UIFigure.UserData.colorset(rgclabelnum,:));
        app.(['nlpop',num2str(rgclabelnum)]).XLim = [-3.1 3.1];
        %app.(['tcpop',num2str(rgclabelnum)]).YLim = [-0.85 0.85];
        pbaspect(app.(['nlpop',num2str(rgclabelnum)]),[4 3 1]);
    else
        app.(['nlpop',num2str(rgclabelnum)]).Children.XData = x(:);
        app.(['nlpop',num2str(rgclabelnum)]).Children.YData = y(:);
    end
end

end