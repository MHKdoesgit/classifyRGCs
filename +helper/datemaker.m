




function [varargout] = datemaker (varargin)

% Getting date of expreiment
% This function work both with date numbers and date string,
% in case of string input, it search through the input and find the 201 as
% part of 2012 or 2013 etc, them it finds the moth and day after year, so
% it is important that the input string always starts with year and
% followed by month and day.
% If the input do not have any indication of date it will ask the user to
% add the date manually.
% When the inputs are numbers, it takes the first number as year, the
% second as month and third as day.
% It won't work with 2 or 4 or more than 4 inputs.
% Written by Mohammad 12.09.2013


if nargin < 1
    error('datemaker:argChk', 'No date was entered!!');
end

if nargin >= 4
    error('datemaker:argChk', 'Do we have somthing more than Year, Month, Day that I am not aware of ?!?!');
end

if nargin == 1 && ischar (varargin{1})
    
    Datestring = varargin {1};
    
    ExpD = cell2mat(regexp (Datestring,{'201','202'}));
    if numel(ExpD) > 1  % to avoid problems with 202010 to 202012 issue where there is 201 in a set
        if diff(ExpD) < -1
            ExpD = min (ExpD);
        end
    end
    
    try
        Expdate = ([ Datestring(ExpD:ExpD+3) '-' Datestring(ExpD+4:ExpD+5) '-' Datestring(ExpD+6:ExpD+7)]);
    catch
        Expdate = ([ Datestring(ExpD:ExpD+3) '-0' Datestring(ExpD+4) '-' Datestring(ExpD+5:ExpD+6)]);
        %Expdate = ([ Datestring(ExpD+6:ExpD+7) '-' Datestring(ExpD+4:ExpD+5) '-' Datestring(ExpD:ExpD+3)]);
    end
    
    datechk = sscanf (Expdate, '%d-%d-%d');
    if isempty(datechk) == 1
        warning ('myfc:inputdatechk',...
            'The Date of this expriment does not exist in Space-Time Continum! Please enter it manually');
        promptdate = {'Enter the expriment year:','Enter the expriment month:','Enter the expriment day:'};
        dlg_date = 'Enter the experiment date';
        num_linesdate = 1;
        dateanswer = inputdlg(promptdate,dlg_date,num_linesdate);
        Expdate = [cell2mat(dateanswer(1)) '-' cell2mat(dateanswer(2)) '-' cell2mat(dateanswer(3))];
    end
    
    varargout{1} = datestr (Expdate);
end

if nargin == 2 && ~ischar(varargin {1}) && ~ischar(varargin {2})
    
    error('datemaker:argChk', 'Well, one of the date component is missing!! and that is suspitious!!');
end

if nargin == 3 && ~ischar(varargin {1}) && ~ischar(varargin {2}) && ~ischar(varargin {3})
    
    datestring = [num2str(varargin{1}),'-', num2str(varargin{2}),'-' num2str(varargin{3})];
    
    varargout {1} = datestr (datestring);
    
end
