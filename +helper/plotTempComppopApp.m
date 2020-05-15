

function plotTempComppopApp(app, lbindex, varargin)

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

x = repmat([app.singlecellpanel.UserData.rf.para.time';nan(1,1)],sum(cells2oplt),1);
y = [ app.singlecellpanel.UserData.rf.tempComp(cells2oplt,:)';nan(1,sum(cells2oplt))];


if isempty(app.(['tcpop',num2str(rgclabelnum)]).Children)
    plot(app.(['tcpop',num2str(rgclabelnum)]),x(:), y(:),'color',app.UIFigure.UserData.colorset(rgclabelnum,:));
    app.(['tcpop',num2str(rgclabelnum)]).XLim = [0 500];
    app.(['tcpop',num2str(rgclabelnum)]).YLim = [-0.85 0.85];
    %pbaspect(app.(['tcpop',num2str(rgclabelnum)]),[864 480 1])
    %axis( app.(['tcpop',num2str(rgclabelnum)]),'tight')
else
    app.(['tcpop',num2str(rgclabelnum)]).Children.XData = x(:);
    app.(['tcpop',num2str(rgclabelnum)]).Children.YData = y(:);
end

end