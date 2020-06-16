

function [rescaledcontours, allpolyshapes, allcentroids, allrescaledconts] = rescaleRFcontours(contpts, scalevalue)
% function to rescale RF contours

allpolyshapes = cell(size(contpts,1),1);
allrescaledconts = cell(size(contpts,1),1);
allcentroids = nan(size(contpts,2));
rescaledcontours = nan(size(contpts));

warning('off','all');
for ii =  1: size(contpts,1)
    
    cpts = squeeze(contpts(ii,:,:))';
    cpts = cpts(~isnan(cpts(:,1)),:);
    p = polyshape(cpts);
    [cx, cy] = centroid(p);
    if ~isempty(p.Vertices)
        s = scale(p,scalevalue,[cx,cy]);
        allrescaledconts{ii} = s;
        rescaledcontours(ii,:,1:size(s.Vertices,1)) = s.Vertices';
    else
        allrescaledconts{ii} = p;
    end
    allpolyshapes{ii} = p;
    allcentroids(ii,:) = [cx, cy];
    
    
end
warning('on','all');

allpolyshapes = [allpolyshapes{:}]';
allrescaledconts = [allrescaledconts{:}]';

end