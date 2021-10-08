

function colorThemeApp(app, colmode)

%hex2rgbfun = @(x)(reshape(sscanf(x(2:end).','%2x'),3,[]).'/255);

switch lower(colmode)
    case 'light'
        bkgcol          = 0.94 .* [1 1 1];
        fgrdcol         = 0.15 .* [1 1 1];
        buttoncol       = 0.80 .* [1 1 1];
        fontcol         = 0.25 .* [1 1 1];
        buttonfontcol   = 0.1  .* [1 1 1];
        pltcol          = 1    .* [1 1 1];
        gridcol         = [0.15 0.15 0.15];
        cmp             = flipud(helper.cbrewer.cbrewer('div','RdBu',255));
        tabrowstrip     = 'on';
        tabstyle        = uistyle("BackgroundColor",fgrdcol,'FontColor',bkgcol,"FontWeight",'bold');
        
    case 'dark'
        bkgcol          = 0.12 .* [1 1 1];
        fgrdcol         = 0.75 .* [1 1 1];
        buttoncol       = 0.35 .* [1 1 1];
        fontcol         = 0.80 .* [1 1 1];
        buttonfontcol   = 0.95 .* [1 1 1];
        pltcol          = 0.18 .* [1 1 1];
        gridcol         = 0.85 .* [1 1 1];
        cmp             = flipud(helper.cbrewer.cbrewer('div','RdBu',255));
        tabrowstrip     = 'off';
        tabstyle        = uistyle("BackgroundColor",fgrdcol,'FontColor',bkgcol,"FontWeight",'bold');
end

% get all the components
appcomps = fieldnames(app);
appcompstypes = cell(size(appcomps));
for ii = 1 : numel(appcomps)
    appcompstypes{ii} = get(app.(appcomps{ii}),'type');
end

% whole figure color
figurelist = find(strcmp(appcompstypes,'figure'));
for ii = 1:length(figurelist)
    app.(appcomps{figurelist(ii)}).Color = bkgcol;
    app.(appcomps{figurelist(ii)}).Colormap = cmp;
    if not(isfield(app.(appcomps{figurelist(ii)}).UserData,'colorset'))
        app.(appcomps{figurelist(ii)}).UserData.colorset = lines(255);
    end 
end

% menus
menulist = find(strcmp(appcompstypes,'uimenu'));
for ii = 1:length(menulist)
    app.(appcomps{menulist(ii)}).ForegroundColor = [0.01 0.01 0.01];
end

%table colors
tablelist = find(strcmp(appcompstypes,'uitable'));
for ii = 1:length(tablelist)
    app.(appcomps{tablelist(ii)}).BackgroundColor = bkgcol;
    app.(appcomps{tablelist(ii)}).ForegroundColor = fgrdcol;
    app.(appcomps{tablelist(ii)}).RowStriping = tabrowstrip;
    app.(appcomps{tablelist(ii)}).UserData.tablestyle = tabstyle;
end

% axes color
axeslist = find(strcmp(appcompstypes,'axes'));
for ii = 1:length(axeslist)    
    %app.(appcomps{axeslist(ii)}).Colormap = cmp;
    app.(appcomps{axeslist(ii)}).GridColor = gridcol;
    app.(appcomps{axeslist(ii)}).MinorGridColor = abs(gridcol-0.05);
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


% buttons color
componentlist = find(ismember(appcompstypes,{'uilabel','uidropdown','uinumericeditfield'}));
for ii = 1:length(componentlist)
    app.(appcomps{componentlist(ii)}).BackgroundColor = bkgcol;
    app.(appcomps{componentlist(ii)}).FontColor = fontcol;
end

% 
% buttons color
buttonlist = find(strcmp(appcompstypes,'uibutton'));
for ii = 1:length(buttonlist)
    app.(appcomps{buttonlist(ii)}).BackgroundColor = buttoncol;
    app.(appcomps{buttonlist(ii)}).FontColor = buttonfontcol;
end

% uiknob
switchknoblist = find(ismember(appcompstypes,{'uiknob','uiswitch'}));
for ii = 1:length(switchknoblist)
    app.(appcomps{switchknoblist(ii)}).FontColor = fontcol;
end


end