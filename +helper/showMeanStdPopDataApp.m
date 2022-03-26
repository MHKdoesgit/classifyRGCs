

function showMeanStdPopDataApp(app , varargin)

%curridx     = app.T.UserData.curridx;
rgclabels   = app.T.Data(:,6);

numplts = sum(contains(fieldnames(app),'rfpop'));
poppltnames = {'acgpop','tcpop','nlpop'};

for ii = 1:numplts
    for jj = 1: numel(poppltnames)
        
        p = app.([poppltnames{jj},num2str(ii)]).Children;
        
%         switch lower(ii)
%             
%             case {1, '1', 'off parasol', 'off p'}
%                 lbtomatch = 'off parasol';
%                 
%             case {2, '2', 'on parasol', 'on p'}
%                 lbtomatch = 'on parasol';
%                 
%             case {3, '3', 'off midget', 'off m'}
%                 lbtomatch = 'off midget';
%                 
%             case {4, '4', 'on midget', 'on m'}
%                 lbtomatch = 'on midget';
%         end
        
        lbtomatch = helper.getAppRGClabels(ii);
        
        cells2plt = (strcmpi(rgclabels,lbtomatch));
        
        if strcmp(p(3).FaceColor,'none') % when the patch facecolor is not there, it is in data mode
            
            xall = reshape(p(2).XData,[],sum(cells2plt));
            yall = reshape(p(2).YData,[],sum(cells2plt));
            
            xax = xall(1:end-1,1);
            ym = mean(yall(1:end-1,:),2);
            ystd = std(yall(1:end-1,:),0,2);
            
            col  = app.UIFigure.UserData.colorset(ii,:);
            col(col>0) = abs(col(col>0)-0.2);
            
            
            p(2).XData = xax';
            p(2).YData = ym';
            p(2).LineWidth = 1.5;
            p(2).Color = col;
            p(2).LineStyle = '-.';
            
            p(3).XData = [xax;flipud(xax)];
            p(3).YData = [ ym- ystd;flipud( ym + ystd)];
            p(3).FaceColor = app.UIFigure.UserData.colorset(ii,:);
            p(3).EdgeColor = 'none';
            p(3).FaceAlpha = 0.5;

        else
            
            switch poppltnames{jj}
                case 'acgpop'
                    xall = repmat([app.singlecellpanel.UserData.acg.lag';nan(1,1)],sum(cells2plt),1);
                    yall = [ app.singlecellpanel.UserData.acg.autocorr(cells2plt,:)';nan(1,sum(cells2plt))];
                case 'tcpop'
                    xall = repmat([app.singlecellpanel.UserData.rfdata.timeVec';nan(1,1)],sum(cells2plt),1);
                    yall = [ app.singlecellpanel.UserData.rfdata.temporalComponents(cells2plt,:)';nan(1,sum(cells2plt))];                    
                case 'nlpop'
                    xall = [ app.singlecellpanel.UserData.nl.nlx(cells2plt,:),nan(sum(cells2plt),1)]';
                    yall = [ app.singlecellpanel.UserData.nl.nly(cells2plt,:),nan(sum(cells2plt),1)]';
            end
            
            
            p(3).FaceColor = 'none';
            p(2).XData = xall(:);
            p(2).YData = yall(:);
            p(2).LineWidth = 0.5;
            p(2).Color = app.UIFigure.UserData.colorset(ii,:);
            p(2).LineStyle = '-';
            
            %  p(1).YData = curry;
        end
    end
end





end