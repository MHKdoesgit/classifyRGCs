

function rescaleContoursApp(app, scalevalue)

if ischar(scalevalue)
    scaleanswer = inputdlg('insert a scaling factor:','scale contours to:',[1 60],{'0.6'});
    if not(isempty(scaleanswer))
        scalevalue = str2double(scaleanswer{1})*100;
        app.scaleknob.Value = scalevalue;
    else
        return;
    end
end

ctrs = app.singlecellpanel.UserData.rfcontours; % load the original
scalevalue = scalevalue /100;

newctrs = nan(size(ctrs.contourspts)); 
for ii = 1:size(newctrs,1)
    if all(not(isnan(ctrs.centroids(ii,:))))
        s = scale(ctrs.shapes(ii),scalevalue , ctrs.centroids(ii,:));
        newctrs(ii,:,1:size(s.Vertices,1)) = s.Vertices';
    end
end
app.singlecellpanel.UserData.rfcontours.scalevalue = scalevalue;
app.singlecellpanel.UserData.rfcontours.contourspts = newctrs;

for jj = 1:4
   helper.plotRFpopApp(app, jj);
end

end