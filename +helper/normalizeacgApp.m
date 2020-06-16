
function normalizeacgApp(app)

acgdat = app.singlecellpanel.UserData.acg;
curridx =    app.T.UserData.curridx;
defval = num2cellstr(app.singlecellpanel.UserData.acg.normrange);

nranswer = inputdlg({'insert normalization range from:','to:'},'normalize auto-correlogram to:',[1 60],defval);
if any(cellfun('isempty',nranswer))
    return;
else
    nr = cellfun(@str2double,nranswer)';
end

% check inputs
if nr(1) < 0
    nr(1) = 0; 
    errordlg('Da-FaQ is tha input !?!, autocorr below 0 ms???','Wrong input'); 
end


if nr(2) > max(acgdat.lagraw)
    nr(2) = max(acgdat.lagraw); 
    errordlg(['How far you want to go!?!, more than ', num2str(max(acgdat.lagraw)),' ms is not allowed!'],'Wrong input');
end

acgnormrange = (acgdat.lagraw >= nr(1) & acgdat.lagraw <= nr(2));
autocorr = acgdat.autocorrraw(:,acgnormrange) ./ sum(acgdat.autocorrraw(:,acgnormrange),2);
lag = acgdat.lagraw(acgnormrange);

app.singlecellpanel.UserData.acg.autocorr = autocorr;
app.singlecellpanel.UserData.acg.lag = lag;
app.singlecellpanel.UserData.acg.normrange = nr;

bar(app.acg,lag,autocorr(curridx,:),'FaceColor',app.UIFigure.UserData.colorset(1,:),'EdgeColor','none','BarWidth',1);
app.acg.XLim = nr;
app.acg.XTick = nr(1):nr(2)/2:nr(2);
app.acg.XTickLabel = num2cellstr( app.acg.XTick)';
% for the pop plots
for ii = 1:4
    helper.plotACGpopApp(app, ii);
    app.(['acgpop',num2str(ii)]).XLim = nr;
    app.(['acgpop',num2str(ii)]).XTick = nr(1):nr(2)/2:nr(2);
    app.(['acgpop',num2str(ii)]).XTickLabel = num2cellstr( app.acg.XTick)';
end


end