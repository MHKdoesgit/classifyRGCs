

function sortTableDataApp(app, sortedcolumn, varargin)

% switch lower(event.Interaction)
%     case 'sort'
if nargin < 3, currtable = app.T.Data; else, currtable = varargin{1}; end

[assort, assortidx] = sort([currtable{:,sortedcolumn}],'ascend');
[dssort, dssortidx] = sort([currtable{:,sortedcolumn}],'descend');
if isequal(assort, [app.T.DisplayData{:,sortedcolumn}])
    appsortingidx = assortidx;
elseif isequal(dssort, [app.T.DisplayData{:,sortedcolumn}])
    appsortingidx = dssortidx;
else
    [~,appsortingidx] = sort([app.T.DisplayData{:,1}],'ascend'); % back to original state
end
%si = app.T.UserData.sortindex;
dat = app.singlecellpanel.UserData;

numcells = size(dat.clus,1);
fn = fieldnames(dat);
fn = fn(~contains(fn,'savingpath'));

for ii = 1:numel(fn)
    df1 = dat.(fn{ii});
    sdf1 = size(df1);
    
    if ~any(eq(sdf1, numcells)) && isstruct(df1)
        fn2 = fieldnames(df1);
        for jj = 1:numel(fn2)
            df2 = df1.(fn2{jj});
            sdf2 = size(df2);
            ncelldim = find(eq(sdf2, numcells));
            if isempty(ncelldim), ncelldim = 0; end
            if length(sdf2)==3 && ncelldim < 3 % find better slution later!
                if ncelldim == 1, ncelldim = 4; else, ncelldim = 5; end
            end
            
            switch ncelldim
                case 1
                    dat.(fn{ii}).(fn2{jj}) = dat.(fn{ii}).(fn2{jj})(appsortingidx,:);
                case 2
                    dat.(fn{ii}).(fn2{jj}) = dat.(fn{ii}).(fn2{jj})(:,appsortingidx);
                case 3
                    dat.(fn{ii}).(fn2{jj})(:,:,:) = dat.(fn{ii}).(fn2{jj})(:,:,appsortingidx);
                case 4
                    dat.(fn{ii}).(fn2{jj})(:,:,:) = dat.(fn{ii}).(fn2{jj})(appsortingidx,:,:);
                case 5
                    dat.(fn{ii}).(fn2{jj})(:,:,:) = dat.(fn{ii}).(fn2{jj})(:,appsortingidx,:);
            end
        end
    else
        ncelldim = find(eq(sdf1, numcells));
        if isempty(ncelldim), ncelldim = 0; end
        if length(sdf2)==3 && ncelldim < 3
            if ncelldim == 1, ncelldim = 4; else, ncelldim = 5; end
        end
        switch ncelldim
            case 1
                dat.(fn{ii}) = dat.(fn{ii})(appsortingidx,:);
            case 2
                dat.(fn{ii}) = dat.(fn{ii})(:,appsortingidx);
            case 3
                dat.(fn{ii})(:,:,:) = dat.(fn{ii})(:,:,appsortingidx);
            case 4
                dat.(fn{ii})(:,:,:) = dat.(fn{ii})(appsortingidx,:,:);
            case 5
                dat.(fn{ii})(:,:,:) = dat.(fn{ii})(:,appsortingidx,:);
        end
        
    end
    
end
%app.T.UserData.curridx
app.singlecellpanel.UserData = dat;
app.T.Data = currtable(appsortingidx,:); %app.T.DisplayData;
%app.T.UserData.sortindex = 1: size(dat.clus,1);
app.T.UserData.sortedcolumn = sortedcolumn;
%end

end
