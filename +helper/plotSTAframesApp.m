

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

rf = app.singlecellpanel.UserData.rf;
curridx = app.T.UserData.curridx;

switch lower(state)
    case 'new'
        % setting some options
        p = inputParser();
        p.addParameter('gap', [2 2], @(x) isnumeric(x));
        p.addParameter('stapeak', nan(1,3));
        p.addParameter('outline', true, @(x) islogical(x));
        %p.addParameter('colormap', flipud(cbrewer('div','RdBu',255)));
        p.addParameter('outlinecolor', 0.5 .* [1 1 1]);
        p.addParameter('peakframeoutlinecolor', 'r');
        p.addParameter('peakframefontcolor', 'r');
        p.addParameter('showframenumber', true, @(x) islogical(x));
        p.addParameter('fontcolor', 'k');
        p.parse(varargin{:});
        pltops = p.Results;
        
        if numel(pltops.gap) == 1, pltops.gap = [pltops.gap, pltops.gap]; end
        
        
        %curridx = app.T.UserData.curridx;
        
        mx = max(abs(rf.STA{curridx}),[],'all');
        nframes = 21;
        nrows = 3;%dims(1);
        if numel(nrows)==1
            ncols = ceil(nframes / nrows);
        else
            ncols = 7;%dims(2);
        end
        
        xl = linspace(0,rf.para.screen(1),rf.para.Nx);
        yl = linspace(0,rf.para.screen(2),rf.para.Ny);
        % get the indices correct, if the nrows and ncols don't match it will crash
        % here
        rfloc = reshape(rf.para.timebins-nframes+1:rf.para.timebins,nrows,ncols);
        
        idx = 0;
        yidx = 0;
        
        for kk = 1:nframes
            xm = idx*max(xl); if idx~=0, xm = xm+idx*(20*pltops.gap(1)); end
            ym = yidx*max(yl); if yidx~=0, ym = ym+yidx*(20*pltops.gap(2)); end
            if mod(kk,ncols)==0, yidx = yidx+1;end
            imagesc(app.sta, xm + xl,ym + yl,rf.STA{curridx}(:,:,rfloc(kk)));
            hold(app.sta,'on');
            %hold on;
            if pltops.outline
                if ~isnan(pltops.stapeak(3)) && pltops.stapeak(3)==rfloc(kk)
                    reccol = pltops.peakframeoutlinecolor;
                else
                    reccol = pltops.outlinecolor;
                end
                rectangle(app.sta,'pos',[xm ym max(xl) max(yl)],'cur',[0 0],'facecolor','none',...
                    'edgecolor',reccol,'linewidth',0.025);
            end
            idx = idx+1;
            if idx == (nframes/nrows); idx = 0; end
            if pltops.showframenumber
                if ~isnan(pltops.stapeak(3)) && pltops.stapeak(3)==rfloc(kk)
                    txtcol = pltops.peakframefontcolor;
                else
                    txtcol = pltops.fontcolor;
                end
                text(app.sta, xm + xl(end-2),ym + yl(2),num2str(rfloc(kk)),'color',txtcol,'VerticalAlignment','top',...
                    'HorizontalAlignment','right','FontSize',7,'FontAngle','italic');
            end
        end
        app.sta.XLim = [0 xm+xm+xl(end)];
        app.sta.YLim = [0 ym+yl(end)];
        % axis([0 xm+xl(end) 0 ym+yl(end)]);
        axis(app.sta,'tight');
        axis(app.sta,'equal');
        axis(app.sta,'off');
        app.sta.CLim = [-mx mx];
        hold(app.sta,'off');
        
    case 'update'
        
        staimg = find(strcmpi(get(app.sta.Children,'type'),'image'));
        for ii = 1:numel(staimg)
            app.sta.Children(staimg(ii)).CData = rf.STA{curridx}(:,:,end-ii);
        end
        
end



end