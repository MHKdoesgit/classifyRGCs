

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

cells2plt = (strcmpi(rgclabels,lbtomatch));

rf = app.singlecellpanel.UserData.rf.correctedcenter;
x = squeeze(rf(1,:,cells2plt));
y = squeeze(rf(2,:,cells2plt));

if size(x,2) ~= sum(cells2plt)
    x = transpose(x);
    y = transpose(y);
end

if isempty(app.(['rfpop',num2str(rgclabelnum)]).Children)
    x = [x;nan(1,sum(cells2plt))];
    y = [y;nan(1,sum(cells2plt))];
    plot(app.(['rfpop',num2str(rgclabelnum)]),x(:), y(:),'Color',app.UIFigure.UserData.colorset(rgclabelnum,:));
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
    app.(['rfpop',num2str(rgclabelnum)]).Children.XData = x(:);
    app.(['rfpop',num2str(rgclabelnum)]).Children.YData = y(:);
end



end