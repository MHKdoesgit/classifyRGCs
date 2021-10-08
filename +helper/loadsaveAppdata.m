

function loadsaveAppdata(app, state)

switch lower(state)
    
    case 'loaddata'
        dp = uigetdir(['D:',filesep,'2-MARMOSET',filesep],'Select Data Folder');
        app.UIFigure.UserData.savingpath = dp;
        cldata = dir([dp,filesep,'*Data for manual classification of cells*']);
        if numel(cldata) > 1
            [indx,tf] = listdlg('PromptString','More than one dataset for classification is found, select one:',...
                'Name','Data selection','SelectionMode','single','ListString',{cldata.name},'ListSize',[500 100]);
            if tf
                app.UIFigure.UserData.datafilename = [cldata(indx).folder,filesep,cldata(indx).name];
                app.singlecellpanel.UserData = load([cldata(indx).folder,filesep,cldata(indx).name]);
            else
                uialert(app.UIFigure,{'yo bro, what the actuall fuck!,',...
                    ' you should select one of the datasets if you want classify them!'},...
                    'aint no file was selected');
            end
        else
            app.UIFigure.UserData.datafilename = [cldata.folder,filesep,cldata.name];
            app.singlecellpanel.UserData = load([cldata.folder,filesep,cldata.name]);
        end
        
        usercldata = dir([dp,filesep,'Classified retinal ganglion cells for experiment on*']);
        if not(isempty(usercldata))
            usercldata = load([usercldata.folder,filesep,usercldata.name]);
            if ~isfield(usercldata,'sortdirection'), usercldata.sortdirection = 'ascend'; end % defualt sorting direction if not defined
            [~,sortbyusercolumn] = sort([usercldata.Data{:,usercldata.sortedcolumn}],usercldata.sortdirection);
            app.T.Data = usercldata.Data(sortbyusercolumn,:);
            helper.sortTableDataApp(app, usercldata.sortedcolumn, usercldata.Data);
            app.T.UserData.curridx = usercldata.lastindex;
            app.T.UserData.previdx = usercldata.onetolastindex;
            app.T.UserData.sortedcolumn = usercldata.sortedcolumn;
        else
            clus = num2cell(sortrows(app.singlecellpanel.UserData.tablevalues,1));
            % little html trick to align the tex in the table
            %clus= strcat(sprintf('<html><tr align=center><td width=%d>', size(clus,1)), clus);
            app.T.Data = [clus, repmat({''},size(clus,1),2)];  % 2 extra: label, comments
            app.T.UserData.sortedcolumn = 1;
        end
        removeStyle(app.T);
        addStyle(app.T, app.T.UserData.tablestyle,'row',app.T.UserData.curridx);
        %startupplotter(app);
        helper.startupplotApp(app);
        
    case 'savedata'
        
        [~,sortbyfirstcolumn] = sortrows(cell2mat(app.T.Data(:,1:4)),[1 2],'ascend'); % sortrows to avoid same channel sort problems
        classifiedRGCs.Data = app.T.Data(sortbyfirstcolumn,:);
        classifiedRGCs.lastindex = find(sortbyfirstcolumn==app.T.UserData.curridx);
        classifiedRGCs.onetolastindex =  find(sortbyfirstcolumn==app.T.UserData.previdx); %app.T.UserData.previdx;
        classifiedRGCs.sortedcolumn = app.T.UserData.sortedcolumn;
        if classifiedRGCs.sortedcolumn == 6, classifiedRGCs.sortedcolumn = 5; end % in case of sorted by strings, switch to sorted by rf
        if isfield(app.T.UserData,'sortdirection') % to get the correct sorting direction
            classifiedRGCs.sortdirection = app.T.UserData.sortdirection;
        end
        saveingfilename = ['Classified retinal ganglion cells for experiment on ',helper.datemaker(app.UIFigure.UserData.savingpath),'.mat'];
        save([app.UIFigure.UserData.savingpath,filesep,saveingfilename],'-v7.3','-struct','classifiedRGCs');
        disp('saving is done!');
end

end