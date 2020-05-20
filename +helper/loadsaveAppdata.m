

function loadsaveAppdata(app, state)


switch lower(state)
    
    case 'loaddata'
        
        %dp = 'D:\2-MARMOSET\20180710_252MEA_MHK\fr_fp_cp\Data Analysis\Manual Classification of Primate Ganglion Cells';
        %dp = uigetdir(['D:',filesep,'2-MARMOSET',filesep],'Select Data Folder');
        dp = 'D:\2-MARMOSET\20180710_60MEA_YE\fr_fp_p42\Data Analysis\Manual Classification of Primate Ganglion Cells';
        app.UIFigure.UserData.savingpath = dp;
        cldata = dir([dp,filesep,'Data for manual classification of cells*']);
        app.UIFigure.UserData.datafilename = [cldata.folder,filesep,cldata.name];
        app.singlecellpanel.UserData = load([cldata.folder,filesep,cldata.name]);
        usercldata = dir([dp,filesep,'Classified retinal ganglion cells for experiment on*']);
        if not(isempty(usercldata))
            usercldata = load([usercldata.folder,filesep,usercldata.name]);
            %[~,sortbyfirstcolumn] = sort([usercldata.Data{:,usercldata.sortedcolumn}],'ascend'); 
            app.T.Data = usercldata.Data;
            %app.T.Data = usercldata.Data(sortbyfirstcolumn,:);
            %helper.sortTableDataApp(app, usercldata.sortedcolumn, usercldata.Data);
            
            app.T.UserData.curridx = 1;%usercldata.lastindex;
            app.T.UserData.previdx = 1;%usercldata.onetolastindex;
        else
            clus = num2cell(sortrows(app.singlecellpanel.UserData.tablevalues,1));
            %clus(:,5) = round(clus(:,5),1);
            %clus(:,1:4) = cellfun(@(x) sprintf('%d', x),clus(:,1:4), 'UniformOutput',0);
            %clus(:,5) = cellfun(@(x) sprintf('%0.2f', x),clus(:,5), 'UniformOutput',0);
            %clus= strcat(sprintf('<html><tr align=center><td width=%d>', size(clus,1)), clus); % little html trick to align the tex in the table
            app.T.Data = [clus, repmat({''},size(clus,1),2)];  % 2 extra: label, comments
            %app.T.UserData.sortindex = 1:size(app.T.Data,1);
            app.T.UserData.sortedcolumn = 1;
        end
        removeStyle(app.T);
        addStyle(app.T, app.T.UserData.tablestyle,'row',app.T.UserData.curridx);
        %startupplotter(app);
        helper.startupplotApp(app);
        
    case 'savedata'
        
        
        [~,sortbyfirstcolumn] = sort([app.T.Data{:,1}],'ascend');
        classifiedRGCs.Data = app.T.Data(sortbyfirstcolumn,:);
        classifiedRGCs.lastindex = app.T.UserData.curridx;
        classifiedRGCs.onetolastindex = app.T.UserData.previdx;
        classifiedRGCs.sortedcolumn = app.T.UserData.sortedcolumn;
        saveingfilename = ['Classified retinal ganglion cells for experiment on ',datemaker(app.UIFigure.UserData.savingpath),'.mat'];
        save([app.UIFigure.UserData.savingpath,filesep,saveingfilename],'-v7.3','-struct','classifiedRGCs');
        
        
end






end