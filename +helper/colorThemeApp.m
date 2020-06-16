

function colorThemeApp(app, colmode)


switch colmode
    case 'light'
        bkgcol      = 0.94 .* [1 1 1];
        fgrdcol     = 0.15 .*[1 1 1];
        buttoncol   = 0.85 .* [1 1 1];
        fontcol     = [0.1 0.1 0.1];
        pltcol      = [1 1 1];
        gridcol     = [0.15 0.15 0.15];
        cmp         = flipud(cbrewer('div','RdBu',255));
        tabrowstrip = 'on';
        tabstyle    = uistyle("BackgroundColor",fgrdcol,'FontAngle','italic','FontColor',bkgcol,"FontWeight",'bold');
        
    case 'dark'
        bkgcol      = 0.14 .* [1 1 1];
        fgrdcol     = 0.85 .* [1 1 1];
        buttoncol   = 0.25 .* [1 1 1];
        fontcol     = 0.90 .* [1 1 1];
        pltcol      = 0.14 .* [1 1 1];
        gridcol     = 0.75 .* [1 1 1];
        cmp         = flipud(cbrewer('div','RdBu',255));
        tabrowstrip = 'off';
        tabstyle    = uistyle("BackgroundColor",fgrdcol,'FontAngle','italic','FontColor',bkgcol,"FontWeight",'bold');
end

% whole figure color
app.UIFigure.Color = bkgcol;
app.UIFigure.Colormap = cmp;
if not(isfield(app.UIFigure.UserData,'colorset'))
    app.UIFigure.UserData.colorset = lines(255);
end

% menus
app.FileMenu.ForegroundColor = [0.1 0.1 0.1];
app.EditMenu.ForegroundColor = [0.1 0.1 0.1];
%table colors
app.T.BackgroundColor = bkgcol;
app.T.ForegroundColor = fgrdcol;
app.T.RowStriping = tabrowstrip;
app.T.UserData.tablestyle = tabstyle;

% get all the components
appcomps = fieldnames(app);
appcompstypes = cell(size(appcomps));
for ii = 1 : numel(appcomps)
    appcompstypes{ii} = get(app.(appcomps{ii}),'type');
end

% buttons color
buttonlist = find(strcmp(appcompstypes,'uibutton'));
for ii = 1:length(buttonlist)
    app.(appcomps{buttonlist(ii)}).BackgroundColor = buttoncol;
    app.(appcomps{buttonlist(ii)}).FontColor = fontcol;
end

% axes color
axeslist = find(strcmp(appcompstypes,'axes'));
for ii = 1:length(axeslist)
    
    %app.(appcomps{axeslist(ii)}).Colormap = cmp;
    app.(appcomps{axeslist(ii)}).GridColor = gridcol;
    app.(appcomps{axeslist(ii)}).MinorGridColor = gridcol-0.05;
    app.(appcomps{axeslist(ii)}).XColor = fgrdcol;
    app.(appcomps{axeslist(ii)}).YColor = fgrdcol;
    app.(appcomps{axeslist(ii)}).ZColor = fgrdcol;
    app.(appcomps{axeslist(ii)}).Color = pltcol;
    app.(appcomps{axeslist(ii)}).BackgroundColor = bkgcol;
    app.(appcomps{axeslist(ii)}).XLabel.Color = fontcol;
    app.(appcomps{axeslist(ii)}).YLabel.Color = fontcol;
    app.(appcomps{axeslist(ii)}).ZLabel.Color = fontcol;
    app.(appcomps{axeslist(ii)}).Title.Color = fontcol;
    
    if strcmp(app.(appcomps{axeslist(ii)}).TickDir,'in')
        app.(appcomps{axeslist(ii)}).TickDir = 'out';
    end
    % unnecessary options for labels (slow down the process)
    %    app.(appcomps{axeslist(ii)}).XLabel.EdgeColor = 'none';
    %    app.(appcomps{axeslist(ii)}).XLabel.BackgroundColor = 'none';
    %    app.(appcomps{axeslist(ii)}).YLabel.EdgeColor = 'none';
    %    app.(appcomps{axeslist(ii)}).YLabel.BackgroundColor = 'none';
    %    app.(appcomps{axeslist(ii)}).ZLabel.EdgeColor = 'none';
    %    app.(appcomps{axeslist(ii)}).ZLabel.BackgroundColor = 'none';
    %    app.(appcomps{axeslist(ii)}).Title.EdgeColor = 'none';
    %    app.(appcomps{axeslist(ii)}).Title.BackgroundColor = 'none';
    
    % unnecessary options
    %    app.(appcomps{axeslist(ii)}).AmbientLightColor = [1 1 1];
    %    app.(appcomps{axeslist(ii)}).GridColorMode = 'auto';
    %    app.(appcomps{axeslist(ii)}).XColorMode = 'auto';
    %    app.(appcomps{axeslist(ii)}).YColorMode = 'auto';
    %    app.(appcomps{axeslist(ii)}).ZColorMode = 'auto';
    
end

% lalel colors
labellist = find(strcmp(appcompstypes,'uilabel'));
for ii = 1:length(labellist)
    app.(appcomps{labellist(ii)}).BackgroundColor = bkgcol;
    app.(appcomps{labellist(ii)}).FontColor = fontcol;
end

% theme switch button
app.themeSwitch.FontColor = fontcol;
%
% fn = fieldnames(app.themeSwitch);
% col = fn(contains(fn,'Color','IgnoreCase',true))
%


end