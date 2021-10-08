

function [dsplt, dspltextra] = circAvgallDScells(dsgcdata, nangle, nstim)
%
%%% circAvgallDScells %%%
%
%
% This function calulate the circular average from all the DS cells.
% Additionally, this function calcualtes everything need for plotting of
% the DS cells. this is part of and is faster version of DSplot function.
%
%================================Inputs====================================
%
%   dsgcdata : ds data structure this is feeded into plotDSdata function.
%   nangle : number of angles for all the cycles.
%   nstim : number of stimuli.
%
%================================Output====================================
%
%   dsplt : circular average and DS grids for plotting.
%   dspltextra : vectornorm and extra shit for more info.
%
% written by Mohammad, 10.05.2019.

if numel(nangle)~= nstim && numel(nangle)==1, nangle = repmat(nangle,1,nstim);  end

if  isstruct(dsgcdata) && (size(dsgcdata,2) == 1) % new formate 3D (ncells,nangles, nstim)
    angs = permute(dsgcdata.anglesRep,[2 1 3]);
    frate = permute(dsgcdata.perAngleRep,[2 1 3]);    
else % old formate [ncells, nstim]
    angs = reshape(cell2mat({dsgcdata.anglesRep}'),unique(nangle)+1,[],nstim);
    frate = reshape(cell2mat({dsgcdata.perAngleRep}'),unique(nangle)+1,[],nstim);
end
x = frate .* cos(angs);
y = frate .* sin(angs);

dsplt.x = permute(x,[2 3 1]);
dsplt.y = permute(y,[2 3 1]);

cosang = cos(angs(1:end-1,:,:));
sinang = sin(angs(1:end-1,:,:));

F = frate(1:end-1,:,:); % this is essentially is the perangle
sF = sum(F,1);
circAvg = [sum(F .* cosang); sum(F .* sinang)] ./sF;
circAvg = permute(circAvg,[2 3 1]);
sF = permute(sF,[2 3 1]);
F = permute(F,[2 3 1]);

%lowfrate = squeeze(max(F,[],1))>=1;
%sF(lowfrate)=NaN;
%circAvg (cat(3,lowfrate,lowfrate)) = NaN;

dspltextra.vecNormds = vecnorm(circAvg,2,3);
dspltextra.vecAngle = atan2(circAvg(:,:,2), circAvg(:,:,1));
dspltextra.unitVector = circAvg ./ dspltextra.vecNormds;
dspltextra.sumfrate = sF;

dsplt.circAvg = circAvg .* sum(F,3);

dsplt.maxF = 2*ceil(max(F,[], 3 )/2);
dsplt.minF = 2*floor(min(F,[], 3 )/2);

pltang = cell(1,length(nangle));
for ii = 1:size(circAvg,2)
    pltangles = linspace(0,360,nangle(ii)+1);
    pltangles = pltangles(1:(end-1));
    pltang{ii} = pltangles;
end

% for the circles
th = 0:pi/20:2*pi;

numgr = 5; % number of grid lines
[grx,gry] = deal(nan(size(circAvg,1),size(circAvg,2),numgr * (length(th)+1) + 2*max((nangle))));
txtvals = nan(size(circAvg,1),size(circAvg,2),2);

for ii = 1:size(circAvg,1)
    for jj = 1:size(circAvg,2)
        
        ang = pltang{jj};
        if any(F(ii,jj,:)>0)
            peakval = dsplt.maxF(ii,jj);
        else
            peakval = dsplt.minF(ii,jj);
        end
        
        gl = linspace(0,peakval,numgr); % grid lines
        xunit = [gl .* cos(th)'; nan(1,numgr)];
        yunit = [gl .* sin(th)'; nan(1,numgr)];
        
        lx = [0 ;1].*cosd(ang).*abs(peakval);
        ly = [0 ;1].*sind(ang).*abs(peakval);
        
        grx(ii,jj,:) = [xunit(:);lx(:)];
        gry(ii,jj,:) = [yunit(:);ly(:)];
        txtvals(ii,jj,:) = [gl(ceil(numgr/2)),gl(end)];
    end
end

dsplt.grx = grx;
dsplt.gry = gry;
dsplt.txtvals = txtvals;

end