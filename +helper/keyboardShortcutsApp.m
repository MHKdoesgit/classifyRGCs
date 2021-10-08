

function keyboardShortcutsApp(app, key)

switch key
    case 'downarrow'
        app.T.UserData.previdx = app.T.UserData.curridx;
        indices = app.T.UserData.curridx+1;
        if indices > size(app.singlecellpanel.UserData.tablevalues,1)
            indices = size(app.singlecellpanel.UserData.tablevalues,1);
        end % to avoid carshes at the end of the tables
        app.T.UserData.curridx = indices(1,1);
        removeStyle(app.T);
        addStyle(app.T, app.T.UserData.tablestyle,'row',indices(1,1));
        helper.updateplotsApp(app);
        app.refereshplotsButtonPushed;
        
    case 'uparrow'
        app.T.UserData.previdx = app.T.UserData.curridx;
        indices = app.T.UserData.curridx - 1;
        if indices < 1, indices = 1; end % to avoid crash for index -1
        app.T.UserData.curridx = indices(1,1);
        removeStyle(app.T);
        addStyle(app.T, app.T.UserData.tablestyle,'row',indices(1,1));
        helper.updateplotsApp(app);
        app.refereshplotsButtonPushed;
    case '1'
        OffparasolButtonPushed(app, event);
    case '2'
        OnparasolButtonPushed(app, event);
    case '3'
        OffmidgetButtonPushed(app,event);
    case '4'
        OnmidgetButtonPushed(app,event);
    case '5'
        OffsmoothButtonPushed(app,event);
    case '6'
        OnsmoothButtonPushed(app,event);
    case '7'
        DSButtonPushed(app,event);
    case '8'
        OSButtonPushed(app,event);
    case '9'
        BistratifiedButtonPushed(app,event);
    case 'b'
        BigspikesButtonPushed(app,event);
    case 'u'
        UnknownButtonPushed(app,event);
    case 'l'
        CommentButtonPushed(app, event);
    case 'n'
        app.T.Data{app.T.UserData.curridx,6} = 'noise';
    case 'c'
        app.T.Data{app.T.UserData.curridx,6} = '';
        refereshplotsButtonPushed(app, event);
    case 'k'
        helper.rescaleContoursApp(app,'k');
    case 's'
        savealldataButtonPushed(app, event);
    case 'a'
        normalizeacgsMenuSelected(app, event);
    case 'p'
        helper.plotPCAsApp(app, 1);
    case 'x'
        app.controlAxes = controlAppAxes(app);
    case 'm'
        helper.showMeanStdPopDataApp(app);
    case 'r'
        refereshplotsButtonPushed(app, event);
end