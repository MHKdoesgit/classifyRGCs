

function res = rfdataforclassification(dp, savingpath)

if nargin < 2,    savingpath = []; end

rd = helper.loadRawData(dp,{'checkerflicker','frozennoise'});

stimPara = rd.stimPara;
%stimPara = stimdata.stimPara;
stimPara = checkstimParaArgs(stimPara, 'stimulus', 'frozennoise');
stimPara = checkstimParaArgs(stimPara, 'refreshrate', 60);
try
stimPara = checkstimParaArgs(stimPara, 'screen', rd.screen);
catch
    stimPara = checkstimParaArgs(stimPara, 'screen', rd.info.screen.resolution);
end
try
stimPara = checkstimParaArgs(stimPara, 'fs', double(rd.samplingrate));
catch
    stimPara = checkstimParaArgs(stimPara, 'fs', double(rd.info.samplingrate));
end
stimPara = checkstimParaArgs(stimPara, 'pulseRate', 2);
stimPara = checkstimParaArgs(stimPara, 'filterWindow', 0.5);
stimPara = checkstimParaArgs(stimPara, 'nsigma', 2);
stimPara = checkstimParaArgs(stimPara, 'nonlinBinN', 40);
% for auto-correlogram
stimPara = checkstimParaArgs(stimPara, 'dtcorr', 5e-4);         % 5e-4;
stimPara = checkstimParaArgs(stimPara, 'Ncorr', 250e-3 / 5e-4); % %60e-3/dtcorr; % old values
stimPara = checkstimParaArgs(stimPara, 'normACG', false);


try
    if strcmpi( rd.lightprojection, 'oled')
        pixsize = 7.5e-6;
    else % now for lightcrafter, add option for patch setups later
        pixsize = 8e-6;
    end
catch
    if strcmpi(rd.info.screen.type, 'oled')
        pixsize = 7.5e-6;
    else % now for lightcrafter, add option for patch setups later
        pixsize = 8e-6;
    end
    
end


stimPara = checkstimParaArgs(stimPara, 'pixelsize', pixsize);

switch lower(stimPara.stimulus)
    case {'frozennoise','frozencheckerflicker'}
        frozenflag = true;
    otherwise
        frozenflag = false;
end

if frozenflag
    try
    stimPara = checkstimParaArgs(stimPara, 'seed', stimPara.seedrunningnoise);
    stimPara = checkstimParaArgs(stimPara, 'secondseed', stimPara.seedfrozennoise);
    catch
       stimPara = checkstimParaArgs(stimPara, 'seed', stimPara.seed);
    stimPara = checkstimParaArgs(stimPara, 'secondseed', stimPara.secondseed); 
    end
end

if isfield(stimPara,'color')
    if stimPara.color && ~frozenflag
        stimPara.seed = stimPara.secondseed;
    elseif stimPara.color && frozenflag
        stimPara.seed =  stimPara.seedrunninggreen;
        stimPara.secondseed = stimPara.seedfrozengreen;
    end
end

if isfield(stimPara,'Nblinks'), stimPara.nblinks = stimPara.Nblinks; stimPara = rmfield(stimPara,'Nblinks'); end

if isrow(rd.ftimes), rd.ftimes = transpose(rd.ftimes); end
if size(rd.ftimes,2) ~=2
    if stimPara.nblinks == 1 && max(size(rd.ftimes)) > (max(size(rd.ftimesoff))*2-10)
    ft = [rd.ftimes(1:2:numel(rd.ftimes)),rd.ftimes(2:2:numel(rd.ftimes))];
    else
        if isrow(rd.ftimes) && isrow(rd.ftimesoff)
            ft = [rd.ftimes(1:end-1)',rd.ftimesoff'];
        else
            ft = [rd.ftimes,rd.ftimesoff];
        end
    end
else
    ft = ftimes;
end

if frozenflag
    res = rf.Analyze_FrozenCheckerFlicker(ft, rd.spiketimes, rd.clusters, stimPara, savingpath);
else
    res = rf.Analyze_CheckerFlicker(ft, rd.spiketimes, rd.clusters, stimPara, savingpath);
end

end



function para = checkstimParaArgs(para, argname, defval)
if not(isfield(para, argname))
    para.(argname) = defval;
end
end





