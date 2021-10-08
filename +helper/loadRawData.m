

function [expData, savingPath, stimNames] = loadRawData(datapath, expname, saveFolder, saveDatafolder, varargin)
%
%%% loadRawData %%%
%
%
% This function loads the raw data of each experiment and also generate a
% saving folder and data folder for the requested stimulus.
%
%================================Inputs====================================
%
%   datapath : datapath of the experiment.
%   expname : name of the stimulus to load or part of its name.
%   saveFolder : name of the saving folder.
%   saveDatafolder : name of the data folder for saving each mat file.
%   excludeName : optional name to exclude from the list of stimulus names
%                 is case to stimulus share similar name.
%   selecgui : flag for gui for selecting experiment names.
%
%================================Output====================================
%
%   expData : loaded data of requested experiment.
%   savingPath : folder path for saving data.
%   stimNames : name of all the files.
%
% written by Mohammad, 28.12.2016.
% update to add multiple selection and gui mode on 30.01.2017.
% update to inputparse at 20.11.2019.

p = inputParser();
p.addParameter('excludename', []);
p.addParameter('selectgui', false, @(x) islogical(x));
p.addParameter('rawdatapath', 'Raw Data', @(x) ischar(x));
p.addParameter('loadfields', {}, @(x) iscell(x));
p.parse(varargin{:});
para = p.Results;

% loading data
if exist([datapath,'/parameters.txt'],'file')
    stimNames = helper.loadParameters([datapath,'/parameters.txt']);
    loaddirect = false;
else
    stimNames = dir([datapath,'/Data Analysis/',para.rawdatapath,'/']); stimNames = {stimNames(3:end).name};
    loaddirect = true;
end

stimNames = stimNames(contains(lower(stimNames),lower(expname)));

% exclude these names
if ~isempty(para.excludename)
    stimNames = stimNames(~contains(lower(stimNames),lower(para.excludename)));
end

% check if the name exist.
if isempty(stimNames)
    disp(loadParameters([datapath,'/parameters.txt']));
    error('404 Bro!, the name you are searching is not in this folder, check the list above!');
end

% if more than 1 file exists ask user.
expID = numel(stimNames);
if expID > 1
    if iscell(expname)  % to handle multiple inputs
        expnamestr = expname{1}; for ii=2:numel(expname), expnamestr = [expnamestr,' & ', expname{ii}]; end; %#ok
    else
        expnamestr = expname;
    end
    selectmsg = ['Too many ',expnamestr,' stimuli on the dance floor!! select what you want to analyze!! ==> '];
    if para.selectgui
        [expID,~] = listdlg('PromptString',selectmsg,'SelectionMode','multiple','ListString',stimNames,'listsize',[500 150],'uh',30);
    else
        for ii=1:   expID, disp(stimNames{ii});        end
        expID = input(selectmsg);
    end
end

% load data into array structure
[expData, savingfoldernames] = deal(cell(1,length(expID)));
for ii = 1: length(expID)
    thisname = stimNames{expID(ii)};
    savingfoldernames{ii} = [thisname(1:strfind(thisname(1:5),'_')-1),'-'];
    if loaddirect
        expData{ii} = load([datapath,'/Data Analysis/',para.rawdatapath,'/',stimNames{expID(ii)}],para.loadfields{:});
    else
        expData{ii} = load([datapath,'/Data Analysis/',para.rawdatapath,'/',stimNames{expID(ii)},...
            ' for Experiment on ',helper.datemaker(datapath),'.mat'],para.loadfields{:});
    end
end

expData = cell2mat(expData);

% creating saving folder
if nargout > 1  % only if the second output is requested
    if ~iscell(saveFolder), saveFolder = {saveFolder}; end
    for ii= 1:numel(saveFolder)
        savingPath = [datapath,'/Data Analysis/',savingfoldernames{ii},saveFolder{ii},'/'];
        
        if not(exist(savingPath,'dir'))
            mkdir(savingPath);
        end
        if exist('saveDatafolder','var') 
            if not(exist([savingPath,'/',saveDatafolder],'dir')) && ~isempty(saveDatafolder)
                mkdir([savingPath,'/',saveDatafolder]);
            end
        end
    end
end

end

