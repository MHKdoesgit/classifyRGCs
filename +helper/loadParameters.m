

function [ mcdfiles, num, header ] = loadParameters( fname )
%
%%% loadParameters %%%
%
%
% This function Loads and parses the parameter file from experiments.
%
% ===============================Inputs====================================
%
%    fname : path to file "parameters.txt"
%
%================================Output====================================
%
%   mcdfiles: name of recorded mcd files
%   num: numbers of recorded mcd files, it is 1 when the recording is
%        shorter than 10 minutes.
%   header: header of text file containg type of array (e.g 60 electrodes),
%           data aquisition rate, which could be 25kHz or 10 kHz.
%           number of recorded stimuli and number of their repetitions.
%
% Copied from same function from Fernando (2011-11-29),
% modified by Mohammad, 30.07.2014
%

    fid = fopen(fname);
    
    firstLine = fgets(fid);
    header = cell2mat(textscan(firstLine, '%u'));
    
    if length(header) < 5     % We're reading the old format
       fseek(fid, 0, 'bof');
       header = [];
    end
    
    exps = textscan(fid, '%s %u', -1);
    
    mcdfiles = exps{1};
    num = exps{2};
    
    fclose(fid);
    
end

