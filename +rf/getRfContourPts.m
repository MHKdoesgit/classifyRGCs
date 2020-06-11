function [contpts, contarea, centgaussparams] = getRfContourPts(spx, spy, spim)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%--------------------------------------------------------------------------
dx = mean(diff(spx)); 
dy = mean(diff(spy));

% upsample everything to single pixel res
upx    = min(spx - (dx/2 - 0.5)): max(spx + (dx/2 - 0.5));
upy    = min(spy - (dx/2 - 0.5)): max(spy + (dx/2 - 0.5));
spimup = imresize(spim, dx, 'nearest');
%--------------------------------------------------------------------------
% get gauss params
centgaussparams  = rf.receptfield(spx, spy, spim);
%--------------------------------------------------------------------------
% get contours
contfac       = 0.25;
spimup        = imgaussfilt(spimup, 4); % upsample first
% upgaussparams = rf.receptfield(upx, upy, spimup); % get gauss for the blurred image
contpts       = contourc(upx, upy, spimup, max(spimup(:))*contfac*[1 1]);
%--------------------------------------------------------------------------
% triage contours points

% cmax          = getEllipseFromParams(upgaussparams, 4);
% contusemax    = inpolygon(contpts(1,:), contpts(2,:), cmax(1,:), cmax(2,:));
% contptsedge   = contpts(:, contusemax);
  
alldist  = sqrt(sum(diff(contpts, [], 2).^2, 1));
madthres = 14 * 1.4826 * mad(alldist, 1);

anchorpts = find(alldist > madthres) + 1;

anchorpts = [1 anchorpts size(contpts, 2)];
[~, imax] = max(diff(anchorpts));

contpts = contpts(:, anchorpts(imax):anchorpts(imax+1)-1);
contpts = [contpts contpts(:,1)];
%--------------------------------------------------------------------------
% get area
contarea      = polyarea(contpts(1,:), contpts(2,:));
%--------------------------------------------------------------------------

end

