

function plotSTAframesApp(app, state,varargin)
%
%%% plotRF.staframes %%%
%
%
% This function plot defined numbers of STA frames. It can rearange the
% selected frame in user-defined dimension (rows and columns).
%
%
% ===============================Inputs====================================
%
%   sta : whole sta (20-40 frames).
%   nframes : number of frames to be plotted from the end.
%   dims : [nrows, ncols] for the final plot.
%   rfpara : para file from the receptive field fits.
%   options : for defining properites of the output plot, check below.
%
%================================Output====================================
%
%   no output : this is a plotting function and no output is produced.
%
% written by Mohammad, 03.03.2020.

rfdata = app.singlecellpanel.UserData.rfdata;
curridx = app.T.UserData.curridx;
mx = max(abs(squeeze(rfdata.staAll(curridx,:,:,:))),[],'all');

switch lower(state)
    case 'new'
        % setting some options
        p = inputParser();
        p.addParameter('nframes', 15, @(x) isnumeric(x));
        p.addParameter('nrows', 3, @(x) isnumeric(x));
        p.addParameter('ncols', 5, @(x) isnumeric(x));
        p.addParameter('gap', [2 2], @(x) isnumeric(x));
        %p.addParameter('stapeak', nan(1,3));
        p.addParameter('outline', true, @(x) islogical(x));
        %p.addParameter('colormap', flipud(cbrewer('div','RdBu',255)));
        p.addParameter('outlinecolor', 0.7 .* [1 1 1]);
        %p.addParameter('peakframeoutlinecolor', 'r');
        %p.addParameter('peakframefontcolor', 'r');
        p.addParameter('showframenumber', true, @(x) islogical(x));
        p.addParameter('fontcolor', 'k');
        p.parse(varargin{:});
        pltops = p.Results;
        
        if numel(pltops.gap) == 1, pltops.gap = [pltops.gap, pltops.gap]; end
        
        
        %curridx = app.T.UserData.curridx;
        
        %mx = max(abs(squeeze(rfdata.staAll(curridx,:,:,:))),[],'all');
        nframes = pltops.nframes;
        nrows   = pltops.nrows;
        ncols   = pltops.ncols;
%         nrows = 3;%dims(1);
%         if numel(nrows)==1
%             ncols = ceil(nframes / nrows);
%         else
%             ncols = 7;%dims(2);
%         end
        
        xl = linspace(0,rfdata.stimPara.screen(1),rfdata.stimPara.Nx);
        yl = linspace(0,rfdata.stimPara.screen(2),rfdata.stimPara.Ny);
        % get the indices correct, if the nrows and ncols don't match it will crash
        % here
        rfloc = reshape(length(rfdata.timeVec)-nframes+1:length(rfdata.timeVec),nrows,ncols);
        
        idx = 0;
        yidx = 0;
        
        for kk = 1:nframes
            xm = idx*max(xl); if idx~=0, xm = xm+idx*(20*pltops.gap(1)); end
            ym = yidx*max(yl); if yidx~=0, ym = ym+yidx*(20*pltops.gap(2)); end
            if mod(kk,ncols)==0, yidx = yidx+1;end
            staimg = uint8(255*((squeeze(rfdata.staAll(curridx,:,:,rfloc(kk)))/mx)+1)/2);
            imagesc(app.sta, xm + xl,ym + yl,staimg);
           % imagesc(app.sta, xm + xl,ym + yl,rfdata.STA{curridx}(:,:,rfloc(kk)));
            hold(app.sta,'on');
            %hold on;
%             if pltops.outline
%                 if ~isnan(pltops.stapeak(3)) && pltops.stapeak(3)==rfloc(kk)
%                     reccol = pltops.peakframeoutlinecolor;
%                 else
%                     reccol = pltops.outlinecolor;
%                 end
                 rectangle(app.sta,'pos',[xm ym max(xl) max(yl)],'cur',[0 0],'facecolor','none',...
                    'edgecolor', pltops.outlinecolor,'linewidth',0.025);
%             end
            idx = idx+1;
            if idx == (nframes/nrows); idx = 0; end
            if pltops.showframenumber
                text(app.sta, xm + xl(end-2),ym + yl(2),num2str(rfloc(kk)),'color',pltops.fontcolor,...
                    'VerticalAlignment','top','HorizontalAlignment','right','FontSize',7,'FontAngle','italic');
            end
        end
        app.sta.XLim = [0 xm+xm+xl(end)];
        app.sta.YLim = [0 ym+yl(end)];
        % axis([0 xm+xl(end) 0 ym+yl(end)]);
        axis(app.sta,'tight');
        axis(app.sta,'equal');
        axis(app.sta,'off');
        app.sta.CLim = [0 255]; %[-mx mx];
        hold(app.sta,'off');
        
    case 'update'
        
        staimg = find(strcmpi(get(app.sta.Children,'type'),'image'));
        for ii = 1:numel(staimg)
            thisstaimg = uint8(255*((squeeze(rfdata.staAll(curridx,:,:,end-ii))/mx)+1)/2);            
            app.sta.Children(staimg(ii)).CData = thisstaimg;%rfdata.STA{curridx}(:,:,end-ii);
        end
        
end



end